--실습 2) 주문 데이터 분석
--2021년 6월 1일 하루동안의 주문 건
--실제 존재하는 패션 이커머스 데이터라고 생각하고 분석을 진행해 주세요! 


--1. 데이터 탐색

--a) 주문 테이블
select *
from online_order

--b) 상품 테이블
select *
from item

--c) 카테고리 테이블
select *
from category

--d) 유저 테이블
select *
from user_info

--2. TOP 상품의 매출 확인

--상품별 매출액 집계 후, 매출액 높은 순으로 정렬하기
select itemid, sum(gmv) as gmv
from online_order
group by 1
order by 2 desc
	
--상품이름을 상품ID와 나란히 놓아서 한눈에 상품별 매출액을 확인할 수 있도록 하자.
select itemid, item_name, sum(gmv) as gmv
from online_order as oo
join item as i on oo.itemid = i.id
group by 1,2


--추가질문: 카테고리별 매출액은 어떻게 될까?

--Join 테이블에 Join을 한번더
select c.cate1, sum(gmv) as gmv
from online_order oo
join item i on oo.itemid = i.id
join category c on i.category_id = c.id
group by 1
order by 2 desc

--추가질문: 성/연령별 매출액은 어떻게 될까?
select ui.gender, sum(gmv) as gmv, count(distinct oo.userid) as user_cnt
from online_order oo
join user_info ui  on oo.userid = ui.userid 
group by 1
order by 2 desc
;
select ui.age_band, sum(gmv) as gmv, count(distinct oo.userid) as user_cnt
from online_order oo
join user_info ui  on oo.userid = ui.userid 
group by 1
order by 2 desc
;

--3. 카테고리별 주요 상품의 매출 확인
select c.cate3, c.cate2, c.cate1, i.item_name, sum(gmv) as gmv, sum(unitsold) as unitsold, 
sum(gmv) / sum(unitsold) as price
from online_order oo
join item i on oo.itemid = i.id
join category c on i.category_id = c.id
group by 1,2,3,4
order by 1, 5 desc

--추가질문: 남성이 구매하는 아이템은 어떤 것이 있을까?
select item_name, cate1, sum(gmv) as gmv, sum(unitsold) as unitsold
from online_order oo
join item i on oo.itemid = i.id
join category c on i.category_id = c.id
join user_info ui on oo.userid = ui.userid 
where ui.gender = 'M'
group by 1,2
;