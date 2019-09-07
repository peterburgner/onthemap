//
//  UdacityClient.swift
//  onthemap
//
//  Created by Peter Burgner on 8/27/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import Foundation
import MapKit

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case logout
        case signup
        case getStudentLocations(String, String)
        case postStudentLocation
        case updateStudentLocation(String)
        
        var stringValue: String {
            switch self {
            case .login: return Endpoints.base + "/session"
            case .logout: return Endpoints.base + "/session"
            // signup URL taken from incorrect spec
            case .signup: return "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1566892321832000"
            case .getStudentLocations(let max, let order): return Endpoints.base + "/StudentLocation?limit=" + max + "&order=" + order
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .updateStudentLocation(let objectId): return Endpoints.postStudentLocation.stringValue + "/" + objectId
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    static var studentLocation = [StudentLocations]()
    
    
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
            print("Login: \n"+String(data: newData, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let loginFailureResponse = try decoder.decode(FailureResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(false, loginFailureResponse)
                }
                return
            } catch {
                
                
                let loggedInResponse = try! decoder.decode(LoggedInResponse.self, from: newData)
                Auth.sessionId = loggedInResponse.session.id
                Auth.objectId = loggedInResponse.account.key
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                return
            }

        }
        task.resume()
        
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            // no data received
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print("logout: \n"+String(data: newData, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let failureResponse = try decoder.decode(FailureResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(false, failureResponse)
                }
                return
            } catch {
                
                _ = try! decoder.decode(LogoutResponse.self, from: newData)
                Auth.sessionId = ""
                DispatchQueue.main.async {
                    completion(true, nil)
                }
                return
            }
        }
        task.resume()
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocations], Error?) -> Void ) {
        let request = URLRequest(url: Endpoints.getStudentLocations("100", "-updatedAt").url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                completion ([], error)
                return
            }
            
            guard let httpStatusCode = (response as? HTTPURLResponse)?.statusCode else {
                completion ([], error)
                return
            }
            
            if httpStatusCode >= 200 && httpStatusCode < 300 {
                let decoder = JSONDecoder()
                
                guard let data = data else {
                    completion ([], error)
                    return
                }
                
                do {
                    let studentInformationResponse = try decoder.decode(StudentLocationsResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(studentInformationResponse.results, nil)
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion([],error)
                    }
                    return
                }
            }
            else {
                // create custom error for all httpStatusCodes
                return completion ([], NSError(domain:"", code:httpStatusCode, userInfo:nil))
            }
        }
        task.resume()
    }
    
    class func postNewStudentLocation(location: MKPlacemark, mediaURL: String, completion: @escaping (Bool, Error?) -> Void ) {
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        /*
         firstName and lastName hard-coded since getting Public User Data seems broken
         https://knowledge.udacity.com/questions/54850
        */
        request.httpBody = "{\"uniqueKey\": \"\(Auth.objectId)\", \"firstName\": \"Speedy\", \"lastName\": \"Gonzales\",\"mapString\": \"\(location.name ?? "")\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(location.coordinate.latitude), \"longitude\": \(location.coordinate.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion (false, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                _ = try decoder.decode(PostStudentLocation.self, from: data)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(false,error)
                }
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
}
