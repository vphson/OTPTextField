//
//  UITextField.swift
//  OTPTextField
//
//  Created by Hoang Son Vo Phuoc on 8/18/21.
//

import UIKit

extension UITextField {
    
    func addUnderLine(with color: UIColor) {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0.0, y: self.bounds.height + 4, width: self.bounds.width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
    
}
