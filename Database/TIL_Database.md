# 📘 데이터분석 학습 노트

## 📅 2026-01-27
## 📌 데이터베이스의 기본

### 데이터베이스에서 가장 중요한 것
- 데이터베이스에서 핵심은 **SQL 문법이 아니라 ‘관계(Relationship)’ 이해**
- 실무에서 발생하는 SQL 오류의 상당수는  
  → 문법 오류가 아니라 **관계 이해 부족**에서 발생

---

### 관계를 이해하지 못하면 발생하는 실무 문제
- JOIN 후 데이터가 갑자기 **불어남**
- 반대로 데이터가 **사라짐**
- NULL이 생기는 구조를 모르고 필터링하여 정상 데이터가 누락됨
- 결과적으로
  - 지표 왜곡
  - 리포트 누락
  - “SQL은 맞는데 결과가 이상한” 상황 발생

---

## 🔗 관계 유형을 JOIN 관점에서 다시 정리

ERD의 관계(1:1, 1:N, M:N)는 설계 이론보다도  
**JOIN했을 때 결과 행(Row)이 어떻게 변하는지**,  
**어떤 JOIN을 쓰면 데이터가 누락되거나 증식되는지**를 판단하는 기준으로 해석하는 것이 중요하다.

---

## [1] 1:1 관계 (One-to-One) — JOIN 관점

### 핵심 구조
- A의 1행 ↔ B의 1행
- 실무에서는 **옵셔널(0..1)** 인 경우가 매우 많다  
  (예: 고객은 존재하지만 프로필은 없을 수 있음, 주문은 있지만 환불은 없을 수 있음)

### JOIN 결과 특징
- **JOIN해도 행(Row)은 원칙적으로 늘어나지 않는다**
- 다만, 옵셔널 관계일 경우
  - `LEFT JOIN` → B 테이블 컬럼에 `NULL` 발생
  - `INNER JOIN` → B가 없는 A의 행이 **누락**

### 실무 해석 포인트
- “한쪽 데이터가 없을 수 있는가?”를 먼저 판단해야 한다
- 기준 테이블(A) 중심 리포트라면  
  **INNER JOIN 사용 시 데이터 누락 위험**이 있다

📌  
1:1 관계의 핵심 리스크는 **행 증식이 아니라 행 누락**이다.

---

## [2] 1:N 관계 (One-to-Many) — JOIN 관점

### 핵심 구조
- A의 1행 ↔ B의 여러 행
- 한쪽(A)은 기준 데이터, 다른 쪽(B)은 반복 데이터  
  (예: 고객 1명 → 주문 여러 건)

### JOIN 결과 특징
- **JOIN하면 행(Row)이 늘어난다**
- A의 1행이 B의 개수만큼 **복제되어 나타난다**
  - 고객 1명 + 주문 3건 → 결과 3행

### 실무 해석 포인트
- JOIN 이후 결과의 **분석 단위가 무엇인지** 반드시 확인해야 한다
- 이 상태에서 단순 집계(`COUNT(*)`)를 하면
  - 고객 수가 아니라 **고객×주문 수**가 계산되는 오류 발생

📌  
1:N 관계에서 JOIN은  
**N쪽 기준으로 데이터가 늘어난다**는 점을 항상 경계해야 한다.

---

## [3] M:N 관계 (Many-to-Many) — JOIN 관점

### 핵심 구조
- A의 1행 ↔ B의 여러 행
- 동시에 B의 1행 ↔ A의 여러 행
- 관계형 DB에서는 **직접 저장하지 않고 중계 테이블로 분해**

---

### 핵심 사고 질문
> **이 데이터는 누구에 종속되는가?**

- 고객 기준 데이터인가?
- 주문 기준 데이터인가?
- 상품 기준 데이터인가?

👉 이 질문에 답하지 못하면 JOIN과 집계는 거의 항상 틀어짐

---

## 📌 식별자 (Identifier)

### 식별자의 정의
- “이 데이터가 바로 이것이다”라고 지정할 수 있게 해주는 값
- 하나의 속성 또는 **여러 속성의 조합**으로 구성 가능

---

### 식별자가 없으면 발생하는 문제
- 특정 데이터 조회 불가
- 중복 데이터 구분 불가
- 테이블 간 관계 설정 불가
- 수정·삭제 대상 명확히 지정 불가
- 식별자가 없는 데이터는  
  → **단순히 모여 있는 데이터 덩어리일 뿐**

---

### 엔터티 · 속성 · 식별자 예시
- 엔터티(Entity): 학생
- 속성(Attribute): 이름, 전공
- 식별자(Identifier): 학번

---

### 식별자의 종류

#### 기본키 (PK, Primary Key)
- 각 행을 유일하게 식별하는 대표 식별자
- 조건
  - 유일성 (중복 불가)
  - NULL 불가
  - 최소성

#### 외래키 (FK, Foreign Key)
- 다른 테이블의 PK를 참조
- 테이블 간의 **다리 역할**
- JOIN의 근거

#### 후보키 (Candidate Key)
- 기본키가 될 수 있는 모든 식별자 후보
- 예: 학번, 주민등록번호

---

### 자연키 vs 인조키
- 자연키(Natural Key)
  - 업무적 의미 있음
  - 원래 존재하는 속성
- 인조키(Surrogate Key)
  - 업무적 의미 없음
  - 시스템을 위해 인위적으로 생성

---

## 📌 분석가 관점의 데이터 모델링

### 분석가에게 데이터 모델링이 중요한 이유
- 데이터가 어떤 기준으로 쪼개져 저장되어 있는지 이해
- 어떤 테이블을 JOIN 해야 하는지 판단 가능
- 지표 정의 시
  - 중복
  - 누락
  - 과대/과소 집계  
  위험을 사전에 인지 가능

📌 비유  
> **데이터베이스는 건축의 ‘설계도’와 같다**

---

### 데이터 모델링 단계

#### 개념적 모델링
- “이 비즈니스에는 어떤 데이터가 존재하는가?”
- ERD의 뼈대를 만드는 단계
- 기획자·마케터·개발자의 공통 언어

#### 논리적 모델링
- “이 데이터를 어떤 구조로 저장할 것인가?”
- 엔터티 → 테이블
- 속성 → 컬럼
- 관계 → PK / FK
- 정규화를 통해 중복 제거, 일관성 확보
- 속성과 관계가 상세히 표현된 ERD 작성

#### 물리적 모델링
- “이 구조를 실제 DB에 어떻게 구현할 것인가?”
- 특정 DBMS 환경에서 실제 구현
- 분석가는
  - 인덱스 컬럼 파악
  - 물리 모델을 읽을 수 있는 수준 필요

---

## 📌 데이터베이스 설계와 ERD

### ERD란?
- 데이터 모델링 결과를 시각적으로 표현한 설계도
- 실무 활용
  - 신규 분석 과제 시작 시 데이터 구조 파악
  - 개발자·기획자·분석가 간 데이터 구조 합의 도구

📌 실무에서는  
→ SQL 코드보다 **ERD를 먼저 보는 경우가 많음**

---

### ERD 해석 시 반드시 던져야 할 질문
- 이 테이블의 한 행은 무엇을 의미하는가?
- 이 관계는 왜 1:N인가?
- 이 구조에서 JOIN은 어디서 발생하는가?

---

### ERD 구성 요소
#### 엔터티
- 데이터로 관리해야 할 대상
- 엔터티 1개 = 테이블 1개
- 잘못 나누면
  - 테이블 비대화
  - 과도한 JOIN 발생

#### 속성
- 엔터티가 가지는 구체적인 정보
- 테이블의 컬럼
- 여러 의미가 섞인 컬럼은 정규화 대상

#### 관계
- 엔터티 간 비즈니스 규칙
- 선(Line)으로 표현
- 이 선 하나가 JOIN의 근거

---

### ERD 기호 (Crow’s Foot Notation)

#### 카디널리티 (최대 개수)
- `|` : 하나
- `<` : 다수

#### 선택성 (최소 개수)
- `O` : 선택 (0 가능)
- `|` : 필수 (1 이상)

→ NULL 발생 가능성 판단 기준

---

### 기호 조합 실무 해석
- `O|`
  → NULL이 나와도 정상
- `||`
  → JOIN해도 데이터 안전
- `O<`
  → JOIN하면 데이터 폭증
- `|<`
  → JOIN 없이는 의미 없는 데이터

---

## 📌 데이터베이스 관계 (Relationship)

### 관계란?
- 테이블 간의 논리적 연결
- 데이터가 늘어나는 방식, 사라지는 조건, NULL 발생 여부를 결정

---

### 관계를 위한 핵심 요소
- 기본키(PK): 이 행이 무엇인지 결정
- 외래키(FK): 다른 테이블의 PK 참조

📌 키는 단순 제약조건이 아니라  
→ **JOIN의 근거 + 데이터 소속 관계**

---

### 1:1 관계
- 주로 ‘분리’ 목적
  - 민감정보 분리
  - 선택적 정보 분리
  - 대용량 데이터 분리

📌 해석 포인트
- 한쪽 데이터가 없을 수 있는지 먼저 확인
- INNER JOIN 시 데이터 누락 가능

---

### 1:N 관계 ⭐ 가장 중요
- JOIN 시 반드시 행(Row)이 늘어남
- 고객 1명 + 주문 3건 → 결과 3행

📌 규칙
> **1:N 관계에서 JOIN하면 N쪽 기준으로 데이터가 늘어난다**

- COUNT(*)는 항상 “무엇을 세고 있는지” 확인

---

### M:N 관계
- 고객 ↔ 상품 = M:N
- 주문 테이블이 중계 테이블 역할
- 관계형 DB에서는
  → 반드시 중계 테이블로 구조 분해

---

### 관계 파트 핵심 요약
- SQL 오류의 대부분은
  → **관계 이해 부족에서 시작된다** 

---
   
## 🧐 오늘의 궁금증

### ERD는 데이터 분석가에게 왜 필요할까?

처음에는 ERD가 데이터베이스 설계 문서처럼 보였지만,  
분석 관점에서 핵심 역할은 **“JOIN을 어떻게 해야 하는지 판단하기 위한 지도”**라는 점을 이해하게 되었다.

데이터 분석가는 ERD를 통해  
- 어떤 테이블을 어떤 키로 JOIN해야 하는지  
- JOIN 시 행(row)이 증가하는지  
- 집계(aggregation)가 선행되어야 하는 테이블인지  
를 빠르게 판단할 수 있다.

---

### 중계 테이블은 왜 중요한가?

중계 테이블은 보통 **M:N 관계**를 표현하며,  
`user_id + 다른_id` 형태의 **관계/행위 로그**가 저장된다.

분석 관점에서 중요한 점은  
> **중계 테이블을 그대로 JOIN하면 데이터가 증식될 가능성이 매우 높다**는 것이다.

따라서 중계 테이블은 대부분  
**집계 → 의미 단위 고정 → JOIN**  
이라는 순서를 따라야 지표 왜곡을 피할 수 있다.

---

### “한 칸에 하나의 값” 기준은 충분할까?

- 한 컬럼에 여러 값이 들어가면 → **테이블 분리**는 맞다.
- 하지만 분리된 테이블이  
  - 두 엔티티 간 **관계 기록(누가–무엇을–언제)** 이면 → **중계 테이블**
  - 내용·텍스트·사건 자체를 담고 있으면 → **독립 엔티티**

즉, “여러 개”라는 이유만으로 중계 테이블은 아니다.

---

### ERD 없이도 중계 테이블을 감지할 수 있을까?

가능하다. 다음 신호가 보이면 중계 테이블일 확률이 높다.

- 컬럼이 거의 전부 `~_id`
- 복합 PK 사용
- row 수가 유독 많음
- JOIN 시 행이 급격히 증가
- “누가 무엇을 언제 했다” 구조

이런 경우 분석가는 **바로 집계부터 고려**해야 한다.

---

### 오늘의 핵심 정리

- 데이터 분석가에게 ERD는 설계 이론을 설명하기 위한 문서가 아니다.
- ERD의 핵심 가치는  
  **JOIN 방향, 집계 필요 여부, 분석 단위(Granularity)를 판단하는 데 있다.**
- “왜 중계 테이블인지”를 말로 설명할 수 없더라도,  
  **중계 테이블처럼 행동(집계 후 JOIN)** 할 수 있으면 충분하다.

---
## 📅 2026-01-29
## 📌 SELECT 구조와 실행 순서 이해

### SQL에서 SELECT가 중요한 이유
- SQL의 모든 분석은 **SELECT 문에서 시작**
- 조회 대상, 분석 단위, 집계 기준이  
  → SELECT 구조에 의해 결정됨

📌  
SQL에서 발생하는 많은 오류는  
문법이 아니라 **실행 순서와 구조 이해 부족**에서 발생한다.

---

### SELECT 구문의 기본 구조
- SELECT
- FROM
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- LIMIT / OFFSET

- SQL은 자유 문장이 아니라  
  **정해진 구조와 순서를 따르는 언어**
- 구문의 순서를 지키지 않으면 실행되지 않음

---

### SELECT 구문의 작성 순서
```sql
SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY
LIMIT
````

#### 올바른 작성 예시

```sql
SELECT Name, Population
FROM city;
```

#### 잘못된 작성 예시 (실행 불가)

```sql
-- FROM city
-- SELECT Name, Population
```

📌
SQL은 사람이 읽는 순서가 아니라
**DB 엔진의 처리 순서**를 기준으로 해석된다.

---

## 📌 SELECT 절과 FROM 절의 역할

### SELECT 절

* 조회하고 싶은 **컬럼을 지정**
* 분석에서 “무엇을 보겠는가”를 결정

```sql
SELECT Name, Population
FROM city;
```

---

### FROM 절

* 데이터의 **출처를 명확히 지정**
* FROM이 없으면 SELECT는 의미를 가질 수 없음

---

### `SELECT *` 사용 시 주의

```sql
SELECT *
FROM city;
```

* 테이블 구조 확인용으로만 제한적으로 사용
* 실무/분석 쿼리에서는 지양

📌
분석에서는
**필요한 컬럼만 명시적으로 선택하는 것이 원칙**이다.
컬럼을 고르는 행위 자체가 분석 의도다.

---

### 특정 컬럼 조회 시 권장 방식

```sql
SELECT city.Name, city.Population
FROM city;
```

* 테이블이 하나여도 `테이블명.컬럼명` 사용 권장
* 이후 JOIN이 추가되어도 컬럼 출처가 명확함

📌
컬럼 출처를 명확히 쓰는 습관은
ERD 해석, 관계 이해, JOIN 사고 예방으로 이어진다.

---

## 📌 SELECT에서 자주 사용하는 기능

### 별칭 설정 (Alias)

* 컬럼명, 테이블명 모두 별칭 설정 가능
* 가독성과 의미 전달을 동시에 개선

```sql
SELECT
    city.Name AS city_name,
    city.Population AS pop
FROM city;
```

📌
별칭은 단순 축약이 아니라
**“이 컬럼을 어떤 의미로 쓰겠다”는 선언**이다.

---

### DISTINCT

* 컬럼 내 **고유 값의 종류를 빠르게 파악**
* 데이터 분포 확인에 유용

```sql
SELECT DISTINCT countrycode
FROM city;
```

📌
DISTINCT는
범주형 데이터의 수준(level)을 빠르게 파악할 때 유용하지만,
여러 컬럼과 함께 사용할 경우
**중복 제거 기준을 반드시 의식해야 한다.**

---

## 📌 SQL의 논리적 실행 순서

### 작성 순서 vs 실행 순서

```text
[작성 순서]
SELECT → FROM → WHERE → GROUP BY → HAVING → ORDER BY → LIMIT

[실행 순서]
FROM
→ WHERE
→ GROUP BY
→ HAVING
→ SELECT
→ ORDER BY
→ LIMIT
```

📌
SELECT에서 만든 별칭은
WHERE 절에서 사용할 수 없다.
→ **WHERE가 SELECT보다 먼저 실행되기 때문**

---

## 📌 WHERE와 HAVING의 차이

### 공통점

* 둘 다 **필터링 역할**

### 차이점

| 구분       | WHERE       | HAVING      |
| -------- | ----------- | ----------- |
| 적용 대상    | 개별 행(Row)   | 그룹화된 결과     |
| 적용 시점    | GROUP BY 이전 | GROUP BY 이후 |
| 집계 함수 사용 | ❌           | ⭕           |

📌

* WHERE → **먼저 버리고 계산**
* HAVING → **다 계산한 후 조건 적용**

이 차이를 이해하지 못하면
분석 대상이 바뀌거나 집계 결과가 왜곡된다.

---

## 📌 GROUP BY 이해

### GROUP BY란?

* 지정된 컬럼 기준으로 데이터를 그룹화
* 각 그룹에 대해 집계 함수 사용 가능

```text
여러 행
→ 하나의 그룹
→ 하나의 결과 행
```

---

### GROUP BY의 목적

* 같은 값을 가진 레코드를 묶어
  **요약·집계 정보 생성**

예:

* 고객별 주문 수
* 국가별 인구 합계
* 상품별 매출

---

### GROUP BY의 핵심 사고

* 그룹화: **분석 단위를 고정하는 작업**
* 집계: SELECT 절에서 수행

```sql
SELECT
    CountryCode,
    SUM(Population) AS total_population
FROM city
GROUP BY CountryCode;
```

📌
GROUP BY는 단순 문법이 아니라
**“이 분석은 무엇을 단위로 보는가”를 결정하는 핵심 구문**이다.

---

## 📌 HAVING으로 그룹 결과 필터링

```sql
SELECT
    CountryCode,
    SUM(Population) AS total_population
FROM city
GROUP BY CountryCode
HAVING SUM(Population) > 10000000;
```

* HAVING은 그룹화된 결과에 조건 적용

📌
HAVING은
집계 결과 자체가 조건일 때만 사용해야 하며,
가능하다면 **WHERE로 먼저 거르는 것이 원칙**이다.

---

### 오늘의 핵심 정리

- 데이터 분석가에게 SQL 문법은 목적이 아니라 **수단**이다.
- SELECT, WHERE, GROUP BY, HAVING의 핵심은  
  **“어떤 데이터를, 어떤 단위로, 언제 거르는가”를 통제하는 데 있다.**
- GROUP BY는 단순 집계 문법이 아니라  
  **분석 단위(Granularity)를 명시적으로 고정하는 행위**다.
- WHERE와 HAVING의 차이를 이해하지 못하면  
  분석 대상이 바뀌거나 집계 결과가 왜곡된다.
- 실행 순서(FROM → WHERE → GROUP BY → HAVING → SELECT)를 이해해야  
  별칭 오류, 필터링 오류, 지표 해석 오류를 예방할 수 있다.
---
## 📅 2026-01-30

## 📌 ORDER BY, JOIN, 다중 JOIN 실습

## 📌 ORDER BY로 결과 정렬하기

### ORDER BY의 역할
- 조회 결과를 **특정 컬럼 기준으로 정렬**
- 분석 결과를 해석 가능한 형태로 만드는 단계

---

### 인구 수 기준 내림차순 정렬
```sql
SELECT
    ct.`Name` AS 이름,
    ct.`District` AS 지역,
    ct.`Population` AS 인구수
FROM city ct
ORDER BY ct.`Population` DESC;
````

* `DESC` : 내림차순
* 기본값은 오름차순(`ASC`)

📌
ORDER BY는 **데이터를 바꾸지 않고, 보여주는 순서만 바꾼다.**

---

### 여러 컬럼 기준 정렬

```sql
SELECT
    ct.`CountryCode`,
    ct.`Population` AS 총인구수
FROM city ct
WHERE ct.`CountryCode` IN ('KOR', 'JPN', 'CHN')
ORDER BY ct.`CountryCode`, 총인구수 DESC;
```

* 국가 코드로 1차 정렬
* 국가 내부에서는 인구 기준 내림차순 정렬

📌
다중 정렬은
**“어떤 기준이 우선인가?”** 를 명확히 드러낸다.

---

### NULL 값 정렬

```sql
SELECT *
FROM country co
ORDER BY co.`IndepYear`;
```

* NULL은 가장 작은 값으로 인식

```sql
SELECT *
FROM country co
WHERE co.`IndepYear` IS NOT NULL
  AND co.`IndepYear` > 0
ORDER BY co.`IndepYear`;
```

📌 분석가 관점 포인트:

* NULL 포함 여부에 따라
  결과 해석이 완전히 달라질 수 있다.
* 정렬 전에 **NULL 처리 여부를 반드시 판단**해야 한다.

---

### LIMIT / OFFSET

```sql
SELECT *
FROM city ct
ORDER BY ct.`Population` DESC
LIMIT 5 OFFSET 5;
```

* 6번째 행부터 5개 출력

📌
LIMIT 결과는
**전체 분포가 아닌 일부 샘플**일 수 있음을 항상 인지해야 한다.

---

## 📌 JOIN 기본 실습

### INNER JOIN

* 양쪽 테이블에 **모두 존재하는 데이터만 조회**
* 교집합 개념

```sql
SELECT
    city.`Name` AS 도시명,
    country.`Name` AS 국가명,
    country.`Continent` AS 대륙명
FROM city
INNER JOIN country
    ON city.`CountryCode` = country.`Code`;
```

📌
INNER JOIN은
“양쪽 데이터가 반드시 존재한다”는 가정을 포함한다.
기준 테이블 분석 시 데이터 누락 위험이 있다.

---

### LEFT JOIN과 결측 발생

```sql
SELECT
    co.`Name` AS 나라명,
    ct.`Name` AS 수도명
FROM country co
LEFT JOIN city ct
    ON co.`Capital` = ct.`ID`
WHERE ct.`Name` IS NULL;
```

* 수도 정보가 없는 국가 확인
* LEFT JOIN은 **기준 테이블(co)을 보존**

📌
LEFT JOIN에서 발생하는 NULL은
**데이터 오류가 아니라 구조적 결과**다.

---

## 📌 JOIN 실무 예제 (sakila)

### 모든 고객의 대여 이력 조회

```sql
SELECT
    c.first_name AS 성,
    c.last_name AS 이름,
    r.rental_date AS 대여일시,
    r.return_date AS 반납일시
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id;
```

* “모든 고객”이 기준이므로 LEFT JOIN

---

### 아직 반납하지 않은 대여 이력

```sql
SELECT
    c.first_name AS 성,
    c.last_name AS 이름,
    r.rental_date AS 대여일시,
    r.return_date AS 반납일시
FROM customer c
LEFT JOIN rental r
    ON c.customer_id = r.customer_id
WHERE r.return_date IS NULL;
```

📌 분석가 관점 포인트:

* LEFT JOIN 후 WHERE 조건은
  **결과를 다시 INNER JOIN처럼 만들 수 있음**
* 기준 테이블이 무엇인지 항상 재확인해야 한다.

---

## 📌 3개 이상의 테이블 JOIN

### world 데이터베이스 예제

```sql
SELECT
    co.`Name` AS 국가명,
    ct.`Name` AS 수도명,
    cl.`Language` AS 언어
FROM country co
INNER JOIN city ct
    ON co.`Capital` = ct.`ID`
INNER JOIN countrylanguage cl
    ON cl.`CountryCode` = co.`Code`;
```

* 언어 수만큼 행이 증가
* **중계 테이블 성격** 확인 가능

---

### 공식 언어만 필터링

```sql
SELECT
    co.`Name` AS 국가명,
    ct.`Name` AS 수도명,
    cl.`Language` AS 언어
FROM country co
INNER JOIN city ct
    ON co.`Capital` = ct.`ID`
INNER JOIN countrylanguage cl
    ON cl.`CountryCode` = co.`Code`
WHERE cl.IsOfficial = 'T';
```

📌
중계 테이블을 그대로 JOIN하면
행이 증식되기 쉽다.
→ **필터링 또는 집계 후 JOIN 고려**

---

### M:N 관계 + 중계 테이블 (sakila)

```sql
SELECT
    a.first_name AS 이름,
    a.last_name AS 성,
    f.title AS 영화이름
FROM film f
INNER JOIN film_actor fa
    ON f.film_id = fa.film_id
INNER JOIN actor a
    ON a.actor_id = fa.actor_id
ORDER BY 이름, 성;
```

---

### USING 구문

```sql
SELECT
    a.first_name,
    a.last_name,
    f.title
FROM actor a
INNER JOIN film_actor fa
    USING(actor_id)
INNER JOIN film f
    USING(film_id);
```

📌
USING은
컬럼명이 동일할 때 가독성을 높여준다.
다만, **조인 키가 명확히 같을 때만 사용**해야 한다.

---

### 오늘의 핵심 정리

* ORDER BY는 단순 정렬이 아니라
  **분석 결과를 해석 가능한 형태로 만드는 단계**다.
* LIMIT가 포함된 결과는
  전체 분포가 아닌 일부 샘플일 수 있다.
* JOIN은 테이블을 붙이는 문법이 아니라
  **데이터 모델을 해석하고 분석용 테이블을 만드는 과정**이다.
* LEFT JOIN은 실무 분석에서 가장 중요한 JOIN 방식이다.
* 3개 이상의 테이블 JOIN에서는
  **첫 FROM 테이블이 분석 기준(Granularity)** 을 결정한다.
* 두 엔터티 사이에서
  “언제 / 어떻게 / 어떤 상태로”라는 질문이 생기면
  그 관계는 반드시 **중계 테이블**로 저장해야 한다.
* 중계 테이블은
  그대로 JOIN하지 말고
  **집계 → 의미 단위 고정 → JOIN** 순서를 항상 고려해야 한다.
---

## 📅 2026-02-02
## 📌 특수 JOIN, VIEW, 서브쿼리 실습
## 📌 CROSS JOIN

### CROSS JOIN이란?
- 조인 조건 없이 **모든 경우의 수를 만들어내는 JOIN**
- 두 테이블의 모든 행을 서로 하나씩 짝지어 **가능한 모든 조합 생성**

```text
테이블 A (n행)
× 테이블 B (m행)
→ 결과 n × m 행
````

```sql
SELECT *
FROM table_a
CROSS JOIN table_b;
```

📌
CROSS JOIN은 의도하지 않으면 거의 항상 **사고의 원인**이 된다.
모든 조합이 필요한 경우에만 명확한 목적을 가지고 사용해야 한다.

---

## 📌 SELF JOIN

### SELF JOIN이란?

* 같은 테이블을 **자기 자신과 JOIN**
* 같은 종류의 데이터끼리 **관계 비교**가 필요할 때 사용

---

### 실습 예제 — 같은 대륙에 속한 국가 비교

```sql
SELECT 
    c2.`Name` AS 국가명,
    c1.`Continent` AS 대륙명
FROM country AS c1
JOIN country AS c2
    ON c1.`Continent` = c2.`Continent`
WHERE 
    c1.`Name` = 'Germany'
    AND c2.`Name` <> 'Germany';
```

📌 분석가 관점 포인트:

* SELF JOIN은
  **데이터 구조를 머릿속에 그릴 수 있어야** 해석 가능하다.
* Alias가 곧 **역할 분리**다.

---

## 📌 실무에서 JOIN이 어려워지는 순간

JOIN 문법 자체보다
**조건이 하나씩 붙는 순간부터 난이도가 급격히 증가**한다.

---

### JOIN이 어려워지는 대표적인 상황

* 중계 테이블이 단순 연결이 아니라 **기록(Log)** 이 되는 순간
* 최신 데이터만 연결해야 하는 순간
* 상태(Status)가 붙는 순간
* JOIN과 집계(GROUP BY)가 섞이는 순간

📌
이 시점부터는
**문법이 아니라 사고 순서가 결과를 결정**한다.

---

## 📌 VIEW의 필요성

### VIEW란?

* 복잡한 쿼리를 **재사용하기 위한 가상 테이블**
* 데이터를 저장하지 않고, **쿼리 자체를 저장**

---

### 실습 예제 — 아시아 국가 VIEW 생성

```sql
CREATE VIEW asia_countries_view AS
SELECT
    co.`Code` AS 국가코드,
    co.`Name` AS 국가명,
    ct.`Name` AS 수도명,
    co.`Population` AS 인구수,
    co.`GNP` AS GNP
FROM country AS co
JOIN city AS ct
    ON co.`Capital` = ct.`ID`
WHERE co.`Continent` = 'Asia';
```

```sql
SELECT *
FROM asia_countries_view
WHERE 인구수 < 100000000
ORDER BY 인구수 DESC
LIMIT 10;
```

---

### VIEW에 대한 핵심 사고

* VIEW는 **저장이 아니라 재실행**
* 원본 테이블이 깨지면 VIEW도 깨질 수 있음

📌 분석가 관점 포인트:

* VIEW는 테이블이 아니라
  **“고정된 기준으로 보게 만드는 인터페이스”**
* 핵심 목적

  * JOIN 반복 단순화
  * 기준 정의 고정
  * 데이터 노출 제어

---

## 📌 서브쿼리 (Subquery)

### 서브쿼리란?

* SQL 안에 포함된 또 다른 SELECT
* JOIN 대신
  **기준을 먼저 만들기 위해 사용**

📌
JOIN은 데이터를 붙이는 도구,
서브쿼리는 **기준을 만드는 도구**다.

---

## 📌 비연관 서브쿼리

### 특징

* 메인 쿼리와 독립적으로 실행
* 고정된 결과 집합을 기준으로 전체를 필터링

---

### 실습 예제 — 평균보다 비싼 영화

```sql
SELECT f.title, f.rental_rate
FROM film f
WHERE f.rental_rate > (
    SELECT AVG(rental_rate)
    FROM film
);
```

📌
서브쿼리는 **“기준값 하나”** 를 만들 때 매우 직관적이다.

---

## 📌 연관 서브쿼리

### 특징

* 메인 쿼리의 **각 행마다**
* 서브쿼리가 **동적으로 실행**

---

### 실습 예제 — 고객별 최근 대여일

```sql
SELECT
    cu.first_name,
    cu.last_name,
    (
        SELECT MAX(r.rental_date)
        FROM rental r
        WHERE r.customer_id = cu.customer_id
    ) AS 최근대여일
FROM customer cu;
```

📌 분석가 관점 포인트:

* 연관 서브쿼리는
  **행 단위 기준이 바뀌는 경우**에 가장 명확하다.
* JOIN + GROUP BY로 대체 가능하지만
  의도 전달은 서브쿼리가 더 직관적인 경우가 많다.

---

## 📌 EXISTS

### EXISTS의 핵심

* 실제 데이터 값은 중요하지 않음
* **존재 여부(있다 / 없다)** 만 판단

---

### 실습 예제 — Horror 영화 대여 경험 고객

```sql
SELECT 
    cu.first_name,
    cu.last_name
FROM customer cu
WHERE EXISTS (
    SELECT 1
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Horror'
      AND r.customer_id = cu.customer_id
);
```

📌
EXISTS는
값을 가져오는 쿼리가 아니라
**조건 충족 여부를 판단하는 논리 연산**이다.

---

### 오늘의 핵심 정리

* CROSS JOIN은 모든 조합을 만드는 강력하지만 위험한 JOIN이다.
* SELF JOIN은 같은 테이블 내 역할 비교를 위한 구조다.
* JOIN이 어려워지는 순간은
  **기록, 상태, 최신 조건, 집계가 붙는 시점**이다.
* VIEW는 데이터를 저장하는 것이 아니라
  **기준을 고정하고 재사용하기 위한 인터페이스**다.
* 서브쿼리는 JOIN의 대체재가 아니라
  **기준을 명확히 드러내는 도구**다.
* 연관 서브쿼리와 EXISTS는
  **행 단위 판단이 필요할 때 가장 명확한 선택**이다.
---
## 📅 2026-02-03
## 🧠 오늘 학습 내용 – 데이터 분석 관점 요약

* 오늘의 핵심은 **“같은 문제를 어떻게 더 읽기 좋은 구조로 풀 것인가”**
* CTE는 결과를 바꾸는 도구가 아니라
  **사고 단계를 드러내는 도구**
* 데이터 타입과 함수는
  → 단순 문법이 아니라 **지표 왜곡을 막는 안전장치**
* 실무 SQL은

  * “돌아가는 쿼리”가 아니라
  * **의도가 명확한 쿼리**가 목표

## 📌 CTE · 데이터 타입 · 함수 · 실습

---

## 📌 CTE (Common Table Expression)

### 같은 문제, 두 가지 접근

#### 1️⃣ 서브쿼리로 해결

```sql
SELECT co1.Continent, co1.Name, co1.Population
FROM country AS co1
JOIN (
    SELECT co2.Continent, MAX(co2.Population) AS max_pop
    FROM country AS co2
    GROUP BY co2.Continent
) AS cmp
ON cmp.Continent = co1.Continent
AND cmp.max_pop = co1.Population;
```

* 결과는 맞음
* 하지만

  * `MAX(Population)`이 언제 계산되는지
  * 무엇을 기준으로 비교하는지
    한눈에 보이지 않음

---

#### 2️⃣ CTE로 문제 분해

```sql
WITH cmp AS (
    SELECT Continent, MAX(Population) AS max_pop
    FROM country
    GROUP BY Continent
)
SELECT c.Continent, c.Name, c.Population
FROM country c
JOIN cmp
ON cmp.Continent = c.Continent
AND cmp.max_pop = c.Population;
```

📌 데이터 분석 관점 포인트:

* 문제를 **2단계로 나눔**

  1. 대륙별 최대 인구 계산
  2. 해당 값을 가진 국가 선택
* SQL이 **사고 흐름 그대로 읽히기 시작**

---

## 📌 데이터 타입 (Data Types)

### 암시적 형변환

```sql
SELECT "1" + 403;
SELECT cat.category_id + cat.name
FROM category AS cat
LIMIT 4;
```

* DB가 자동으로 형변환 시도
* 의도하지 않은 결과 발생 가능

---

### 명시적 형변환 (CAST)

```sql
SELECT CONCAT(CAST(cat.category_id AS CHAR), '_', cat.name)
FROM category AS cat;
```

```sql
SELECT YEAR(cat.last_update)
FROM category AS cat;
```

```sql
SELECT CAST('2026' AS YEAR) - YEAR(cat.last_update)
FROM category AS cat;
```

📌 데이터 분석 관점 포인트:

* 형변환은 **명시적으로**
* 특히

  * 날짜
  * 숫자
  * 문자열
    혼용 시 지표 오류 빈번

---

## 📌 SQL 함수 (Function)

### 문자열 함수

```sql
SELECT CONCAT(
    UPPER(ct.Name), 
    "(", ct.CountryCode, ")"
)
FROM city ct
WHERE ct.CountryCode IN (
    SELECT co.Code
    FROM country co
    WHERE LOWER(co.Continent) = 'asia'
);
```

```sql
SELECT co.Name, SUBSTRING(co.Name, 1, 3)
FROM country co
LIMIT 5;
```

```sql
SELECT country.Name, LENGTH(country.Name)
FROM country;
```

📌 포인트:

* 함수는 **표현을 바꾸는 도구**
* 분석에서는
  → 가독성 개선, 그룹 기준 통일에 중요

---

## 📌 실습 문제 (practice.sql)

### 🎯 문제 1

**Action 장르 영화를 ‘한 번도’ 빌리지 않은 고객 찾기**

#### 서브쿼리 방식

```sql
SELECT c.first_name, c.last_name
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE r.customer_id = c.customer_id
    AND cat.name = 'Action'
);
```

---

#### CTE 방식

```sql
WITH ActionCustomer AS (
    SELECT DISTINCT r.customer_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE cat.name = 'Action'
)
SELECT c.first_name, c.last_name
FROM customer c
LEFT JOIN ActionCustomer ac
ON c.customer_id = ac.customer_id
WHERE ac.customer_id IS NULL;
```

📌 데이터 분석 관점 포인트:

* **NOT EXISTS vs LEFT JOIN + IS NULL**
* 마케팅 타겟 추출에서 매우 자주 쓰는 패턴
* 핵심은

  > “무엇을 제외할 것인가”를 먼저 정의
---
## 📌 단일행 함수 · 서브쿼리 실습
---
## 📌 단일행 함수 (Single-row Function)

- **행별로 값 하나 → 값 하나**로 변환하는 함수
- 문자열/숫자/날짜/NULL 처리 함수가 대표적

---

## [1] 문자열 함수

### (1) CONCAT : 문자열 이어붙이기
- 예: `Seoul (KOR)` 형태로 변환

```sql
SELECT CONCAT(UPPER(ct.`Name`), "(", ct.`CountryCode`, ")")
FROM city ct
WHERE ct.`CountryCode` IN (
    SELECT co.`Code`
    FROM country co
    WHERE LOWER(co.`Continent`) = 'asia'
);
````

데이터 분석 관점 포인트:

* 표준화(대소문자 통일) + 라벨링(CONCAT)은
  **리포트/시각화 단계에서 재가공 비용을 줄인다.**

---

### (2) SUBSTRING : 위치 기반 부분 추출

```sql
SELECT co.`Name`, SUBSTRING(co.`Name`, 1, 3)
FROM country co
LIMIT 5;
```

---

### (3) LENGTH : 문자열 길이

```sql
SELECT country.`Name`, LENGTH(country.`Name`)
FROM country;
```

---

### (4) REPLACE : 문자열 치환

```sql
SELECT co.`Name`, REPLACE(co.`Name`, 'South', 'S.')
FROM country co
WHERE co.name LIKE "%South%";
```

데이터 분석 관점 포인트:

* 치환은 “표기 통일”에 효과적이지만,
  **원본 의미가 바뀔 수 있으니(예: South 포함 국가명)** 적용 범위를 조건으로 제한하는 습관이 중요하다.

---

## [2] 숫자형 함수

### 산술 연산 예시 (인구밀도)

```sql
SELECT co.`Name`, co.`Population` / co.`SurfaceArea` AS 인구밀도
FROM country co
WHERE co.`Population` > 0;
```

데이터 분석 관점 포인트:

* 인구밀도/객단가/전환율 같은 지표는
  **분모(0/NULL) 처리 규칙**이 없으면 지표가 깨진다.
* 아래처럼 `SurfaceArea > 0` 같은 방어 조건이 실무에서 필수.

---

### (1) 반올림/올림/내림/버림

```sql
SELECT
    co.`Name`,
    ROUND(co.`Population` / co.`SurfaceArea`, 2) AS 인구밀도,
    CEIL(co.`Population` / co.`SurfaceArea`) AS 올림,
    FLOOR(co.`Population` / co.`SurfaceArea`) AS 내림,
    TRUNCATE(co.`Population` / co.`SurfaceArea`, 2) AS 버림
FROM country co
WHERE co.`SurfaceArea` > 0;
```

데이터 분석 관점 포인트:

* `ROUND` vs `TRUNCATE`는 결과 해석이 달라진다.

  * ROUND: 보기 좋지만 값이 바뀜(정책/과금 지표에 영향 가능)
  * TRUNCATE: 값 보수적(컷팅) — 금융/정책 지표에 더 자주 사용

---

## [3] 날짜형 함수

### (1) 현재 시간

```sql
SELECT NOW(), CURDATE(), CURTIME();
```

---

### (2) 날짜 일부 추출

```sql
SELECT WEEKDAY(NOW());  -- 요일
SELECT YEAR(NOW());
SELECT YEARWEEK(NOW());
```

---

### (3) 날짜 포맷

```sql
SELECT DATE_FORMAT(NOW(), '%M,%D');
```

---

### (4) 날짜 연산

```sql
SELECT NOW() + 10;  -- 의도: 10일 뒤, 실제: 초 단위 연산(10초 뒤)
SELECT DATE_ADD(NOW(), INTERVAL 10 DAY);
SELECT DATE_SUB(NOW(), INTERVAL 3 HOUR);
```

데이터 분석 관점 포인트:

* `NOW() + 10` 처럼 “의도와 실제 동작이 다른 연산”이 지표 오류를 만든다.
* 날짜 연산은 **DATE_ADD/DATE_SUB 같은 함수로 명시적으로** 처리하는 게 안전하다.

---

### 예시: 반납일-대여일 간격(일수)

```sql
USE sakila;
DESCRIBE rental;

SELECT AVG(DATEDIFF(r.return_date, r.rental_date))
FROM rental r;
```

---

### 종강일까지 남은 일수

```sql
SELECT DATEDIFF('2026-03-27', CURDATE());
```

---

## [4] NULL 관련 함수

```sql
USE world;
SELECT DATABASE();
DESCRIBE country;

SELECT COUNT(*)
FROM country co
WHERE `GNP` IS NULL;

SELECT COUNT(*)
FROM country co
WHERE `HeadOfState` IS NULL;
```

---

### (1) COALESCE : 결측이 아닌 첫 번째 값 반환

```sql
SELECT 
    co.`Name`, co.`GNPOld`, co.`GNP`,
    COALESCE(co.`GNPOld`, co.`GNP`, 0) AS 최종GNP
FROM country co;
```

데이터 분석 관점 포인트:
* country 테이블에서 과거 GNP(GNPOld)가 없으면 최신 GNP(GNP)를 사용하고, 둘 다 없으면 0으로 표시합니다.
* 결측 대체값(0/평균/중앙값/제외)은 지표 정의의 일부다.
* `COALESCE(..., 0)`는 “0으로 간주” 규칙이므로,
  **분석 목적에 맞는지** 확인이 필요하다.

---

### (2) IFNULL : 단일 값 결측 대체

```sql
SELECT
    co.`Name`, co.`HeadOfState`,
    IFNULL(co.`HeadOfState`, '정보없음')
FROM country co
WHERE co.`Continent` = 'Europe';
```

---

### (3) NULLIF : 의도적으로 NULL 발생

```sql
SELECT cl.`Language`, cl.`Percentage`, NULLIF(cl.`Percentage`, 0.0)
FROM countrylanguage cl
WHERE cl.`Language` = 'English';
```

데이터 분석 관점 포인트:

* `NULLIF(x, 0)`는
  “0을 결측으로 간주해 제외/무효 처리”할 때 유용.
* 평균/비율 계산에서 0을 제거하고 싶을 때 자주 사용한다.

---

## 📌 서브쿼리 실무형 문제 풀이 (sakila)

```sql
USE sakila;
SELECT DATABASE();
SHOW TABLES;
```

---

## [문제 1] 평균보다 비싼 영화 찾기 (가격 정책 점검)

```sql
SELECT
    f.title,
    f.rental_rate
FROM film f
WHERE f.rental_rate > (
    SELECT AVG(f.rental_rate)
    FROM film f
);
```

데이터 분석 관점 포인트:

* 서브쿼리는 “평균이라는 기준값”을 만든다.
* 비교 기준(전체 평균 vs 장르 평균 vs 등급 평균)을 바꾸면 정책 결론도 바뀐다.

---

## [문제 2] 고객 5번 결제 + 전체 평균 결제액 같이 보기

```sql
SELECT
    p.payment_id,
    p.amount,
    (
        SELECT AVG(p.amount)
        FROM payment p
    ) AS 전체평균결제액
FROM payment p
WHERE customer_id = 5;
```

데이터 분석 관점 포인트:

* “각 행에 전체 평균을 붙이는 패턴”은
  **개별 vs 전체 비교 리포트**에서 매우 흔하다.

---

## [문제 3] Action 카테고리 영화의 재고(inventory) 조회

```sql
SELECT *
FROM inventory i
WHERE i.film_id IN (
    SELECT f.film_id
    FROM film f
    WHERE f.film_id IN (
        SELECT fc.film_id
        FROM film_category fc
        JOIN category c
            ON fc.category_id = c.category_id
        WHERE c.name = 'action'
    )
);
```

데이터 분석 관점 포인트:

* `IN` 중첩이 깊어질수록 가독성이 급감한다.
* 이런 구조는 나중에 CTE로 단계 분해하면 유지보수성이 좋아진다.

---

## [문제 4] 캐나다 거주하지 않는 고객 추출

```sql
SELECT
    cu.first_name,
    cu.last_name
FROM customer cu
WHERE cu.address_id NOT IN (
    SELECT a.address_id
    FROM address a
    WHERE a.city_id IN (
        SELECT c.city_id
        FROM city c
        JOIN country co
            ON c.country_id = co.country_id
        WHERE co.country = 'Canada'
    )
);
```

데이터 분석 관점 포인트:

* “제외 조건(NOT IN)”은
  **NULL이 섞이면 결과가 꼬일 수 있다**는 점이 실무 리스크다.
* (추후 학습 포인트) `NOT EXISTS`로 바꾸면 더 안전한 경우가 많다.

---

## [문제 5] 고객별 결제 합/평균 요약 리포트 만들기

```sql
SELECT
    cu.first_name,
    cu.last_name,
    d.합,
    d.평균
FROM customer cu
JOIN (
    SELECT
        p.customer_id,
        SUM(p.amount) AS 합,
        AVG(p.amount) AS 평균
    FROM payment p
    GROUP BY p.customer_id
) AS d
ON cu.customer_id = d.customer_id;
```
데이터 분석 관점 포인트:

* **집계(고객 단위) → 의미 단위 고정 → JOIN**의 정석 패턴.
* 분석에서 가장 중요한 건 “고객 단위 리포트인데 행이 불어나지 않게” 만드는 것.
---
## 📌 조건 분기와 전처리

데이터 분석에서 조건 분기는  
**값을 해석 가능한 범주로 바꾸는 전처리 단계**에서 매우 자주 사용된다.  
특히 KPI 구간화, 등급 분류, 세그먼트 정의에서 핵심 역할을 한다.

---

### [1] IF 함수

- 단일 조건 분기 함수
- 조건에 따라 **두 가지 경우 중 하나를 반드시 반환**
- 구조  
  ```sql
  IF(조건, 참일 때 값, 거짓일 때 값)
```
```sql
USE world;

SELECT 
    co.`Name` AS 국가명,
    co.`LifeExpectancy` AS 기대수명,
    IF(co.`LifeExpectancy` >= 80, '고령사회', '해당 없음') AS 분류
FROM country AS co
WHERE co.`Continent` = 'Asia';
```

**특징**

* 단순한 이분 분류에 적합
* 다중 조건 처리 불가

📌 데이터 분석 관점 포인트:

* IF는 **“기준 이상 / 미만”** 같은 단순 기준을 빠르게 만들 때 유용
* 조건이 늘어나기 시작하면 유지보수가 급격히 나빠진다

---

### [2] CASE 표현식

* 다중 조건 분기 가능
* Python의 `if / elif / else`와 동일한 사고 방식
* 실무에서 **IF보다 훨씬 자주 사용**

**기본 구조**

```sql
CASE
    WHEN 조건1 THEN 결과1
    WHEN 조건2 THEN 결과2
    ELSE 기본값
END
```

```sql
SELECT 
    co.`Name` AS 국가명,
    co.`Continent` AS 대륙명,
    CASE 
        WHEN co.`Continent` = 'Asia' THEN '아시아권'
        WHEN co.`Continent` = 'Europe' THEN '유럽권'
        ELSE '기타'
    END AS 권역
FROM country AS co;
```

---

### [3] ELSE가 없는 CASE의 동작

```sql
SELECT 
    co.`Name` AS 국가명,
    co.`Continent` AS 대륙명,
    CASE 
        WHEN co.`Continent` = 'Asia' THEN '아시아권'
        WHEN co.`Continent` = 'Europe' THEN '유럽권'
        -- ELSE가 없으면 나머지는 NULL
    END AS 권역
FROM country AS co;
```

**동작 원리**

* 어떤 WHEN 조건에도 걸리지 않으면 → `NULL` 반환

📌 데이터 분석 관점 포인트:

* ELSE가 없는 CASE는
  **“의도적으로 분류되지 않은 값”을 NULL로 남길 때** 사용
* 하지만 리포트·대시보드용 데이터에서는
  **의도치 않은 NULL 확산의 원인**이 되기 쉬움

---

### 📌 조건 분기 실무 핵심 요약

* IF
  → 단순 이분 분류
* CASE
  → 다중 분류, 세그먼트 정의, KPI 구간화
* 분석에서는

  * “값을 계산하는 것”보다
  * **“값을 해석 가능한 범주로 바꾸는 것”**이 더 중요할 때가 많다

📌
조건 분기 문법은 단순하지만,
**분류 기준이 곧 분석의 가설**이 된다.
---
## 🎯 오늘의 핵심 정리

* CTE는 SQL 실력을 보여주는 문법이 아니라
  **분석 사고를 구조로 보여주는 도구**다.
* 데이터 타입과 함수는
  → 결과의 정확도를 보장하는 **기초 설계**
* 실무 SQL은

  * 짧은 코드보다
  * **읽히는 코드가 더 중요**
* 좋은 SQL은
  **결과보다 ‘왜 이렇게 계산했는지’가 먼저 보인다.**
* 단일행 함수는 데이터 가공이 아니라
  **분석 가능한 형태로 표준화하는 도구**다.
* 숫자/날짜/NULL 함수는
  **지표 오류(분모 0, 결측치, 날짜 연산 오해)를 막는 안전장치**다.
* 서브쿼리는 JOIN과 달리
  **기준을 먼저 만들고 적용하는 도구**다.
* 실무 쿼리는
  “짧은 쿼리”보다 **의도가 잘 보이는 구조(기준 → 적용 → 검증)**가 더 중요하다.
---
## 📅 2026-02-04

## 📌 윈도우 함수 (Window Function)

## 🧠 오늘 학습 내용 – 데이터 분석 관점 요약

* 윈도우 함수는 **집계 결과를 “요약”하지 않고 원본 행 옆에 붙이기 위한 도구**
* GROUP BY가 **분석 단위를 바꾸는 연산**이라면,
  WINDOW FUNCTION은 **분석 단위를 유지한 채 비교 정보를 추가하는 연산**
* 실무 리포트에서

  * 순위
  * 누적
  * 증감
  * 상·하위 그룹
    을 만들 때 **거의 항상 마지막 단계에 등장**
* “데이터를 계산한다”기보다
  → **데이터를 비교 가능하게 만든다**는 관점이 핵심

---

## 📌 윈도우 함수란 무엇인가

* **집계값을 원본 데이터 옆에 붙일 수 있기 때문에 중요**
* 원본 행(row)을 유지한 상태에서

  * 누적값
  * 평균
  * 순위
  * 이전/다음 값
    을 함께 볼 수 있다

📌 핵심 공식

> **원본 행 유지 + 계산된 컬럼 추가 = 윈도우 함수**

---

## 📌 GROUP BY vs WINDOW FUNCTION

| 구분    | GROUP BY | WINDOW FUNCTION |
| ----- | -------- | --------------- |
| 행 수   | 줄어든다     | 유지된다            |
| 분석 단위 | 바뀐다      | 유지된다            |
| 용도    | 요약 테이블   | 비교·리포트용 컬럼      |
| 실무 위치 | 중간 집계    | 최종 리포트 단계       |

📌
GROUP BY는 **“한 행을 대표값으로 바꾸는 작업”**
WINDOW FUNCTION은 **“행의 맥락을 유지한 비교 작업”**

---

## 📌 OVER 절과 PARTITION BY

### OVER 절

* 윈도우 함수의 핵심
* **“어디까지를 비교 범위로 볼 것인가”**를 정의

### PARTITION BY

* 결과를 그룹으로 나누되
* **각 행은 유지**
* 전체 결과 집합의 행 수는 줄지 않음

📌

> PARTITION BY는
> **GROUP BY처럼 보이지만, 절대 GROUP BY가 아니다**

---

## 📌 윈도우 프레임(Window Frame)

윈도우 함수는
**“어디부터 어디까지 계산할 것인가”**를 프레임으로 정의한다.

프레임은 **패턴으로 기억하면 충분**하다.

---

### 대표적인 프레임 패턴

#### 누적 합계

```
UNBOUNDED PRECEDING ~ CURRENT ROW
```

* 파티션의 첫 행부터
* 현재 행까지 누적

#### 이동 평균

```
n PRECEDING ~ n FOLLOWING
```

* 현재 행 기준
* 앞뒤 n개 행을 포함한 평균

---

### 프레임 키워드 정리

* **UNBOUNDED PRECEDING**
  → 파티션의 첫 번째 행 (맨 처음부터)
* **n PRECEDING**
  → 현재 행 기준 앞쪽 n개
* **CURRENT ROW**
  → 현재 처리 중인 행
* **n FOLLOWING**
  → 현재 행 기준 뒤쪽 n개
* **UNBOUNDED FOLLOWING**
  → 파티션의 마지막 행 (맨 끝까지)

📌
프레임을 이해하지 못하면
→ “왜 누적이 이상하지?” 같은 사고가 난다

---

## 📌 윈도우 함수 분류 (질문 유형 기준)

> ⚠️ 이 분류는 **문법 분류가 아니라 실무 질문 분류**

---

### ① 집계(Window Aggregate)

**질문 유형**

* “누적을 보고 싶다”
* “추세를 보고 싶다”
* “평균 대비 현재는 어떤가?”

**대표 함수**

* SUM() OVER
* AVG() OVER
* COUNT() OVER

📌 결과물

* 누적 매출
* 누적 사용자
* 이동 평균 KPI

---

### ② 순위(Rank / NTILE)

**질문 유형**

* “누가 상위인가?”
* “상·하위 그룹을 나누고 싶다”
* “상위 20%는 누구인가?”

**대표 함수**

* ROW_NUMBER
* RANK
* DENSE_RANK
* NTILE

📌 결과물

* Top N 리스트
* 분위수(상위 25%, 하위 25%)
* 등급 분류

---

### ③ 값 비교(FIRST / LAST / LAG / LEAD)

**질문 유형**

* “이전 값 대비 얼마나 변했는가?”
* “기준 값과 비교하면 어떤가?”

**대표 함수**

* LAG
* LEAD
* FIRST_VALUE
* LAST_VALUE

📌 결과물

* 전월 대비 증감
* 직전 구매 대비 변화
* 기준 시점 비교 분석

---

## 📌 실무에서의 윈도우 함수 사용 위치

* 대부분 **SQL의 마지막 단계**
* 이미

  * JOIN 완료
  * 필터링 완료
  * 집계 완료
    된 데이터 위에서 사용

📌

> 윈도우 함수는
> **데이터를 만들기보다, 리포트 형태로 “정리”하는 단계**

---

## 📌 데이터 분석 관점 포인트

**데이터 분석 관점 포인트:**
윈도우 함수는 데이터를 요약하는 도구가 아니라
**“비교 가능한 상태로 만드는 도구”다.

**데이터 분석 관점 포인트:**
GROUP BY 이후 바로 지표를 뽑으려 하면
**순위·증감·누적 같은 질문에 답할 수 없다.**

**데이터 분석 관점 포인트:**
리포트용 SQL의 완성도는
**윈도우 함수를 얼마나 정확히 쓰느냐**에서 갈린다.

---

## 🧩 오늘의 핵심 정리 (분석가 관점)

* 윈도우 함수는 **분석 단위를 깨지 않는다**
* OVER + PARTITION BY는
  → “비교 범위를 정의하는 언어”
* 프레임은
  → “시간·순서 개념을 SQL에 부여하는 장치”
* 윈도우 함수는
  **대시보드·리포트·KPI 산출의 마지막 퍼즐**이다

* 윈도우 함수는 데이터를 줄이기(GROUP BY) 위한 문법이 아니라  
  **행 단위 비교를 가능하게 만드는 분석 도구**다.
* 핵심 차이
  - GROUP BY → 행을 줄여서 요약
  - WINDOW FUNCTION → **원본 행을 유지한 채 계산 결과를 옆에 붙임**
* 윈도우 함수는 문법이 아니라 **질문 유형으로 접근해야 한다.
  - 누적·평균·추세 → 집계(Window Aggregate)
  - 상대적 위치·등급 → 순위(RANK / NTILE)
  - 증감·비교 → 값 비교(LAG / LEAD / FIRST / LAST)
* 프레임은 외울 대상이 아니라 **패턴으로 인지**
  - 누적 → `UNBOUNDED PRECEDING ~ CURRENT ROW`
  - 이동 평균 → `n PRECEDING ~ n FOLLOWING`
* 실무에서 윈도우 함수는 대부분
  **SQL의 마지막 단계**에서 사용된다.
  - 리포트용 데이터
  - 대시보드용 지표
  - 비교·순위·증감이 필요한 KPI

📌 최종 정리  
> 데이터 분석에서 SQL의 목표는  
> “정답을 뽑는 것”이 아니라  
> **비교 가능한 구조를 만드는 것**이며,  
> 그 역할을 가장 잘 수행하는 문법이 윈도우 함수다.

---
