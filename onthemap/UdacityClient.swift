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
    
    
    class func login(username:String, password: String, completion: @escaping (Bool, Error?) -> Void)  {
        
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            // no data received
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            // data received but may be an error message
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let loginFailureResponse = try decoder.decode(LoginFailureResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(false, loginFailureResponse)
                }
                return
            } catch {
                
                
                let loggedInResponse = try! decoder.decode(LoggedInResponse.self, from: newData)
                Auth.sessionId = loggedInResponse.session.id
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                return
            }

        }
        task.resume()
        
    }
    
    class func logout() {
        Auth.sessionId = ""
    }
}
