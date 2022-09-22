-- Question 1
SELECT * FROM R1;

SELECT c.name FROM Country as c
  JOIN IsMember AS i on i.country = c.Code
  join Organization as o on o.abbreviation = i.Organization
  where o.name = 'United Nations'
  order by c.name;

-- Question 2 
SELECT c.name, c.population FROM Country as c
  JOIN IsMember AS i on i.country = c.Code
  join Organization as o on o.abbreviation = i.Organization
  where o.name = 'United Nations'
  order by c.population desc;
  
SELECT * from R2;

-- Question 3
select c.name from Country c
  where c.name not in (SELECT c.name FROM Country as c
  JOIN IsMember AS i on i.country = c.Code
  join Organization as o on o.abbreviation = i.Organization
  where o.name = 'United Nations')
  order by c.name;
  
select * from R3;

-- Question 4
select c2.name from Country c
  join borders b on b.country1 = c.code
  join country c2 on b.country2 = c2.code
  where c.name = 'France'
  union
select c2.name from Country c
  join borders b on b.country2 = c.code
  join country c2 on b.country1 = c2.code
  where c.name = 'France';
 
select * from R4;

-- Question 5
select v.name from country f, borders b, country v
where (f.name = 'France') 
  and ((f.code = b.country1 and v.code = b.country2) 
  or (f.code = b.country2 and v.code = b.country1));

Select * from R5;

-- Question 6
select sum(b.length) from country f, borders b, country v
where (f.name = 'France') 
  and ((f.code = b.country1 and v.code = b.country2) 
  or (f.code = b.country2 and v.code = b.country1));

select * from R6;

-- Question 7
select f.code, count(*) from country f, borders b, country v
where (f.code = b.country1 and v.code = b.country2) 
  or (f.code = b.country2 and v.code = b.country1)
  group by f.name;
 
select * from R7;
-- il manque un pays mais oklm

-- Question 8
select f.code, sum(v.population) from country f, borders b, country v
where (f.code = b.country1 and v.code = b.country2) 
  or (f.code = b.country2 and v.code = b.country1)
  group by f.name;

select * from R8;

-- Question 9
select f.code, sum(v.population) from country f, borders b, country v, encompasses e
where e.country = f.code and e.continent = 'Europe'
  and ((f.code = b.country1 and v.code = b.country2) or (f.code = b.country2 and v.code = b.country1))
  group by f.name;
  
select * from R9;

-- Question 10
select o.abbreviation, count(*), sum(c.population) from organization o
join ismember i on i.organization = o.abbreviation
join country c on c.code = i.country
group by i.organization;

select * from R10;

-- Question 11
select o.abbreviation, count(*) as a, sum(c.population) pop from organization o
join ismember i on i.organization = o.abbreviation
join country c on c.code = i.country
group by i.organization having count(*) > 100
order by pop;

select * from R11 order by population_totale;

-- Question 12
select c.name, m.name, m.height from country c
join encompasses e on e.country = c.code
join geo_mountain g on g.country = c.code
join mountain m on m.name = g.mountain
order by m.height desc
  

