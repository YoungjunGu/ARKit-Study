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


### [`SCNGeometry`](https://developer.apple.com/documentation/scenekit/scngeometry)

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


### [`SCNMaterial`](https://developer.apple.com/documentation/scenekit/scnmaterial)

Geometry가 랜더링 되었을 때 외형을 정의하는 Shading attribute(속성)들의 집합이다.

Material을 생성할 때 Scene에서 다양한 Geometry에서 재사용 할 수 있는 시각적인 속성들의 집합과 그들의 옵션을 정의한다.

메터리얼은 몇몇의 시각적 프로퍼티들을 갖고 있고 각각은 SceneKit의 조명 및 음영 처리의 다른 부분을 정의한다. 각각의 프로퍼티들은 단색, 질감 혹은 기타 2D 컨텐츠를 제공하는 [SCNMaterialProperty](https://developer.apple.com/documentation/scenekit/scnmaterialproperty) 클래스의 인스턴스들이다. 그리고 메터리얼의 [lightingModel](https://developer.apple.com/documentation/scenekit/scnmaterial/1462518-lightingmodel) 프로퍼티는 SceneKit이 시각적 속성을 장면의 광원과 결합하여 랜더링 된 씬의 각 픽셀에 대한 최종 색상을 생성하는데 사용하는 수식을 결정한다. (랜더링 프로세스에 대한 자세한 내용은 [SCNMaterial.LightingModel](https://developer.apple.com/documentation/scenekit/scnmaterial/lightingmodel)를 참고)


`SCNGeometry` 인스턴스의 [firstMaterial](https://developer.apple.com/documentation/scenekit/scngeometry/1523485-firstmaterial) 또는 [materials](https://developer.apple.com/documentation/scenekit/scngeometry/1523472-materials) 프로퍼티들을 사용하여 한 개 또는 그 이상의 Material들을 Geometry에 붙일 수 있다. 다수의 Geometry 들은 동일한 Material을 참조할 수 있다. 이 경우 Material 속성을 변경하면 이를 참조하고 있는 모든 Geometry의 외형이 변경된다.

### [`SCNNode`](https://developer.apple.com/documentation/scenekit/scnnode)

Geometry, Light(조명), Camera 또는 기타 표현 가능한 컨텐츠를 첨부할 수 있는 3D좌표계 에서 위치와 변형을 나타내는 Scene Graph의 구조 요소이다.

`SCNNode` 객체는 스스로는 어떠한 시각적인 요소를 가지고 있지 않다. 상위 노드 기준으로 오직 한 좌표 공간의 변형(위치, 방향 및 크기 조절)만을 나타낸다. Scene 을 구성하려면 구조를 생성하기 위해 node의 계층을 사용하고 조명과 카메라 그리고 Geometry를 노드에 추가하여 시각적 요소를 생성한다.

### Nodes Determine the Structure of a Scene

씬 안의 노드의 계층 혹은 씬 그래프는 SceneKit를 사용하여 컨텐츠의 구성과 내용을 표현하고 조작할 수 있는 기능을 정의한다. SceneKit를 사용하여 코드로 제작하거나 3D 제작 도구로 만든 파일에서 불러오거나 혹은 이 두 방법을 함께 사용하여 노드 계층을 생성할 수 있다. SceneKit은 씬 그래프를 구성하고 탐색할 수 있는 여러 기능을 제공한다.

씬의 [rootNode](https://developer.apple.com/documentation/scenekit/scnscene/1524029-rootnode) 객체는 SceneKit이 랜더링한 세계의 좌표계를 정의한다. 이 루트 노드에 추가한 각 자식 노드들은 자신들만의 좌표 시스템을 생성하고 이는 그 자식 노드들에게 상속된다. 노드의 position, rotation 및 scale 프로퍼티들을 사용하여 (또는 transform 프로퍼티를 사용하여 직접) 좌표계 간의 변환(transformation)을 결정할 수 있다.

노드 계층과 변환을 사용하여 앱의 요구에 맞는 방식으로 씬의 컨텐츠들을 모델링 할 수 있다. 예를 들어 만약 당신의 앱이 움직이는 태양계 시스템의 뷰를 표현한다면 서로 연관되어 있는 천체를 모델링하는 노드 계층 구조를 만들 수 있다. 각 행성은 궤도와 태양의 좌표계에 정의 된 궤도상의 현재 위치를 갖는 노드가 될 수 있다. 하나의 행성 노드는 자신의 좌표 공간을 정의하는데 이는 자신의 회전 궤도와 달의 궤도 (각 행성의 자식 노드)를 지정하는데 유용하다. 이러한 뷰 씬 계층으로 씬에 현실적인 움직임을 쉽게 추가할 수 있다. 행성 주변의 달의 자전과 태영 주위의 행성에 애니메이션을 적용하면 달이 행성을 따라가는 애니메이션을 확인할 수 있다.

### A Node’s Attachments Define Visual Content and Behavior

노드 계층은 씬의 공간과 논리적 구조를 결정하지만 시각적 컨텐츠는 정의하지 않는다. SCNGeometry 객체를 노드에 붙임으로써 2D 그리고 3D 객체를 씬에 추가할 수 있다. (지오메트리들은 SCNMaterial 객체들에 의해서 외형이 결정된다.) 조명과 그림자 효과가 있는 씬에서 지오메트리를 음영 처리하기 위해선 SCNLight가 붙여진 노드를 추가하라. 랜더링 할 때 나타나는 뷰 포인트를 조정하려면 SCNCamera 객체가 붙여진 노드를 추가하라.

SceneKit 컨텐츠에 물리학에 기반한 행동이나 특수 효과를 주기 위해선 다른 종류의 노드 부착물을 사용하라. 예를 들어 SCNPhysicsBody 객체는 물리 시뮬레이션을 위한 노드의 특성을 정의하고 SCNPhysicsField 객체는 노드 주변의 물리 구조체에 힘을 적용한다. SCNParticleSystem 객체는 노드가 정의한 공간 안에서 불, 비 혹은 떨어지는 낙엽과 같은 입자 효과를 랜더링한다.

성능을 개선하기 위해서 SceneKit은 여러 노드들 간의 부착물을 공유할 수 있다. 예를 들어 각각의 동일한 모형을 갖는 레이싱 게임에서 씬 그래프는 많은 노드를 포함하는데 각각은 위치와 애니메이션을 지정하지만 모든 자동차 노드는 동일한 지오메트리 객체를 참조한다.


### 구현 순서

- Scene 을 생성한다.

```swift
		// --- 1
        // 새로운 Scene 생성
        let scene = SCNScene()
```

-  SceneKit의 기본 원시 도형인 SCNBox를 생성한다. (단위 : m)

```swift
        // --- 2
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
```

- 생성한 SCNBox의 외형dmf SCNMaterial 객체를 생성하고 설정한다.


```swift

        // ---- 3
        let material = SCNMaterial() 
        material.diffuse.contents = UIColor.red 
```

- SCNBox가 위치하게 될 SCNode를 생성하고 SCNBox를 할당하고 위치, material 을 결정하는 속성을 부여한다.

```swift
        // --- 4
        let node = SCNNode()
        node.geometry = box
        node.geometry?.materials = [material]
        node.position = SCNVector3(0, 0.1, -0.5)
```

- Scene의 Node Layer의 rootNode에 생성한 노드를 추가한다.

```swift
        // --- 5
        scene.rootNode.addChildNode(node)

        // 생성한 SCNScene을 프로젝트 Scene에 할당한다
        sceneView.scene = scene
```

- Session 구성을 생성하고 Session을 실행시킨다

```swift
		// --- 6
        // Session 구성을 생성
        let configuration = ARWorldTrackingConfiguration()

        // Scene의 Session 실행
        sceneView.session.run(configuration)
```




