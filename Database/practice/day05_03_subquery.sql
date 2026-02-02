use world;
-- 데이터 반환 형태에 따른 서브쿼리

-- [1] 단일행 서브쿼리
-- 서브쿼리가 단일한 값 반환
-- 하나의 값 -> 비교 연산과 주로 사용된다..

-- 예시 1 : 평균 인구수 보다 인구가 많은 도시 조회
-- 대상 테이블 : city
-- 필터링 조건 : 평균인구수보다 크다.(비교연산)
    -- -> 평균인구수는? 집계해야만 알수 있음.
    --필터링 걸기 위해 꼭 필요한 평균 인구수 -> 서브 쿼리로 만든다.
-- 메인 쿼리
SELECT *
from city ct
where ct.`Population` >(
    SELECT avg(ct.`Population`)
    from city ct
);
-- 서브 쿼리 : 반환값 한 -> 단일행 서브쿼리
SELECT avg(ct.`Population`)
from city ct;

-- 얘시 2 : 가장 많은 인구를 가진 도시의 국가 정보
-- 대상 테이블
    -- city
    -- country
-- 조건 : 가장 많은 인구의 도시
SELECT *
from country co
where co.`Code` = (
    SELECT ct.`CountryCode`
    from city as ct
    ORDER BY ct.`Population` DESC
    LIMIT 1
)
-- 서브쿼리 반환 값 하나 : 단일행 서브쿼리
SELECT ct.`CountryCode`
    from city as ct
    ORDER BY ct.`Population` DESC
    LIMIT 1;

-- [2] 다중행 서브쿼리
-- 서브쿼리가 반환하는 값이 여러개
-- 여러값을 한번에 비교하기 어려워서, IN, NOT IN, EXISTS 등 사용

-- 예시 : 'English'를 공식 언어로 사용하는 모든 국가의 이름을 조회하는 경우
-- 대상 테이블
    -- 1) country
    -- 2) countrylanguage -> 서브쿼리
-- 조건: 언어 = English + 공식언어


-- 메인쿼리
SELECT co.`Name`
from country co
where co.`Code` IN (
    SELECT cl.`CountryCode`
    from countrylanguage cl
    WHERE cl.`Language` = 'English'
    and cl.`IsOfficial` = 'T'
);

-- 서브쿼리 : 반환값이 여러개인 다중행 서브쿼리
SELECT cl.`CountryCode`
from countrylanguage cl
WHERE cl.`Language` = 'English'
and cl.`IsOfficial` = 'T';

-- [3] 다중컬럼 서브쿼리
-- 여러행, 여러컬럼 -> 테이블 형태
SELECT bc.`Name`, bc.`District`, bc.`Population`
from (
    SELECT *
    from city ct
    where ct.`Population` > 5000000
) bc;

-- 각 나라에서 가장 인구가 많은 도시의 정보를 조회하는 경우
SELECT ct1.`Name`, ct1.`CountryCode`, ct1.`Population`
from city ct1
WHERE (ct1.`CountryCode`,`Population`) IN (
        SELECT ct2.`CountryCode`, max(ct2.`Population`)
        from city ct2
        GROUP BY ct2.`CountryCode`
);