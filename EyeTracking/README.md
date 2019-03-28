
# AR Face Tracking Use ARKit

Face Tracking을 위해 TrueDepth 전면 카메라를 지원하는 iPhone이 필요하다.(iPhoneX 이상)


## 시작하기

- Xcode를 실행하고 Single View App 템플릿을 기반으로 새로운 프로젝트를 만든다.
- `import ARKit` 를 추가한다.
- Main.stroyboard 에서 ViewController의 최상위 view를 선택한 상태에서 클래스를 `ARSCNView`로 변경한다.

<img width="1399" alt="image" src="https://user-images.githubusercontent.com/33486820/55002731-73949580-501a-11e9-987a-1598e94263d2.png">

[`ARSCNView`](https://developer.apple.com/documentation/arkit/arscnview)는 `SceneKit` 컨텐츠를 사용하여 증강 현실 경험을 보요주는 view이다. 카메라 피드를 표시하고 `SCNNode`를 표시해준다.

- ViewController에서 ARSCNView로 설정한 최상위 view를 sceneView라는 IBOutlet 으로 연결해준다.


```swift
override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
        
  // 1
  let configuration = ARFaceTrackingConfiguration()
        
  // 2
  sceneView.session.run(configuration)
}
    
override func viewWillDisappear(_ animated: Bool) {
  super.viewWillDisappear(animated)
        
  // 1
  sceneView.session.pause()
}
```

- `viewWillAppear`
	- 1. 얼굴을 추적하는 **configuration**을 생성한다
	- 2. ARSCNView의 기본 ARSession 속성을 사용하여 얼굴 추적 구성 실행한다.

- `viewWillDisappear`
	- 1. ARSession을 pause한다
    
    
### TrueDepth 를 지원 하는 디바이스에서만 사용가능

사용자에게 TrueDepth가 전면 카메라에 지원되는 디바이스 인지 아닌지에 따라 피드백을 해야한다.


```swift
guard ARFaceTrackingConfiguration.isSupported else {
  fatalError("이 장치에서는 얼굴 추적 기능이 지원 되지 않습니다.")
}
```

## Face Anchors and Geometries


### [`ARFaceAnchor`](https://developer.apple.com/documentation/arkit/arfaceanchor)

Face Tracking AR Session에서 감지된 얼굴의 포즈, 위상 및 표현에 대한 정보

```swift
class ARFaceAnchor : ARAnchor
```

얼굴 추적 ARSession을 실행할 때([`ARFaceTrackingConfiguration`](https://developer.apple.com/documentation/arkit/arfacetrackingconfiguration) 참고), 세션은 전면 카메라로 사용자의 얼굴을 탐지했을 때 ARFaceAnchor 객체의 앵커 목록에 자동으로 추가한다. 각 face anchor는 현재 위치와 방향, topology(위상) 및 facial expression(표정)에 대한 정보를 제공한다.

#### Tracking Face Position and Orientation(얼굴 위치 및 방향 추적)

상속된 [`transform`](https://developer.apple.com/documentation/arkit/aranchor/2867981-transform) 속성은 실세계 좌표에서 세션 구성의 [`worldAlignment`](https://developer.apple.com/documentation/arkit/arconfiguration/2923550-worldalignment) 속성에 의해 지정된 것과 관련된 좌표 공간에서. 얼굴의 현재 위치와 방향을 설명한다. 이 변환 매트릭스를 사용하여 AR 씬(scene)의 얼굴에 "attach"할 가상 컨텐츠를 배치해야한다.

<img width="613" alt="image" src="https://user-images.githubusercontent.com/33486820/55006077-7c886580-5020-11e9-8664-856239bb0940.png">


> 좌표계는 오른손 기준

- 양(+)의 x 방향은 관점자(viewer)의 오른쪽( 즉, 얼굴 기준의 왼쪽)
- 양(+)의 y 방향은 위로 향하고(실세계가 아닌 얼굴 자체에 입장에서 즉 관찰자 기준이 아닌 대상의 얼굴의 위쪽으로)
- 양(+)의 z 방향은 얼굴에서 (viewer 쪽으로) 바깥쪽으로 향한다.
 
 
#### Using Face Topology(얼굴의 위상 사용)


이 [`geometry`](https://developer.apple.com/documentation/arkit/arfaceanchor/2928271-geometry) 속성은 얼굴의 자세한 topology(위상)을 나타내는 [`ARFaceGeometry`](https://developer.apple.com/documentation/arkit/arfacegeometry)객체를 제공한다. 이 객체는 감지 된 얼굴의 크기, 모양 및 현재 식과 일치하도록 일반 모델을 준수한다.

예를 들어 가상 메이크업이나 문신을 바르는 등 사용자의 얼굴 모양을 따르는 콘텐츠를 오버레이하는 기준으로 이 모델을 사용할 수 있다. 또한 이 모델을 사용하여 눈에 보이는 콘텐츠를 렌더링하지 않지만(카메라 이미지가 투과되도록 허용) 장면의 다른 가상 콘텐츠에 대한 카메라의 시야를 방해하는 3D 모델인 폐색 지오메트리를 만들 수 있다.


#### Tracking Facial Expressions(얼굴 감정 추적)


[`blendShapes`](https://developer.apple.com/documentation/arkit/arfaceanchor/2928251-blendshapes) property(혼합형 쉐이프 특성) 은 현재 얼굴 표정의 높은 수준의 모델을 제공하며, 중립 구성에 대한 특정 얼굴 형상의 움직임을 나타내는 일련의 명명된 계수를 통해 설명된다. 혼합형 모양 계수를 사용하여 사용자의 얼굴 표정을 따르는 방법으로 캐릭터나 아바타와 같은 2D 또는 3D 콘텐츠를 애니메이션할 수 있다.


<hr>

### [`ARFaceGeometry`](https://developer.apple.com/documentation/arkit/arfacegeometry)


얼굴 추적 AR 세션에 사용되는 얼굴 토폴로지를 설명하는 3D 망(mesh)

```swift
class ARFaceGeometry : NSObject
```

이 클래스는 다양한 렌더링 기술과 함께 사용하거나 3D Asset을 내보내는 데 적합한 3D 망(mesh)의 형태로 얼굴의 세부 topology(위상)에 대한 일반 모델을 제공한다.(SceneKit를 사용하여 얼굴 형상을 신속하게 시각화하는 방법은 [`ARSCNFaceGeometry`](https://developer.apple.com/documentation/arkit/arscnfacegeometry) 클래스를 참조).

얼굴 추적 AR 세션에서 [`ARFaceAnchor`]([`ARFaceAnchor`](https://developer.apple.com/documentation/arkit/arfaceanchor)객체로부터 얼굴 형상을 얻을 때 모델은 검출된 얼굴의 치수, 형태 및 현재 표현과 일치한다. 또한 얼굴의 현재 표현에 대한 상세하지만 효율적인 설명을 제공하는 blend shape coefficients의 dictionary를 사용하여 얼굴의 mesh를 만들 수도 있다.

AR 세션에서 이 모델을 사용자의 얼굴 모양을 따르는 컨텐츠를 오버레이하는 기준으로 사용할 수 있다(예: SNOW 앱). 또한 이 모델을 사용하여 카메라 영상에서 탐지된 면의 3D 모양 뒤에 다른 가상 컨텐츠를 숨기는 폐색 형상을 만들 수도 있다.

> 노트

얼굴 메쉬 위상은 ARFaceGeometry 인스턴스(instance)에 걸쳐 일정하다. 즉, [vertexCount](https://developer.apple.com/documentation/arkit/arfacegeometry/2928206-vertexcount),[textureCoordinateCount](https://developer.apple.com/documentation/arkit/arfacegeometry/2928197-texturecoordinatecount) 및 [trianglecount](https://developer.apple.com/documentation/arkit/arfacegeometry/2928207-trianglecount)의 값은 절대 변하지 않으며, [triangleIndices](https://developer.apple.com/documentation/arkit/arfacegeometry/2928199-triangleindices)버퍼는 항상 정점의 동일한 배치를 설명하며, 텍스쳐 좌표 버퍼는 항상 동일한 정점 지수를 동일한 질감 좌표에 매핑한다.

AR 세션에서 제공하는 얼굴 메쉬 간에 정점 버퍼만 변경되며, ARKit가 사용자 얼굴의 모양과 표현에 mesh를 적응시킬 때 vertex 위치의 변화를 나타낸다.


<hr>


### [`ARSCNFaceGeometry`](https://developer.apple.com/documentation/arkit/arscnfacegeometry)

AR Session에 의해 제공된 얼굴 정보와 함께 사용하기 위한 얼굴 topology(위상)의 SceneKit 표현


```swift
class ARSCNFaceGeometry : SCNGeometry
```

이 클래스는 ARFaceGeometry 클래스에서 제공하는 mesh 데이터를 감싸는 SCNGeometry의 하위 클래스다. ARKit에서 제공하는 얼굴 위상과 얼굴 표정을 SceneKit View에서 빠르고 쉽게 시각화할 수 있는 ARSCNFaceGeometry를 사용할 수 있다.


> ARSCNFaceGeometry는 Metal을 사용하는 SceneKit View 또는 렌더러에서만 사용할 수 있다. 이 클래스는 OpenGL 기반 SceneKit 렌더링에는 지원되지 않는다


얼굴 mesh 위상은 ARSCNFaceGeometry 객체의 수명 동안 일정하다. 즉, 지오메트리의 단일 [`SCNGeometryElement`](https://developer.apple.com/documentation/scenekit/scngeometryelement) 객체는 항상 같은 정점의 배치를 기술하며, [`texcoord`](https://developer.apple.com/documentation/scenekit/scngeometrysource/semantic/1523762-texcoord) 지오메트리 소스는 항상 동일한 정점을 동일한 texture 좌표에 매핑한다.

[`update(from:)`](https://developer.apple.com/documentation/arkit/arscnfacegeometry/2928196-update)메서드로 지오메트리를 수정하면 정점 지오메트리 소스의 내용만 변경되어 ARKit가 사용자 얼굴의 모양과 표현에 mesh를 적응시킴으로써 정점 위치의 차이를 나타낸다.

<hr>

## Adding a Mesh Mask


전면 카메라를 실행 시키면 아이폰은 face tracking을 즉각적으로 실행하고 보이지 않지만 실행을 하고있다. 사용자의 얼굴을 추적하는 것을 시각화 하는 것이 가능하다. 여러개의 폴리곤 형태로 face mesh mask를 시각화 할 수 있다.


```swift
// 1
extension ViewController: ARSCNViewDelegate {
  // 2
  func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
    
    // 3
    guard let device = sceneView.device else {
      return nil
    }
    
    // 4
    let faceGeometry = ARSCNFaceGeometry(device: device)
    
    // 5
    let node = SCNNode(geometry: faceGeometry)
    
    // 6
    node.geometry?.firstMaterial?.fillMode = .lines
    
    // 7
    return node
  }
}
```

실행하기 전에 sceneViewdml  ARSCNView 델리게이트를 설정해주어야한다.


```swift
sceneView.delegate = self
```


1. ViewController에서 `ARSCNViewDelegate` 프로토콜을 채택한다.

2. `renderer(_:nodefor:)` 메서드를 구현한다.

3. 렌더링을 위해 Metal에서 지원이 되는 디바이스인지 체크해야한다.(iPhoneX 미만시 여기서 nil이 반환 된다)

4. face geometry를 생성한다.

5. 생성한 face geometry 기반으로 SceneKit Node를 생성한다.

6. 시각화를 위해 geometry의 material을 `.line`으로 설정한다.

7. SCNNode를 반환한다.


## Updating the Mesh Mask

위의 과정이 끝났으면 이제 얼굴의 feature를 찾는 작업을 해야한다. 눈을 깜빡이고 입을 벌리고 하는 등에 동작을 할때 아직까지는 mesh에 반영이 되지 않는다.
아래의 ARSCNViewDelegate 메서드를 추가로 구현해주면 된다.


```swift
// 1
func renderer(
  _ renderer: SCNSceneRenderer, 
  didUpdate node: SCNNode, 
  for anchor: ARAnchor) {
   
  // 2
  guard let faceAnchor = anchor as? ARFaceAnchor,
    let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
      return
  }
    
  // 3
  faceGeometry.update(from: faceAnchor.geometry)
}
```

1. [`renderer(_:didUpdate:for:)`](https://developer.apple.com/documentation/arkit/arscnviewdelegate/2865799-renderer) 프로토콜 메서드를 추가한다. 해당 메서드는 SceneKit 노드의 속성이 해당 앵커의 현재 상태와 일치하도록 업데이트되었음을 알려주는 역할이다.

2. anchor가 업데이트 되는 것이 `ARFaceAnchor`이고 faceGeometry 가 `ARSCNFaceGeometry`인지 보장이 되어야한다.

3. faceGeometry를 업데이트 된 값의 ARFaceAnchor의 Geometry갑으로 업데이트 해준다.


<hr>


## Face Feature 제어하기


얼굴의 각 feature(눈, 코, 입 등)를 제어하고 위에 이미지 등을 SNOW 앱처럼 제어하는 방법을 익혀보자.


- 우선 String 을 UIImage로 바꾸는 작업을 하여 SCNPlane의 contents 값을 설정하기 위해 extension해준다.


```swift
extension String {
  
  func image() -> UIImage? {
    
    let size = CGSize(width: 20, height: 22)
    
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    UIColor.clear.set()
    
    let rect = CGRect(origin: .zero, size: size)
    UIRectFill(CGRect(origin: .zero, size: size))
    
    (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 15)])
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    return image
  }
}
```

- 얼굴 feature 위에 입힐 이모지 배열을 선언한다.

```swift
  let noseOptions = ["👃", "🐽", "💧", " "]
  let eyeOptions = ["👁", "🌕", "🌟", "🔥", "⚽️", "🔎", " "]
  let mouthOptions = ["👄", "👅", "❤️", " "]
  let hatOptions = ["🎓", "🎩", "🧢", "⛑", "👒", " "]
```

- feature의 node 이름과 indice 배열을 선어한다.

```swift
  let features = ["nose", "leftEye", "rightEye", "mouth", "hat"]
  let featureIndices = [[9], [1064], [42], [24, 25], [20]]
``` 


`features` 배열은 얼굴 feature의 NODE 이름을 저장한 배열이고 `featureIndices` 배열은 ARFaceGeometry에서 해당 기능에 해당하는 정점 인덱스이다. 입의 경우에는 인덱스 값을 두개를 가진다. 열린 입의 경우에는 얼굴에 그려질 mesh mask의 구멍에 해당하기 때문에 윗 입술과 아랫입술의 평균값을 이용하는 것이 좋다 그렇기 때문에 두개의 인덱스를 가진다.

> 참고
위의 과정 처럼 입 눈 코 머리 등의 feature에 해당하는 vertex index를 우리가 하드코딩 방식으로 지정해서 사용 할 수 있는 것은 ARFaceGeometry에는 1220 개의 정점이 있고 또 그것을 알고 있기 때문에 명시적으로 지정하고 사용할 수 있다. 하지만 애플이 앞으로 해상도를 높이고 그에따라 정점이 많아지면 이런 것들이 보장 받을 수 없다 그렇기때문에 Apple의 [Vision](https://developer.apple.com/documentation/vision) 프레임워크를 사용하여 얼굴을 감지하고 머신러닝을 통해 ARFaceGeometry에서 feature에 해당하는 가장 가까운 vertex를 찾아내 매핑 해야한다.


- `updateFeature(for:using)` 메서드 추가 : `renderer(didUpdate)` 메서드 등에서 feature의 변화에 따라 삽입한 node도 변화를 주기위한 메서드이다.

```swift
 func updateFeatures(for node: SCNNode, using anchor: ARFaceAnchor) {
 	// 1
    for (feature, indices) in zip(features, featureIndices) {
    
   	  // 2
      let child = node.childNode(withName: feature, recursively: false) as? EmojiNode
      
      // 3
      let vertices = indices.map { anchor.geometry.vertices[$0] }
      
      // 4
      child?.updatePosition(for: vertices)
      
      ....
```

1. 루프를 통해 상단에 정의된 node name 이 담김 features 와 정점 인덱스가 담긴 featureIndices 배열을 순차적으로 접근한다.

2. 

