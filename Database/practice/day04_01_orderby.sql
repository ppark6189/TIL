-- ==== ORDER BY로 정렬하기 ====
use world;
SELECT DATABASE();

-- 예시 1 : 인구가 많은 순서대로 정렬
SELECT *
from city as ct
ORDER BY ct.`Population` DESC;

SELECT ct.`Name` as 이름, ct.`District` 지역, ct.`Population` 인구수
from city as ct
ORDER BY ct.`Population` DESC;

-- 에시 2 : 여러번 정렬
SELECT ct.`CountryCode`,ct.`Population` 총인구수
from city ct
where ct.`CountryCode` IN ('KOR','JPN','CHN')
ORDER BY ct.`CountryCode`,총인구수 DESC;

-- 예시 3 : NULL 값의 정렬
SELECT *
FROM country as co
ORDER BY co.`IndepYear`; --null 값은 가장 작은 값으로 인식

SELECT*
from country as co
where co.`IndepYear` is not null
    AND
    co.`IndepYear` >0
ORDER BY co.`IndepYear`;

-- LIMIT와 OFFSET
SELECT *
from city ct
ORDER BY ct.`Population` DESC
LIMIT 5 
OFFSET 5; -- 6위부터, LIMMIT 5 -> 5개 값을 보여줌 