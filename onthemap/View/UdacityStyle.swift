//
//  UdacityStyle.swift
//  onthemap
//
//  Created by Peter Burgner on 9/1/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import UIKit

class UdacityStyle {
    
    enum Color {
        
        case button
        
        var cgcolor : CGColor {
            switch self {
                case .button: return UIColor(red: 1/255, green: 171/255, blue: 228/255, alpha: 1).cgColor
            }
        }
    }
    
    enum CornerRadius {
        
        case button
        
        var cgfloat : CGFloat {
            switch self {
                case .button: return 5
            }
        }
    }
}
