-- ===== Group by로 집계하기 ====

use world;
show tables;
desc country;

-- 예시: 대륙별로 몇개의 나라가 있는지 확인하기
-- GROUP BY의 기본 형태
SELECT co.`Continent` as 대륙별 , count(*)
from country as co
GROUP BY co.`Continent`

-- GROUP 별로 나누는 이유는?
-- 그룹별 대표하는 값이 어떻게 되는지 비교하고 싶어서
-- 너무나도 많은 행들이 있으니, 이걸 요약하자!
-- => 요약 가능한 집계 함수들과 함께 쓰인다.

desc country;
SELECT co.`Continent` as 대륙별, co.`Region` as 그룹별, count(*) as 나라수
from country as co
GROUP BY co.`Continent`
-- 불가능!

-- GROUP BY 사용시 유의할 점
-- SELECT 에는
-- 1) GROUP BY 절에서 사용한 기준 컬럼이 오거나
-- 2) 집계함수만 올 수 있다.

-- 얘시 1 : Region 별 평균 인구
SELECT co.`Region` as 지역, avg(co.`Population`) as 평균인구
from country as co
GROUP BY co.`Region`;

-- 예시 2 : 대륙 별 최소/ 최대 인구
SELECT co.`Continent` as 대륙별, min(co.`Population`) as 최소인구, max(co.`Population`) as 최대인구
from country as co
GROUP BY co.`Continent`;

-- 예시 3 : 대륙 별 "인구가 1000만 이상"인 국가의 수
-- 인구가 1000만 이상인 경우"만" 셀 수 있도록 -> group by 전에 where 필터링 추가
SELECT co.`Continent`, count(*)
from country as co
where co.`Population` >= 10000000
GROUP BY co.`Continent`;

-- 집계 함수는 기본적으로 NULL을 무시하고 계산
-- count(*),count('칼럼') -> count(*)로 해야 NULL값 포함한 총 계수 집계 가능