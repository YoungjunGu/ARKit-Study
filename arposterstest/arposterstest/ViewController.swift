//
//  ViewController.swift
//  arposterstest
//
//  Created by Romain on 13/03/2018.
//  Copyright © 2018 Romain. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	
	let starwarsNode = SCNScene(named: "art.scnassets/ship.scn")!.rootNode
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
		starwarsNode.eulerAngles.x = -.pi/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        //Image Detection 
		configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        sceneView.session.run(configuration)
    }
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		
		guard let imageAnchor = anchor as? ARImageAnchor else {return}
		let ref = imageAnchor.referenceImage.name
		node.addChildNode(starwarsNode)
		
	}
    
	
}
