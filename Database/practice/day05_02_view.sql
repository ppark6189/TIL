-- 자주 사용하는 쿼리 저장소
-- VIEW 객체
-- 객체를 생성, 수정, 삭제 -->DDL
use world;
SELECT DATABASE();

show tables;
-- 아시아 (Asia) 대륙에 속한 국가들의 이름, 수도, 인구, GNP
-- 대상테이블
    -- !) country
    -- 2) country
SELECT
    co.`Code` 국가코드,
    co.`Name` 국가명,
    ct.`Name` 수도명,
    co.`Population` 인구수,
    co.`GNP` GNP
FROM country as co 
    join
    city as ct
    on co.`Capital` = ct.`ID`
where co.`Continent` = 'Asia';

-- [1] VIEW 생성
-- 고정을 위한 가상 테이블 VIEW를 생성
-- 생성 -> CREATE
CREATE View asia_countries_view as
SELECT
    co.`Code` 국가코드,
    co.`Name` 국가명,
    ct.`Name` 수도명,
    co.`Population` 인구수,
    co.`GNP` GNP
FROM country as co 
    join
    city as ct
    on co.`Capital` = ct.`ID`
where co.`Continent` = 'Asia';
show tables;
-- 테이블처럼 사용 가능
select*
FROM asia_countries_view
where 인구수 < 100000000
ORDER BY 인구수 DESC
limit 10;

-- [2] VIEW 수정
CREATE or REPLACE VIEW asia_countries_view AS
SELECT
    co.`Code` 국가코드,
    co.`Name` 국가명,
    ct.`Name` 수도명,
    co.`Population` 인구수,
    co.`GNP` GNP,
    co.`GovernmentForm` 정부형태
FROM country as co 
    join
    city as ct
    on co.`Capital` = ct.`ID`
where co.`Continent` = 'Asia';
select *
from asia_countries_view;
-- 정부형테 추가 완료

-- [3] VIEW 삭제하기
drop VIEW if EXISTS asia_countries_view;
show tables;