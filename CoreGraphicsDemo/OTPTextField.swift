//
//  OTPTextField.swift
//  CoreGraphicsDemo
//
//  Created by Raman choudhary on 14/11/22.
//

import Foundation
import UIKit

class OTPTextField: UITextField {
  weak var previousTextField: OTPTextField?
  weak var nextTextField: OTPTextField?
    var innerShadowLayer:CALayer?
    
  override public func deleteBackward(){
    text = ""
    previousTextField?.becomeFirstResponder()
   }
}
