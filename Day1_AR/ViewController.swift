//
//  ViewController.swift
//  Day1_AR
//
//  Created by youngjun goo on 05/11/2018.
//  Copyright © 2018 youngjun goo. All rights reserved.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        createShapes()
        addLights()
    }
    
    func createShapes() {
        //createNode
        let pyramid = SCNPyramid(width: 0.2, height: 0.2, length: 0.2) // m 단위
        pyramid.firstMaterial?.diffuse.contents = UIColor.green // color 설정
        let pyramidNode = SCNNode(geometry: pyramid)
        //최초 생성 position 설정
        pyramidNode.position.z = -0.8 //사용자 앞에 80cm 떨어진 곳에 생성
        //pyramidNode.position.x 는 좌우 방향 조절
        // pyramidNode.position.y 는 위 아래 방향 조절
        // 0 0 0 의 root 노드
        //scene에 SCNNode 추가
        sceneView.scene.rootNode.addChildNode(pyramidNode)
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0) //chamferRadius = 모서리 경사진 정도
        box.firstMaterial?.diffuse.contents = UIColor.yellow
        let boxNode = SCNNode(geometry: box)
        boxNode.position =  SCNVector3Make(-0.5, 0, -0.8) // 왼쪽  50센치 뒤로 80센치 떨어진 곳에 벡터값 설정
        sceneView.scene.rootNode.addChildNode(boxNode)
        
        let sphere = SCNSphere(radius: 0.15)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = SCNVector3Make(0.5, 0, -0.8)// 오른쪽 50센치 뒤로 80 센치 떨어진 곳에 벡터값 설정
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
    }
    // Lights Settings Method
    func addLights() {
        //방향 변수 설정
        let directional = SCNLight()
        directional.type = .directional
        let directionalNode = SCNNode()
        directionalNode.light = directional
        directionalNode.eulerAngles.x = -.pi/4
        sceneView.scene.rootNode.addChildNode(directionalNode)
        
        let ambient = SCNLight()
        ambient.type = .ambient
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambient
        //literal 값으로 색상 설정
        let color = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        ambient.color = color
        sceneView.scene.rootNode.addChildNode(ambientLightNode)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
