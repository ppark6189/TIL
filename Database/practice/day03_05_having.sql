-- ==== HAVING으로 추가 필터링하기 ====
use world;
-- 예시 1 : 대륙 별 국가 수가 20개가 넘는 대륙, 국가 수 조회
SELECT co.`Continent`,count(*)
from country as co
GROUP BY co.`Continent`
HAVING count(*)>20;

-- 예시 2 : Region 별 평균 인구가 10000000이 넘는 지역, 평균 인구 조회
SELECT co.`Region` as 지역, avg(co.`Population`) 평균인구
from country as co
GROUP BY co.`Region`
having 평균인구 >100000000;

-- 예시 3 : 대륙 별 인구가 1000만 이상인 국가의 수가 10개가 넘는 대륙, 국가 수 조회
select co.`Continent` 대륙명,count(*) as big_countries
from country as co
where co.`Population` >=10000000
GROUP BY co.`Continent`
HavinG big_countries >=10;

-- 예시 4 : 평균 인구수가 10000000 이 넘는 대륙 의 국가 수 
-- 평균 인구수 10000000 -> 대륙을 수식
SELECT co.`Continent` 대륙명, count(*) 인구수
from country as co
GROUP BY co.`Continent`
HAVING avg(co.`Population`)>10000000;