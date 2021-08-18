//
//  OTPStackView.swift
//  OTPTextField
//
//  Created by Hoang Son Vo Phuoc on 8/18/21.
//

import UIKit

protocol OTPStackViewDelegate: AnyObject {
    func didChangeValidity(isValid: Bool)
}

class OTPStackView: UIStackView {

    var textFieldArray = [OTPTextField]()
    var numberOfOTPdigit = 6

    weak var delegate: OTPStackViewDelegate?
    
    var showsWarningColor = false {
        didSet {
            textFieldArray.forEach {
                $0.addUnderLine(with: UIColor(hex: showsWarningColor ? "#C35C45" : "#F4B836"))
                $0.textColor = UIColor(hex: showsWarningColor ? "#C35C45" : "#F4B836")
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupStackView()
        setTextFields()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupStackView()
        setTextFields()
    }

    private func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 16
    }

    private func setTextFields() {

        for i in 0..<numberOfOTPdigit {
            let field = OTPTextField()
            setupTextField(field)
            textFieldArray.append(field)
            i != 0 ? (field.previousTextField = textFieldArray[i-1]) : ()
            i != 0 ? (textFieldArray[i-1].nextTextFiled = textFieldArray[i]) : ()
        }
        textFieldArray[0].becomeFirstResponder()
    }
    
    
    private func setupTextField(_ textField: OTPTextField) {
        textField.delegate = self
        addArrangedSubview(textField)
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(self.snp.height)
            make.width.equalTo(40)
        }
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.textColor = UIColor(hex: "#F4B836")
        textField.keyboardType = .phonePad
        textField.autocorrectionType = .yes
        textField.textContentType = .oneTimeCode
        textField.addUnderLine(with: UIColor(hex: "#F4B836"))
    }
    
    private func checkForValidity(){
        for fields in textFieldArray{
            if (fields.text?.trimmingCharacters(in: CharacterSet.whitespaces) == ""){
                delegate?.didChangeValidity(isValid: false)
                return
            }
        }
        delegate?.didChangeValidity(isValid: true)
    }
    
    func getOTPString() -> String {
        var OTP = ""
        for textField in textFieldArray{
            OTP += textField.text ?? ""
        }
        return OTP
    }
    
    
}

extension OTPStackView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if showsWarningColor {
            showsWarningColor = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkForValidity()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange,
                   replacementString string: String) -> Bool {
        
        guard let field = textField as? OTPTextField else {
            return true
        }
        if !string.isEmpty {
            field.text = string
            field.resignFirstResponder()
            field.nextTextFiled?.becomeFirstResponder()
            return true
        }
        return true
    }
}

class OTPTextField: UITextField {
    var previousTextField: UITextField?
    var nextTextFiled: UITextField?

    override func deleteBackward() {
        if text == "" {
            previousTextField?.becomeFirstResponder()
            previousTextField?.text = ""
            return
        }
        text = ""
    }
}


