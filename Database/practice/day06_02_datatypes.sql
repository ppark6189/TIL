use sakila;
-- 데이터 형변환
-- [1] 암시적 형변환
SELECT "1" + 403;
SELECT cat.category_id + cat.name
from category as cat
limit 4;

-- [2] 명시적 형변환
-- cast 함수 사용
-- cast (컬럼 as 자료형)
SELECT concat(cast(cat.category_id as char),'_',cat.name)
from category as cat;

SELECT year(cat.last_update)
FROM category as cat;

SELECT cast('2026' as year) - year(cat.last_update)
FROM category as cat;