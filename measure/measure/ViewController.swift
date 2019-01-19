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
    
    let arrow = SCNScene(named: "art.scnassets/arrow.scn")?.rootNode
    var center: CGPoint!
    
    //위치들을 저장할 SCNVector 형 배열
    var positions = [SCNVector3]()
    
    var isFirstPoint = true
    var points = [SCNNode]()
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        //hitTest 글자나 AR image 를 찾기 위한 작업 수행
        let hitTest = sceneView.hitTest(center, types: .featurePoint)
        //마지막 값을 반환
        let result = hitTest.last
        //세계 좌표계와 관련된 히트 테스트 결과의 위치와 방향.
        guard let transform = result?.worldTransform else {
            return
        }
        //3열의 좌표값을 반환
        let thirdColumn = transform.columns.3
        let position = SCNVector3Make(thirdColumn.x, thirdColumn.y, thirdColumn.z)
        positions.append(position)
        //suffic 사용법 : 컬렉션의 최종 요소가 들어있는 지정된 최대 길이까지 하위 시퀀스를 반환
        //positions 배열의 하위 10개의 position 인자들을 반환 한다.
        let lastTenPositions = positions.suffix(10)
        //하위 10개의 position들의 평균 position 값을 얻어 반환 한다.
        arrow?.position = getAveragePosition(from: lastTenPositions)
    }
    
    //평균 위치를 반환 하는 함수
    //주의 SCNVector3 형의 벡터를 반환할때 SCNVector3Make(:::)를 사용해서 반환한다.
    func getAveragePosition(from positions: ArraySlice<SCNVector3>) -> SCNVector3 {
        var averageX: Float = 0
        var averageY: Float = 0
        var averageZ: Float = 0
        
        for position in positions {
            averageX += position.x
            averageY += position.y
            averageZ += position.z
        }
        let count = Float(positions.count)
        return SCNVector3Make(averageX / count, averageY / count, averageZ / count)
    }
    
    
    //사용자가 터치를 하게 될시에 호출이 되는 함수
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let sphereGeometry = SCNSphere(radius: 0.005)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        
        if let nodePosition = arrow?.position {
            sphereNode.position = nodePosition
        } else {
            print("Node position is nil")
        }
        
        sceneView.scene.rootNode.addChildNode(sphereNode)
        points.append(sphereNode)
        
        //중복 터치를 막기 위한 작업
        if isFirstPoint {
            isFirstPoint = false
        } else {
            //거리 측정
            let firstPoint = points[points.count - 2]
            guard let lastPoint = points.last else {
                return
            }
            let realDistance = distance(float3(firstPoint.position), float3(lastPoint.position))
            
            let line = SCNGeometry.line(from: firstPoint.position, to: lastPoint.position)
            print(realDistance.description)
            line.firstMaterial?.diffuse.contents = UIColor.yellow
            
            //시작과 끝 point 사이 선을 추가
        
            let lineNode = SCNNode(geometry: line)
            sceneView.scene.rootNode.addChildNode(lineNode)
            //중단점 추가 -> 중단점에 실제 길이 값을 보여주는 3D Text 를 위함
            let midPoint = (float3(firstPoint.position)) + (float3(lastPoint.position)) / 2
            let midPointGeometry = SCNSphere(radius: 0.003)
            midPointGeometry.firstMaterial?.diffuse.contents = UIColor.red
            let midPointNode = SCNNode(geometry: midPointGeometry)
            //중간노드 즉 텍스트를 추가할 노드의 위치를 설정
            midPointNode.position = SCNVector3Make(midPoint.x, midPoint.y, midPoint.z)
            sceneView.scene.rootNode.addChildNode(midPointNode)
            //테스트 노드를 추가
            //실제 거리 값에 *100  = cm 표현
            //extrusionDepth : Geometry의 깊이를 설정하는 값
            let textGeometry = SCNText(string: String(format: "%.1f", realDistance * 100) + "cm" , extrusionDepth: 1)
            let textNode = SCNNode(geometry: textGeometry)
            
            textNode.scale = SCNVector3Make(0.005, 0.005, 0.01)
            //텍스트 geometry의 정확도와 부드러움 정도를 설정 하는 값
            textGeometry.flatness = 0.2
            
            midPointNode.addChildNode(textNode)
            
            //노드가 항상 현재 카메라를 가리 키도록 지시하는 제약 조건
            //해당 midPoint의 text를 카메라의 모든 방향에서 동일하게 보이도록 제약조건을 걸어 준다.
            let constraints = SCNBillboardConstraint()
            constraints.freeAxes = .all
            midPointNode.constraints = [constraints]
            
            
            isFirstPoint = true
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        center = view.center
        if let node = arrow {
            sceneView.scene.rootNode.addChildNode(node)
        } else {
            print("the arrow node is nill!")
        }
        //조명을 추가 할지를 결정하는 Bool 값 설정
        sceneView.autoenablesDefaultLighting = true
        
    }
    //View가 회전했을때의 Center 값을 다시 반한 하기 위함
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


extension SCNGeometry {
   class func line(from vectorFirst: SCNVector3, to vectorLast: SCNVector3) -> SCNGeometry {
        
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vectorFirst, vectorLast])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
}
