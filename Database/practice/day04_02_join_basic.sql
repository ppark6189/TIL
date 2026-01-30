-- ==== JOIN으로 여러 테이블 연결하기 ====

-- [1] INNER JOIN
-- 공통된 값에 해당하는 데이터만 반환

-- 예시 : world 데이터베이스 중
-- city + country
-- 1:N 관계
select 
    city.`Name` 도시명,
    country.`Name` 국가명,
    country.`Continent` 대륙명
from
    city
    INNER JOIN
    country
    ON
    city.`CountryCode` =country.`Code`; -->inner join해서 커다란 table 하나 더 만들었다고 보면 된다.

-- [2] OUTER JOIN, LEFT JOIN

-- 예시 2 : world 데이터베이스
SELECT
    co.`Name` 나라명,
    ct.`Name` 수도명
FROM
    country co
    left JOIN
    city ct
    on co.`Capital` = ct.`ID`
    where ct.NAME is null;
--결측이 발생할 수 있음
--lEFT를 기준으로 LEFT 상에 존재하면 병함 -> RIGHT에 있다고(존재한다고) 보장할 수 없다.
--따라서 결측이 발생할 수 있다.

-- sakila 비디오 대여점 에시
use sakila;
show tables;
desc rental;
desc customer;

-- 질문 : 모든 고객의 대여내역 (대여일자, 반납일자) 정보를 보고 싶다.
-- 대상 테이블
    -- 고객 (customer)
    -- 대여내역 (rental)
-- 우리는 자세히 무엇을 원하는가?
    -- 1) 모든 고객? --> LEFT JOIN
    -- 2) 대여를 한번이라도 해본 고객을 보길 원하는가? -> INNER JOIN
desc rental;
desc customer;
SELECT
    c.first_name 성,
    c.last_name 이름,
    r.rental_date 대여일시,
    r.return_date 반납일시
from
    customer c
    left JOIN
    rental r
    on c.customer_id = r.customer_id;

-- 모든 고객 중, 아직 반납 안한 사람의 대여내역(대여일자, 반납일자)
desc rental;
desc customer;
SELECT
    c.first_name 성,
    c.last_name 이름,
    r.rental_date 대여일시,
    r.return_date 반납일시
from
    customer c
    left JOIN
    rental r
    on c.customer_id = r.customer_id
where r.return_date is null;

