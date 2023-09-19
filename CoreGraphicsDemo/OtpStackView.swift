//
//  OtpStackView.swift
//  CoreGraphicsDemo
//
//  Created by Raman choudhary on 14/11/22.
//

import UIKit

import Foundation


protocol OTPDelegate {
    //always triggers when the OTP field is valid
    func didChangeValidity(isValid: Bool)
}

@IBDesignable class OTPStackView: UIView {
    //Customise the OTPField here
    @IBInspectable var numberOfFields:Int = 4
    @IBInspectable var cornerRadius:CGFloat = 15
    
    var textFieldsCollection: [OTPTextField] = []
    var delegate: OTPDelegate?
    var showsWarningColor = false
    var stackView = UIStackView()
    
    //Colors
    let inactiveFieldBorderColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)//UIColor(white: 1, alpha: 0.3)
    let textBackgroundColor = UIColor.lightGray//UIColor(white: 1, alpha: 0.5)
    let activeFieldBorderColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
    var remainingStrStack: [String] = []
    var field_Spacing:CGFloat = 20
    
    override func draw(_ rect: CGRect) {
        self.stackView.frame = self.bounds
        self.addSubview(self.stackView)
        setupStackView()
        addOTPFields()
    }
    
    //Customisation and setting stackView
    private final func setupStackView() {
        self.stackView.backgroundColor = .clear
        self.stackView.isUserInteractionEnabled = true
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        self.stackView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.stackView.contentMode = .center
        self.stackView.distribution = .fillEqually
        self.stackView.spacing = self.field_Spacing
        
    }
    
    //Adding each OTPfield to stack view
    private final func addOTPFields() {
        for index in 0..<numberOfFields{
            let field = OTPTextField()
            setupTextField(field)
            textFieldsCollection.append(field)
            //Adding a marker to previous field
            index != 0 ? (field.previousTextField = textFieldsCollection[index-1]) : (field.previousTextField = nil)
            //Adding a marker to next field for the field at index-1
            index != 0 ? (textFieldsCollection[index-1].nextTextField = field) : ()
        }
        self.addShadowLayer()
        textFieldsCollection[0].becomeFirstResponder()
    }
    
    //Customisation and setting OTPTextFields
    private final func setupTextField(_ textField: OTPTextField){
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.addArrangedSubview(textField)
        textField.centerYAnchor.constraint(equalTo: self.stackView.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalTo: self.stackView.heightAnchor).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 40).isActive = true
        textField.textAlignment = .center
        textField.adjustsFontSizeToFitWidth = false
        textField.font = UIFont(name: "Kefa", size: 40)
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .yes
        textField.textContentType = .oneTimeCode
        textField.borderStyle = .none
        textField.layer.cornerRadius = 15
        stackView.layoutIfNeeded()
    }
    
    func addShadowLayer(){
        self.textFieldsCollection.enumerated().forEach { (index,text_field) in
            let layer = CALayer()
            layer.name = "InnerShadow\(index)"
            textFieldsCollection[index].innerShadowLayer = layer
            textFieldsCollection[index].addInnerShadow(corner_radius: self.cornerRadius,innerShadow: layer)
        }
    }
    
    func setShadowColor(){
        self.textFieldsCollection.enumerated().forEach { (index,text_field) in
            textFieldsCollection[index].backgroundColor = UIColor(red: 214/255, green: 250/255, blue: 232/255, alpha: 1.0)
            textFieldsCollection[index].innerShadowLayer?.borderColor = UIColor(red: 205/255, green: 241/255, blue: 223/255, alpha: 1.0).cgColor
            textFieldsCollection[index].innerShadowLayer?.shadowColor = UIColor(red: 3/255, green: 214/255, blue: 112/255, alpha: 1.0).cgColor
        }
    }
    
    //checks if all the OTPfields are filled
    private final func checkForValidity(){
        for fields in textFieldsCollection{
            if (fields.text == ""){
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }
    
    //gives the OTP text
    final func getOTP() -> String {
        var OTP = ""
        for textField in textFieldsCollection{
            OTP += textField.text ?? ""
        }
        return OTP
    }

    //set isWarningColor true for using it as a warning color
    final func setAllFieldColor(isWarningColor: Bool = false, color: UIColor){
        for textField in textFieldsCollection{
            textField.layer.borderColor = color.cgColor
        }
        showsWarningColor = isWarningColor
    }
    
    //autofill textfield starting from first
    private final func autoFillTextField(with string: String) {
        remainingStrStack = string.reversed().compactMap{String($0)}
        for textField in textFieldsCollection {
            if let charToAdd = remainingStrStack.popLast() {
                textField.text = String(charToAdd)
            } else {
                break
            }
        }
        checkForValidity()
        remainingStrStack = []
    }
    
}

//MARK: - TextField Handling
extension OTPStackView: UITextFieldDelegate {
        
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
            setAllFieldColor(color: inactiveFieldBorderColor)
            showsWarningColor = false
        }
        textField.layer.borderColor = activeFieldBorderColor.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
        self.setShadowColor()
        textField.layer.borderColor = inactiveFieldBorderColor.cgColor
    }
    
    //switches between OTPTextfields
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        guard let textField = textField as? OTPTextField else { return true }
        if string.count > 1 {
            textField.resignFirstResponder()
            autoFillTextField(with: string)
            return false
        } else {
            if (range.length == 0){
                if textField.nextTextField == nil {
                    textField.text? = string
                    textField.resignFirstResponder()
                }else{
                    textField.text? = string
                    textField.nextTextField?.becomeFirstResponder()
                }
                return false
            }
            return true
        }
    }
    
}

