//
//  HomeViewController.swift
//  ARMultiuser
//
//  Created by admin on 11/9/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!
        
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: app[appVersion]!["logoImageName"]!)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = app[appVersion]!["name"]!
        titleLabel.textColor = UIColor(hex: "\(app[appVersion]!["mainColor"]!)FF")!
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        
        let playButton = UIButton(type: .system)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside) // Function that the button runs
        playButton.setTitle(app[appVersion]!["playButtonTitle"]!, for: .normal)
        playButton.setTitle(app[appVersion]!["playButtonTitle"]!, for: .selected)
        playButton.titleLabel?.font = UIFont(name: app[appVersion]!["mainFont"]!, size: CGFloat(Float(app[appVersion]!["buttonFontSize"]!)!))
        playButton.setTitleColor(UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!, for: .normal)
        playButton.setTitleColor(UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!, for: .selected)
        playButton.setBackgroundColor(UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!, forState: .normal)
        playButton.setBackgroundColor(UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!, forState: .selected)
        playButton.layer.borderWidth = CGFloat(Float(app[appVersion]!["buttonBorderWidth"]!)!)
        playButton.layer.borderColor = UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!.cgColor
        playButton.layer.cornerRadius = CGFloat(Float(app[appVersion]!["buttonCornerRadius"]!)!)
        playButton.layer.maskedCorners = buttonMaskedCorners
        playButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playButton)
        
        let infoButton = UIButton(type: .system)
        infoButton.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside) // Function that the button runs
        infoButton.setTitle(app[appVersion]!["infoButtonTitle"]!, for: .normal)
        infoButton.setTitle(app[appVersion]!["infoButtonTitle"]!, for: .selected)
        infoButton.titleLabel?.font = UIFont(name: app[appVersion]!["mainFont"]!, size: CGFloat(Float(app[appVersion]!["buttonFontSize"]!)!))
        infoButton.setTitleColor(UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!, for: .normal)
        infoButton.setTitleColor(UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!, for: .selected)
        infoButton.setBackgroundColor(UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!, forState: .normal)
        infoButton.setBackgroundColor(UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!, forState: .selected)
        infoButton.layer.borderWidth = CGFloat(Float(app[appVersion]!["buttonBorderWidth"]!)!)
        infoButton.layer.borderColor = UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!.cgColor
        infoButton.layer.cornerRadius = CGFloat(Float(app[appVersion]!["buttonCornerRadius"]!)!)
        infoButton.layer.maskedCorners = buttonMaskedCorners
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoButton)
        
        let instructionsButton = UIButton(type: .system)
        instructionsButton.addTarget(self, action: #selector(instructionsButtonPressed), for: .touchUpInside) // Function that the button runs
        instructionsButton.setTitle(app[appVersion]!["instructionsButtonTitle"]!, for: .normal)
        instructionsButton.setTitle(app[appVersion]!["instructionsButtonTitle"]!, for: .selected)
        instructionsButton.titleLabel?.font = UIFont(name: app[appVersion]!["mainFont"]!, size: CGFloat(Float(app[appVersion]!["buttonFontSize"]!)!))
        instructionsButton.setTitleColor(UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!, for: .normal)
        instructionsButton.setTitleColor(UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!, for: .selected)
        instructionsButton.setBackgroundColor(UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!, forState: .normal)
        instructionsButton.setBackgroundColor(UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!, forState: .selected)
        instructionsButton.layer.borderWidth = CGFloat(Float(app[appVersion]!["buttonBorderWidth"]!)!)
        instructionsButton.layer.borderColor = UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!.cgColor
        instructionsButton.layer.cornerRadius = CGFloat(Float(app[appVersion]!["buttonCornerRadius"]!)!)
        instructionsButton.layer.maskedCorners = buttonMaskedCorners
        instructionsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionsButton)
        
       
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            logoImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
           
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            
            playButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            playButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            
            infoButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            infoButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            infoButton.heightAnchor.constraint(equalToConstant: 50),
            infoButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            
            instructionsButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            instructionsButton.topAnchor.constraint(equalTo: infoButton.bottomAnchor, constant: 20),
            instructionsButton.heightAnchor.constraint(equalToConstant: 50),
            instructionsButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5)
        ])
    }
    
    
    @objc func playButtonPressed(sender: UIButton!) {
        presentScreen(fromViewController: self, toViewController: MapViewController())
    }
    @objc func infoButtonPressed(sender: UIButton!) {
        presentScreen(fromViewController: self, toViewController: InformationViewController())
    }
    @objc func instructionsButtonPressed(sender: UIButton!) {
        presentScreen(fromViewController: self, toViewController: InstructionsViewController())
    }
}









func presentScreen(fromViewController: UIViewController, toViewController: UIViewController) {
    toViewController.modalPresentationStyle = .fullScreen
    fromViewController.present(toViewController, animated: false, completion: nil)
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, forState controlState: UIControl.State) {
        let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { _ in
            color.setFill()
            UIBezierPath(rect: CGRect(x: 0, y: 0, width: 1, height: 1)).fill()
        }
        
        setBackgroundImage(colorImage, for: controlState)
    }
}


extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
    
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        
        return nil
    }
}
