-- 동작 방식에 따른 서브쿼리

-- [1] 비연관 서브쿼리
-- 메인쿼리와 연관이 없다 -> 메인쿼리 없이도 서브쿼리가 잘 실행된다.
-- 실행 순서 : 서브쿼리 -> 메인쿼리
    -- => 한 번에 끝
-- 예시 : 적어도 한 번이라도 대여된 적이 있는 영화들 찾기
-- (메인쿼리) 대상 테이블 : film
-- 조건 : 적어도 한 번이라도 "대여"된 적이 있다.
    -- (서브쿼리) 대상테이블 : rental
use sakila ;

select f.title
from film as f
where f.film_id in (
    SELECT distinct i.film_id
    from rental as r
    join inventory as i
    on r.inventory_id = i.inventory_id
);

-- [2] 연관 서브쿼리
-- 메인쿼리와 연관이 있다 -> 메인쿼리 없이 서브쿼리는 실행될 수 없다.
    --  why? 서브쿼리 안에서 메인쿼리의 값을 사용
-- 실행 순서 : 메인쿼리(한행) -> 서브쿼리 실행 -> 메인쿼리 사용(조건)
    -- => 메인쿼리의 모든 행에 대해서 반복
-- 예시 : 적어도 한 번이라도 대여된 적이 있는 영화들 찾기
-- 대상 테이블 : film
-- 대상 테이블 : rental + inventory

SELECT f.title
from film f
where exists (
    SELECT 1
    FROM rental as r
    join inventory i
    on r.inventory_id = i.inventory_id
    where f.film_id = i.film_id
);


