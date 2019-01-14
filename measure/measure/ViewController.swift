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
    
    //사용자가 터치를 하게 될시에 호출이 되는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //hitTest 글자나 AR image 를 찾기 위한 작업 수행
        let hitTest = sceneView.hitTest(view.center, types: .featurePoint)
        //마지막 값을 반환
        let result = hitTest.last
        //세계 좌표계와 관련된 히트 테스트 결과의 위치와 방향.
        guard let transform = result?.worldTransform else {
            return
        }
        //3열의 좌표값을 반환
        let thirdColumn = transform.columns.3
        let position = SCNVector3Make(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        
        let sphereGeometry = SCNSphere(radius: 0.005)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.position = position
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
 
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        sceneView.scene = scene
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
