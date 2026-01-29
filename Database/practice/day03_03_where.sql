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

-- [2] 논리 연산자
-- 논리 값들 사이 연산
-- AND : ㅇㅇ이면서 ㅇㅇ를 만족하는 경우에만 필터링
-- OR : ㅇㅇ이거나 ㅇㅇ 둘중 하나라도 만족된다면 필터링
-- NOT : 반대
DESC country;

SELECT *
from country as c
where c.`Population` >1000000 
    and c. `Continent` = 'Asia' 
    and c. `IndepYear` > 1900;

SELECT *
from country as c
where c. `IndepYear` > 1900 
    and c. `Continent` = 'Asia' 
    and c.`Population` >1000000;
-- 위에서 아래로 진행
-- 조건1 AND 조건2 -> (조건1 AND 조건2)을 만족하는 조건결과 AND 조건3  

-- [3] 범위 연산
-- 연속된 범위를 지정할때 의미가 있는 연산(숫자)
-- BETWEEN A AND B : A와 B 사이에 있는 값만을 필터링
-- NOT BETWEEN A AND B : A와 B 사이에 있지 않은 값만을 필터링

SELECT *
from country as c
where not c.`LifeExpectancy` BETWEEN 75 and 80;

-- [4] 포함 연산
-- IN : 목록 아네에 있는 모든 케이스에 대해서만 필터링
SELECT *
from country as c
where c.`Code` in ('KOR','JPN','CHN');

-- [5] NULL 여부
-- IS NULL : 결측이면 True, 결측이 아니면 False -> 결측인 경우만 본다.
-- IS NOT NULL 결측이면 False, 결측이 아니면 True -> 결측이 아닌 경우만 본다.
desc country;

SELECT *
FROM country as c
where c.`LifeExpectancy` is NULL
    and c. `IndepYear` is not null;

-- [6] 패턴 매칭
-- LIKE : 특정 패턴처럼 보이는 행만 필터링
-- LIKE 뒤에는 "패턴"이 온다
-- % : 0개 이상의 글자
-- _ : 1개의 글자

SELECT *
from country as c
where c.`Name` like "S%"; --S로 시작

SELECT *
from country as c
where c.`Name` like "%S"; --S로 끝

SELECT *
from country as c
where c.`Name` like "S_";

-----------------------------------------

-- WHERE의 목적 : 각각의 조건 연산을 이어서 원하는 형태의 행만 선택할 수 있다.
SELECT *
from country as co
where co.`Continent` = 'Asia' 
    and co.`IndepYear` > 1930 
    and co.`LifeExpectancy` is not null 
    and not co.`Code` IN ('KOR','JPN','CHN')
    and co.`Name` LIKE '%n%'