# ARKit 기본적이 구현

## SceneKit 에 속하는 기본적인 클래스

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

Node Layer와 3D Scene을 만드는 전역 프로퍼티들의 컨테이너 이다.

SCneneKit를 사용하여 3D 컨텐츠를 표시하기 위해서는 시각적 요소를 표현하는 속성들과 노드들의 계층을 포함하는 Scene 을 생성해야한다. 일반적으로 3D visual editor로 asset 을 생성하고 Xcode의 `SceneKit Scene Editor` 를 사용하여 하나의 씬으로 조합하면 SceneKit에서의 렌더링 준비가 끝난다.


<img width="546" alt="image" src="https://user-images.githubusercontent.com/33486820/54734803-9c192b80-4be5-11e9-94a5-3e12eb0107f3.png">

출력하고자 하는 Scene 을 위해 런타임에서 불러와야 하며 이를 [SCNView](https://developer.apple.com/documentation/scenekit/scnview)의 프로퍼티로 지정해야한다. 증강현실을 제공하기 위한 ARKit의 ARKit의 `ARSCNView`는 SCNView 타입의 scene 프로퍼티를 갖고 있어 코드에서 생성한 SCNView 타입의 scene 객체를 할당해줄 수 있다.

> ARSCNView 와 SCNView의 차이는 SCNView 클래스는 3D ScneneKit 컨텐츠를 출력해주는 뷰로 ARSCNView 의 부모 클래스이다. ARSCNView는 SCNView와 달리 출력하기 위한 non-nil한 객체를 필요로한다.


### [SCNGeometry](https://developer.apple.com/documentation/scenekit/scngeometry)

3D 형태의 모형(Model 또는 Mesh)으로 외형을 결정하는 물질(materials)들과 함께 Scene 에서 출력될 수 있다.

SceneKit에서 `SCNNode` 객체에 붙은 `SCNGeometry` 객체들은 Scene의 시각적인 요소들을 구성하고 `SCNMaterial` 객체들은 `SCNGeometry` 들의 외형을 결정하기 위해 붙여진다.

### Working with Geometry Object

Scenen의 Geometry(`SCNGeometry` Object) 들의 외형은 Node(`SCNNode` Object) 들과 Material(`SCNMAterail` 객체)들로 조정한다.
Geometry 객체는 SceneKit에 의해 랜더링된 시각적 객체의 형태만 제공한다. Geometry 표면의 색과 텍스쳐(질감)을 지정할 수 있으며 빛에 어떻게 음영이지고 밝기가 조절되는지 조정할 수 있고 Material들을 붙여 특수 효과를 추가할 수도 있다([`Managing a Geometry's Materials`](https://developer.apple.com/documentation/scenekit/scngeometry#1655143) 문서 참고)
Geometry를 `SCNNode` 객체에 붙임으로써 Scene에서 Geometry의 위치와 방향을 지정할 수 있다. 여러개의 Node들이 같은 Geometry 객체를 참조할 수 있도록 함으로 그것이 Scene 내에서 다양한 위치에서 보일 수 있도록 한다.


> Geometry를 쉽게 복사할 수 있고 그들의 Material또한 쉽게 변경 가능하다


Geometry 객체는 변경 불가능한 **정점 데이터(vertex data)** 와 ** 변경가능한 Material** 간의 관계를 관리한다. 하나의 Geometry를 다른 Material의 구성으로 동일한 씬에서 한번 이상 보이게 하려면 [copy()](https://developer.apple.com/documentation/objectivec/nsobject/1418807-copy) 메소드를 사용하면 된다. 이러한 복사본은 원본의 정점 데이터를 공유하지만 Material은 별개로 지정 가능하다. 그 결과 상당한 비용이 드는 랜더링 퍼포먼스 없이 하나의 Geometry를 복사해서 사용할 수 있다.


> Geometry 객체에 애니메이션 효과를 줄 수 있다.

Geometry 와 연관된 정점 데이터는 변경 불가능 하지만 SceneKit은 Geometry 애니메이션 효과를 줄 수 있는 몇개의 방법을 제공한다. [SCNMorpher](https://developer.apple.com/documentation/scenekit/scnmorpher) 혹은 [SCNSkinner](https://developer.apple.com/documentation/scenekit/scnskinner)
객체를 사용하여 Geometry의 표면을 변형하거나 외부 3D 제작 툴에서 작성되고 Scene file 에서 로드된 애니메이션을 실행할 수 있다. 또한 [SCNShadable](https://developer.apple.com/documentation/scenekit/scnshadable)
프로토콜 메소드를 사용하여 SceneKit의 Geometry 랜더링을 변경하는 사용자 정의 GLSL 쉐이더 프로개름을 추가할 수 있다.


### Obtaining a Geometry Object

ScneneKit는 앱에서 사용할 수 있는 Geometry 객체를 다양한 방법으로 제공한다.

|Action|For Further Information|
|:---|:---|
|외부 3D 제작 도구로부터 만들어진 파일 로드|`SCNScene`, `SCNSceneSource`|
|SceneKit에 내장된 원시 도형 사용과 사용자 정의|`SCNPlane`, `SCNBox`, `SCNSphere`, `SCNPyramid`, `SCNCone`, `SCNCylinder`, `SCNCapsule`, `SCNTube`, `SCNTorus`|
|2D 텍스트 혹은 베이저 곡선을 통해 3D 지오메트리 생성|`SCNText`, `SCNShape`|
|정점 데이터로부터 사용자 정의 지오메트리 생성|`SCNGeometrySource`, `SCNGeometryElement`, `init(sources:elements:)`, [Managing Geometry Data]((https://developer.apple.com/documentation/scenekit/scngeometry#1655143))|






