-- ==== 단일행 함수 ====
-- 행별로 값 하나 -> 값 하나
-- [1] 문자열 함수
-- (1) concat : 여러 문자열을 이어낸다.

-- Seoul (KOR)의 형태로 변환하고 싶을 떄
SELECT concat(upper(ct.`Name`),"(", ct.`CountryCode`,")") 
FROM city ct
where ct.`CountryCode` in (
    SELECT co.`Code`
    from country co
    where lower(co.`Continent`) = 'asia'
);

-- (2) SUBSTRING : 위치기반 특정 부분 잘라내기
SELECT co.`Name`, substring(co.`Name`,1,3)
FROM country co
limit 5;

-- (3) LENGTH : 길이 변환
SELECT country.`Name`, LENGTH(country.`Name`)
from country;

-- (4) REPLACE : 문자열 치환
SELECT co.`Name`, REPLACE(co.`Name`,'South','S.')
from country co
where co.name like "%South%"

-- [2] 숫자형 함수
-- 산술연산 가능
-- +,-,*/,/
SELECT co.`Name`, co.`Population`/co.`SurfaceArea` 인구밀도
from country co
where co.`Population` > 0;

-- (1) 반올릶 올림, 내림, 버림

SELECT co.`Name`, round(co.`Population`/co.`SurfaceArea`,2) 인구밀도,
    ceil(co.`Population`/co.`SurfaceArea`),
    floor(co.`Population`/co.`SurfaceArea`),
    TRUNCATE(co.`Population`/co.`SurfaceArea`,2)
FROM country co
where co.`SurfaceArea` > 0;

-- [3] 날짜형 함수
-- (1) 현재 시간
SELECT now(), CURDATE(), CURTIME();
-- (2) 날짜 일부 추출
SELECT weekday(now()); -- 요일
SELECT year(now());
SELECT YEARWEEK(now());

-- (3) 날짜 형식
SELECT DATE_FORMAT(now(),'%M,%D');
-- 형식은 필요에 따라 찾아서 보면 된다.

-- (4) 날짜 연산
SELECT now() +10;  -- 의도 : 10일 뒤 출력 : 초 단위 10초 뒤
SELECT DATE_ADD(now(), INTERVAL 10 day);
SELECT date_sub(now(), INTERVAL 3 HOUR);

-- 예시 : 반납일과 대여일 사이 간격 확인하기
use sakila;
DESCRIBE rental;
SELECT avg(DATEDIFF(r.return_date, r.rental_date))
from rental r;

-- 종강일까지의 날짜
SELECT DATEDIFF('2026-03-27',CURDATE());

-- [4] NULL 관련 함수
-- 결측치 -> 비어 있는 값 (SQLD 시험의 경우 ORACLE SQL이기 때문에 다르다)
use world;
SELECT DATABASE();
DESCRIBE country; -- 결측이 될 수 있는 필드 확인
select count(*)
from country co
where `GNP` is null; -- 없을 수도 있음
select count(*)
from country co
where `HeadOfState` is null;

-- (1) COALESCE
-- 결측이 아닌 첫번째 값을 반환
SELECT 
    co.`Name`, co.`GNPOld`, co.`GNP`,
    COALESCE(co.`GNPOld`, co.`GNP`, 0) as 최종GNP
from country co;

-- (2) IFNULL
-- 단일 값 결측 대체
SELECT
    co.`Name`, co.`HeadOfState`,
    IFNULL(co.`HeadOfState`,'정보없음')
FROM country co
where co.`Continent` = 'Europe'

-- [3] NULLIF
-- 발측치 발생을 위한 함수
-- 만약 같으면, NULL 반환, 다르면 A 반환
-- 일부러 NULL을 발생 -> 처리,제외되고 싶어서
SELECT cl.`Language`, cl.`Percentage`, NULLIF(cl.`Percentage`,0.0)
from countrylanguage cl
WHERE cl.`Language` = 'English'
