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
        let query = englishWord
        let urlStringForPronunciation = baseURLForPronunciation + query
        let urlStringForDefinition = baseURLForDefinition + query
        var pronunciation = ""
        var pearsonResults = [PearsonData]()
        
        
        // First get the pronunciation
        retrievePronuciation(urlStringForPronunciation) {success, result, error in
            if success {
                pronunciation = result!
                
                // Now get the definition
                self.retrieveDefinition(urlStringForDefinition) { success, result, error in
                    if success {
                        pearsonResults = result!
                        
                        // Finally we give the correct pronunciation if it is the same word
                        if pronunciation.characters.count != 0 && pearsonResults.count != 0 {
                            for result in pearsonResults {
                                if result.headWord == englishWord {
                                    result.pronunciation = pronunciation
                                }
                            }
                            completionHandler(success: true, data: pearsonResults, errorString: nil)
                        }
                    }
                    else {
                        completionHandler(success: false, data: nil, errorString: error)
                    }
                }
            }
            else {
                completionHandler(success: false, data: nil, errorString: error)
            }
        }
    }
    
    func retrievePronuciation(urlString : String!, completionHandler : (success: Bool, pronunciation : String?, errorString : String?) -> Void) {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
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
            
            
            /* ==== NEED TO MAKE THIS SAFER ==== */

            
            if let results = parsedResult!["results"]!![0] {
//                print(results)
                if let pronunciation = results["pronunciations"]!![0] {
//                    print(pronunciation)
                    if let ipa = pronunciation["ipa"] {
                        print(ipa)
                        let pronunciationResult = ipa as! String
                        completionHandler(success: true, pronunciation: pronunciationResult, errorString: nil )
                    }
                }
            }
    
        }
        task.resume()
    }
    
    func retrieveDefinition(urlString : String!, completionHandler : (success: Bool, definitions : [PearsonData]?, errorString : String?) -> Void) {
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
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
            print(numberOfResults)
            let resultsArray = parsedResult!["results"]
            
            if numberOfResults == 0 {
                completionHandler(success: false, definitions: nil, errorString: "No results were found")
                return
            }
            
            /* ==== NEED TO MAKE THIS SAFER ==== */
            for index in 0...(numberOfResults - 1) {
                let headWord = resultsArray!![index]["headword"] as! String
                let definition = resultsArray!![index]["senses"]!![0]["definition"] as! String!
                print(definition)
                let pearsonData = PearsonData(headWord: headWord, definition: definition)
                pearsonResults.append(pearsonData)
            }
            
            completionHandler(success: true, definitions: pearsonResults, errorString: nil)
        }
        task.resume()
    }
}