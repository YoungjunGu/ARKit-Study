//
//  ViewController.swift
//  shapes
//
//  Created by youngjun goo on 01/11/2018.
//  Copyright © 2018 youngjun goo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        //MARK: - iOS version check
        if #available(iOS 11.3, *) {
            configuration.planeDetection = [.horizontal, .vertical]
        } else {
            configuration.planeDetection = .horizontal
        }
        sceneView.session.run(configuration)
    }
    
    //MARK: - Plane Setting
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        //estimate width and height of plane
        let extent = planeAnchor.extent
        
        let plane = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi/2
        planeNode.name = "arPlane"
        
        
        let anchorNode = SCNScene(named: "art.scnassets/ship.scn")!.rootNode
        //node.addChildNode(anchorNode)
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        let extent = planeAnchor.extent
        
        let planeGeometry = SCNPlane(width: CGFloat(extent.x), height: CGFloat(extent.z))
        //planeGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
        
        planeGeometry.firstMaterial?.colorBufferWriteMask = []
        planeGeometry.firstMaterial?.isDoubleSided = true
        
        let planeNode = node.childNode(withName: "arPlane", recursively: false)
        //Shadow
        planeNode?.castsShadow = false
        //렌더링 순서 설정 즉 -> 사물이 겹쳐지는 것을 감지
        planeNode?.renderingOrder = -1
        
        planeNode?.geometry = planeGeometry
        
        
        let center = planeAnchor.center
        planeNode?.position = SCNVector3Make(center.x, 0, center.z)
        
    }
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    

}
