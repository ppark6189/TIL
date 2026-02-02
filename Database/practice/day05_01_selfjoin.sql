-- 또다른 JOIN의 형태

-- SELF JOIN
-- 새로운 조인의 종류가 아닌 "나 자신과의 연결"
-- 같은 테이블 내, 행과 행 비교 -> 구분을 위한 Alias 지정

use world;

-- 예시 : "대한민국과 같은 대륙"에 속한 "다른 국가들"을 찾고 싶다.
-- 대상 테이블
    -- country
SELECT 
    c2.`Name` as 국가명,
    c1.`Continent` 대륙명
FROM country as c1
    JOIN
    country as c2
    on c1.`Continent` = c2.`Continent`
where 
    c1.NAME = 'Germany'        --대륙명
    AND
    c2.NAME <> 'Germany'; -- 제외 항목