//
//  ViewController.swift
//  OTPTextField
//
//  Created by Hoang Son Vo Phuoc on 8/18/21.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private lazy var otpStackView: OTPStackView = {
        let view = OTPStackView()
        view.delegate = self
        return view
    }()
    
    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "DDDDDD")
        button.isUserInteractionEnabled = false
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(onClicktoContinueButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(otpStackView)

        otpStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
        }
        
        view.addSubview(continueButton)
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        continueButton.layer.cornerRadius = 24
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        otpStackView.showsWarningColor = false
    }
    
    private func isEnableContinueButton(isValid: Bool) {
        continueButton.backgroundColor = UIColor(hex: isValid ? "#DDDDDD" : "#F4B836")
        continueButton.isUserInteractionEnabled = isValid ? false : true
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func onClicktoContinueButton() {
        otpStackView.showsWarningColor = true
        debugPrint("OTP: \(otpStackView.getOTPString())")
    }
}

extension ViewController: OTPStackViewDelegate {
    func didChangeValidity(isValid: Bool) {
        isEnableContinueButton(isValid: !isValid)
    }
}
