//
//  LoggedInResponse.swift
//  onthemap
//
//  Created by Peter Burgner on 8/28/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import Foundation

struct LoggedInResponse: Codable {
    let account: Account
    let session: Session
}

struct Account:Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}


/*
 {
 "account":{
 "registered":true,
 "key":"3903878747"
 },
 "session":{
 "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
 "expiration":"2015-05-10T16:48:30.760460Z"
 }
 }
 */
