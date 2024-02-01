CREATE DATABASE university;
USE university;

CREATE TABLE students (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    major VARCHAR(50)
);

-- 1.
insert into students values( 101, "John Smith,",20,"Computer Science");
-- 2.
select * from students;
-- 3.
update students set age=21 where id=101;
-- 4.
delete from students where id=101;
-- 5.
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50),
    credits INT
);
-- 6. 
insert into courses values( 201, "Database Managment",3);
-- 7. 
select * from courses;
-- 8. 
 update courses set course_name="Advanced Database Management." where course_id=201;
-- 9. 
Delete from courses where course_id=201;
-- 10. 
select * from students where major="Computer Science";


-- 1. 
select name from students;
-- 2. 
select name,age from students;
-- 3. 
select name,age,major from students where age<=20;
-- 4.
select course_name,credits from courses;
-- 5. 
select course_name,credits from courses where credits>3;
-- 6.
select name,course_name from students join courses on id=course_id;
-- 7.
 select name,course_name from students join courses on id=course_id group by id having count(*)>1;
 -- 8.
 select name,count(*) from students join courses on id=course_id group by id order by count(*) desc;
 -- 9. 
 select avg(age) from students;
 -- 10.
 select major,count(*) from students group by major order by count(*) desc;
 
 
 -- 1.
 select name,course_name from students join courses on id=course_id or id!=course_id;
 -- 2.
  select name,course_name from students join courses on id=course_id group by id having count(*)>1;
-- 3.
select name,coalesce(course_name,"Not Enrolled") from students left join courses on id = course_id;
-- 4.
select name,course_name from students join courses on id!=course_id;
-- 5.
select name,count(*) from students left join courses on id=course_id group by id;
-- 6.
select name,count(*) from students join courses on id=course_id group by id having count(*)>1;
-- 7.
select name,course_name from students join courses on id=course_id order by name;
-- 8.
select name,course_name from students join courses on id=course_id order by course_name;
-- 9.
select name,course_name from students join courses on id=course_id order by course_name,name;
-- 10. 
select name,major,course_name from students join courses on id=course_id or id!=course_id;


-- 1. 
select name from students where major in (select major from students where id=101);
-- 2.
select name from students where major not in (select major from students where id=101);
-- 3. 
select course_name from courses where count(*) > (select count(*) from courses where course_id=201) group by count(*);
-- 4.
select name from students where id not in (select course_id from courses where course_id=102);
-- 5. 
select name from students where id in ( select course_id from courses where credits > 3);
-- 6. 
select course_name from courses where course_id in (select id from students where count(*) > 1 group by id);
-- 7.
select name,count(*) from students where id in (select course_id from courses) group by id;
-- 8.
select name,count(*) from students where id in (select course_id from courses) group by id order by count(*) desc;
-- 9.
select name from students where major in ( select major from students where id=102) and id in (select course_id from students where credits>2);
-- 10.
select name from students where id not in ( select course_id  from courses);

-- 1.
select count(*) from students;
-- 2. 
select avg(age) from students;
-- 3.
select count(*) from courses;
-- 4. 
select sum(credits) from courses;
-- 5.
select max(age) from students;
-- 6.
select min(age) from students;
-- 7.
select distinct(major),count(*) from students group by major;
-- 8. 
select avg(credits) from courses;
-- 9. 
select count(*) from students where id in (select course_id  from courses);
-- 10.
select sum(credits) from courses;

-- 1.
select name,case
				when age>=25 then  "Adult"
                when age>=18 and age <=25 then "Young Adult"
                when age < 18 then "Minor"
			end
            from students;
-- 2.
select distinct(course_name),case 
						when sum(credits) <=3 then "Easy"
                        when sum(credits) >3 then "Difficult"
					end
                    from students group by course_name;
-- 3.
select name,course_name,"Not Enrolled" from students where id not in (select course_id from courses);
-- 4.
select name,case 
				when count(*) >= 1 then "Yes"
                else "NO"
			end
            from students where major="Computer Science" group by id;
-- 5. 
select avg(age) as avg_age,case 
								when avg_age < 20 then "Below 20"
                                when avg_age >= 20 and avg_age <=25 then  "20-25"
                                else "Above 25"
							end
                            from students;
-- 6. 
select course_name,case 
					   when course_id in (select id from students) then count(*)
                       else "Not Enrolled"
					end
                    from courses group by course_id;
-- 7. 
select distinct(name),count(*) from students where id in (select course_id from courses) group by id having count(*) > 1;
-- 8. 
select name,case when
					course_name is not null then course_name
                    else "Not Enrolled"
			end
            from students left join courses on id=course_id;
-- 9. 
select major,case when
					sum(credits) is not null then sum(credits)
                    else "No credits"
				end
                from students left join courses on id=course_id;
-- 10. 
select name,case when 
					age >=25 then "Senior"
                    when age>=20 and age<=25 then "Junior"
                    when age>=18 and age<=20 then "Sophomore"
                    else "Freshman"
				 end
                 from students;

-- 1. 
insert into students values(104, "Sarah Johnson",22,"Biology");
-- 2.
update students set age=24 where major="Computer Science";
-- 3.
delete from courses where credits<3;
-- 4.
insert into courses values(304, "Data Analysis",4);
-- 5.
update courses set course_name="Database Managment" where course_id=201;
-- 6. 
delete from students where id=301;
-- 7. 
update students set major="Computer Engineering" where id=101;
-- 8. 
insert into courses values(302, "Data Science",3);
-- 9. 
update courses set credits=2 where course_id=202;
-- 10. 
delete from students where id not in(select course_id from courses);


-- 1.
create view Computer_Science_students as select name,age from students where major="Computer Science";
-- 2. 
create view Course_Information as select course_name,credits from courses;
-- 3. 
create view Enrolled_Students as select case when count(*)>1 then (name,major) end from students join courses on id=course_id;
-- 4.
create view Course_Enrollment_Count as select distinct(course_name),count(*) from courses join students on course_id=id group by course_name;
-- 5. 
create view Major_Average_Age as select distinct(major),avg(age) from students group by major;

-- 1.
select rank() over(order by age) from students;
-- 2.
select avg(age) over() from students;
-- 3. 
select sum(credits) over(partition by course_name order by credits desc) from courses;
-- 4. 
select max(age) over(partition by major) from students;
-- 5.
select max(age) over(partition by major) from students where age not in (select max(age) from students);
-- 6. 
select row_number() over(order by age desc) from students;
-- 7. 
select age-max(age) over(partition by major) from students;
-- 8. 
select (age*100)/avg(age) over(partition by major) from students;
-- 9. 
select avg(age) over(partition by major order by age rows between 1 preceding and 1 following) from students;
-- 10. 
select age,count(*) over(partition by major order by count(*) desc) from students group by age limit 1; 

