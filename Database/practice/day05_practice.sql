use sakila;
SELECT database();
show tables;

-- 가격 정책 점검을 위한 기준 초과 상품 찾기
 
-- 현재 서비스에 등록된 영화 중,
-- 전체 평균 대여료보다 비싼 가격으로 책정된 영화를 찾아
-- 가격 정책 검토 대상으로 삼으려고 합니다.
 
-- 전체 영화의 평균 대여료를 기준으로,
-- 그보다 비싼 대여료를 가진 영화의 제목과 대여료를 조회하세요.

-- 대상 테이블 : film
-- 조건 : 전체 평균 대여료 보다 높은 영화
    -- 전체 평균 대여료는? -> 단일행서브쿼리
SELECT f.title, f.rental_rate
from film f
where f.rental_rate > (
    SELECT avg(rental_rate)
    from film
);

-- 특정 고객의 결제 패턴을 전체 평균과 함께 비교하기
-- 고객 ID가 5인 고객의 결제 내역을 확인하면서,
-- 각 결제가 전체 고객 평균 결제액 대비 어느 수준인지를 함께 보고 싶습니다.
 
-- 해당 고객의 모든 결제 ID와 결제액을 조회하되,
-- 전체 고객의 평균 결제액을 모든 행에 함께 표시하세요.

-- 대상 테이블 : payment
-- 필터링 : 특정 고객 -> 고객 ID = 5
-- select-> 결제ID, 결제액, 전체고객평균결제액
-- 의도 : select 문 아래 서브쿼리 존재
select
    p.customer_id,
    p.payment_id,
    p.amount,
    (select avg(amount)
    from paymnet)
from payment p
where p.customer_id = 5;

-- 특정 카테고리 영화의 재고 현황 점검
-- ‘Action’ 카테고리에 속한 영화들에 대해
-- 현재 어떤 재고(inventory)가 존재하는지 확인하려고 합니다.
 
-- 먼저 ‘Action’ 카테고리에 속한 영화 ID 목록을 구한 뒤,
-- 그 영화들에 해당하는 재고 정보만 inventory 테이블에서 조회하세요.

-- 대상테이블 : inventory
-- 조건 : 액션 카테고리에 속한 ID인 경우, 필터링
    -- (서브쿼리) 대상 테이블 : film_category
    -- -> 다중행 서브쿼리
    SELECT
        i.inventory_id,
        i.film_id
    from inventory i
    where i.film_id in (
        SELECT fc.film_id
        FROM film_category fc
        join category c
        on fc.category_id = c.category_id
        where c.name='Action'
    );
-- 특정 국가 외 지역 고객만 선별하기
-- 마케팅 캠페인을 위해
-- 캐나다에 거주하지 않는 고객만 따로 추출하려고 합니다.
 
-- 캐나다에 속한 모든 도시를 기준으로,
-- 그 도시들에 주소를 두고 있지 않은 고객의 이름을 조회하세요.

-- 대상 테이블 : customer -> 메인 쿼리
-- 조건 : 캐나다에 거주하지 않음
    -- 서브쿼리
        -- 대상 테이블 : address
            -- 서브쿼리
                -- 대상  테이블 : city + country
SELECT c.first_name, c.last_name
from customer c
where c.address_id IN (
    SELECT a.address_id
    from address a
    where a.city_id not in (
        SELECT ct.city_id
        from 
            city ct
            JOIN
            country co
            on ct.country_id = co.country_id
        where co.country='Canada'
    )
)
-- 고객 단위 매출 요약 리포트 생성
-- 고객별로
-- 지금까지의 총 결제 금액
-- 고객당 평균 결제 금액
-- 을 함께 계산한 뒤,
-- 이를 고객 기본 정보와 결합하여 고객 이름 + 매출 요약 정보 형태의 리포트를 만들려고 합니다.
 
-- payment 테이블에서 고객별 결제 요약을 먼저 계산하고,
-- 그 결과를 customer 테이블과 연결하여 조회하세요.

USE sakila; -- 데이터베이스 선택
SELECT DATABASE(); -- 데이터베이스 확인
SHOW TABLES; -- 테이블 목록 확인
-- 카테고리 기반 영화 목록 조회 (기준 목록이 먼저 필요한 경우)
-- 마케팅 팀에서
-- “Action 장르에 속한 영화들의 상세 정보(제목, 설명)를 한 번에 보고 싶다”
-- 라는 요청이 들어왔습니다.
 
-- 이 경우 먼저
-- ‘Action’이라는 고정된 기준에 해당하는 영화 ID 목록을 만들고,
-- 그 결과를 바탕으로 영화 정보를 조회하는 방식이 적합합니다.
 
-- 바깥 쿼리와 무관하게 먼저 실행되는
-- 비연관 서브쿼리를 사용하여
-- ‘Action’ 카테고리에 속한 모든 영화의 제목(title)과 설명(description)을 조회해 보세요.

-- 대상 테이블 : 영화
SELECT 
    f.title,
    f.DESCRIPTION
from film f
where f.film_id in (
    SELECT fc.film_id
    from film_category fc
    where fc.category_id = (
        select c.category_id
        from category c
        where c.name = 'Action'
    )
);

-- 고객별 최신 상태 요약 조회 (행마다 기준이 달라지는 경우)
-- 운영 리포트에서
-- “각 고객이 가장 최근에 영화를 대여한 시점이 언제인지”
-- 를 고객 목록과 함께 한 번에 보고 싶습니다.
 
-- 이때는
-- 고객 한 명 한 명마다
-- 그 고객의 대여 기록 중 가장 최신 날짜를 찾아야 하므로
-- 서브쿼리가 메인 쿼리의 고객 정보를 행 단위로 참조하며 실행되어야 합니다.
 
-- 연관 서브쿼리를 사용하여
-- 각 고객의 이름(first_name, last_name)과
-- 해당 고객의 가장 최근 대여일(rental_date)을 조회해 보세요.
select cu.first_name, cu.last_name, max(r.rental_date)
from customer cu
join rental r
on cu.customer_id = r.customer_id
group BY cu.customer_id;

SELECT
    cu.first_name,
    cu.last_name,
    (SELECT max(r.rental_date)
    from rental r
    where cu.customer_id = r.customer_id)
from customer cu;

-- 특정 행동 이력 존재 여부 확인 (있다 / 없다만 중요한 경우)
-- 콘텐츠 기획팀에서
-- “Horror 장르 영화를 한 번이라도 대여한 경험이 있는 고객만 추려달라”
-- 는 요청이 들어왔습니다.
 
-- 이 요구사항에서는
-- 몇 편을 빌렸는지
-- 언제 빌렸는지
-- 보다, 해당 이력이 존재하는지 여부 자체만 중요합니다.
 
-- 고객 한 명씩 확인하면서
-- Horror 영화 대여 기록이 존재하는지만 검사하도록
-- EXISTS를 사용하는 연관 서브쿼리로
-- 조건을 만족하는 고객의 이름(first_name, last_name)을 조회해 보세요.
SELECT 
    cu.first_name,
    cu.last_name
from customer cu
where EXISTS(
    select 1
    from rental r
    join inventory i
    on r.inventory_id = i.inventory_id
    join film f
    on i.film_id = f.film_id
    join film_category fc
    on f.film_id = fc.film_id
    join category c
    on fc.category_id = c.category_id
    where c.name ='Horror'
    and r.customer_id = cu.customer_id
);
select * from category;