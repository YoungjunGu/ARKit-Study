//
//  ViewController.swift
//  ImageDetection
//
//  Created by youngjun goo on 12/11/2018.
//  Copyright © 2018 youngjun goo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var siri = AVSpeechSynthesizer()
    
    let contentFor = [
        "Rony" : "이 강아지 이름은 로니에요 채은이의 강아지 이고 태어난지는 1년조금 넘은거 같아요 정말 귀엽죠?",
        "Water Lily Pond" : "워터 릴리 폰드 라는 그림이에요 뭐가 더 궁금하죠?",
        "Surprised!" : "서프라이즈드! 라는 그림이에요 뭐가 더 궁금하죠?",
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "paintings", bundle: nil)
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return
        }
        let image = imageAnchor.referenceImage
       
        guard let imageName = image.name, let content = contentFor[imageName] else {
            return
        }
        print(imageName)
        //Speak Contents
        speekSentence(what: content)
        
    }
    //MARK: -Text to Speech
    func speekSentence(what description: String) {
        siri.stopSpeaking(at: .immediate)
        let content = AVSpeechUtterance(string: description)
        siri.speak(content)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

}
