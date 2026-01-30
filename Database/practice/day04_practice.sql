use world;
show tables;
SELECT DATABASE();

-- country 테이블에서 대륙별로 정렬하고, 같은 대륙 내에서는 GNP가 높은 순으로 정렬하여 Name, Continent, GNP을 조회하세요.
SELECT co.`Name` 국가명, co.`Continent` 대륙명, co.`GNP`
from country co
ORDER BY co.`Continent`, co.`GNP` DESC;

-- 대륙 별 국가 수가 많은 순서대로 Continent, 국가 수를 조회하세요.
SELECT co.`Continent` 대륙명,  count(*) 국가수
from country co
GROUP BY co.`Continent`
ORDER BY 국가수 desc;

-- 독립년도가 있는 국가들의 대륙 별 평균 기대수명이 높은 순서대로 Continent, 평균 기대수명을 조회하세요.
SELECT co.`Continent` 대륙명, avg(co.`LifeExpectancy`) 평균기대수명
from country co
where co.`IndepYear` is not null
GROUP BY co.`Continent`
ORDER BY 평균기대수명 DESC;

-- 인구가 많은 도시 중 11위부터 20위까지 조회하세요.
SELECT ct.`Name` 도시명, ct.`Population` 인구수
from city ct
ORDER BY ct.`Population` DESC
LIMIT 10 OFFSET 10;


use sakila;
show tables;
desc sakila.customer;

-- 고객 정보를 화면이나 리포트에 보여줄 때, 기본 정보 + 주소 정보를 항상 함께 조회합니다
-- customer 테이블과 address 테이블을 INNER JOIN하여, 각 고객의 이름(first_name, last_name)과 주소(address)를 함께 조회해 보세요.
-- 두 테이블은 address_id로 연결됩니다.
SELECT
    c.first_name 성,
    c.last_name 이름,
    a.address 주소
FROM
    customer c
    inner join
    address a
    on c.address_id = a.address_id;

-- 영화 제목과 언어 이름 조회하기
-- 코드(language_id)만으로는 의미가 없기 때문에, 운영·분석 화면에서는 항상 사람이 읽을 수 있는 값으로 치환합니다.
-- film 테이블과 language 테이블을 조인하세요.
-- 각 영화의 제목(title)과 해당 영화의 언어 이름(name)을 조회하는 쿼리를 작성합니다.
-- 공통 컬럼은 language_id 입니다.
SELECT
    f.title 영화제목,
    l.name 언어
from
    film f
    join
    language l
    on f.language_id =l.language_id;

-- 모든 고객과 각 고객의 최근 대여일 조회하기
-- 활동 이력이 없는 고객도 포함해서 보고 싶다”는 요구사항이 종종 있습니다. 
-- customer 테이블을 기준으로 rental 테이블을 LEFT JOIN 하세요.
-- 모든 고객의 이름을 조회하되, 각 고객이 마지막으로 대여한 날짜(rental_date)를 함께 표시해야 합니다.
SELECT
    c.first_name 성,
    c.last_name 이름,
    max(r.rental_date) 대여일시
FROM
    customer c
left JOIN
    rental r
on c.customer_id = r.customer_id
GROUP BY c.customer_id

-- 특정 도시에 사는 고객 찾기
-- 마케팅, 지역 분석, 물류 등에서는 주소 테이블을 기준으로 고객을 필터링하곤 합니다.
-- customer 테이블과 address 테이블을 조인한 후, city_id가 312인 도시에 거주하는 고객의 이름과 이메일을 찾아보세요.
SELECT
    c.first_name 성,
    c.last_name 이름,
    c.email 이메일,
    a.city_id
FROM
    customer c
join
    address a
on c.address_id = a.address_id
where a.city_id =312;

-- 직원별로 처리한 총 결제 건수 구하기
-- 개인별 처리량, 성과 지표(KPI)는 대부분 “JOIN + GROUP BY” 형태로 계산합니다.
-- staff 테이블과 payment 테이블을 조인하여, 각 직원의 이름(first_name)과 그 직원이 처리한 총 결제 건수를 조회하세요.
SELECT
    s.first_name 이름,
    count(p.payment_id) 총결제건수
FROM
    staff s
JOIN
    payment p
on s.staff_id = p.staff_id
GROUP BY s.staff_id;

-- 결제액 합계가 높은 우수 고객 찾기
-- VIP 고객, 상위 고객군 분석은 HAVING을 이용한 집계 조건 필터링의 전형적인 예시입니다.
-- customer 테이블과 payment 테이블을 조인하여 고객별로 총 결제액(amount)을 계산하세요. 그중 총 결제액이 $180 이상인 우수 고객의 이름과 총 결제액을 조회하세요.
SELECT
    c.first_name 이름,
    sum(p.amount) 총결제액
from
    customer c
JOIN
    payment p
on c.customer_id = p.customer_id
GROUP BY
    c.customer_id
having 총결제액 >180
ORDER BY 총결제액 DESC;


-- 고객의 기본 정보, 주소, 도시 조회
-- 고객 상세 화면이나 고객 관리 리포트에서는
-- 고객의 이름, 이메일뿐 아니라 주소와 도시 정보까지 함께 보여줘야 합니다.
 
-- 하지만 customer 테이블에는 도시 이름이 없고,
-- 도시 이름은 city 테이블에만 존재합니다.
 
-- customer, address, city 세 개의 테이블을 연결하여
-- 고객의 기본 정보, 주소, 도시 이름을 한 번에 조회해 보세요.
use sakila;
SELECT
    cu.first_name 성,
    a.address 주소,
    ct.city 도시
FROM
    customer cu
    inner JOIN
    address a
    on cu.address_id = a.address_id
    inner JOIN
    city ct
    on a.city_id = ct.city_id;

-- 정 지역 고객 타겟팅: London 거주 고객 조회
-- 마케팅이나 운영 업무에서는
-- 특정 도시에 거주하는 고객만 선별해서 확인해야 하는 경우가 많습니다.
 
-- customer, address, city 테이블을 JOIN하여
-- London에 거주하는 고객들의 기본 정보, 주소, 도시를 조회해 보세요.
SELECT
    cu.first_name 성,
    a.address 주소,
    ct.city 도시
FROM
    customer cu
    inner JOIN
    address a
    on cu.address_id = a.address_id
    inner JOIN
    city ct
    on a.city_id = ct.city_id
where ct.city='London';

-- 도시별 고객 수 조회
-- customer, address, city 테이블을 JOIN하여 각 도시에 몇 명의 고객이 살고 있는지 계산해 보세요.
-- 고객 수가 많은 순서대로 정렬(ORDER BY)하여 결과를 확인해 보세요.
-- 운영 리포트에서는
-- “어느 도시에 고객이 많이 분포되어 있는가”를 자주 확인합니다.
-- customer, address, city 테이블을 JOIN하여
-- 도시별 고객 수를 계산하고,
-- 고객 수가 많은 순서대로 정렬해 보세요.
SELECT 
    ct.city 도시명,
    count(*) 고객수
FROM
    customer cu
    inner JOIN
    address a
    on cu.address_id = a.address_id
    inner JOIN
    city ct
    on a.city_id = ct.city_id
GROUP BY ct.city
ORDER BY 고객수 desc;
desc city;

-- 고객 전체 주소 정보 조회 (주소 + 도시 + 국가)
-- 고객의 전체 주소를 화면이나 외부 시스템에 전달할 때는
-- 주소, 도시뿐 아니라 국가 정보까지 함께 필요합니다.
 
-- customer, address, city, country
-- 총 네 개의 테이블을 JOIN하여
-- 고객의 전체 주소 정보를 조회해 보세요.
SELECT
    cu.first_name 성,
    a.address 주소,
    ct.city 도시,
    co.country 국가
FROM
    customer cu
    left JOIN
    address a
    on cu.address_id = a.address_id
    left JOIN
    city ct
    on a.city_id = ct.city_id
    left JOIN
    country co
    on ct.country_id = co.country_id;

-- 배우가 출연한 영화 조회
-- 영화 서비스나 콘텐츠 관리 시스템에서는
-- 배우를 기준으로 출연 영화 목록을 조회해야 하는 경우가 많습니다.
 
-- 배우(actor)와 영화(film)는 직접 연결되어 있지 않고,
-- 출연 기록을 담은 film_actor 중계 테이블을 통해 연결됩니다.
 
-- 세 테이블을 JOIN하여
-- 각 배우의 이름과 출연 영화 제목을 조회해 보세요.
SELECT
    a.actor_id 배우명,
    f.title 영화명
FROM
    actor a
    left JOIN
    film_actor fa
    on a.actor_id = fa.actor_id
    LEFT JOIN
    film f
    on fa.film_id = f.film_id;

-- 특정 배우가 출연한 영화의 제목을 조회
-- 콘텐츠 검색이나 관리자 화면에서는
-- 특정 배우 한 명의 출연작만 필터링해야 할 때가 많습니다.
 
-- 배우의 first_name이 PENELOPE인 경우에 한해,
-- 그 배우가 출연한 영화 제목을 조회해 보세요.
SELECT
    a.first_name 배우명,
    f.title 영화제목
FROM
    actor a
    left JOIN
    film_actor fa
    on a.actor_id = fa.actor_id
    LEFT JOIN
    film f
    on fa.film_id = f.film_id
where a.first_name = 'PENELOPE';