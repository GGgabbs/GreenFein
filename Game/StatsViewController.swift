//
//  StatsViewController.swift
//  ARMultiuser
//
//  Created by admin on 11/9/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import UIKit
import SceneKit


class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let popUp = UIView()
    let tableView = UITableView()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 0, green: 0.1, blue: 0, alpha: 0.6)
        
        popUp.backgroundColor = UIColor(hex: "\(app[appVersion]!["backgroundColor"]!)66")!
        popUp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(popUp)
        
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "Stats"
        titleLabel.textColor = UIColor(hex: "\(app[appVersion]!["mainColor"]!)FF")!
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        popUp.addSubview(titleLabel)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        popUp.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            popUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popUp.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            popUp.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.75),
            popUp.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.75),
            
            titleLabel.topAnchor.constraint(equalTo: popUp.topAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: popUp.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: popUp.widthAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: popUp.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: popUp.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: popUp.bottomAnchor)
        ])
        
        
        
        tableView.reloadData()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = view.hitTest(firstTouch.location(in: view), with: event)

            if hitView === popUp {
                print("touch is inside popUp")
            } else {
                dismiss(animated: true)
            }
        }
    }
    
    
    // UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(containerView)
        
        
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.text = Array(stats.keys)[indexPath.row]
        nameLabel.textColor = UIColor(hex: "\(app[appVersion]!["textColor"]!)FF")!
        nameLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        
        let valueLabel = UILabel()
        valueLabel.textAlignment = .right
        valueLabel.text = "\(stats[nameLabel.text!]!)"
        valueLabel.textColor = UIColor(hex: "\(app[appVersion]!["mainColor"]!)FF")!
        valueLabel.font = UIFont.systemFont(ofSize: 60, weight: .bold)
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(valueLabel)
        
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor),
            containerView.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor),
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: valueLabel.leftAnchor, constant: -10),
            
            valueLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            valueLabel.widthAnchor.constraint(equalToConstant: 100),
            valueLabel.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentingView = presentingViewController as! ViewController
        presentingView.currentTile = energyDatabase[indexPath.row]["name"]!
        dismiss(animated: true)
    }
}
