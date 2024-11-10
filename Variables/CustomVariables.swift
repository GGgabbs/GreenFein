//
//  CustomVariables.swift
//  HackPrinceton2024
//
//  Created by admin on 11/8/24.
//

import UIKit


let appVersion = "1.0" // Can change app version for when we want to change our UI


let app: [String: [String: String]] = [
    "1.0": [
        // Colors
        "mainColor": "#12CD12" // Grass green
        , "accentColor": "#8A9A5B" // Sage green
        , "backgroundColor": "#E5E4E2" // Light grey
        , "textColor": "#000000" // Black
        
        
        // Fonts
        , "mainFont": "Arial"
        , "boldFont": "Arial Bold"
        
        , "mainFontSize": "14"
        , "buttonFontSize": "20"
        , "headerFontSize": "30"
        
        
        // Corners
        , "buttonBorderWidth": "5"
        , "buttonCornerRadius": "0"
        
        
        // Links
        
        
        // Images
        , "logoImageName": "Logo"
        , "restartButton": "restart"
        , "restartButtonSelected": "restartPressed"
        , "addButtonImageName": "Build"
        , "addButtonSelectedImageName": "Build"
        , "deleteButtonImageName": "Delete"
        , "deleteButtonSelectedImageName": "Delete"
        , "multiplayerButtonImageName": "Singleplayer"
        , "multiplayerButtonSelectedImageName": "Multiplayer"
        , "statsButtonImageName": "Stats"
        , "statsButtonSelectedImageName": "Stats"
        , "homeButtonImageName": "Home"
        , "homeButtonSelectedImageName": "Home"
        
        
        // Keys
        , "mcPeerServiceKey": "myServiceKey"
        
        
        // Text
        , "name": "GreenFe!n"
        , "playButtonTitle": "START"
        , "infoButtonTitle": "INFO"
        , "instructionsButtonTitle": "INSTRUCTIONS"
        , "backButtonTitle": "BACK"
        , "instructions": "Welcome to GreenFe!n\n\n\nPick a location on the map of where you want to start your town! Careful, your location affects how effective your choice of energy is. As town creator, you have a budget and the freedom to pick and choose your building blocks. According to John Geiss III, with great power comes great responsibility. You must keep your townspeople happy, the environment healthy, and your town energy output high in order to run shops and houses.\n\nOnce you start a new game, locate the toolbar on the left of your screen to find a build box, delete box, and multiplayer or singleplayer box. To build a block, select your desired tile and tap on your phone screen. In multiplayer you and your co-town creator alternate between placing blocks by selecting the “share your world map” button after placing a block. To exit the game press the home button. Good luck!"
    ]
]


var stats: [String: Float] = [
    "money": 100
    //, "energy": 0
    //, "happiness": 0
    //, "greenScale": 0
    , "energy": 40
    , "happiness": 20
    , "greenScale": 60
]


// Corners
let buttonMaskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner)


// Data
let dispatchGroup = DispatchGroup()
var errorString = ""
