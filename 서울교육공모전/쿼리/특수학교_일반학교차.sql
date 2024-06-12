WITH 특수학교 AS (
    SELECT REPLACE(지역, '서울특별시 ', '') AS 지역,
           SUM(`학급수(계)`) AS 총특수학급수, 
           SUM(`학생수(계)`) AS 총특수학생수
    FROM `서울시 학교 현황` 
    JOIN (SELECT `정보공시 학교코드`, `특수학급 학급수`, `특수학급 학생수`, `학급수(계)`, `학생수(계)`
          FROM `서울시 학교별·학급별 학생수 현황`
          WHERE 공시연도 = 2023) 학생수
    USING(`정보공시 학교코드`)
    WHERE 학교급코드 = 5 AND 공시연도 = 2023
    GROUP BY 지역
),
일반학교 AS (
    SELECT REPLACE(지역, '서울특별시 ', '') AS 지역,
           SUM(`학급수(계)`) AS 총학급수, 
           SUM(`학생수(계)`) AS 총학생수, 
           SUM(`특수학급 학급수`) AS 총특수학급수, 
           SUM(`특수학급 학생수`) AS 총특수학생수,
           ROUND(FORMAT(SUM(`특수학급 학생수`)/SUM(`학생수(계)`), 5)*100, 5) AS 특수학생비율 
    FROM `서울시 학교 현황`
    JOIN (SELECT `정보공시 학교코드`, `특수학급 학급수`, `특수학급 학생수`, `학급수(계)`, `학생수(계)`
          FROM `서울시 학교별·학급별 학생수 현황`
          WHERE 공시연도 = 2023) 학생수
    USING(`정보공시 학교코드`)
    WHERE NOT 학교급코드 = 5 AND 공시연도 = 2023 AND `특수학급 학급수` > 0
    GROUP BY 지역
)

SELECT 일반학교.지역, 
       COALESCE(특수학교.총특수학생수, 0) - COALESCE(일반학교.총특수학생수, 0)  AS 특수학생수차
FROM 일반학교
LEFT JOIN 특수학교 USING(지역)