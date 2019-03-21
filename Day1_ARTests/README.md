# ARKit 기본적이 구현

## SceneKit 에 속하는 기본적이 클래스

- [SCNScene](https://developer.apple.com/documentation/scenekit/scnscene)
- [SCNGeometry](https://developer.apple.com/documentation/scenekit/scngeometry)
- [SCNMaterial](https://developer.apple.com/documentation/scenekit/scnmaterial)
- [SCNNode](https://developer.apple.com/documentation/scenekit/scnnode)


```swift
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

        // --- 1
        // 새로운 Scene 생성
        let scene = SCNScene()

        // --- 2
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)

        // ---- 3
        let material = SCNMaterial() 
        material.diffuse.contents = UIColor.red 

        // --- 4
        let node = SCNNode()
        node.geometry = box
        node.geometry?.materials = [material]
        node.position = SCNVector3(0, 0.1, -0.5)

        // --- 5
        scene.rootNode.addChildNode(node)

        // Set the scene to the view
        sceneView.scene = scene
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // --- 6
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
```

### [SCNScene](https://developer.apple.com/documentation/scenekit/scnscene)
