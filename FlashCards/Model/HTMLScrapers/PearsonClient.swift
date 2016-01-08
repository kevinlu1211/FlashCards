//
//  PearsonAPI.swift
//  PearsonAPI
//
//  Created by Kevin Lu on 8/01/2016.
//  Copyright © 2016 Kevin Lu. All rights reserved.
//

import Foundation

class PearsonClient {
    class func sharedInstance() -> PearsonClient {
        struct Singleton {
            static var sharedInstance = PearsonClient()
        }
        return Singleton.sharedInstance
    }
    
    func retrieveData(englishWord : String, completionHandler : (success: Bool, data : [PearsonData]?, errorString : String?) -> Void) {
        let baseURLForPronunciation = "https://api.pearson.com/v2/dictionaries/ldoce5/entries?headword="
        let baseURLForDefinition = "https://api.pearson.com/v2/dictionaries/laad3/entries?headword="

        let query = createQuery(englishWord)
        let urlStringForPronunciation = baseURLForPronunciation + query
        let urlStringForDefinition = baseURLForDefinition + query
        var pronunciation = ""
        var pearsonResults = [PearsonData]()
        
        // First get the definition
        
        retrieveDefinition(urlStringForDefinition, query: query) { success, result, error in
            if success {
                pearsonResults = result!
                
                // Now get the pronunciation
                self.retrievePronuciation(urlStringForPronunciation, query: query) { success, result, error in
                    if success {
                        pronunciation = result!
                        for result in pearsonResults {
                            result.pronunciation = pronunciation
                        }
                        completionHandler(success: true, data: pearsonResults, errorString: nil)
                    }
                    else {
                        completionHandler(success: false, data: pearsonResults, errorString: error)
                    }
                }
            }
            else {
                completionHandler(success: false, data: nil, errorString: error)
            }
            
        }
//        // First get the pronunciation
//        retrievePronuciation(urlStringForPronunciation, query: query) {success, result, error in
//            if success {
//                pronunciation = result!
//                print(pronunciation)
//                // Now get the definition
//                self.retrieveDefinition(urlStringForDefinition) { success, result, error in
//                    if success {
//                        pearsonResults = result!
//                        
//                        // Finally we give the correct pronunciation if it is the same word
//                        if pronunciation.characters.count != 0 && pearsonResults.count != 0 {
//                            print("hi")
//                            for result in pearsonResults {
//                                
//                                if result.headWord == query {
//                                    result.pronunciation = pronunciation
//                                    print("Pronunciation is:" + pronunciation)
//                                }
//                            }
//                            completionHandler(success: true, data: pearsonResults, errorString: nil)
//                        }
//                    }
//                    else {
//                        completionHandler(success: false, data: nil, errorString: error)
//                    }
//                }
//            }
//            else {
//                completionHandler(success: false, data: nil, errorString: error)
//            }
//        }
    }
    
    func retrievePronuciation(urlString : String!, query: String!, completionHandler : (success: Bool, pronunciation : String?, errorString : String?) -> Void) {
        
        var request : NSMutableURLRequest?
        let url = NSURL(string: urlString)
        
        if let url = url {
            request = NSMutableURLRequest(URL: url)
        }
        else {
            completionHandler(success: false, pronunciation: nil, errorString: "There was an error in the request for data, check internet connection and language settings")
            return
        }
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request!) { data, response, error in
            if error != nil {
                completionHandler(success: false, pronunciation: nil, errorString: "There was a networking error")
                return
            }
            if data == nil {
                completionHandler(success: false, pronunciation: nil, errorString: "There was an error in the request for data")
                return
            }
            
            let parsedResult : AnyObject?
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                } catch {
                completionHandler(success: false, pronunciation: nil, errorString: "There was an error in the conversion for data")
                return
            }
            
            let numberOfResults = parsedResult!["count"] as! Int
            
            if numberOfResults == 0 {
                completionHandler(success: false, pronunciation: nil, errorString: "No results were found")
                return
            }
            
            for index in 0...(numberOfResults - 1) {
                let result = parsedResult!["results"]!![index]
                
                // First check if we can find the headword
                if result["headword"] === nil {
                    continue
                }
                else {
                    let headWord = result["headword"] as! String!
                    
                    // Create the comparison terms
                    let comparisonHeadWord = self.standardizeWord(headWord)
                    let comparisonQuery = self.standardizeWord(query)
                    
                    // If we can find it check if the headword is the same as the query
                    if comparisonHeadWord == comparisonQuery {
                        
                        // Make sure it isn't nil
                        if result["pronunciations"] === nil {
                            // Do nothing
                        }
                        else {
                            print(result["pronunciations"])
                            if result["pronunciations"]!![0]["ipa"] === nil {
                                // Do nothing
                            }
                            else {
                                let pronunciation = result["pronunciations"]!![0]["ipa"] as! String
                                completionHandler(success: true, pronunciation: pronunciation, errorString: nil)
                                return
                            }
                        }

                    }
                }
            }
            completionHandler(success: false, pronunciation: nil, errorString: "No results for pronunciation were found")
            return
            
        }
        task.resume()
    }
    
    func retrieveDefinition(urlString : String!, query : String!, completionHandler : (success: Bool, definitions : [PearsonData]?, errorString : String?) -> Void) {
        var request : NSMutableURLRequest
        let url = NSURL(string: urlString)
        
        // Check if the url is valid!
        if let url = url {
            request = NSMutableURLRequest(URL: url)
        }
        else {
            completionHandler(success: false, definitions: nil, errorString: "There was an error in the request for data, check internet connection and language settings")
            return
        }
        
        let session = NSURLSession.sharedSession()
        var pearsonResults = [PearsonData]()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completionHandler(success: false, definitions: nil, errorString: "There was a networking error")
                return
            }
            if data == nil {
                completionHandler(success: false, definitions: nil, errorString: "There was an error in the request for data")
                return
            }
            
            let parsedResult : AnyObject?
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
            } catch {
                completionHandler(success: false, definitions : nil, errorString: "There was an error in the conversion for data")
                return
            }
            
            // Now parse the results
            let numberOfResults = parsedResult!["count"] as! Int
            
            if numberOfResults == 0 {
                completionHandler(success: false, definitions: nil, errorString: "No results were found")
                return
            }
            
            for index in 0...(numberOfResults - 1) {

                let result = parsedResult!["results"]!![index]
                print(result)
                
                // First check if we can find the headword
                if result["headword"] === nil {
                    continue
                }
                
                let headWord = result["headword"] as! String!
                
                // Create the comparison terms
                let comparisonHeadWord = self.standardizeWord(headWord)
                let comparisonQuery = self.standardizeWord(query)
                
                if comparisonHeadWord == comparisonQuery {
                    // Make sure it isn't nil
                    if result["senses"] === nil {
                        // Do nothing
                    }
                    else {
                        let senses = result["senses"]!!
                        if senses[0] === nil {
                            // Do nothing
                        }
                        else {
                            let definition = senses[0]["definition"] as! String
                            let userHeadWord = self.recreateUserInput(query)
                            let pearsonData = PearsonData(headWord: userHeadWord, definition: definition)
                            pearsonResults.append(pearsonData)
                        }
                    }
                    
                }

            }
            
            if pearsonResults.count == 0 {
                completionHandler(success: false, definitions: nil, errorString: "No results were found")
            }
            else {
                completionHandler(success: true, definitions: pearsonResults, errorString: nil)
            }
        }
        task.resume()
    }
    
    func standardizeWord(string : String!) -> String {
        var standardizedString = string.stringByReplacingOccurrencesOfString(" ", withString: "")
        standardizedString = standardizedString.stringByReplacingOccurrencesOfString("+", withString: "")
        return standardizedString.lowercaseString
    }
    
    func createQuery(string : String!) -> String {
        let query = string.stringByReplacingOccurrencesOfString(" ", withString: "+")
        return query
    }
    
    // Basically the inverse of createQuery
    func recreateUserInput(string : String!) -> String {
        let userInput = string.stringByReplacingOccurrencesOfString("+", withString: " ")
        return userInput
    }
}