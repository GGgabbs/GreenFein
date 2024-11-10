import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity


class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    // MARK: - IBOutlets
    @IBOutlet weak var sessionInfoView: UIView!
    @IBOutlet weak var sessionInfoLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var sendMapButton: UIButton!
    @IBOutlet weak var mappingStatusLabel: UILabel!
    let deleteButton = UIButton(type: .system)
    
    // MARK: - View Life Cycle
    var multipeerSession: MultipeerSession!
    var isMulti = false // If playing multiplayer or not
    var isTurn = true // If it is the current user's turn or the other user (to prevent further world editing)
    var isDeleting = false // If the user is going to delete a block as their next move
    
    var currentTile = "windmill"
    var tilesSet: [String: Float] = ["c": 0.05, "3y": 0, "1y": 0, "1z": 0, "2y": 0, "2z": 0]
    var tiles: [[String: String]] = [] // Keeping track of name, x, and z for each node in grid
    var tileNodes: [SCNNode] = [] // The actual node (to remove properly)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multipeerSession = MultipeerSession(receivedDataHandler: receivedData)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        // Start the view's AR session.
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        // Set a delegate to track the number of plane anchors for providing UI feedback.
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        let spotLight = SCNNode()
        spotLight.light = SCNLight()
        spotLight.scale = SCNVector3(1,1,1)
        spotLight.light?.intensity = 1000
        spotLight.castsShadow = true
        spotLight.position = SCNVector3Zero
        spotLight.light?.type = SCNLight.LightType.directional
        spotLight.light?.color = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        sceneView.pointOfView?.light = spotLight.light
        
        
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
        
        createSideBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("panda") {
            let child = loadRedPandaModel()
            node.addChildNode(child)
            tileNodes.append(node)
            
            // Adding people
            if currentTile == "coal" {
                child.addChildNode(makePerson(nodeName: "construction", scalingFactor: 0.02, originx: child.position.x + 2, originy: tilesSet["3y"]! + 1, originz: child.position.z - 3.5))
            } else if currentTile == "house" {
                child.addChildNode(makePerson(nodeName: "watering", scalingFactor: 0.02, originx: child.position.x - 2, originy: tilesSet["3y"]! + 1, originz: child.position.z + 3.5))
            } else if currentTile == "plantFarm" {
                child.addChildNode(makePerson(nodeName: "planting", scalingFactor: 0.02, originx: child.position.x, originy: tilesSet["3y"]! + 1, originz: child.position.z))
            }
        }
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    /// - Tag: CheckMappingStatus
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        switch frame.worldMappingStatus {
        case .notAvailable, .limited:
            sendMapButton.isEnabled = false
        case .extending:
            sendMapButton.isEnabled = !multipeerSession.connectedPeers.isEmpty
        case .mapped:
            sendMapButton.isEnabled = !multipeerSession.connectedPeers.isEmpty
        @unknown default:
            sendMapButton.isEnabled = false
        }
        mappingStatusLabel.text = frame.worldMappingStatus.description
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        sessionInfoLabel.text = "Session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        sessionInfoLabel.text = "Session interruption ended"
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        
        // Remove optional error messages.
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.resetTracking(nil)
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Multiuser shared session
    
    /// - Tag: PlaceCharacter
    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        if isTurn {
            // Hit test to find a place for a virtual object.
            guard let hitTestResult = sceneView
                .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
                .first
            else { return }
            
            /*var x = hitTestResult.worldTransform.columns.3.x
            var z = hitTestResult.worldTransform.columns.3.z*/
            let x = hitTestResult.worldTransform.columns.3.x
            let z = hitTestResult.worldTransform.columns.3.z
            var anchor: ARAnchor!
            if isDeleting {
                for i in 0..<tiles.count {
                    if (x <= Float(tiles[i]["x"]!)! + tilesSet["c"]!) && (x >= Float(tiles[i]["x"]!)! - tilesSet["c"]!) && (z <= Float(tiles[i]["z"]!)! + tilesSet["c"]!) && (z >= Float(tiles[i]["z"]!)! - tilesSet["c"]!) { // In a tile
                        print(i)
                        tileNodes[i].removeFromParentNode()
                        tileNodes.remove(at: i)
                        
                        isDeleting = false
                        deleteButton.layer.borderWidth = 0
                        break
                    }
                }
            } else {
                
                // Place an anchor for a virtual character. The model appears in renderer(_:didAdd:for:).
                //let anchor = ARAnchor(name: "panda", transform: hitTestResult.worldTransform)
                
                /*print(x, z)
                for i in 0..<tiles.count {
                    let a = Float(tiles[i]["x"]!)!
                    let b = Float(tiles[i]["z"]!)!
                    if (x > a + tilesSet["c"]!) {
                        //x = a + Float(2 * tileSets["c"]!)
                    }
                }
                print(x, z)*/
                
                // y is up-down
                //let anchor = ARAnchor(name: "panda", transform: simd_float4x4(hitTestResult.worldTransform.columns.0, hitTestResult.worldTransform.columns.1, hitTestResult.worldTransform.columns.2, SIMD4(x, tileSets["y"]!, z, hitTestResult.worldTransform.columns.3.w)))
                if tilesSet["1y"]! == 0.0 {
                    tilesSet["1y"]! = hitTestResult.worldTransform.columns.1.y
                }
                if tilesSet["1z"]! == 0.0 {
                    tilesSet["1z"]! = hitTestResult.worldTransform.columns.1.z
                }
                if tilesSet["2y"]! == 0.0 {
                    tilesSet["2y"]! = hitTestResult.worldTransform.columns.2.y
                }
                if tilesSet["2z"]! == 0.0 {
                    tilesSet["2z"]! = hitTestResult.worldTransform.columns.2.z
                }
                if tilesSet["3y"]! == 0.0 {
                    tilesSet["3y"]! = hitTestResult.worldTransform.columns.3.y
                }
                
                anchor = ARAnchor(name: "panda", transform:
                    simd_float4x4(
                        hitTestResult.worldTransform.columns.0,
                        SIMD4(hitTestResult.worldTransform.columns.1.x, tilesSet["1y"]!, tilesSet["1z"]!, hitTestResult.worldTransform.columns.1.w),
                        SIMD4(hitTestResult.worldTransform.columns.2.x, tilesSet["2y"]!, tilesSet["2z"]!, hitTestResult.worldTransform.columns.2.w),
                        SIMD4(x, tilesSet["3y"]!, z, hitTestResult.worldTransform.columns.3.w)
                    )
                )
                sceneView.session.add(anchor: anchor)
                tiles.append(["name": currentTile, "x": "\(x)", "z": "\(z)"])
            }
            
            
            // Changing variables
            /*let currentTileIndex = energyDatabase.firstIndex(where: $0["name"] = currentTile)
            stats["money"] -= energyDatabase[currentTile]["moneyCost"]!
            "money": 100
            , "energy": 0
            , "happiness": 0
            , "greenScale": 0*/
            
            // Changing the user's turn
            if isMulti {
                // Send the anchor info to peers, so they can place the same content.
                guard let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor!, requiringSecureCoding: true)
                else { fatalError("can't encode anchor") }
                self.multipeerSession.sendToAllPeers(data)
                
                // Sending the map via shareSession
                // Sending the map via shareSession
                sceneView.session.getCurrentWorldMap { worldMap, error in
                    guard let map = worldMap
                    else { print("Error: \(error!.localizedDescription)"); return }
                    guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                    else { fatalError("can't encode map") }
                    self.multipeerSession.sendToAllPeers(data)
                }
                
                self.isTurn = false
                self.sessionInfoLabel.text = "Wait for your next turn"
            }
        } else {
            self.sessionInfoLabel.text = "Wait for your next turn"
        }
    }
    
    var mapProvider: MCPeerID?
    /// - Tag: ReceiveData
    func receivedData(_ data: Data, from peer: MCPeerID) {
        do {
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
                // Run the session with the received world map.
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                
                // Remember who provided the map for showing UI feedback.
                mapProvider = peer
                
                isTurn = true
            } else if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data) {
                // Add anchor to the session, ARSCNView delegate adds visible content.
                sceneView.session.add(anchor: anchor)
                
                isTurn = true
            } else {
                print("unknown data recieved from \(peer)")
            }
        } catch {
            print("can't decode data recieved from \(peer)")
        }
    }
    
    // MARK: - AR session management
    
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty && multipeerSession.connectedPeers.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "Move around to map the environment, or wait to join a shared session."
            
        case .normal where !multipeerSession.connectedPeers.isEmpty && mapProvider == nil:
            let peerNames = multipeerSession.connectedPeers.map({ $0.displayName }).joined(separator: ", ")
            message = "Connected with \(peerNames)."
            
        case .notAvailable:
            message = "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.initializing) where mapProvider != nil,
             .limited(.relocalizing) where mapProvider != nil:
            message = "Received map from \(mapProvider!.displayName)."
            
        case .limited(.relocalizing):
            message = "Resuming session — move to where you were when the session was interrupted."
            
        case .limited(.initializing):
            message = "Initializing AR session."
            
        default:
            // No feedback needed when tracking is normal and planes are visible.
            // (Nor when in unreachable limited-tracking states.)
            message = ""
            
        }
        
        sessionInfoLabel.text = message
        sessionInfoView.isHidden = message.isEmpty
    }
    
    @IBAction func resetTracking(_ sender: UIButton?) {
        isDeleting = false
        deleteButton.layer.borderWidth = 0
        
        //let configuration = ARWorldTrackingConfiguration()
        //configuration.planeDetection = .horizontal
        //sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        sceneView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
            else { print("Error: \(error!.localizedDescription)"); return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
            else { fatalError("can't encode map") }
            self.multipeerSession.sendToAllPeers(data)
        }
        
        isTurn = true
    }
    
    // MARK: - AR session management
    private func loadRedPandaModel() -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: currentTile, withExtension: "scn")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        referenceNode.load()
        
        let percentScale = 0.01
        referenceNode.scale = SCNVector3(x: (referenceNode.scale.x * Float(percentScale)), y: (referenceNode.scale.y * Float(percentScale)), z: (referenceNode.scale.z * Float(percentScale)))
        
        
        return referenceNode
    }
    
    
    func createSideBar() {
        let sideBar = UIView()
        sideBar.translatesAutoresizingMaskIntoConstraints = false
        sceneView.addSubview(sideBar)
        
        let addButton = UIButton(type: .system)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        addButton.tintColor = .clear
        addButton.setBackgroundImage(UIImage(named: app[appVersion]!["addButtonImageName"]!)!, for: .normal)
        addButton.setBackgroundImage(UIImage(named: app[appVersion]!["addButtonSelectedImageName"]!)!, for: .selected)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        sideBar.addSubview(addButton)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonPressed), for: .touchUpInside)
        deleteButton.tintColor = .clear
        deleteButton.setBackgroundImage(UIImage(named: app[appVersion]!["deleteButtonImageName"]!)!, for: .normal)
        deleteButton.setBackgroundImage(UIImage(named: app[appVersion]!["deleteButtonSelectedImageName"]!)!, for: .selected)
        deleteButton.layer.borderColor = UIColor.red.cgColor
        deleteButton.layer.borderWidth = 0
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        sideBar.addSubview(deleteButton)
        
        let multiplayerButton = UIButton(type: .system)
        multiplayerButton.addTarget(self, action: #selector(multiplayerButtonPressed), for: .touchUpInside)
        multiplayerButton.tintColor = .clear
        multiplayerButton.setBackgroundImage(UIImage(named: app[appVersion]!["multiplayerButtonImageName"]!)!, for: .normal)
        multiplayerButton.setBackgroundImage(UIImage(named: app[appVersion]!["multiplayerButtonSelectedImageName"]!)!, for: .selected)
        multiplayerButton.isSelected = false
        multiplayerButton.translatesAutoresizingMaskIntoConstraints = false
        sideBar.addSubview(multiplayerButton)
        
        let statsButton = UIButton(type: .system)
        statsButton.addTarget(self, action: #selector(statsButtonPressed), for: .touchUpInside)
        statsButton.tintColor = .clear
        statsButton.setBackgroundImage(UIImage(named: app[appVersion]!["statsButtonImageName"]!)!, for: .normal)
        statsButton.setBackgroundImage(UIImage(named: app[appVersion]!["statsButtonSelectedImageName"]!)!, for: .selected)
        statsButton.translatesAutoresizingMaskIntoConstraints = false
        sideBar.addSubview(statsButton)
        
        let homeButton = UIButton(type: .system)
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .touchUpInside)
        homeButton.tintColor = .clear
        homeButton.setBackgroundImage(UIImage(named: app[appVersion]!["homeButtonImageName"]!)!, for: .normal)
        homeButton.setBackgroundImage(UIImage(named: app[appVersion]!["homeButtonSelectedImageName"]!)!, for: .selected)
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        sideBar.addSubview(homeButton)
        
        
        NSLayoutConstraint.activate([
            sideBar.centerYAnchor.constraint(equalTo: sceneView.centerYAnchor),
            sideBar.leftAnchor.constraint(equalTo: sceneView.safeAreaLayoutGuide.leftAnchor),
            sideBar.widthAnchor.constraint(equalToConstant: 50),
            
            addButton.topAnchor.constraint(equalTo: sideBar.topAnchor),
            addButton.centerXAnchor.constraint(equalTo: sideBar.centerXAnchor),
            addButton.widthAnchor.constraint(equalTo: sideBar.widthAnchor),
            addButton.heightAnchor.constraint(equalTo: addButton.widthAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: addButton.bottomAnchor),
            deleteButton.centerXAnchor.constraint(equalTo: sideBar.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalTo: sideBar.widthAnchor),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor),
            
            multiplayerButton.topAnchor.constraint(equalTo: deleteButton.bottomAnchor),
            multiplayerButton.centerXAnchor.constraint(equalTo: sideBar.centerXAnchor),
            multiplayerButton.widthAnchor.constraint(equalTo: sideBar.widthAnchor),
            multiplayerButton.heightAnchor.constraint(equalTo: multiplayerButton.widthAnchor),
            
            statsButton.topAnchor.constraint(equalTo: multiplayerButton.bottomAnchor),
            statsButton.centerXAnchor.constraint(equalTo: sideBar.centerXAnchor),
            statsButton.widthAnchor.constraint(equalTo: sideBar.widthAnchor),
            statsButton.heightAnchor.constraint(equalTo: statsButton.widthAnchor),
            
            homeButton.topAnchor.constraint(equalTo: statsButton.bottomAnchor),
            homeButton.centerXAnchor.constraint(equalTo: sideBar.centerXAnchor),
            homeButton.widthAnchor.constraint(equalTo: sideBar.widthAnchor),
            homeButton.heightAnchor.constraint(equalTo: statsButton.widthAnchor),
            homeButton.bottomAnchor.constraint(equalTo: sideBar.bottomAnchor),
        ])
    }
    
    @objc func addButtonPressed(sender: UIButton!) {
        isDeleting = false
        deleteButton.layer.borderWidth = 0
        
        let vc = AddTileViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    @objc func deleteButtonPressed(sender: UIButton!) {
        if isDeleting {
            isDeleting = false
            deleteButton.layer.borderWidth = 0
        } else {
            isDeleting = true
            deleteButton.layer.borderWidth = 3
        }
    }
    @objc func multiplayerButtonPressed(sender: UIButton!) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            isMulti = true
        } else {
            isMulti = false
            isTurn = true
        }
    }
    @objc func statsButtonPressed(sender: UIButton!) {
        isDeleting = false
        deleteButton.layer.borderWidth = 0
        
        let vc = StatsViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    @objc func homeButtonPressed(sender: UIButton!) {
        print("SAVE????")
        dismiss(animated: true)
    }
}



func makePerson(nodeName: String, scalingFactor: Float, originx: Float, originy: Float, originz: Float) -> SCNNode {
    let newTileScene = SCNScene(named: nodeName + ".scn")!

    let imageMaterial = SCNMaterial()
    imageMaterial.isDoubleSided = false
    imageMaterial.diffuse.contents = UIImage(named: "Logo")
    imageMaterial.diffuse.contentsTransform = SCNMatrix4Mult(SCNMatrix4MakeScale(0.01, 0.01, 0.01), SCNMatrix4MakeTranslation(0, 0, 0))
    newTileScene.rootNode.childNode(withName: nodeName, recursively: true)?.geometry?.materials = [imageMaterial]
    
    let newTile = newTileScene.rootNode
    newTile.position = SCNVector3Make(originx,originy,originz)
    newTile.scale = SCNVector3(x: (newTile.scale.x * Float(scalingFactor)), y: (newTile.scale.y * Float(scalingFactor)), z: (newTile.scale.z * Float(scalingFactor)))
    //game.scene.rootNode.addChildNode(newTile)
    
    return newTile
}
