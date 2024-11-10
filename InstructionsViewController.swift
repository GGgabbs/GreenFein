//
//  InstructionsViewController.swift
//  ARMultiuser
//
//  Created by admin on 11/10/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import UIKit


class InstructionsViewController: UIViewController, UITextViewDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!
        
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "Instructions"
        titleLabel.textColor = UIColor(hex: "\(app[appVersion]!["mainColor"]!)FF")!
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let tileSettings = UITextView()
        tileSettings.contentInsetAdjustmentBehavior = .automatic
        tileSettings.textAlignment = NSTextAlignment.justified
        tileSettings.textColor = UIColor(hex: "\(app[appVersion]!["textColor"]!)FF")!
        tileSettings.tintColor = UIColor(hex: "\(app[appVersion]!["mainColor"]!)FF")!
        tileSettings.font = UIFont(name: app[appVersion]!["mainFont"]!, size: CGFloat(Float(app[appVersion]!["buttonFontSize"]!)!))
        tileSettings.backgroundColor = UIColor.clear
        tileSettings.text = app[appVersion]!["instructions"]!
        tileSettings.isScrollEnabled = true
        tileSettings.isEditable = false
        tileSettings.isSelectable = false
        tileSettings.isUserInteractionEnabled = true
        tileSettings.showsVerticalScrollIndicator = false
        tileSettings.delegate = self
        tileSettings.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tileSettings)
        
        let backButton = UIButton(type: .system)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside) // Function that the button runs
        backButton.setTitle(app[appVersion]!["backButtonTitle"]!, for: .normal)
        backButton.setTitle(app[appVersion]!["backButtonTitle"]!, for: .selected)
        backButton.titleLabel?.font = UIFont(name: app[appVersion]!["mainFont"]!, size: CGFloat(Float(app[appVersion]!["buttonFontSize"]!)!))
        backButton.setTitleColor(UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!, for: .normal)
        backButton.setTitleColor(UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!, for: .selected)
        backButton.setBackgroundColor(UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!, forState: .normal)
        backButton.setBackgroundColor(UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!, forState: .selected)
        backButton.layer.borderWidth = CGFloat(Float(app[appVersion]!["buttonBorderWidth"]!)!)
        backButton.layer.borderColor = UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!.cgColor
        backButton.layer.cornerRadius = CGFloat(Float(app[appVersion]!["buttonCornerRadius"]!)!)
        backButton.layer.maskedCorners = buttonMaskedCorners
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            tileSettings.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tileSettings.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            tileSettings.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            tileSettings.bottomAnchor.constraint(equalTo: backButton.topAnchor),
            
            backButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
        ])
    }
    
    
    @objc func backButtonPressed(sender: UIButton!) {
        dismiss(animated: true)
    }
}
