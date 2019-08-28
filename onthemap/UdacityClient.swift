//
//  UdacityClient.swift
//  onthemap
//
//  Created by Peter Burgner on 8/27/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            }
            
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    class func login(username:String, password: String) {
        
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}
