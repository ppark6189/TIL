SELECT co1.`Continent`, co1.`Name`, co1.`Population`
from country as co1
join (
    SELECT co2.`Continent`, max(co2.`Population`) max_pop
    from country as co2
    GROUP BY co2.`Continent`
) as cmp
on cmp.`Continent` = co1.`Continent`
AND cmp.max_pop = co1.`Population`

-- CTE로 풀기
-- 해당 문제를 분해하자!
-- 1단계 : 대륙별 최대 인구 계산
with cmp as (
    SELECT `Continent`, max(`Population`) as max_pop
    FROM country
    GROUP BY `Continent`
)
select c.`Continent`, c.`Name`, c.`Population`
FROM 
    country c
    JOIN cmp
    on c.`Continent` = cmp.`Continent`
WHERE c.`Population` = cmp.max_pop
    and c.`Population` <> 0
