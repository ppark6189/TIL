-- 리포트] 국가별 ‘TOP 도시 리스트’ 만들기
-- 국가 상세 페이지(또는 국가별 리포트)에는 보통 “인구가 많은 주요 도시”가 함께 표시됩니다.
-- city 테이블에서 각 국가(CountryCode)별로 인구 기준 상위 5개 도시를 뽑아, 국가별 주요 도시 목록을 만들어 보세요.
WITH CityRanking AS (
    SELECT
        CountryCode,
        Name AS city_name,
        Population,
        ROW_NUMBER() OVER (PARTITION BY CountryCode ORDER BY Population DESC) AS ranking
    FROM
        city
)
SELECT
    CountryCode,
    city_name,
    Population
FROM
    CityRanking
WHERE
    ranking <= 5
ORDER BY
    CountryCode, Population DESC;

-- [세그먼트] 대륙 내 국가를 ‘GNP 4등급’으로 분류하기
-- 대륙별로 경제 규모(GNP)를 기준으로 국가를 4단계 등급(상/중상/중하/하)으로 나눠서 비교하려고 합니다.
-- country 테이블에서 대륙(Continent) 단위로 GNP를 정렬해 4개 그룹으로 나누고, 각 국가가 어느 등급에 속하는지 표시해 보세요.
SELECT
    Name,
    Continent,
    GNP,
    -- 대륙별로 GNP가 높은 순으로 4개의 그룹으로 나눔
    NTILE(4) OVER (PARTITION BY Continent ORDER BY GNP DESC) AS gnp_quartile
FROM
    country
WHERE
    GNP > 0 -- GNP가 0인 국가는 제외
ORDER BY
    Continent, gnp_quartile, GNP DESC;

-- [벤치마크] 국가 수명 지표를 ‘대륙 평균’과 나란히 비교하기
-- 성과 지표를 볼 때는 “절대값”보다 “같은 그룹 평균 대비” 비교가 더 자주 쓰입니다.
-- country 테이블에서 각 국가의 평균 수명(LifeExpectancy) 옆에, 해당 국가가 속한 대륙의 평균 수명을 함께 붙여 비교 가능한 형태로 만들어 보세요.
SELECT
    Name,
    Continent,
    LifeExpectancy,
    -- 대륙별 평균 수명 계산
    AVG(LifeExpectancy) OVER (PARTITION BY Continent) AS continent_avg_life_expectancy
FROM
    country
WHERE
    LifeExpectancy IS NOT NULL
ORDER BY
    Continent, LifeExpectancy DESC;

-- [기준 대비] 국가별 ‘주요 언어’ 대비 다른 언어의 사용률 차이 보기
-- 국가별 언어 데이터를 볼 때는 “최대 언어(대표 언어)”를 기준점으로 두고, 다른 언어가 얼마나 차이나는지 보는 형태가 자주 쓰입니다.
-- countrylanguage 테이블에서 각 국가별로 가장 높은 사용률 언어를 기준으로, 다른 언어들의 사용률 차이를 각 행에 함께 표시해 보세요.
SELECT
    CountryCode,
    Language,
    Percentage,
    -- 국가별(파티션) 사용률(내림차순 정렬) 중 첫 번째 값(가장 높은 사용률)을 가져옴
    FIRST_VALUE(Percentage) OVER (PARTITION BY CountryCode ORDER BY Percentage DESC) AS primary_lang_percentage,
    -- 최고 사용률과의 차이 계산
    FIRST_VALUE(Percentage) OVER (PARTITION BY CountryCode ORDER BY Percentage DESC) - Percentage AS diff_from_primary
FROM
    countrylanguage
ORDER BY
    CountryCode, Percentage DESC;

-- [추세 완화] 대륙 내 ‘GNP 순서’ 기준 이동 평균으로 안정화하기
-- 지표가 들쭉날쭉하면 비교가 어렵기 때문에, 실무에서는 이동 평균으로 스무딩(완화)한 값을 같이 봅니다.
 
-- country 테이블에서 대륙별로 GNP 순으로 정렬했을 때, 각 국가의 평균 수명(LifeExpectancy)을 기준으로 앞뒤 2개 국가(총 5개)의 이동 평균을 계산해 보세요.
SELECT
    Name,
    Continent,
    GNP,
    LifeExpectancy,
    -- 파티션(대륙) 내에서 GNP 순으로 정렬하고, 현재 행의 앞 2개, 뒤 2개 행(총 5개)의 평균 수명을 계산
    AVG(LifeExpectancy) OVER (
        PARTITION BY Continent
        ORDER BY GNP DESC
        ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING
    ) AS moving_avg_life_expectancy
FROM
    country
WHERE
    LifeExpectancy IS NOT NULL AND GNP > 0
ORDER BY
    Continent, GNP DESC;