WITH 학생수 AS (
    SELECT `정보공시 학교코드`, `특수학급 학급수`, `특수학급 학생수`, `학급수(계)`, `학생수(계)`
    FROM `서울시 학교별·학급별 학생수 현황`
    WHERE 공시연도 = 2023
)

SELECT 교육지원청, `정보공시 학교코드`, 학교명, 
       REPLACE(지역, '서울특별시 ', '') AS 지역,
       `학급수(계)`, `학생수(계)`,
       CASE 
           WHEN 학교급코드 = 5 THEN `학급수(계)`
           ELSE `특수학급 학급수`
       END AS `특수학급 학급수`,
       CASE 

           WHEN 학교급코드 = 5 THEN `학생수(계)`
           ELSE `특수학급 학생수`
       END AS `특수학급 학생수`,
       학교급코드, 
       CASE
           WHEN 학교급코드 = 2 THEN '초'
           WHEN 학교급코드 = 3 THEN '중'
           WHEN 학교급코드 = 4 THEN '고'
           WHEN 학교급코드 = 5 THEN '특수'
           ELSE '기타'
       END AS 학교구분,
       공시연도
FROM `서울시 학교 현황`
JOIN 학생수 USING(`정보공시 학교코드`)
WHERE (학교급코드 = 5 OR `특수학급 학급수` > 0) AND 공시연도 = 2023