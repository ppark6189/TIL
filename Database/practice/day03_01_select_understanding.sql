-- ====select 구문의 이해 ====
use world;
show TABLEs;

-- [1] SELECT 구문의 순서
-- 작성 순서
-- select -> from -> where -> group by -> having -> order by

-- 예시1 : 올바른 순서
SELECT Name, Population
FROM city
-- 예시2 : 잘못된 순서
-- 작동이 되지 않음
--from city
--SELECT Name, Population

-- [2] select 구문의 필수요소
-- 조회의 목적 : "하나 이상의 테이블"에서 "원하는 데이터"를 선택하여 검색

-- 필수 요소 :
-- 1. select 원하는 필드
-- 2. From 테이블 출처

-- 테이블명 생략 없이 특정 필드 조회
SELECT city.`Name`,city.`Population`
from city

-- [3] 자주 쓰는 기능
-- (1) 축약 (Alias)
-- 키워드 AS를 통해 테이블명 혹은 컬렴명을 축약합니다.

-- 테이블명 축약
-- 테이블에 딸려있는 컬럼을 나타낼때 테이블 이름 전체를 쓰지 않음으로서
-- 가독성과 타이핑 상 장점 존재

SELECT c.`Name`, c.`Continent`, c.`LifeExpectancy`
from country as c;

-- 컬럼명 축약
-- 선택한 컬럼의 이름을 바꾸어서 조회할 수 있는 장점 존재
SELECT c.`Name` as 국가, c.`Continent` as 대륙명, c.`LifeExpectancy` as 기대수명
from country as c;

-- 축약의 경우는 생략이 가능
SELECT c.`Name` 국가, c.`Continent` 대륙명, c.`Population` 인구수
FROM country c

-- (2) 중복제거 Distinct
SELECT DISTINCT c.continent
from country as c
