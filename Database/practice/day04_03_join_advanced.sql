-- 세 개 이상의 테이블 JOIN하기
use world;
SELECT DATABASE(); 

-- world 데이터 베이스 예시

SELECT 
    co.`Name` 국가명,
    ct.`Name` 수도명,
    cl.`Language` 언어
from 
    country co
    inner join
    city ct
    on co.`Capital` = ct.`ID`
    inner JOIN
    countrylanguage cl
    on cl.`CountryCode` = co.`Code`;
-- language의 수만큼 국가 record 수가 늘어난다

SELECT 
    co.`Name` 국가명,
    ct.`Name` 수도명,
    cl.`Language` 언어
from 
    country co
    inner join
    city ct
    on co.`Capital` = ct.`ID`
    inner JOIN
    countrylanguage cl
    on cl.`CountryCode` = co.`Code`
where cl.Isofficial ='T';
-- 국가별 공식언어로 국가별 1개의 record만 출력

-- 배우가 출연한 영화
-- 대상테이블
    -- 1) 영화(film)
    -- 중계테이블) film_actor
    -- 2) 배우(actor)
use sakila;
SELECT 
    a.first_name 이름,
    a.last_name 성,
    f.title 영화이름
FROM
    film as f
    inner JOIN 
    film_actor fa
    on f.film_id = fa.film_id
    INNER JOIN
    actor a
    on a.actor_id = fa.actor_id
ORDER BY 이름, 성;

-- 예시 : 같은 컬럼명일때의 USING 사용
use sakila;
SELECT
    a.first_name,
    a.last_name,
    f.title
FROM
    actor a
    inner JOIN
    film_actor fa
    USING(actor_id)
    inner join
    film as f
    USING(film_id);
-- 공백, 들여쓰기, 개행의 형태는 편한대로 하지만 가독성 확보는 필수!
