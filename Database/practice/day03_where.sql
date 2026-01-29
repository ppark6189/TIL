-- ====WHERE 조건으로 필터링 하기 ====
use world;
show tables;
desc country;

-- [1] 비교 연산자
-- (1) 대소비교
-- > 혹은 >= : 크거나 같다
-- < 혹은 <= : 작거나 같다

SELECT *
from country as c
where c.`Population` >= 1000000;

-- (2) 일치 비교
-- = : 같다
-- <> : 같지 않다
SELECT *
from country as c
where c.`Population` <> 1000000;
