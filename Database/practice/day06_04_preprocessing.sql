-- === 조건분기와 전처리 ===
-- [1] IF 함수
USE world;

-- IF(주어진 조건, 참일 때 값, 거짓일 때의 값)
-- 두케이스 중 하나를 무조건 반환
SELECT 
    co.`Name` AS 국가명,
    co.`LifeExpectancy` AS 기대수명,
    IF(co.`LifeExpectancy` >= 80, "고령사회", "해당 없음") AS 분류
FROM country AS co
WHERE co.`Continent` = 'Asia';

-- 다중 조건 불가능

-- [2] CASE 표현식
-- 다중 조건문
-- 파이썬에서 사용되는 if, elif, else와 같은 문법

-- CASE 
--     WHEN 조건1 THEN  결과1
--     WHEN 조건2 THEN  결과2
--     ELSE  기본값
-- END

SELECT 
    co.`Name` AS 국가명,
    co.`Continent` AS 대륙명,
    CASE 
        WHEN co.`Continent` = 'Asia' THEN  '아시아권'
        WHEN co.`Continent` = 'Europe' THEN '유럽권'
        ELSE  '기타' -- 그외의 케이스의 기본값
    END AS 권역
FROM country AS co;

-- 질문! 만약 ELSE 구문이 없다면?
SELECT 
    co.`Name` AS 국가명,
    co.`Continent` AS 대륙명,
    CASE 
        WHEN co.`Continent` = 'Asia' THEN '아시아권'
        WHEN co.`Continent` = 'Europe' THEN '유럽권'
        -- ELSE 구문이 없다면? 그외의 케이스 NULL  
    END AS 권역
FROM country AS co;