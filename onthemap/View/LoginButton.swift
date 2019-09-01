//
//  LoginButton.swift
//  onthemap
//
//  Created by Peter Burgner on 8/27/19.
//  Copyright © 2019 Peter Burgner. All rights reserved.
//

import Foundation
import UIKit

class UdacityButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = UdacityStyle.CornerRadius.button.cgfloat
        layer.backgroundColor = UdacityStyle.Color.button.cgcolor
        self.setTitleColor(.white, for: .normal)
        
    }
    
}
