-- === SELECT 구문의 논리적 실행 ===

USE world;
show table

-- 작성 순서 : SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY
-- 실행 순서 : FROM -> WHERE -> GROPU BY -> HAVIGN -> SELECT -> ORDER BY

-- 논리적 실행 순서에 따른 예시
SELECT c.`Continent` as 대륙, c.`Name` as 국가, c.`Population` as 인구
FROM country as c
;

DESCRIBE country;

-- 예시 1: 작성 순서와 실행 순서간 차이로 인한 오류
-- Error 셀렉트에의 별칭 설정이 where 뒤에서 설정이기 때문에 오류
SELECT c.`Continent` as 대륙, c.`Name` as 국가, c.`Population` as 인구
FROM country as c
where 대륙 = 'asia';

-- 예시 2: 올바른 실행 순서
SELECT c.`Continent` as 대륙, c.`Name` as 국가, c.`Population` as 인구
FROM country as c
where c.`Continent`= 'Asia';

-- 예시 3: 올바른 실행 순시
SELECT c.`Continent` as 대륙, c.`Name` as 국가, c.`Population` as 인구
FROM country as c
where c.`Continent`= 'Asia'
ORDER BY 인구;

-- ORDER BY 실행 순서가 SELECT 보다 뒤에 있기 때문에 
-- SELECT 에서 지정한 별칭을 쓸 수 있다.