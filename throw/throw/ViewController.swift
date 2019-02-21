//
//  ViewController.swift
//  throw
//
//  Created by Romain on 02/04/2018.
//  Copyright © 2018 Romain. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	
	var center : CGPoint!
	let arrow = SCNScene(named: "art.scnassets/arrow.scn")!.rootNode
	let gameNode = SCNScene(named: "art.scnassets/scene.scn")!.rootNode
	var positions = [SCNVector3]()
	
	var isGameOn = false
	
	
	func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		if !isGameOn {
		let hitTest = sceneView.hitTest(center, types: .featurePoint)
		let result = hitTest.last
		guard let transform = result?.worldTransform else {return}
		let thirdColumn = transform.columns.3
		let position = SCNVector3Make(thirdColumn.x, thirdColumn.y, thirdColumn.z)
		positions.append(position)
		let lastTenPositions = positions.suffix(10)
		arrow.position = getAveragePosition(from: lastTenPositions)
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if isGameOn {
			//throw balls
			createAndThrowFireBall()
			
			
		} else {
			//place the gameNode
			guard let angle = sceneView.session.currentFrame?.camera.eulerAngles.y else {return}
			gameNode.position = arrow.position
			gameNode.eulerAngles.y = angle
			isGameOn = true
			sceneView.scene.rootNode.addChildNode(gameNode)
			arrow.removeFromParentNode()
		}
	}
	
	func createAndThrowFireBall() {
		//fireball 생성
		let ball = SCNSphere(radius: 0.06)
		let fireBall = SCNNode(geometry: ball)
		fireBall.physicsBody = .dynamic()
		fireBall.physicsBody?.mass = 0.5
		
        //particle 이펙트 추가
		fireBall.addParticleSystem(SCNParticleSystem(named: "fire.scnp", inDirectory: nil)!)
		
		//해당 카메라 화면에 fireball 추가
		let camera = sceneView.session.currentFrame?.camera
		guard let cameraTransform = camera?.transform else {return}
		fireBall.simdTransform = cameraTransform
		sceneView.scene.rootNode.addChildNode(fireBall)
		
		//set force
		let force = float4(0, 0,-5,0)
		let adjustedForce = simd_mul(cameraTransform, force)
		let vector = SCNVector3Make(adjustedForce.x, adjustedForce.y, adjustedForce.z)
		fireBall.physicsBody?.applyForce(vector, asImpulse: true)
		
		//공 유지 시간 설정 
		let disapear = SCNAction.fadeOut(duration: 0.3)
		fireBall.runAction(.sequence([.wait(duration: 3) ,disapear]))
		
	}

	
	
	
	
	
	
	
	func getAveragePosition(from positions : ArraySlice<SCNVector3>) -> SCNVector3 {
		var averageX : Float = 0
		var averageY : Float = 0
		var averageZ : Float = 0
		
		for position in positions {
			averageX += position.x
			averageY += position.y
			averageZ += position.z
		}
		let count = Float(positions.count)
		return SCNVector3Make(averageX / count , averageY / count, averageZ / count)
	}
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
		center = view.center
		sceneView.scene.rootNode.addChildNode(arrow)
    }
	
	override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
		center = view.center
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
