//
//  ViewController.swift
//  planedetection
//
//  Created by Romain on 20/03/2018.
//  Copyright © 2018 Romain. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
		
		if #available(iOS 11.3, *) {
			configuration.planeDetection = [.horizontal, .vertical]
		} else {
			// ios 11.0
			configuration.planeDetection = .horizontal
		}
        sceneView.session.run(configuration)
    }
	
	
	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
		//the initial torus
//		let torus = SCNTorus(ringRadius: 0.15, pipeRadius: 0.02)
//		torus.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.9)
//		node.geometry = torus

		guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
		let extent = planeAnchor.extent

		let plane = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
		let planeNode = SCNNode(geometry: plane)
		planeNode.eulerAngles.x = -.pi/2
		planeNode.name = "arPlane"

		let anchorNode = SCNScene(named: "art.scnassets/anchor.scn")!.rootNode
		
		//uncomment next line to see the AR Anchor!
		//node.addChildNode(anchorNode)
		node.addChildNode(planeNode)

	}


//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
//        let extent = planeAnchor.extent
//
//        let planeGeometry = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
//        planeGeometry.firstMaterial?.colorBufferWriteMask = []
//        planeGeometry.firstMaterial?.isDoubleSided = true
//
//        let planeNode = node.childNode(withName: "arPlane", recursively: false)
//        planeNode?.castsShadow = false
//        planeNode?.renderingOrder = -1
//        planeNode?.geometry = planeGeometry
//
//        let center = planeAnchor.center
//        planeNode?.position = SCNVector3Make(center.x, 0, center.z)
//
//
//    }
	
	//ARSCNPlaneGeometry (Last lecture of the section on plane detection.
	
	
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        if #available(iOS 11.3, *) {
            let planeGeometry = planeAnchor.geometry
            guard let metalDevice = MTLCreateSystemDefaultDevice() else {return}
            let plane = ARSCNPlaneGeometry(device: metalDevice)
            plane?.update(from: planeGeometry)
            node.geometry = plane
        }
    }
	
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
	
}
