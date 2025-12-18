# TIL Day 01

## 2025년 12월 17일 수요일

### Why Git & Github?

![Git로고](https://user-images.githubusercontent.com/49775540/168756716-68f9aebb-380f-4897-8141-78d8403f6113.png)

#### Git

- 분산 버전 관리 프로그램
백업, 복구, 협업을 위해 사용
[Git 공식문서](https://git-scm.com/book/ko/v2)

#### Github

- Git을 사용하는 프로젝트의 협업을 위한 웹호스팅 서비스
포트폴리오를 자랑할 수 있는 공간
1일 1커밋 하기
[이동욱님 Github 계정](https://github.com/jojoldu
)


### CLI

- CLI (Command Line Interface, 커맨드 라인 인터페이스)는 터미널을 통해 사용자와 컴퓨터가 상호 작용하는 방식을 뜻한다.

- 터미널 명령어 정리


    - 예시

        `mkdir test`: make directory, 새 폴더를 생성하는 명령어, 띄어쓰기로 구분하여 여러 파일을 한꺼번에 생성 가능합니다.  
        `touch a.txt`: 파일을 생성하는 명령어  
        `ls`: list segments, 현재 작업 중인 디렉토리의 폴더/파일 목록을 보여주는 명령어
        `mv A B`: move, 폴더/파일(A)을 다른 폴더(B) 내로 이동 하거나 이름을 변경하는 명령어  
        `cd`: change directory, 현재 작업 중인 디렉토리를 변경하는 명령어  
        `cd ~`: 홈 디렉토리로 이동  
        `cd ..`: 부모 디렉토리로 이동  
        `cd -`: 바로 전 디렉토리로 이동  
        `rm`: remove, 폴더/파일 지우는 명령어(**바로 완전 삭제**)  
        `start, open`: 폴더/파일을 여는 명령어(windows=open)  
     
        

### Visual Studio Code

- Visual Studio Code (비주얼 스튜디오 코드)는 마이크로소프트에서 개발한 텍스트 에디터의 한 종류이다.

- 장점

    Windows, Mac, Linux 운영체제를 모두 지원한다.
기존 개발 도구보다 빠르고 가볍다.
Extension을 통해 다양한 기능을 설치할 수 있어서, 무한한 확장성을 가진다.
무료로 사용 가능하다.

### Git Bash 연동하기

1. 터미널을 연다. (Ctrl + `)
2. 화살표를 누르고 **Select Default Profile**을 클릭한다.
3. **Git Bash**를 선택한다.
4. **휴지통**을 눌러서 터미널을 종료하고, 재시작한다.
5. 휴지통은 **Kill Terminal** 로써, 터미널 자체를 아예 종료한다.
6. 닫기는 **Close Terminal** 로써, 터미널을 종료하지 않고 창만보이지 않게 만든다.
7. 기본 터미널이 Git Bash로 열리는지 확인한다.



### Markdown

- Markdown (마크다운)은 일반 텍스트 기반의 경량 Markup (마크업) 언어이다.

### Markup (마크업) 이란?

- 마크(Mark)로 둘러싸인 언어를 뜻한다. 마크란 글의 역할을 지정하는 표시이다.
HTML도 마크업 언어인데, 글에 제목의 역할을 부여할 때 `<h1>제목1</h1>` 과 같이 작성한다.

### 마크다운의 장점과 단점

- 장점  
1. 문법이 직관적이고 쉽다.
2. 지원 가능한 플랫폼과 프로그램이 다양하다.
- 단점
1. 표준이 없어서 사용자마다 문법이 상이하다.
2. 모든 HTML의 기능을 대신하지는 못한다.

- 주의 사항

1. 마크다운의 본질은 글에 역할을 부여하는 것이다.
2. 반드시 역할에 맞는 마크다운 문법을 작성한다.
3. 글씨를 키우고 싶다고 해서 본문에 제목의 역할을 부여하면 안된다.

### 주요 문법
1. 제목: `#`을 사용합니다.
2. 목록  
   - 순서가 없는 목록은 `- , * , + `를 사용합니다.
   - 순서가 있는 목록은 `1. 2. 3.`과 같은 숫자를 사용합니다.
   - `tab키`를 이용해서 들여쓰기를 할 수 있습니다.
3. 강조
    - 기울임: `*글자*` 혹은 `_글자_`
    - 굵게: `**글자**` 혹은 `__글자__`
    - 취소선: `~~글자~~`
4. 코드
   - 인라인 코드: ``백틱을 통해 코드를 감싸준다
   - 블록 코드: ```python 백틱을 3번 입력하고 코드의 종류를 작성
5. 링크: `[표시할 글자](이동할주소)`
6. 이미지: `![대체 텍스트](이미지주소)`
7. 인용: `>`를 사용합니다. 갯수에 따라 중첩이 가능합니다.
8. 표: 파이프`|`와 파이폰`-`을 이용해서 행과 열을 구분합니다.(구글에서 마크다운 표 생성하여 복사 붙이기 가능)
9. 수평선: `-,*,-`을 3번 이상 연속으로 작성합니다.

### Git 기초
#### [1] Git 초기 설정(최초 한 번 만 설정.)
1. 누가 커밋을 기록을 남겼는지 확인할 수 있도록 이름과 이메일을 설정합니다.
    - `git config --global user.name"이름"`
    - `git config --global user.email "메일 주소"`
    - `git config --global init.defaultBranch main`
  2. 작성자가 올바르게 설정되었는 지 확인
    - `git config --global -1`
    - `git config --global --list`

#### [2] Git 기본 명령어
![git 원격 저장소 흐름도](https://www.notion.so/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2Ff2678325-6f7b-4a25-b188-86c42030d6d5%2Fc86c667a-616f-45b6-892e-15da6a3c494e%2FUntitled.png%3FspaceId%3Df2678325-6f7b-4a25-b188-86c42030d6d5?table=block&id=2cb611ac-3a00-80e9-bdf6-cfe94d27be85&cache=v2)  

##### Git 흐름별 명령어( 흐름별 각 상태는 `git.status`로 확인)
**git 관리 시작 ~ commit 까지**  
1. `git init`
   - 현재 작업 중인 디렉토리를 Git으로 관리한다는 명령어
   - `.git`이라는 숨김 폴더를 생성하고, 터미널에는 `(main)`라고 표기됩니다.
2. `git.status`
    - Working Directory와 Staging Area에 있는 파일의 현재 상태를 알려주는 명령어
   - `Untracked`: Git이 관리하지 않는 파일( 한번도 Staging Area에 올라간 적 없는 파일)
   - `Unmodified`: 최신 상태
   - `Modified`: 수정되었지만 아직 Staging Area에는 반영하지 않은 상태
   - `Staged`: Staging Area에 올라간 상태
  3. `git add`
      - Working Directory에 있는 파일을 Staging Area로 올리는 명령어
      - Untracked, Modified → Staged 로 상태를 변경합니다.
  4. `git commit`
      - Staging Area에 올라온 파일의 변경 사항을 하나의 버전(커밋)으로 저장하는 명령어
      - `git commit -m "first message"`: 커밋 메세지는 현재 변경 사항들을 잘 나타낼 수 있도록 의미 있게 작성하는 것을 권장합니다.
  5. `git log`
      - 커밋의 내역(ID, 작성자, 시간, 메세지 등)을 조회할 수 있는 명령어
      - `git log --oneline`: 한 줄로 축양해서 보여줍니다.
---
 **원격 저장소로 보내는 과정**
 ![원격 저장소로 전송](https://www.notion.so/image/https%3A%2F%2Fprod-files-secure.s3.us-west-2.amazonaws.com%2Ff2678325-6f7b-4a25-b188-86c42030d6d5%2F357df618-2ddf-4f18-b96c-c1b0787a1a45%2FUntitled.png%3FspaceId%3Df2678325-6f7b-4a25-b188-86c42030d6d5?table=block&id=2cb611ac-3a00-8065-864e-c28794964ed5&cache=v2)

  6. `git remote`
      - 등록: `git remote add<이름><주소>`
      - 조회: `git remote -v`
      - 삭제: `git remote rm <이름>`
  7. `git push`
      - 로컬 저장소의 커밋을 원격 저장소에 업로드하는 명령어
       - `git push <저장소 이름> <브랜치 이름>` 형식으로 작성합니다. 

---
---
---  
### 참고 자료
[Markdown Guide](https://www.markdownguide.org/basic-syntax/)  
[마크다운 문법 정리](https://gist.github.com/ihoneymon/652be052a0727ad59601)



<details>
-  dfasfasfsadfda
-  
</details>
