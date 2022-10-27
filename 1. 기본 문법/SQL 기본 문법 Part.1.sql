--2017년부터 2021년 3월까지의 전자상거래 추정거래액 (단위 : 백만원)
--내 회사의 거래액 데이터라고 생각해도 됨

---------------------------------- 1) 데이터 탐색 ----------------------------------

---------- STEP 1) 모든 컬럼 추출하기 ----------
select *
from gmv_trend

---------- STEP 2) 특정 컬럼 추출하기 ----------
select category, yyyy, mm, gmv  
from gmv_trend

---------- STEP 3) 중복값 없이 특정 컬럼 추출하기 ----------
select distinct category 
from gmv_trend

select distinct yyyy, mm
from gmv_trend

---------------------------------- 2) 특정 연도의 매출 탐색 ----------------------------------

----------------------- 2-1) 조건이 하나일 때 More Example -----------------------

---------- a) 숫자열 (between, 대소비교) ----------
select *
from gmv_trend
where yyyy = 2021

select *
from gmv_trend
where yyyy >= 2019

select *
from gmv_trend
where yyyy between 2018 and 2020

select *
from gmv_trend
where yyyy != 2021 -- 제외하고 

select *
from gmv_trend
where yyyy <> 2017 -- 같지 않음 


---------- b) 문자열 (=, !=, like, in, not in) ----------
select *
from gmv_trend
where category = '컴퓨터 및 주변기기'  -- 큰 따옴표로는 안됨

select *
from gmv_trend
where category != '컴퓨터 및 주변기기'

select *
from gmv_trend 
where category in ('가전·전자·통신기기','생활용품') --2개 카테고리 선택

select *
from gmv_trend 
where category not in ('가전·전자·통신기기','생활용품') -- 2개 카테고리만 제외

select *
from gmv_trend 
where category like '%패션%' -- 패션 단어가 들어간 문자 찾기 
							-- %는 앞 혹은 뒤에 해당 단어가 포함되는 문자 찾기

select *
from gmv_trend 
where category not like '%패션%'

----------------------- 2-2) 조건이 여러개일 때 -----------------------

---------- a) and 조건 ----------
select *
from gmv_trend
where category = '컴퓨터 및 주변기기'
and yyyy = 2021

---------- b) or 조건 ----------
select *
from gmv_trend
where gmv > 1000000 or gmv < 10000

---------- c) and, or 조건 혼용 ----------
select *
from gmv_trend
where (gmv > 1000000 or gmv < 10000) -- (괄호)를 사용해서 의미 단위로 괄호로 묶어서 써줘야 됨 
and yyyy = 2021


---------------------------------- 3) 카테고리별 매출 분석 ----------------------------------

---------- More Example) 카테고리별 ----------
select category cate , yyyy as year, sum(gmv) as total_gmv --as는 생략해도 가능 / 고유 단어만 빼고 모두 사용 가능
from gmv_trend
group by category, yyyy --SQL의 문법상 group by를 반드시 써주고 집계합수를 제외한 컬럼을 써줘야
-- (= group by 1,2 )
-- gmv trend 테이블에서 category와 yyyy를 뽑을건데 gmv는 그룹핑을 할거다
-- group by랑 select절의 컬럼 개수는 일치해야

---------- More Example) 전체 총합 ----------
select sum(gmv) as gmv
from gmv_trend
-- 전체를 집계하는 경우에는 group by를 쓰지 않 

---------- More Example) 집계함수의 종류 ----------
sum
min
max
avg

---------- group by + where 예시 ----------
select category, yyyy, sum(gmv) as gmv
from gmv_trend
where category  = '컴퓨터 및 주변기기'  --where은 반드시 from 뒤에 나와야 
group by 1,2

---------------------------------- 4)매출이 높은 주요 카테고리만 확인하기 ----------------------------------
select category , sum(gmv) as gmv
from gmv_trend
group by 1
having sum(gmv) >= 10000000

---------- More Example) where절이랑 같이 쓰기 ----------
select category , sum(gmv) as gmv
from gmv_trend
where yyyy = 2020
group by 1
having sum(gmv) >= 10000000

------------------- having where의 차이는? -------------------
-- where절은 "집계 전" 데이터를 필터링 / 집계함수가 올 수 없다.
-- having절은 "집계 후" 데이터를 필터링  / 집계함수만 올 수 있다.
------------------------------------------------------------


---------------------------------- 5) 매출이 높은 순으로 카테고리 정렬하기 ----------------------------------
select *
from gmv_trend
order by category, yyyy, mm, platform_type  -- 정렬하겠다.

---------- 매출액이 높은 순 정렬 ----------
select category, sum(gmv) as gmv
from gmv_trend
group by 1
order by gmv desc 

---------- 내림차순 Example ----------
select category,yyyy, sum(gmv) as gmv
from gmv_trend
group by 1,2
order by 1 desc,2 desc --특정 컬럼 다음에 desc를 붙여주면 

---------- [추가 예제 1] 복수의 컬럼으로 정렬 ----------
select yyyy, mm, sum(gmv) as gmv
from gmv_trend
group by 1,2
order by 3 desc

---------- [추가 예제 2] select 절에 없는 컬럼으로 정렬 가능할까? -> 불가능 ----------

select yyyy, sum(gmv) as gmv
from gmv_trend
group by yyyy
order by mm  -- 반드시 select절에 있는 컬럼을 선택해야 