//
//  ViewController.swift
//  testAR
//
//  Created by An Nguyen on 10/6/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        sceneView.autoenablesDefaultLighting = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    
    func getFruitType() -> String {
        
        return "tomato"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let fruitType = getFruitType()
        let string2 = "art.scnassets/"
        let string3 = ".scn"
        let path =  string2 + fruitType + string3
        print(path)
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                
                let bananaScene = SCNScene(named: path)!
                
                if let bananaNode = bananaScene.rootNode.childNode(withName: fruitType, recursively: true) {
                    
                    bananaNode.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y,
                        z: hitResult.worldTransform.columns.3.z
                    )
                    
                    sceneView.scene.rootNode.addChildNode(bananaNode)
                    
                }
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        let fruitType = getFruitType()
        let string1 = "-pop.png"
        let image_path = fruitType + string1
        if anchor is ARPlaneAnchor {
            
            print("plane detected")
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(planeAnchor.center.x, 0.3, planeAnchor.center.z)
            
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named: image_path)
            gridMaterial.isDoubleSided = true
            plane.materials = [gridMaterial]
            
            
            
            planeNode.geometry = plane
            
            
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
    }
}

    

