//
//  LoginFailureResponse.swift
//  onthemap
//
//  Created by Peter Burgner on 8/28/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import Foundation

struct LoginFailureResponse: Codable {
    let statusCode: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case errorMessage = "error"
    }
}

extension LoginFailureResponse: LocalizedError {
    var errorDescription: String? {
        return errorMessage
    }
}




//example response
// {"status":403,"error":"Account not found or invalid credentials."}
