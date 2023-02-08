# TwitterTutorial

## 사용 기술 & 라이브러리
- MVVM
- Firebase, SDWebImage

## 구현 내용
- 게시글 올리기
- 팔로우하기
- 좋아요 누르기
- 사용자 검색하기
- 좋아요, 멘션 알림 받기

## 프로젝트를 진행하며 배운 점
- 스토리보드를 사용하지 않고 코드로 UI구현
- FirebaseAuth를 이용한 로그인과 회원가입 구현
  - Firebase를 사용해 간단한 회원가입 및 로그인 기능을 구현할 수 있게 되었습니다.
  - 현재 로그인 중인 상태와 로그아웃한 상태를 통해 로그인 뷰를 띄울지, 게시글 피드 뷰를 띄울지를 분기하였습니다.
- FireStore를 통한 데이터 구조
  - 데이터 구축, 저장, 불러오기 업데이트를 경험하였습니다.
  - 데이터들의 이동, 흐름에 대하여 배웠습니다.
- Delegate 패턴, MVVM 디자인패턴
  - 이번 프로젝트에 사용해보며 익숙해지도록 하였습니다.
- 고차함수의 활용
  - FireStore에서 받아온 데이터를 고차함수를 이용해서 처리하는 방법을 배웠습니다.
  - 이러한 고차함수를 이용해 로그인한 사용자의 데이터는 검색 시에 나오지 않게 구현하였으며,
    특정 문자열을 가지고 있는 데이터는 무엇인지를 필터링하여 가져오는 등의 기능을 구현하였습니다. 


## Firebase 정리
- [Firebase 주요 기능](https://jesskoh.notion.site/Firebase-5e8fcef80c4e4da095464bc869c19edf)
- [Firebase Database 정리](https://jesskoh.notion.site/Firebase-Database-1fccd12d344e4d91ada3f58f09ca3db6)
- [Firebase (1)](https://jesskoh.notion.site/Firebase-1-c20a64e55bf14f598f8c5a03588a5c06)
- [Firebase (2) 유저등록](https://jesskoh.notion.site/Firebase-2-97b4ef263d78478fa6ede2e69488bc23)

## 🐞 Bug
- [Cannot find type 'AuthDataResultCallback' in scope 오류](https://developer.apple.com/forums/thread/706016)
- [51강) fullname 입력 시 검색 안되는 버그](https://jesskoh.notion.site/51-fullname-373f57db9e564a4f909d1f7a36827deb)

## 강의 정리
- [버튼을 lazy var로 선언해야 하는 이유](https://jesskoh.notion.site/lazy-var-b001ea38b0ce43f0bfbf11b163a36d40)
- [init(frame: CGReact) & (coder: NSCoder)](https://www.notion.so/jesskoh/init-frame-CGRect-coder-NSCoder-fe1222d3a6db453998d5d30f63be7aef)
- [38강) 프로필 이미지(UIImageView)를 버튼처럼 만드는 법](https://jesskoh.notion.site/38-UIImageView-fe49acdfe9904eae9579b8e0793493ca)
- [38강) 셀 내 요소 클릭 시 프로토콜을 이용한 뷰 전환](https://jesskoh.notion.site/38-75995e7b542d4ca1816e07f56e857745)
- [39강) UICollectionReusableView를 이용한 CollectionViewHeader만들기](https://jesskoh.notion.site/39-UICollectionReusableView-CollectionViewHeader-96fb1c5dfb2e4f449685715c9a715e29)
- [53강) typealias를 사용하여 자주 쓰는 completion정의](https://jesskoh.notion.site/53-typealias-completion-6200bf388f61491eb8ebe14e9471c5a6)
- [66강) ActionSheet (1)](https://jesskoh.notion.site/66-ActionSheet-1-d472894d2cbe4005b47473f8d36594a6)
- [67강) ActionSheet (2)_UI Test](https://jesskoh.notion.site/66-ActionSheet-1-d472894d2cbe4005b47473f8d36594a6)
- [68강) ActionSheet (3)_TableView animation & FadeView](https://jesskoh.notion.site/68-ActionSheet-3-_TableView-animation-FadeView-6c2c9fb7e1014767954c7ab5bc34eb7b)
- [69강) ActionSheet (4)_TableView Footer](https://jesskoh.notion.site/69-ActionSheet-4-_TableView-Footer-b95b45f3b8b9484f996261f53da86650)
- [74강) 좋아요 버튼](https://jesskoh.notion.site/74-528dfdd2a628427b99b06057871e7cd7)


