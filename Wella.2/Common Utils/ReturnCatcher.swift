//
//  ReturnCatcher.swift
//  Wella.2
//
//  Created by Acxiom Consulting on 11/12/18.
//  Copyright © 2018 Acxiom. All rights reserved.
//

import Foundation
import UIKit
class  ReturnCatcher: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}
