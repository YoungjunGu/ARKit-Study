# Image Tracking

> AR Resourse asset에 추가한 image 데이터를 tracking


## 설정 작업

- Assets 디렉토리에 AR Resourse를 추가하고 내가 tracking 하고 싶은 이미지 데이터를 추가한다

<img width="1136" alt="image" src="https://user-images.githubusercontent.com/33486820/54762829-2f7b4c80-4c38-11e9-9dd9-eaf3802d29b7.png">

- 이미지를 감지하고 생성할 scn 파일을 생성한다


## 구현

```swift

// image 에 적용할 SCNNode 생성
var shapeNode = SCNNode()

override func viewDidLoad() {
        super.viewDidLoad()
        
        //3D Scene 값 설정
        shapeNode = SCNScene(named: "art.scnassets/kim.scn")!.rootNode.childNodes[0]
        
        // Set the view's delegate
        sceneView.delegate = self
        
    }
    
    ...(중략)
    
     	let configuration = ARWorldTrackingConfiguration()
     	//사용자 실제환경에서 AR Resource로 등록한 image를 detection 설정
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        //움직임을 동시에 추적 할 수있는 최대 탐지 이미지 수 설정
        configuration.maximumNumberOfTrackedImages = 1
        sceneView.session.run(configuration)
        
        
     //SCNScene을 랜더링을 해주는 함수   
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            return nil
        }
        // 실제 세계에서 감지되는 image를 여러개 등록한 뒤 랜더링이 가능하다
        switch imageAnchor.referenceImage.name {
        case "RealityBook":
            return shapeNode
        default: return nil
        }
    }
```        


- SCNNode 객체 생성
- SCNScene 값설정
- 사용자 실제환경에서 AR Resource로 등록한 image를 detection 설정
- `renderer()`메서드를 사용해서 SCNScene을 렌더링





 
 