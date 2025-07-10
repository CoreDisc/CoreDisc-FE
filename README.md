# 💽 CoreDisc

> 로고 추가 예정

하루에 4개, 매일 다른 질문에 대해 답변하며 **나만의 코어**를 찾아가는 기록 서비스

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)]()
[![Xcode](https://img.shields.io/badge/Xcode-16.0-blue.svg)]()
[![License](https://img.shields.io/badge/license-MIT-green.svg)]()

---

<br>

## 👥 멤버
| 마티/김미주 | 연두/신연주 | 초록/이채은 | 크롱/정서영 |
|:------:|:------:|:------:|:------:|
| ![image](https://github.com/user-attachments/assets/5273ff91-6026-49d2-8433-5b824bf2e20a) | ![image](https://github.com/user-attachments/assets/49a38f66-d140-49bb-86b7-23959efe450d) | ![image](https://github.com/user-attachments/assets/7a453dfb-c2d3-4f6d-884b-605cf3d5afcf) | ![image](https://github.com/user-attachments/assets/12682fd6-4928-4f38-bfe8-d903eff121da) |
| FE | FE | FE | FE |
| [alwn8918](https://github.com/alwn8918) | [Yeondu428](https://github.com/Yeondu428) | [codmsdlrltgjqm](https://github.com/codmsdlrltgjqm) | [mzxxzysy](https://github.com/mzxxzysy) |

<br>


## 📱 소개

**하루에 질문 4개를 SHOOT.**

똑같은 일상의 반복 속에서 좋아하는 것에 마음을 쓰는 일을 빼놓지 않고 기록하고 싶은 모두를 위한 서비스.

최종적으로 매일을 살아가며 각자의 **코어**를 찾아갈 수 있는 서비스.

<br>

## 📆 프로젝트 기간
- 전체 기간: `2025.06.03 - YYYY.MM.DD`
- 개발 기간: `2025.07.07 - YYYY.MM.DD`

<br>

## 🤔 요구사항
For building and running the application you need:

iOS 18.2 <br>
Xcode 16.2 <br>
Swift 6.0

<br>

## ⚒️ 개발 환경
* Front : SwiftUI
* 버전 및 이슈 관리 : Github, Github Issues
* 협업 툴 : Discord, Notion, Figma

<br>

## 🔎 기술 스택
### Envrionment
<div align="left">
<img src="https://img.shields.io/badge/git-%23F05033.svg?style=for-the-badge&logo=git&logoColor=white" />
<img src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white" />
<img src="https://img.shields.io/badge/SPM-FA7343?style=for-the-badge&logo=swift&logoColor=white" />
</div>

### Development
<div align="left">
<img src="https://img.shields.io/badge/Xcode-007ACC?style=for-the-badge&logo=Xcode&logoColor=white" />
<img src="https://img.shields.io/badge/SwiftUI-42A5F5?style=for-the-badge&logo=swift&logoColor=white" />
<img src="https://img.shields.io/badge/Alamofire-FF5722?style=for-the-badge&logo=swift&logoColor=white" />
<img src="https://img.shields.io/badge/Moya-8A4182?style=for-the-badge&logo=swift&logoColor=white" />
<img src="https://img.shields.io/badge/Kingfisher-0F92F3?style=for-the-badge&logo=swift&logoColor=white" />
</div>

### Communication
<div align="left">
<img src="https://img.shields.io/badge/Notion-white.svg?style=for-the-badge&logo=Notion&logoColor=000000" />
<img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=Discord&logoColor=white" />
<img src="https://img.shields.io/badge/Figma-F24E1E?style=for-the-badge&logo=figma&logoColor=white" />
</div>

<br>

## 📱 화면 구성
> 개발 후 수정 예정
<table>
  <tr>
    <td>
      사진 넣어주세요
    </td>
    <td>
      사진 넣어주세요
    </td>
   
  </tr>
</table>

<br>

## 🔖 브랜치 컨벤션
- `main`
- `feat/xx` - 기능 개발
- `fix/xx` - 버그 수정
- `refac/xx` - 리팩토링
- `design/xx` - 디자인 변경

→ [ex- `feat/MainPage` ]
### 

<br>

## 🌀 코딩 컨벤션
**줄바꿈**

- 파라미터가 2개 이상일 경우 파라미터 이름을 기준으로 줄바꿈 한다.

```swift
let actionSheet = UIActionSheet(
  title: "정말 계정을 삭제하실 건가요?",
  delegate: self,
  cancelButtonTitle: "취소",
  destructiveButtonTitle: "삭제해주세요"
)

```

- if let 구문이 길 경우에 줄바꿈 한다

```swift
if let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
   let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
  user.gender == .female {
  // ...
}

```

**주석**

- 나중에 추가로 작업해야 할 부분에 대해서는 `// TODO: - xxx` 주석을 남기도록 한다.
- 코드의 섹션을 분리할 때는 `// MARK: - xxx` 주석을 남기도록 한다.
- 함수에 대해 전부 주석을 남기도록 하여 무슨 액션을 하는지 알 수 있도록 한다.

**색상, 폰트**

- 색상은 Color 등록 후 사용한다. (rgb코드 사용 금지)
- 폰트는 Font extension 선언 후 사용한다.

**컴포넌트**

- 2개 이상의 View에서 사용하는 컴포넌트는 Views>Components 폴더 내부에 생성한다.
- 1개의 View에서 사용하는 컴포넌트는 해당 View 하단에 작성한다. (QuestionMainView 참고)

<br>

## 📁 PR 컨벤션
* PR 시, 템플릿이 등장한다. 해당 템플릿에서 작성해야할 부분은 아래와 같다
    1. `PR 유형 작성`, 어떤 변경 사항이 있었는지 [] 괄호 사이에 x를 입력하여 체크할 수 있도록 한다.
    2. `작업 내용 작성`, 작업 내용에 대해 자세하게 작성을 한다.
    3. `추후 진행할 작업`, PR 이후 작업할 내용에 대해 작성한다
    4. `리뷰 포인트`, 본인 PR에서 꼭 확인해야 할 부분을 작성한다.
    6. `PR 태그 종류`, PR 제목의 태그는 아래 형식을 따른다.

#### 🌟 태그 종류
| 태그        | 설명                                                   |
|-------------|--------------------------------------------------------|
| [Feat]      | 새로운 기능 추가                                       |
| [Fix]       | 버그 수정                                              |
| [Refactor]  | 코드 리팩토링 (기능 변경 없이 구조 개선)              |
| [Style]     | 코드 포맷팅, 들여쓰기 수정 등                         |
| [Docs]      | 문서 관련 수정                                         |
| [Test]      | 테스트 코드 추가 또는 수정                            |
| [Chore]     | 빌드/설정 관련 작업                                    |
| [Design]    | UI 디자인 수정                                         |
| [Hotfix]    | 운영 중 긴급 수정                                      |
| [CI/CD]     | 배포 및 워크플로우 관련 작업                          |

### ✅ PR 예시 모음
> 🎉 [Chore] 프로젝트 초기 세팅 <br>
> ✨ [Feat] 프로필 화면 UI 구현 <br>
> 🐛 [Fix] iOS 17에서 버튼 클릭 오류 수정 <br>
> 💄 [Design] 로그인 화면 레이아웃 조정 <br>
> 📝 [Docs] README에 프로젝트 소개 추가 <br>

<br>

## 📑 커밋 컨벤션
| 이모티콘 | 기능 | 설명 |
| --- | --- | --- |
| ✨ | Feat | 새 기능 |
| 🐛 | Fix | 버그 수정 |
| 🚑 | Hotfix | 긴급 수정 |
| 💄 | Design | UI/스타일 파일 추가/수정 |
| ✏️ | Typing Error | 오타 수정 |
| 🔥 | Del | 코드/파일 삭제 |
| ♻️ | Refactor | 코드 리팩토링 |
| 🎉 | Begin | 프로젝트 시작 |
| 🔀 | Merge | 브랜치 합병 |
| 📝 | Docs | 문서 추가/수정 |
| 🔒 | Security | 보안 이슈 수정 |
| ⏪ | Rewind | 변경 내용 되돌리기 |
| 🚚 | Mod | 리소스 이동, 이름 변경 |

→ [ex- ✨ 메인 페이지 구현 (#이슈번호)]

<br>
