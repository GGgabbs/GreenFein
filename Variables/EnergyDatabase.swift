//
//  EnergyDatabase.swift
//  ARMultiuser
//
//  Created by admin on 11/9/24.
//  Copyright © 2024 Apple. All rights reserved.
//

import UIKit


let energyDatabase: [[String: String]] = [
    [
        "name": "solar"
        , "moneyCost": "400"
        , "moneyMake": "0"
        , "energyOutput": "120"
        , "happinessOutput": "0"
        , "greenOutput": "20"
    ]
    , [
        "name": "windmill"
        , "moneyCost": "600"
        , "moneyMake": "0"
        , "energyOutput": "200"
        , "happinessOutput": "5"
        , "greenOutput": "25"
    ]
    , [
        "name": "animalFarm"
        , "moneyCost": "150"
        , "moneyMake": "50"
        , "energyOutput": "0"
        , "happinessOutput": "5"
        , "greenOutput": "-5"
    ]
    , [
        "name": "grass"
        , "moneyCost": "10"
        , "moneyMake": "0"
        , "energyOutput": "0"
        , "happinessOutput": "5"
        , "greenOutput": "5"
    ]
    , [
        "name": "nuclearPlant"
        , "moneyCost": "2000"
        , "moneyMake": "0"
        , "energyOutput": "1000"
        , "happinessOutput": "-15"
        , "greenOutput": "15"
    ]
    , [
        "name": "shop"
        , "moneyCost": "300"
        , "moneyMake": "200"
        , "energyOutput": "-100"
        , "happinessOutput": "15"
        , "greenOutput": "-5"
    ]
    , [
        "name": "oil"
        , "moneyCost": "300"
        , "moneyMake": "0"
        , "energyOutput": "150"
        , "happinessOutput": "-15"
        , "greenOutput": "-20"
    ]
    , [
        "name": "coal"
        , "moneyCost": "200"
        , "moneyMake": "0"
        , "energyOutput": "120"
        , "happinessOutput": "-25"
        , "greenOutput": "-40"
    ]
    , [
        "name": "house"
        , "moneyCost": "70"
        , "moneyMake": "30"
        , "energyOutput": "-50"
        , "happinessOutput": "1"
        , "greenOutput": "-2"
    ]
    , [
        "name": "plantFarm"
        , "moneyCost": "80"
        , "moneyMake": "20"
        , "energyOutput": "0"
        , "happinessOutput": "5"
        , "greenOutput": "5"
    ]
]


let mapDatabase: [[String: String]] = [
    [
        "name": "West coast"
        , "UV": "4"
        , "wind": "6"
        , "crop": "Grape"
        , "color": "#4f42b5" // Ocean blue (coast)
    ]
    , [
        "name": "Midwest"
        , "UV": "5.5"
        , "wind": "4"
        , "crop": "Corn"
        , "color": "#4f42b5" // Sand (desert)
    ]
    , [
        "name": "Northeast"
        , "UV": "2"
        , "wind": "7"
        , "crop": "Potato"
        , "color": "#4f42b5" // Grey (mountain)
    ]
    , [
        "name": "South"
        , "UV": "4"
        , "wind": "2"
        , "crop": "Orange"
        , "color": "#4f42b5" // Green (swamp)
    ]
]

let mapDatabaseCoordinates: [[[Float]]] = [
    [ // West coast
        [48.903105, -124.799442]
        , [40.326622, -124.372315]
        , [34.717745, -120.528174]
        , [32.430294, -117.111160]
        , [31.498518, -109.056769]
        , [48.903105, -110.033059]
    ]
    , [ // Midwest
        [31.498518, -109.056769]
        , [48.903105, -110.033059]
        , [48.943198, -95.022603]
        , [47.849366, -89.653009]
        , [29.871898, -89.591990]
        , [29.386556, -94.890043]
        , [26.030561, -97.249222]
        , [29.899158, -101.714810]
        , [31.498518, -109.056769]
    ]
    , [ // Northeast
        [47.849366, -89.653009]
        , [48.264572, -88.249750]
        , [45.259685, -82.515896]
        , [42.086927, -82.281861]
        , [44.929257, -74.558711]
        , [45.341993, -70.638627]
        , [47.281566, -68.298279]
        , [44.763326, -66.894070]
        , [36.520723, -75.892116]
        , [36.550259, -89.653009]
    ]
    , [ // South
        [36.550259, -89.653009]
        , [36.520723, -75.892116]
        , [35.769895, -75.659665]
        , [31.553953, -81.331470]
        , [26.682576, -79.983254]
        , [25.177480, -80.541137]
        , [30.036491, -83.934922]
        , [29.871898, -89.591990]
    ]
]
