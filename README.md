# ARkit2.0-Tutorial

ARkit2.0,SceneKit,SpriteKit,Metal 렌더링의 기본적인 사용법을 익히고 다양한 방면으로 활용하기 위해 개인 스터디를 진행합니다.
<br><br>

## ARKit Layout
ARKit 는 증강현실에 필요한 프로세스와 분석 작업을 진행하고 실제 오브젝트의 렌더링은 `SceneKit`,`SpriteKit`,`Metal`이 수행한다.

<img width="1213" alt="2019-02-04 2 35 30" src="https://user-images.githubusercontent.com/33486820/52180124-95954700-2825-11e9-954d-44ff610ae9fd.png">

증강 현실 프로세스 작업에는 두가지의 핵심 기능을 사용한다

<img width="640" alt="2019-02-04 2 36 15" src="https://user-images.githubusercontent.com/33486820/52180128-acd43480-2825-11e9-9fe2-bc3cd4a31824.png">


- `AVFoundation`: 카메라로 촬영하는 영상 데이터를 제공
- `Core Motion` : 앱 디바이스의 모션에 관한 데이터를 제공

# Basic Class

### [`ARSession`](https://developer.apple.com/documentation/arkit/arsession) : AR을 처리하기 위한 공유 객체

`ARSession` 객체는 증강 현실에 필요하 작업을 수행하기 위해 ARKit 가 수행하는 주요 프로세스를 관리하고 조정한다. 이러한 프로세스에는 장치의 모셔 감지 하드웨어로 부터 데이터를 읽고, 앱 디바이스에 내장되어있느 카메라를 조정 그리고 캡쳐된 카메라 이미지로부터 이미지 분석 수행 또한 포함한다. Session은 이러 작은 작업들으 결과를 통합하여 장치의 현재 존재하는 주변 환경들의 공간과 AR Contents 를 Modeling 하는 가상 공간 사이의 연결을 구축한다.

ARkit로 구축된 모든 AR애는 단일 ARsession 객체가 필요하다. ARSCNView 또는 ARSKView 객체를 사용하 AR 경험의 시각적 부분을 쉽게 만들면 뷰 겍체에는 ARSession 인스턴스가 포함된다.
<br>

> 세션 구성 및 실행

- [`run(_ : ,options: )`](https://developer.apple.com/documentation/arkit/arsession): 지정된 구성 및 옵션을 사용하여 세션에 대한 AR 처리를 시작

- [`ARSession.RunOptions`](https://developer.apple.com/documentation/arkit/arsession): AR세션의 구성을 변경할때 AR 세션의 현재 상태를 전환하는 방법에 영향을 주는 옵션

- [`configuration: ARConfiguration`](https://developer.apple.com/documentation/arkit/arsession): 세션에 대한 motion 과 scene 을 tracking 행동을 정의하는 객체

- [`pause()`](https://developer.apple.com/documentation/arkit/arsession): 세션에서 처리를 일시 중지

<br>

> AR update 응답

- `var delegate: ArSessionDelegate?`: 캡처 된 비디오 이미지 및 tracking 정보를 수신하거나 세션 상태의 변경 사항에 응답하기 위해 제공되는 객체

- `var delegateQueue: DispatchQueue?`: 세션이 대리자 메서드를 호출하는데 사용하는 디스패치 큐

- `protocol ARSessionDelegate`: 캡처된 비디오 프레임 이미지를 수신, AR 세션에서 상태를 추적하도록 구현할 수 있는 메소드

- `protocol ARSessionObserver`: ARSession 의 상태 변화에 대응하기 위해 구현할 수 있는 메소드

<br>

### [`ARConfiguration`](https://developer.apple.com/documentation/arkit/arconfiguration) : ARSession 구성을 위한 추상 클래스

<br>
추상 클래스 이기에 직접 인스턴스를 만들거나 작업이 불가능하다.

AR 세션을 실행시키기 위해선 당신이 제작하는 앱이나 게임에서 필요한 AR 경험 종류에 따라 알맞는 [`ARConfiguration`](https://developer.apple.com/documentation/arkit/arconfiguration)의 서브클래스들의 인스턴스를 생성해서 사용해야 한다. 그리고 구성 객체의 프로퍼티를 지정하고 이를 세션의 [`run(_:options:)`](https://developer.apple.com/documentation/arkit/arsession/2875735-run) 메소드에 전달한다. ARKit는 다음과 같은 구성 클래스들을 포함하고 있다.
<br>
- [`ARWorldTrackingConfiguration`](https://developer.apple.com/documentation/arkit/arworldtrackingconfiguration) 
  - 후면 카메라를 활용해 디바이스의 위치와 방향을 정교하게 추격하고 지면 감지, 히트 테스팅, 환경에 기반한 조명, 이미지와 사물 인식이 가능한 상위 수준의 AR 경험을 제공
- [`AROrientationTrackingConfiguration`](https://developer.apple.com/documentation/arkit/arorientationtrackingconfiguration)
  - 후면 카메라를 활용해 디바이스의 방향만을 추적하는 기본적인 AR 경험을 제공
- [`ARImageTrackingConfiguration`](https://developer.apple.com/documentation/arkit/arimagetrackingconfiguration)
  - 후면 카메를 활용해 사용자 환경에 상관없이 가시적인 이미지들을 추적하는 기본적인 AR 경험을 제공
- [`ARFaceTrackingConfiguration`](https://developer.apple.com/documentation/arkit/arfacetrackingconfiguration)
  - 전면 카메라를 활용해 사용자 얼굴의 움직임과 감정을 추적하는 AR 경험을 제공
- [`ARObjectScanningConfiguration`](https://developer.apple.com/documentation/arkit/arobjectscanningconfiguration)
  - 후면 카메라를 활용해 고성능 공간 데이터를 수집하고 다른 AR 경험에서의 감지를 위한 참조 객체를 생성

![image](https://user-images.githubusercontent.com/33486820/52576668-e7605180-2e63-11e9-86db-3ea823397768.png)

`ARSession`의 `run` 메소드에 `ARConfiguration` 서브클래스 오브젝트를 넣어 실행시키면 위에서 언급한 것 처럼 `ARSession`은 내부적으로 `AVCaptureSession`과 `CMMotionManager`를 통해 필요한 데이터를 받아 처리하고 이의 결과물을 초당 60프레임으로  `ARFrame` 객체를 반환한다.

<br>

# Display Class

### [`ARSCNView`](https://developer.apple.com/documentation/arkit/arscnview): 카메라 뷰에 3D SceneKit 컨텐츠를 증강시켜 AR 경험을 출력하는 뷰

<br>
`ARSCNView` 클래스는 실제의 보여지는 현실의 디바이스 카메라 뷰에 3D 컨텐츠를 조합한 증강현실을 만들 수 있는 가장 쉬운 방법을 제공한다. 이 뷰가 제공하는 `ARSession`객체를 실행 시키면 뷰는 해당 작업들을 수행한다.

- 뷰는 자동으로 디바이스 카메라가 제공하는 실시간 비디오 피드(Video feed)를 장면의 배경으로 랜더링 한다.
- 뷰의 SceneKit 장면의 실제의 좌표계는 세션 구성에 의해 설정된 AR속 세상 좌표계에 직접 반응한다.(디바이스를 중심으로 AR좌표계가 매핑이 된다)
- 뷰는 자동으로 SceneKit 카메라를 움직여 디바이스의 실제 현실 움직임과 일치시킨다.
<br>

`ARKit` 는 `SceneKit` 의 공간과 실제 현실 세계를 자동으로 일치시키기 때문에 실제 세상에서의 위치를 유지하는 것 처럼 보이는 가상 객체를 배치하기 위해선 객체의 `SceneKit` 위치만 적절히 조절해서 설정하면된다.(문서참고 : [Providing 3D Virtual Content with SceneKit](https://developer.apple.com/documentation/arkit/arscnview/providing_3d_virtual_content_with_scenekit))
<br>

화면에 추가된 객체의 위치를 추적하기 위해서 [`ARAnchor`](https://developer.apple.com/documentation/arkit/aranchor)의 사용이 필수는 아니지만 [`ARSCNViewDelegate`](https://developer.apple.com/documentation/arkit/arscnviewdelegate)메소드를 구현하면 `ARKit` 에 의해 자동으로 감지 된 모든 앵커에 `SceneKit` 컨텐츠를 추가할 수 있다.
<br>

### [`ARSKView`](https://developer.apple.com/documentation/arkit/arskview): 카메라 뷰에 2D SpriteKit 컨텐츠를 증강시킨 AR 경험을 출력하는 뷰

<br>

실제 세계의 디바이스 카메라 뷰 내의 3D 공간에 2D 요소를 배치한 증강 현실을 만들기 위해서 `ARSKView` 를 사용하면된다. 이 뷰가 제공하는 [`ARSession`](https://developer.apple.com/documentation/arkit/arsession)을 실행시키면 뷰는 다음의 작업들을 수행한다.

<br>

- 뷰는 자동으로 디바이스 카메라라가 제공하는 실시간 비디오 피드를 장면의 배경으로 랜더링한다.
- [`ARSKViewDelegate`](https://developer.apple.com/documentation/arkit/arskviewdelegate) 메소드를 구현하여 `Sprite` 컨텐츠를 실제 위치와 연관시키면 뷰가 자동으로 해당 `SpriteKit` 노드의 크기를 조절하고 회전시켜 카메라가 보는 실제 세사을 추적하는 것처럼 보인다.

<br>

## 현재진행상황
> Day1
- SceneKit 의 기본적인 개념
- SCN도형 생성 후 -> SCNNode vector 값 설정 
- addChildNode(AnyNode) 로 Scene 에 추가
- SCNLights 를 활용해 도형에 명암 삽입
> Day2
- SCNAction 사용 하여 애니메이션 추가
- SCNLight 설정 
- SCNPArticleSystem을 사용 하여 애니메이셔 효과 추가

> Day3
- Plane Detection (vertical, horizontal)
- renderer method 에서 plane 생성
- euler = -90 이 평면 plane의 경사 정도를 나타내는 값
- let planeAnchor = ARPlaneAnchor : AR detecting에 감지된 실제으 평면에 대한 위치 정보
- planeAnchor.extent AR로 추적한 실제 평면의 예상 넓이와 길이르 저장 하는 프로펕
- center : Anchor 기준으로 하 실제 평면의 중심 
- planeNode?.position = SCNVector3Make(center.x, 0, center.z)  평면의 벡터값 설정
- Shadow 적용 법 plane 위에 directional light 설정후 casts shadow 설정 (false)
- renderingOrder = -1 설정으로 지정한 node의 순서를 지정 렌더링 순서 크면으 마지막으로 렌더링 된다.
- planeGeometry.firstMaterial?.isDoubleSided SceneKit이 plane을 detecting 시에 양면을 detecting을 해야하는지 여부 설정

> Day4
- Metal이란? Apple OS앱의 그래픽작업을 위해 그래픽 처리장치(GPU)에 직접적으로 접근하여 다양한 기능을 제공하는 렌더링
  Metal 2는 GPU가 그래픽 파이프라인을 더 강력히 제어하고, 신경망 훈련을 가속(Metal Performance Shader(MPS), 셰이더 코드를 깊이 통찰등에 장점들을 가진다.
- Plane Detection을 위해 MTLCreateSystemDefaultDevice를 사용 하여 지속적으로 planeGeometry를 update 하여 실제 평면을 빠르게 감지하여 update 하는것을 볼 수 있었다.

> Day5
- PlaneDetection 마지막 "바닥에 위험한 구멍을 내보자"
- 3개의 Tube 를 활용하여 lib(입구), Darkness(구멍 속) , occlussion(외부에 안보이게 튜브를 클로킹하기 위한 tube)
- 중복을 막기 위해 boolean 프로퍼티로 제어하자  

> Day6(Image Detecting)
- AVSpeechSynthesizer() : iOS에서 사용되는 Text-to_Speech 방식 , 텍스트를 siri 음성으로 speech 해준다.
- 사용방법: AVSpeechSynthesizer() ,AVSpeechUtterance() 프로퍼티 생성 후 Utterance 프로퍼티로 읽고 싶은 문장의 속성을 제어
  speech.speak(utterance) 로 문장 speech 실행
- Asset 에 등록한 이미지 를 detecting 하기위해 
<img width="806" alt="2018-11-12 9 58 25" src="https://user-images.githubusercontent.com/33486820/48348955-298fc080-e6c6-11e8-9461-ddc15f128789.png"><br>
- ARImageAnchor를 사용해 등록한 asset 이미지를 감지시 정보를 넘김
<img width="430" alt="2018-11-12 9 58 43" src="https://user-images.githubusercontent.com/33486820/48348983-3d3b2700-e6c6-11e8-9ca5-7ac83e2f3d48.png"><br>
- 이미지를 감지하면 AVSpeechSynthesizer()를 이용해 해당 이미지의 정보를 닮고 있는 String Array의 contents르 읽어 줌
<img width="676" alt="2018-11-12 9 58 50" src="https://user-images.githubusercontent.com/33486820/48348991-43c99e80-e6c6-11e8-8166-19806e984e9f.png"><br>

> Measure(AR 측정 앱)
- 측정을 하기 위해 사용자의 터치를 감지해야한다 ` touchBegan() ` 를 이용하여 사용자의 터치를 감지
- hitTest : SceneKit view의 한 지점에 해당하는 캡처 된 카메라 이미지엣 실제 객체나 AR Anchor를 검색하는 기능
- worldTrnasform : 변환 매트릭스의 일종으로 검출되 표면과 hitTest 결과를 생성 하 포인트 사이의교점을 나타낸다.
 hitTest는 이미지 또는 뷰의 좌표계 2D 점을 선을 따라 3D 공간을 투영 , 해당 선이 검출된 표면과 교차하는 결과를 반환
<img width="200" src="https://user-images.githubusercontent.com/33486820/51325014-648be700-1aaf-11e9-8bdc-e9ca400dbde2.jpeg">
- 추가: 시작 vertex 와 끝 vertext를 추가 하고 사이의 간격의 길이를 측정
- ` var points = [SCNNode]() ` 배열을 사용, 사용자가 시작 과 끝의 위치를 터치하면 points 배열에 저장후 처음과 끝의 값을 계산
- `let realDistance = distance(float3(firstPoint.position), float3(lastPoint.position))`: 시작과 끝의 거리를 구함
<img width="200" alt="2019-01-17 11 26 44" src="https://user-images.githubusercontent.com/33486820/51325362-1b886280-1ab0-11e9-8e32-c3a0419c1f06.png">

- 두 간격 사이의 선을 시각화 하는 방법

```
extension SCNGeometry {
   class func line(from vectorFirst: SCNVector3, to vectorLast: SCNVector3) -> SCNGeometry {
        
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vectorFirst, vectorLast])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
} 
````

- SCNGeometry를 확장해 'line 이라는 클래서 정의 함수 생성 -> 두 백터 값을 받아 사이에 선을 이어 `let lineNode = SCNNode(geometry: line)`로 
scene에 추가

<br><br>


> SCNAudioSource 를 활용
- ` var audioSource = SCNAudioSource() ` 오디오 소스를 사용할 프로퍼티 생성
- ` audioSource.isPositional = true `: 오디오 음향을 3D 입체화 시키는 값, 거리에 따라 음향을 자동 조절하는 여부를 설정하는 부울 값
- ` audioSource.shouldStream = false `: 재생할 때 오디오 소스가 소스 URL에서 콘텐츠를 스트리밍해야하는지 여부를 결정하는 부울 값





## What to do
마커, 마커리스 방식에 대한 이해

- Image Tracking
- Word Tracking
- Motion Tracking

## Challenging

- 사용자 몸을 Detecting 후 간단한 의상을 입혀보기
- 특정 지형을 감지 즉 특정 지형에서면 AR 이 작동
- 사물을 Detecting 하여 상황에 맞느 AR 적용 
- Image Detection과 CoreML을 활용하여 "Real Time Camera Object Detection" 제작 해보기
