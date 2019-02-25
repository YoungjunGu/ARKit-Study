//
//  ViewController.swift
//  solarsystem
//
//  Created by youngjun goo on 07/11/2018.
//  Copyright © 2018 youngjun goo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    func createSolarSystem() {
        //parent Node
        let parentNode = SCNNode()
        parentNode.position.z = -1.5
        
        //planets
        let mercury = Planet(name: "mercury", radius: 0.14, rotation: 32, color: <#T##UIColor#>, sunDistance: <#T##Float#>)
        
    }
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

}
