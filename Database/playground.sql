USE sakila; -- 데이터베이스 선택
SELECT DATABASE(); -- 데이터베이스 확인
SHOW TABLES; -- 테이블 목록 확인
-- 가격 정책 점검을 위한 기준 초과 상품 찾기
 
-- 현재 서비스에 등록된 영화 중,
-- 전체 평균 대여료보다 비싼 가격으로 책정된 영화를 찾아
-- 가격 정책 검토 대상으로 삼으려고 합니다.
 
-- 전체 영화의 평균 대여료를 기준으로,
-- 그보다 비싼 대여료를 가진 영화의 제목과 대여료를 조회하세요.
SELECT
    f.title,
    f.rental_rate
from film f
where f.rental_rate >(
    SELECT avg(f.rental_rate)
    from film f 
)

-- 특정 고객의 결제 패턴을 전체 평균과 함께 비교하기
-- 고객 ID가 5인 고객의 결제 내역을 확인하면서,
-- 각 결제가 전체 고객 평균 결제액 대비 어느 수준인지를 함께 보고 싶습니다.
 
-- 해당 고객의 모든 결제 ID와 결제액을 조회하되,
-- 전체 고객의 평균 결제액을 모든 행에 함께 표시하세요.
SELECT
    p.payment_id,
    p.amount,
    (select avg(p.amount)
    from payment p)
FROM payment p
where customer_id = 5

-- 특정 카테고리 영화의 재고 현황 점검
-- ‘Action’ 카테고리에 속한 영화들에 대해
-- 현재 어떤 재고(inventory)가 존재하는지 확인하려고 합니다.
 
-- 먼저 ‘Action’ 카테고리에 속한 영화 ID 목록을 구한 뒤,
-- 그 영화들에 해당하는 재고 정보만 inventory 테이블에서 조회하세요.
SELECT *
from inventory i
where i.film_id in (
    select f.film_id
    from film f
    where f.film_id in (
        select fc.film_id
        from film_category fc
        join category c
        on fc.category_id= c.category_id
        where c.name ='action'
    )
)

-- 특정 국가 외 지역 고객만 선별하기
-- 마케팅 캠페인을 위해
-- 캐나다에 거주하지 않는 고객만 따로 추출하려고 합니다.
 
-- 캐나다에 속한 모든 도시를 기준으로,
-- 그 도시들에 주소를 두고 있지 않은 고객의 이름을 조회하세요.
SELECT
    cu.first_name,
    cu.last_name
from customer cu
where cu.address_id not in (
    SELECT a.address_id
    from address a
    where a.city_id in(
        SELECT c.city_id
        FROM city c
        join country co
        on c.country_id = co.country_id
        where co.country='Canada'
        )
    );

-- 고객 단위 매출 요약 리포트 생성
-- 고객별로
-- 지금까지의 총 결제 금액
-- 고객당 평균 결제 금액
-- 을 함께 계산한 뒤,
-- 이를 고객 기본 정보와 결합하여 고객 이름 + 매출 요약 정보 형태의 리포트를 만들려고 합니다.
 
-- payment 테이블에서 고객별 결제 요약을 먼저 계산하고,
-- 그 결과를 customer 테이블과 연결하여 조회하세요.
SELECT
    cu.first_name,
    cu.last_name,
    합,
    평균
from customer cu
join (
    SELECT
        p.customer_id,
        sum(p.amount) 합,
        avg(p.amount) 평균
    from payment p
    group BY p.customer_id
)
as d
on cu.customer_id = d.customer_id
;
