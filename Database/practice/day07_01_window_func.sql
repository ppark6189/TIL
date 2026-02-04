-- ==== 윈도우 함수 ====
-- 각 행의 개별 정보 유지 + 집계된 값을 붙이기
-- 행을 유지한채로 파티션별 추가 집계된 정보를 붙여서 비교 가능
SELECT
    co.`Name`,
    co.`GNP`,
    co.`Continent`,
    avg(co.`GNP`) OVER(PARTITION BY co.`Continent`) 대륙평균
FROM country co;

-- GROUP BY로 계산한 결과에 대해 JOIN 하는 형태로 추가했던 이전 방식보다
-- 훨씬 더 쉽고 간단하게 원본 행에 집계 값을 추가하여 표시할 수 있다.

-- 이전이었다면
with avg_gnp as (
    SELECT `Continent`, avg(`GNP`) 평균GNP
    from country
    GROUP BY `Continent`
)
SELECT
    co.`Name`,
    co.`Continent`,
    ag.평균GNP
FROM country co
    join avg_gnp ag
    on co.`Continent` = ag.`Continent`;

-- [1]대표적 프레임
-- 예시 : 누적합산
-- 아시아 국가들을 인구수를 기준으로 내림차순하고, 이들을 누적합
SELECT
    co.`Name` 국가명,
    co.`Population` 인구수,
    sum(co.`Population`) OVER(ORDER BY co.`Population` desc 
                            ROWS BETWEEN UNBOUNDED PRECEDING and current row
                            ) 인구수누적합
from country co
WHERE co.`Continent` = 'Asia'

-- 예시 : 이동평균
SELECT
    co.`Name`,
    co.`GNP`,
    avg(co.`GNP`) over(
                    ORDER BY co.`GNP`
                    ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
    ) 3개국_이동평균
FROM country co
where co.`Continent` = 'Europe';
-- 시계열성 데이터에서 추세가 튀는 현상을 방지하기 위해 이동평균을 자주 본다.
-- 시계열 데이터에서 스무딩 시키고자 할 때