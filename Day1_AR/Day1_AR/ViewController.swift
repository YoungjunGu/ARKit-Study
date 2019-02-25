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
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()

        sceneView.scene = scene
        
        createSolarSystem()
        
    }
    func createSolarSystem() {
        //parent Node
        let parentNode = SCNNode()
        parentNode.position.z = -1.5
        
        //planets
        let mercury = Planet(name: "mercury", radius: 0.14, rotation: 32.degreesToRadians, color: .orange, sunDistance: 1.3)
        let venus = Planet(name: "venus", radius: 0.35, rotation: 10.degreesToRadians, color: .cyan, sunDistance: 2)
        let earth = Planet(name: "earth", radius: 0.5, rotation: 18.degreesToRadians, color: .blue, sunDistance: 7)
        let saturn = Planet(name: "saturn", radius: 1, rotation: 12.degreesToRadians, color: .brown, sunDistance: 12)
        
        let planets = [mercury, venus, earth, saturn]
        
        for planet in planets {
            parentNode.addChildNode(createNode(from: planet))
        }
        
        
        let light = SCNLight()
        light.type = .omni
        parentNode.light = light
        
        //ParticleSystem 적용
        if let stars = SCNParticleSystem(named: "stars.scnp", inDirectory: nil) {
            parentNode.addParticleSystem(stars)
        } else {
            print("The Star ParticleSystem is nil")
        }
        
        if let sun = SCNParticleSystem(named: "sun", inDirectory: nil) {
            parentNode.addParticleSystem(sun)
        } else {
            print("The Sun ParticleSystem  is nil")
        }
        
        sceneView.scene.rootNode.addChildNode(parentNode)

    }
    
    func createNode(from planet: Planet) -> SCNNode {
        
        //부모 노드 생성
        let parentNode = SCNNode()
        //Animation rotateAction Setting
        let rotateAction = SCNAction.rotateBy(x: 0, y: planet.rotation, z: 0, duration: 1)
        parentNode.runAction(.repeatForever(rotateAction)) //infinite Rotation
        
        
        let sphereGeometry = SCNSphere(radius: planet.radius)
        sphereGeometry.firstMaterial?.diffuse.contents = planet.color
        let planetNode = SCNNode(geometry: sphereGeometry)
        planetNode.position.z = -planet.sunDistance // 뒤쪽으로 이어 지도록 -
        planetNode.name = planet.name
        parentNode.addChildNode(planetNode)
        
        //saturn 이면 고리 형성 작업 수행
        if planet.name == "saturn" {
            let ringGeometry = SCNTube(innerRadius: 1.2, outerRadius: 1.8, height: 0.05)
            ringGeometry.firstMaterial?.diffuse.contents = UIColor.darkGray
            let ringNode = SCNNode(geometry: ringGeometry)
            ringNode.eulerAngles.x = Float(-10.degreesToRadians)
            planetNode.addChildNode(ringNode)
        }
        
        if planet.name == "earth" {
            let moonGeometry = SCNSphere(radius: planet.radius/4)
            moonGeometry.firstMaterial?.diffuse.contents = UIColor.yellow
            let moonNode = SCNNode(geometry: moonGeometry)
            let moonRotateAction = SCNAction.rotateBy(x: CGFloat(planetNode.position.x), y: 5.degreesToRadians, z: CGFloat(planetNode.position.z) , duration: 1)

            moonNode.position.z = -planet.sunDistance + 5
            parentNode.addChildNode(moonNode)
            parentNode.runAction(.repeatForever(moonRotateAction))

        }
        
        return parentNode
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


}

extension Int {
    //conver to radius
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
    
}
