//
//  MapViewController.swift
//  ARMultiuser
//
//  Created by admin on 11/9/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate, UITextViewDelegate {
    var mapView = MKMapView()
    
    let regionView = UIView()
    var currentTileIndex = 0
    var regionRectangles: [[CLLocationCoordinate2D]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)FF")!
        
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "Select a location on the map."
        titleLabel.textColor = UIColor(hex: "\(app[appVersion]!["mainColor"]!)FF")!
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(regionSelected))
        mapView.addGestureRecognizer(tap)
        
        regionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(regionView)
        
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
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            
            mapView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.bottomAnchor.constraint(equalTo: regionView.topAnchor),
            
            regionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regionView.bottomAnchor.constraint(equalTo: backButton.topAnchor),
            regionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            backButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            
            playButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            playButton.bottomAnchor.constraint(equalTo: backButton.bottomAnchor),
            playButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            playButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -10),
        ])
        
        
        createMapOverlays()
        createRegionInfoView()
    }
    
    
    @objc func backButtonPressed(sender: UIButton!) {
        dismiss(animated: true)
    }
    
    @objc func playButtonPressed(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "viewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    
    func createMapOverlays() {
        for i in 0..<mapDatabase.count {
            var regionRectangle: [CLLocationCoordinate2D] = []
            for j in 0..<mapDatabaseCoordinates[i].count {
                regionRectangle.append(CLLocationCoordinate2D(latitude: CLLocationDegrees(mapDatabaseCoordinates[i][j][0]), longitude: CLLocationDegrees(mapDatabaseCoordinates[i][j][1])))
            }
            
            regionRectangles.append(regionRectangle)
            let polygon = MKPolygon(coordinates: regionRectangle, count: regionRectangle.count)
            mapView.addOverlay(polygon)
        }
    }
    
    func createRegionInfoView() {
        for subview in regionView.subviews {
            subview.removeFromSuperview()
        }
        
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = mapDatabase[currentTileIndex]["name"]!
        titleLabel.textColor = UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        regionView.addSubview(titleLabel)
        
        let tileSettings = UITextView()
        tileSettings.contentInsetAdjustmentBehavior = .automatic
        tileSettings.textAlignment = NSTextAlignment.left
        tileSettings.textColor = UIColor(hex: "\(app[appVersion]!["textColor"]!)FF")!
        tileSettings.tintColor = UIColor(hex: "\(app[appVersion]!["mainColor"]!)FF")!
        tileSettings.font = UIFont(name: app[appVersion]!["mainFont"]!, size: CGFloat(Float(app[appVersion]!["buttonFontSize"]!)!))
        tileSettings.backgroundColor = UIColor.clear
        tileSettings.text = "UV Index (kWh/m^2/Day): \(mapDatabase[currentTileIndex]["UV"]!)\nWind (m/s): \(mapDatabase[currentTileIndex]["wind"]!)\nSuggested crop: \(mapDatabase[currentTileIndex]["crop"]!)"
        tileSettings.isScrollEnabled = false
        tileSettings.isEditable = false
        tileSettings.isSelectable = false
        tileSettings.isUserInteractionEnabled = false
        tileSettings.delegate = self
        tileSettings.translatesAutoresizingMaskIntoConstraints = false
        regionView.addSubview(tileSettings)
        
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: regionView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: regionView.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: regionView.widthAnchor, multiplier: 0.8),
            
            tileSettings.centerXAnchor.constraint(equalTo: regionView.centerXAnchor),
            tileSettings.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tileSettings.widthAnchor.constraint(equalTo: regionView.widthAnchor, multiplier: 0.8),
            tileSettings.bottomAnchor.constraint(equalTo: regionView.bottomAnchor),
        ])
    }
    
    
    // Map functions
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard(overlay is MKPolygon) else { return MKOverlayRenderer() }
        
        let renderer = MKPolygonRenderer.init(polygon: overlay as! MKPolygon)
        renderer.lineWidth = 1.0
        renderer.strokeColor = UIColor(hex: "\(app[appVersion]!["accentColor"]!)FF")!
        renderer.fillColor = UIColor(hex: "\(app[appVersion]!["accentColor"]!)66")!
        
        return renderer
    }
    
    @objc func regionSelected(sender: UIGestureRecognizer!) {
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        for i in 0..<regionRectangles.count {
            let region = PolygonRegion(verticies: regionRectangles[i])
            if region.isPointInside(locationCoordinate) {
                // Changing color of selected region
                /*let polygon = MKPolygon(coordinates: regionRectangles[i], count: regionRectangles[i].count)
                if let renderer = mapView.renderer(for: polygon) as? MKPolygonRenderer {
                    renderer.fillColor = UIColor.red
                    renderer.setNeedsDisplay()
                }*/
                
                // Adjusting the selected views
                currentTileIndex = i
                createRegionInfoView()
                break
            }
        }
    }
}
