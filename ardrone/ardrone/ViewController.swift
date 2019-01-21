//
//  ViewController.swift
//  measure
//
//  Created by youngjun goo on 13/11/2018.
//  Copyright © 2018 youngjun goo. All rights reserved.
//


import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	
	var drone = SCNNode()
	var audioSource = SCNAudioSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
		let scene = SCNScene(named: "art.scnassets/ardrone.scn")!
		
		//load Drone
		drone = scene.rootNode.childNode(withName: "ardrone", recursively: true)!
		// Load audioSource
		audioSource = SCNAudioSource(fileNamed: "art.scnassets/drone.m4a")!
		audioSource.loops = true
		audioSource.isPositional = true
		audioSource.shouldStream = false
		audioSource.load()
        sceneView.scene = scene
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		drone.removeAllAudioPlayers()
		drone.addAudioPlayer(SCNAudioPlayer(source: audioSource))
		
		
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
