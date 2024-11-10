//
//  InformationViewController.swift
//  ARMultiuser
//
//  Created by admin on 11/9/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import UIKit
import SceneKit


class InformationViewController: UIViewController, UITextViewDelegate {
    let tileView = UIView()
    var currentTileIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!
        
        
        createTileInfoView()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
        
        
        tileView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tileView)
        
        
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
            tileView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tileView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            backButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
        ])
    }

    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if currentTileIndex == 0 {
                    currentTileIndex = energyDatabase.count - 1
                } else {
                    currentTileIndex -= 1
                }
            case UISwipeGestureRecognizer.Direction.down:
                    print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                if currentTileIndex == energyDatabase.count - 1 {
                    currentTileIndex = 0
                } else {
                    currentTileIndex += 1
                }
            case UISwipeGestureRecognizer.Direction.up:
                    print("Swiped up")
            default:
                    break
            }
        }
        
        createTileInfoView()
    }
    
    
    @objc func backButtonPressed(sender: UIButton!) {
        dismiss(animated: true)
    }
    
    
    func createTileInfoView() {
        for subview in tileView.subviews {
            subview.removeFromSuperview()
        }
        
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = energyDatabase[currentTileIndex]["name"]!
        titleLabel.textColor = UIColor(hex: "\(app[appVersion]!["mainColor"]!)FF")!
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tileView.addSubview(titleLabel)
        
        
        let modelScene = SCNScene(named: energyDatabase[currentTileIndex]["name"]! + ".scn")
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 15, z: 15)
        modelScene!.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.darkGray
        modelScene!.rootNode.addChildNode(ambientLightNode)
        
        let model = SCNView()
        model.allowsCameraControl = true // Change for testing
        model.cameraControlConfiguration.allowsTranslation = false
        model.scene = modelScene
        model.translatesAutoresizingMaskIntoConstraints = false
        tileView.addSubview(model)
        
        
        let tileSettings = UITextView()
        tileSettings.contentInsetAdjustmentBehavior = .automatic
        tileSettings.textAlignment = NSTextAlignment.left
        tileSettings.textColor = UIColor(hex: "\(app[appVersion]!["textColor"]!)FF")!
        tileSettings.tintColor = UIColor(hex: "\(app[appVersion]!["mainColor"]!)FF")!
        tileSettings.font = UIFont(name: app[appVersion]!["mainFont"]!, size: CGFloat(Float(app[appVersion]!["buttonFontSize"]!)!))
        tileSettings.backgroundColor = UIColor.clear
        tileSettings.text = "Cost ($): \(energyDatabase[currentTileIndex]["moneyCost"]!)\nProduce ($): \(energyDatabase[currentTileIndex]["moneyMake"]!)\nEnergy production (k Watt hour): \(energyDatabase[currentTileIndex]["energyOutput"]!)\nHappiness: \(energyDatabase[currentTileIndex]["happinessOutput"]!)\nEco-friendly green scale: \(energyDatabase[currentTileIndex]["greenOutput"]!)"
        tileSettings.isScrollEnabled = false
        tileSettings.isEditable = false
        tileSettings.isSelectable = false
        tileSettings.isUserInteractionEnabled = false
        tileSettings.delegate = self
        tileSettings.translatesAutoresizingMaskIntoConstraints = false
        tileView.addSubview(tileSettings)
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: tileView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: tileView.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: tileView.widthAnchor, multiplier: 0.8),
            
            model.centerXAnchor.constraint(equalTo: tileView.centerXAnchor),
            model.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            model.widthAnchor.constraint(equalTo: tileView.widthAnchor),
            model.heightAnchor.constraint(equalToConstant: 200),
            
            tileSettings.centerXAnchor.constraint(equalTo: tileView.centerXAnchor),
            tileSettings.topAnchor.constraint(equalTo: model.bottomAnchor, constant: 10),
            tileSettings.widthAnchor.constraint(equalTo: tileView.widthAnchor, multiplier: 0.8),
            tileSettings.bottomAnchor.constraint(equalTo: tileView.bottomAnchor),
        ])
    }
}
