use world;
show tables

-- 인구가 800만 이상인 도시의 Name, Population을 조회하시오.
SELECT c.`Name`, c.`Population`
from city as c
where c.`Population` >= 8000000;

-- 한국(KOR)에 있는 도시의 Name, CountryCode를 조회하시오.
desc city;
SELECT c.`Name`,c.`CountryCode`
from city as c
where c.`CountryCode` = 'KOR';

--이름이 'San'으로 시작하는 도시의 Name을 조회하시오
select c.`Name`
from city as c
where c.`Name` like 'San%';

--인구가 100만에서 200만 사이인 한국 도시의 Name을 조회하시오
--문제의도 : 문제에 숨겨져 있는 조건을 살펴보아라.
--조건 1 : 범위
--조건 2 : 일치
--(조건1) AND (조건2)로 논리 연산하라
SELECT c.`Name`
from city as c
where c.`CountryCode` = 'KOR'
    and c.`Population` BETWEEN 1000000 and 2000000;

--인구가 500만 이상인 한국, 일본, 중국의 도시의 Name, CountryCode, Population 을 조회하시오
SELECT c.`Name`, c.`CountryCode`, c.`Population`
from city as c
where c.`CountryCode` in ('KOR','JPN','CHN')
    and c.`Population` >= 5000000;

--오세아니아 대륙에서 예상 수명의 데이터가 없는 나라의 Name, LifeExpectancy, Continent를 조회하시오.
desc country;
SELECT DISTINCT co.`Continent`
from country as co;
select co.`Name`, co.`LifeExpectancy`, co.`Continent`
from country as co
where co.`Continent` = 'Oceania'
    and co.`LifeExpectancy` is null;

-- Table 소개
-- city: 전 세계 도시 정보
-- country: 국가 정보
-- countrylanguage: 각 국가에서 사용되는 언어 정보
 
 use world;
 show TABLES;
 desc country;

 -- 대륙별 총 인구수를 구하시오.
SELECT co.`Continent` as 대륙명, sum(co.`Population`) as 총인구수
from country as co
GROUP BY co.`Continent`

-- Region별로 GNP가 가장 높은 지역을 찾으시오.
SELECT co.`Region` as 지역명, max(co.`GNP`) as 최대GNP
from country as co
GROUP BY co.`Region`

-- 대륙별 평균 GNP와 평균 인구를 구하시오.
SELECT co.`Continent` as 대륙명, 
    avg(co.`GNP`) as 평균GNP,
    avg(co.`Population`) as 평균인구
from country as co
GROUP BY co.`Continent`;

-- 인구가 50만에서 100만 사이인 도시들에 대해, District별 도시 수를 구하시오
SELECT ct.`District` as 구역명, count(*) as 도시수
from city as ct
where ct.`Population` BETWEEN 500000 and 1000000
GROUP BY ct.`District`;

-- 아시아 대륙 국가들의 Region별 총 GNP를 구하세요
SELECT co.`Region` 지역명, sum(co.`GNP`) 총GNP
FROM country as co
where co.`Continent` = 'Asia'
GROUP BY co.`Region`;

use world;
show tables;
desc city;

-- 각 국가별 도시가 10개 이상인 국가의 CountryCode, 도시 수를 조회하시오.
select ct.`CountryCode` 국가코드, count(*) 도시수
from city ct
GROUP BY ct.`CountryCode`
HAVING count(*)>=10;

-- District별 평균 인구가 100만 이상이면서 도시 수가 3개 이상인 District,  도시 수, 총 인구를 구하시오
SELECT c.`District` 지역, count(*) 도시수, sum(c.`Population`) 총인구
from city  c
GROUP BY c.`District`
HAVING avg(c.`Population`)>=1000000
    and 도시수 >= 3;

-- 아시아 대륙의 국가들 중에서, Region별 평균 GNP가 1000 이상인 Region,  평균 GNP를 조회하시오
SELECT co.`Region` 지역, avg(co.`GNP`) 평균GNP
from country as co
where co.`Continent` = 'Asia'
GROUP BY co.`Region`
HAVING 평균GNP>1000;

-- 독립년도가 1900년 이후인 국가들 중에서, 대륙별 평균 기대수명이 70세 이상인 Continent, 평균 기대수명을 조회하시오.
SELECT co.`Continent` 대륙,
    avg(co.`LifeExpectancy`) 평균기대수명
from country as co
where co.`IndepYear` >1900
GROUP BY co.`Continent`
having 평균기대수명 >=70;

-- CountryCode별 도시 평균 인구가 100만 이상이고 도시 최소 인구가 50만 이상인 CountryCode, 총 도시수, 총 인구수를 조회하시오.
SELECT c.`CountryCode` 국가코드,
    count(*) 총도시수, 
    sum(c.`Population`) 총인구수
from city c
GROUP BY c.`CountryCode`
HAVING avg(c.`Population`)>=1000000
    and min(c.`Population`)>=500000;

desc country;