# <Img src = "https://github.com/user-attachments/assets/5f2888f1-9dc4-4fe6-9cb2-147c41077087" width="30"/> Roome
###### 아래 이미지를 클릭하면 랜딩 페이지로 이동합니다. 
[![image-9](https://github.com/user-attachments/assets/07d73d84-7160-49ec-a6d8-a387464cee88)](https://enlivened-copy-474650.framer.app/)
> 프로젝트 기간: 24.03.09 ~

## 📖 목차

1. [🍀 소개](#소개)
2. [🛠️ 기술 스택](#기술-스택)
3. [💻 실행 화면](#실행-화면)
4. [🧨 트러블 슈팅](#트러블-슈팅)
5. [👥 팀](#팀)

</br>

<a id="소개"></a>

## 🍀 소개
방 탈출을 좋아하는 사람들이 나의 취향을 담은 프로필을 이미지 1장으로 만들 수 있는 서비스.
</br>
[앱 스토어 링크](https://apps.apple.com/kr/app/roome/id6503616766)
</br>
[블로그 링크](https://roome.tistory.com/)


</br>
<a id="기술-스택"></a>

## 🛠️ 기술 스택
`UIKit`, `MVVM`, `Combine`, `Swift Pakage Manager`, `Swift Concurrency`, `Lottie`, `Clean Architecture`

</br>
<a id="실행-화면"></a>

## 💻 실행 화면

| 회원 가입 | 방탈출 프로필 생성 과정 |
|:--------:|:--------:|
|<img src="https://github.com/user-attachments/assets/f3df287e-5f5f-415d-8401-c2e7af1f584b" alt="launch Screen" width="250">|<img src="https://github.com/user-attachments/assets/a33556d9-78d5-4294-8fce-9069f2b0cb0b" alt="main_view" width="250">|

| Toast Alert | 프로필 이미지 저장 |
|:--------:|:--------:|
|<img src="https://github.com/user-attachments/assets/73a68017-e006-4936-a027-8284dbd86df5" alt="launch Screen" width="250">|<img src="https://github.com/user-attachments/assets/467dc598-d060-4030-a843-4fba71ec942b" alt="main_view" width="250">|

| 카카오톡 공유하기 | 방탈출 프로필 내용 편집 |
|:--------:|:--------:|
|<img src="https://github.com/user-attachments/assets/102b4fa9-23c7-4c09-a518-88d218993b84" alt="launch Screen" width="250">|<img src="https://github.com/user-attachments/assets/c4141059-146a-4180-ad74-bcb32435d67f" alt="main_view" width="250">|


| 설정 페이지 | 로그아웃 |
|:--------:|:--------:|
|<img src="https://github.com/user-attachments/assets/6ecf0e09-69ec-49e3-9929-0eea1ebaa8c7" alt="launch Screen" width="250">|<img src="https://github.com/user-attachments/assets/a98ff9df-a187-4226-818d-6da1bf08a2e3" alt="main_view" width="250">|

| 회원 탈퇴 |
|:--------:|
|<img src="https://github.com/user-attachments/assets/1d013714-c03a-4759-aaf6-7600507e16a0" alt="launch Screen" width="250">|

</br>

<a id="트러블-슈팅"></a>

## 🧨 트러블 슈팅
###### 핵심 트러블 슈팅위주로 작성하였습니다.
### 1️⃣ **보이지 않는 상태에서 UIView를 UIImage로 변환** <br>
🔒 **문제점** <br>
이미지로 만들 UIView를 ProfileView로 custom 하여 구현했다. 그 중에서 세로형 화면을 만드는 것에 문제가 생겼다. "저장하기" 버튼을 클릭하면 ProfileView가 UIImage로 변환하여 사용자의 사진첩에 저장된다. 화면에 띄워져야만 rendering을 통해 UIImage로의 저장이 가능한데 3:4 세로형을 만드는 경우 높이를 늘리는 방식이 아닌 넓이를 줄이는 방법을 사용하면, ProfileView에 구현되어 있는 Label의 FontSize로 인해 글자가 잘리고 비율이 맞지 않았다.
-> 그러나 높이를 늘리면 사이즈가 작은 SE의 경우 버튼이 겹쳐서 스크롤을 해야하는 상황이 발생하므로 높이는 고정이어야 했다.

🔑 **해결방법** <br>
❌ UILabel.autoshrink <br>
자동으로 Label의 크기에 따라 폰트가 일정 비율까지 줄어드는 autoShrink도 고민하였으나, 이렇게 하면 프로필의 각 라인에 따라 폰트 크기가 들쭉날쭉한 문제가 발생했다.

❌ font Size 수정 <br>
squareProfileView와 rectangleProfileView를 둘 다 생성하여 들고 있어야 하며 비율에 따라 각 글자들의 사이즈가 조금씩 차이가 나게 된다.

✅ Image로 변환, resize <br>
때문에 뷰가 화면에 display 되기 전에 이미지로 저장하여 해당 image를 resize해 보여주는 방법을 생각했는데, 뷰의 위치가 잡히기 전이라 처음에는 배경색만 Image로 저장되었다. subview인 CardView의 layout이 완성되기 전에 View가 만들어져 버렸기에 ImageView에 빈 이미지가 들어가고 있었다. 때문에 subview들이 다 생성된 후인 viewDidLayoutSubviews()에서 image를 넣어주었다. 

<br>


### 2️⃣ **ViewModel을 공유하며 팝업이 두번 생성** <br>
🔒 **문제점** <br>
![img1 daumcdn](https://github.com/user-attachments/assets/447aba7c-a97f-49b1-8a69-d9d35446863f)

버튼을 한번만 눌렀음에도 사진과 같이 팝업화면이 두개 뜨는 문제가 있었다.

🔑 **해결방법** <br>
현재 이 프로젝트에는 프로필 이미지를 볼 수 있는 순간이 두 번 존재한다.

1. 처음에 프로필을 다 생성한 후 
2. 마이 페이지에서 프로필 카드 버튼을 누른 경우

뷰에는 차이가 있기에 각기 다른 뷰를 만들고 뷰모델만 공유해 줬었는데, 이때 각자 다른 뷰모델을 생성해서 넣어준 것이 아니라 DIManager에서 뷰모델을 하나만 생성해서 그 뷰모델을 두 개의 뷰 모두에 넣어주었다. 때문에 1번 뷰를 지나서 2번 뷰를 온 경우 이미지 저장하기를 누르면 뷰모델이 두 번 작동해서 뷰가 두 번 뜬다.
-> 새로운 뷰모델을 생성하여 해결하였다.

<br>

### 3️⃣ **textfield Runloop Error** <br>
🔒 **문제점** <br>
textField에서 값을 가져올 때 기존 방식이 한박자 느려서 문제가 생겼다.
값이 없는 걸로 인식되어 서버로 넘어가지 않고 오류가 발생하였다.

🔑 **해결방법** <br>
뷰모델에 `@Published var textInput = ""`를 구현하고 `receive(on:)`으로 `Runloop.main`을 해주었다.
그 후 해당 값을 assign으로 뷰모델에 넘겨주는 방식을 사용했다.

<br>

### 4️⃣ **카카오톡 공유하기 디코딩 문제** <br>
🔒 **문제점** <br>
카카오톡으로 공유된 프로필 링크를 눌렀을 때 파라미터로 type에는 "profile", value에는 "닉네임값"이 들어와야 했다. 닉네임값이 한글인 경우 카카오에서 자동으로 인코딩을 한 값을 내보내주었기 때문에 다음과 같은 오류가 나왔다. 
<img width="600" alt="343682051-939de7f0-f39b-4857-a30a-cc02a77ba9e7" src="https://github.com/user-attachments/assets/3217519b-b227-4ee3-9e18-37a9c983e4ea">


🔑 **해결방법** <br>
안드로이드의 경우는 자동으로 다시 한글로 디코딩해주지만, iOS는 아니라서 쿼리 파라미터를 분리하여 딕셔너리를 만들 때 디코딩한 값을 value값으로 넣는 방법으로 해결했다. 이때 removingPercentEncoding를 사용하여 디코딩해주었다.
```swift
func queryParams(url: URL) -> Dictionary<String, String> {
        var parameters = Dictionary<String, String>()
    
        if let queryComponents = url.query?.components(separatedBy: "&") {
            for queryComponent in queryComponents {
                let paramComponents = queryComponent.components(separatedBy: "=")
                var object: String? = nil
                if paramComponents.count > 1 {
                    object = paramComponents[1].removingPercentEncoding
                }
                let key = paramComponents[0]
                parameters[key] = object
            }
        }
        return parameters
    }
```
<br>

### 5️⃣ **Suspended 상태에서 링크를 통해 앱 로딩시 공유용 프로필 화면 띄우기** <br>
🔒 **문제점** <br>
앱을 한번 실행했을 때는 링크를 타고 들어갔을 때 공유용 프로필 화면이 뜨는데 Suspended 상태에서는 뜨지 않았다.
SceneDelegate에 있는 willConnectTo함수에서 마지막에 self.scene(scene, openURLContexts: connectionOptions.urlContexts)를 불러주었는데, 그럼에도 뜨지 않았다.

기본적으로 앱이 실행되었을 때 window?.rootViewController = SplashView()가 불리는데 이때 SplashView()의 내부에서 작업들이 처리되면서 공유용 프로필 화면이 rootViewController로 설정된 이후에 다시 changeRootViewController()를 통해 화면이 전환되어 보이지 않는 것 같았다.

🔑 **해결방법** <br>
때문에 분기 처리를 통해 해결했다.
```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        if connectionOptions.urlContexts.isEmpty {
            window?.rootViewController = SplashView()
        } else {
            DIManager.shared.registerAll()
            self.scene(scene, openURLContexts: connectionOptions.urlContexts)
        }
        window?.makeKeyAndVisible()
    }
```


<br>

### 6️⃣ **PassthroughSubject에서 에러를 보내고 난 후 연결 끊김.** <br>
🔒 **문제점** <br>
닉네임을 한 번 틀리고 나면 Error를 발행하여 PassthroughSubject가 종료되는 오류가 있었다.
때문에 Error 발생 이후엔 더 이상 다음 버튼이 작동하지 않았다.
PassthroughSubject는 Error를 발행하면 구독을 종료하기에 일어난 문제였다.

🔑 **해결방법** <br>
고민하다 타입을 PassthroughSubject<Result<Void, Error>,Never>로 바꾸어서 해결했다.

</br>

### 7️⃣ **DIContainer를 사용한 의존성 관리** <br>
🔒 **고민점** <br>
roome는 페이지 넘김 외에는 특별한 화면 전환이 적지만 재사용되는 뷰가 많아 복잡한 의존성 관리가 필요했다.

🔑 **해결방법** <br>
DIContainer는 객체 간의 의존성을 명시적으로 주입함으로써 의존성을 쉽게 교체할 수 있는 유연함을 제공한다.
특히, 프로젝트가 커질수록 복잡해지는 의존성 그래프를 체계적으로 관리할 수 있어 확장성과 유지보수 측면에서 유리하다. 
또한 꾸준한 업데이트를 통한 기능 확장성을 우선시하였기에 DIContainer를 선택하여 코드의 확장성을 높였다.

</br>

### 8️⃣ **MVVM을 통한 코드의 재사용** <br>
🔒 **고민점** <br>
뷰에 독립적인 비즈니스 로직의 작성에 대해 고민하였다. UIKit의 특성상 Controller가 View와 떨어지기 힘든 구조라서 새로운 아키텍쳐가 필요했다. 

🔑 **해결방법** <br>
ViewController를 View로 취급하고, 따로 로직을 연결해 처리하는 ViewModel이 있는 MVVM 아키텍쳐를 도입하였다. MVVM 패턴을 통해 View와 ViewModel을 분리하여 뷰와 로직 간의 결합을 줄이고, 데이터를 양방향으로 바인딩함으로써 코드의 가독성과 테스트 가능성을 높였다. 특히, 뷰모델을 통해 뷰에 독립적인 비즈니스 로직을 작성할 수 있어,뷰와 로직의 분리라는 큰 장점을 얻을 수 있었다.

</br>

### 9️⃣ **계층별 추상화를 위해 Clean Architecture 도입** <br>
🔒 **고민점** <br>
그러나 프로젝트의 복잡도가 증가하니 계층별 추상화를 통한 관리가 필요했다. 

🔑 **해결방법** <br>
Clean Architecture는 도메인 로직, 데이터 소스, UI 등의 계층을 명확히 분리하여 각 계층이 독립적으로 동작할 수 있게 하였다. 의존성 역전 원칙을 활용해 데이터 흐름을 역방향으로 관리하고, 특정 라이브러리나 프레임워크에 대한 의존성을 줄임으로써 확장성과 테스트 용이성을 크게 향상시킬 수 있었다.
</br>

<a id="팀"></a>

## 👥 팀

### 👨‍💻 팀원
| PO_김상희 | Designer_김설아 | Marketer_원성목 | 
| :--------: | :-------: | :-------: |
| <img src="https://github.com/user-attachments/assets/9c0f0171-ea49-4c56-8509-02526995c9a1"  width="200" height="225"> | <img src="https://github.com/user-attachments/assets/bae92a9e-8348-4454-b074-6b46fd0f7a4b"  width="200" height="225">| <img src="https://github.com/user-attachments/assets/f2522ed7-a2d1-49bd-a120-9cb8fadbee6e"  width="200" height="225">|

| iOS_김민송(Mint) | AOS_문장훈 | Backend_김준환 |
| :--------: | :-------: | :-------: |
| <img src="https://github.com/user-attachments/assets/453b01ce-9fc4-49c9-8b98-a1a0b9cef0f5"  width="200" height="225"> | <img src="https://github.com/user-attachments/assets/60ea6287-190a-45fa-88de-ce64328cf1e8"  width="200" height="225">| <img src="https://github.com/user-attachments/assets/68e0b257-b9d2-46f3-bb7e-e4c2a4277889"  width="200" height="225">|
|[Github Profile](https://github.com/mint3382) | [Github Profile](https://github.com/moondev03)| [Github Profile](https://github.com/jjunhwan-kim)|



