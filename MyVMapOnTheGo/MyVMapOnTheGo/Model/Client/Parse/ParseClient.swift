//
//  ParseClient.swift
//  MyVMapOnTheGo
//
//  Created by Vedarth Solutions on 11/10/18.
//  Copyright © 2018 Vedarth Solutions. All rights reserved.
//

import Foundation

class ParseClient: NSObject {
    
    // MARK: Properties
    
    // shared session
    var session = URLSession.shared
    
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {

        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: parseURL(parameters, withPathExtension: method))

        /* add standard headers */
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: ParseClient.Constants.AcceptKey)
        request.addValue("application/json", forHTTPHeaderField: ParseClient.Constants.ContentType)
        request.addValue(ParseClient.HeaderValues.ApiKeyValue, forHTTPHeaderField: ParseClient.Constants.ApiKey)
        request.addValue(ParseClient.HeaderValues.ApplicationIdValue, forHTTPHeaderField: ParseClient.Constants.ApplicationId)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in

            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }

            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }

            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }

            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }

        /* 7. Start the request */
        task.resume()

        return task
    }
    
    
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }

    // create a URL from parameters
    private func parseURL(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {

        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
         components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.url!
    }
    
   
class func sharedInstance() -> ParseClient {
    struct Singleton {
        static var sharedInstance = ParseClient()
    }
    return Singleton.sharedInstance
}
}
