# ARkit2.0-Tutorial

ARkit2.0,SceneKit,SpriteKit,Metal 렌더링의 기본적인 사용법을 익히고 다양한 방면으로 활용하기 위해 개인 스터디를 진행합니다.
<br><br>

## ARKit Layout
ARKit 는 증강현실에 필요한 프로세스와 분석 작업을 진행하고 실제 오브젝트의 렌더링은 `SceneKit`,`SpriteKit`,`Metal`이 수행한다.

<img width="623" alt="arkitapplayout1" src="https://user-images.githubusercontent.com/33486820/52179930-451cea00-2823-11e9-9f61-eb5e1b3367df.png">

증강 현실 프로세스 작업에는 두가지의 핵심 기능을 사용한다

![image1](https://user-images.githubusercontent.com/33486820/52179982-ceccb780-2823-11e9-81f8-8c309b610f0f.png)

- `AVFoundation`: 카메라로 촬영하는 영상 데이터를 제공
- `Core Motion` : 앱 디바이스의 모션에 관하 데이터르 제공



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






