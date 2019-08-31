//
//  LogoutResponse.swift
//  onthemap
//
//  Created by Peter Burgner on 8/29/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import Foundation

struct LogoutResponse: Codable {
    let session: Session
}

//{
//    "session": {
//        "id": "1463940997_7b474542a32efb8096ab58ced0b748fe",
//        "expiration": "2015-07-22T18:16:37.881210Z"
//    }
//}
