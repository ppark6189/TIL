use sakila;
show tables;
-- 특정 카테고리 영화를 ‘한 번도’ 빌리지 않은 고객 리스트 만들기 (마케팅 타겟팅)
-- 프로모션을 기획 중입니다.
-- ‘Action’ 카테고리는 한 번도 빌려본 적 없는 고객에게 신규 장르 체험 쿠폰을 보내려고 합니다.
 
-- 아래 서브쿼리 예시를 참고하여, 동일한 결과가 나오도록 CTE로 변환해 보세요.
-- 고객을 조회하시오. 
SELECT c.first_name, c.last_name
FROM customer c
WHERE NOT EXISTS (
    SELECT 1
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    WHERE r.customer_id = c.customer_id
    AND cat.name = 'Action'
);
with NotRentedActionCustomer as (
    select DISTINCT r.customer_id
    from rental r
    join inventory i on r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    where cat.name = 'Action'
)
SELECT c.first_name, c.last_name
from customer c
left JOIN NotRentedActionCustomer nac on c.customer_id = nac.customer_id
where  nac.customer_id is null;
-- 우수 고객이 실제로 소비한 영화 목록 뽑기 (콘텐츠 추천/편성 후보군)
-- 서비스 운영팀이 “헤비 유저가 많이 본 영화”를 기반으로
-- 추천 슬롯(또는 프로모션 배너) 후보 영화를 뽑으려고 합니다.
 
-- 아래 서브쿼리 예시를 참고하여, 동일한 결과가 나오도록 CTE로 변환해 보세요.
SELECT DISTINCT f.title
FROM film f
WHERE f.film_id IN (
    SELECT i.film_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE r.customer_id IN (
        SELECT customer_id
        FROM rental
        GROUP BY customer_id
        HAVING COUNT(*) >= 40
    )
);

with hu as (
    SELECT r.customer_id
    from rental r
    GROUP BY r.customer_id
    having count(*) >=40
),
rf as (
    SELECT DISTINCT i.film_id
    from rental r
    join inventory i on r.inventory_id = i.inventory_id
    where r.customer_id in (
        SELECT hu.customer_id
        from hu
    )
)
SELECT f.title
from film f
join rf on f.film_id = rf.film_id

-- 고객 표시용 이름 컬럼 만들기
-- 실무에서 고객 이름은 화면, 리포트, 다운로드 파일 등에서
-- 성, 이름 형태로 하나의 컬럼으로 보여지는 경우가 많습니다.
 
-- customer 테이블의 first_name과 last_name을 조합하여
-- 표시용 full_name 컬럼을 만들어 보세요.
use sakila;
SELECT CONCAT(c.first_name," ",c.last_name) full_name
FROM customer c

-- 출력 포맷 통일을 위한 문자열 변환
-- 데이터를 외부로 전달하거나 리포트에 사용할 때
-- 대소문자 포맷을 통일해야 하는 경우가 자주 발생합니다.
 
-- film 테이블에서
-- 영화 제목(title)은 모두 대문자
-- 설명(description)은 모두 소문자
-- 로 변환하여 조회해 보세요.
SELECT UPPER(f.title) 영화제목, lower(f.DESCRIPTION) 설명
FROM film f

-- 이메일 주소에서 사용자 ID 분리
-- 로그 분석이나 사용자 식별을 위해
-- 이메일 주소에서 도메인을 제거하고
-- @ 앞의 사용자 ID만 사용하는 경우가 있습니다.
 
-- customer 테이블의 email 컬럼에서
-- @ 앞부분만 추출하여 사용자 ID 형태로 조회해 보세요.
SELECT SUBSTRING_INDEX(c.email,'@',1)
FROM customer c;
-- 금액 처리 기준에 따른 값 차이 확인
-- 결제 금액은
-- 반올림
-- 올림
-- 버림
-- 등의 기준에 따라 다른 값으로 처리될 수 있습니다.
-- payment 테이블의 결제 금액(amount)을 기준으로
-- 각 처리 방식에 따른 결과를 한 번에 비교해 보세요.
SELECT 
    round(p.amount),
    CEIL(p.amount),
    FLOOR(p.amount)
FROM payment p

-- 리포트용 날짜 포맷 변환
-- 날짜 데이터는 그대로 저장하되,
-- 리포트나 화면에서는 사람이 읽기 쉬운 형식으로 변환하여 출력하는 경우가 많습니다.
 
-- rental 테이블의 대여일(rental_date)을
-- YYYY-MM-DD (요일 약어) 형태로 변환하여 조회해 보세요.
SELECT DATE_FORMAT(r.rental_date,'%Y-%m-%d (%a)')
FROM rental r;

-- 요일별 매출 패턴 분석
-- 운영 관점에서는
-- 요일별로 대여가 얼마나 발생하고,
-- 어느 요일에 매출이 집중되는지를 자주 확인합니다.
 
-- rental 테이블과 payment 테이블을 활용하여
-- 요일별 렌탈 건수
-- 요일별 총 수익
-- 을 함께 계산해 보세요.
SELECT 
    DATE_FORMAT(r.rental_date,'%a'),
    count(*),
    sum(p.amount)
FROM rental r
join payment p on r.rental_id = p.rental_id
GROUP BY DATE_FORMAT(r.rental_date,'%a');

-- 실제 대여 기간 계산
-- 영화가 며칠 동안 대여되었는지는
-- 연체, 이용 패턴, 고객 행동 분석의 기본 지표가 됩니다.
 
-- rental 테이블의 대여일(rental_date)과 반납일(return_date)을 이용하여
-- 각 대여 건의 실제 대여 기간(일수)을 계산해 보세요.
SELECT
    r.rental_id, 
    DATEDIFF(r.return_date,r.rental_date)
FROM rental r

-- 분석 전 데이터 품질 점검
-- 실무에서 분석이나 리포트를 시작하기 전에
-- 가장 먼저 확인해야 하는 것은 필수 지표가 누락된 데이터입니다.
 
-- country 테이블에서 기대 수명(LifeExpectancy) 또는 경제 지표(GNP)가 누락된 국가들을 찾아
-- 해당 국가와 대륙 정보를 함께 확인해 보세요.
SELECT
    co.`Name`,
    co.`Continent`,
    co.`LifeExpectancy`,
    co.`GNP`
FROM country co
WHERE 
    co.`LifeExpectancy` is NULL OR
    co.`GNP` is null;

-- 결측치 보정 로직 적용하기
-- 기대 수명 데이터가 없는 국가가 포함된 상태로는
-- 대륙별 평균, 비교 분석이 왜곡될 수 있습니다.
 
-- 기대 수명(LifeExpectancy)이 NULL인 경우,
-- 해당 국가가 속한 대륙 평균 기대 수명으로 보정한 값을 계산하고
-- 원래 값과 대체 값을 함께 비교할 수 있도록 조회해 보세요.
SELECT
    co.`Name`,
    co.`Continent`,
    co.`LifeExpectancy`,
    c2.avg_le
FROM country co
JOIN(
    SELECT `Continent`, AVG(`LifeExpectancy`) avg_le
    from country
    GROUP BY `Continent`
) c2
on co.`Continent` = c2.`Continent`;

-- 범주형 데이터 정규화
-- 실제 데이터에서는
-- 같은 의미를 가지는 값이 여러 표현으로 저장되는 경우가 많습니다.
 
-- GovernmentForm 컬럼에서
-- Republic
-- Federal Republic
-- Islamic Republic
-- 처럼 표현이 다른 값을 분석 기준에서는 하나의 표준 카테고리(Republic) 로 묶어야 합니다.
 
-- 'Republic'이라는 단어가 포함된 국가는 모두 Republic으로 통일하여
-- 정규화된 정부 형태 컬럼을 만들어 보세요.
SELECT 
    co.`Name`,
    co.`GovernmentForm`,
    CASE 
        WHEN co.`GovernmentForm` like '%Republic%' THEN 'Republic' 
        ELSE co.`GovernmentForm`  
    END n_governmentform
FROM country co;

-- 분석용 파생 지표 생성 – 인구 밀도
-- 단순 인구 수만으로는 국가 간 비교가 어렵습니다.
-- 실무에서는 인구를 면적 기준으로 보정한 지표를 자주 사용합니다.
 
-- Population과 SurfaceArea를 활용하여
-- 국가별 인구 밀도(1km²당 인구 수) 를 계산해 보세요.
 
-- 단, 계산이 의미 없는 경우(면적 또는 인구가 0)는 제외합니다.
SELECT
    co.`Name`,
    co.`Population`,
    co.`SurfaceArea`,
    (co.`Population`/co.`SurfaceArea`) 인구밀도
FROM country co
WHERE co.`Population` >0 and co.`SurfaceArea` > 0;


-- 경제 수준 비교를 위한 지표 가공
-- 총 GNP는 국가 규모의 영향을 크게 받기 때문에
-- 국가 간 생활 수준 비교에는 적합하지 않습니다.
-- GNP와 Population을 활용해
-- 국가별 1인당 GNP를 계산하고,
-- 국가명과 대륙 기준으로 비교 가능한 형태로 조회해 보세요.
-- *GNP는 백만달러 단위 입니다.
SELECT
    co.`Name`,
    co.`Population`,
    co.`GNP`,
    (co.`GNP`/co.`Population`)*1000000 1인당GNP
FROM country co
WHERE co.`Population` > 0 and co.`GNP` > 0
ORDER BY 1인당GNP DESC;

-- 수도 집중도 지표 계산
-- 국가 전체 인구 대비 수도 인구 비율은
-- 행정·경제·인구 집중도를 판단하는 데 자주 사용되는 지표입니다.
 
-- country 테이블의 전체 인구와 city 테이블의 수도 인구를 연결하여,
-- 각 국가의 수도 인구 집중 비율(%) 을 계산해 보세요.
SELECT
    co.`Name`,
    co.`Capital`,
    concat(CAST((ct.`Population`/co.`Population`)*100 as char),"%") 수도인구밀도
FROM country co
JOIN city ct on co.`Capital` = ct.`ID`
WHERE co.`Population` > 0;
