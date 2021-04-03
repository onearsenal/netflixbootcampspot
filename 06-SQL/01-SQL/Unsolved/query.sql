-- Select all the employees who were born between January 1, 1952 and December 31, 1955 and their titles and title date ranges
-- Order the results by emp_no

with about_to_retire as (select * from employees 
where birth_date between '1952-01-01' and '1955-12-31')
select  about_to_retire.emp_no, 
		about_to_retire.first_name,
		about_to_retire.last_name,
		about_to_retire.birth_date,
		titles.title,
		titles.from_date,
		titles.to_date
		from about_to_retire join titles 
		on about_to_retire.emp_no=titles.emp_no
		order by emp_no;
        
-- Select only the current title for each employee

with emp_history as (
with about_to_retire as (select * from employees 
where birth_date between '1952-01-01' and '1955-12-31')
	
select  about_to_retire.emp_no, 
		about_to_retire.first_name,
		about_to_retire.last_name,
		about_to_retire.birth_date,
		titles.title,
		titles.from_date,
		titles.to_date
		from about_to_retire join titles 
		on about_to_retire.emp_no=titles.emp_no
		order by emp_no),
		
latest_emp as (
select emp_no, max(from_date) as most_recent from titles group by emp_no)

select emp_history.emp_no, emp_history.first_name, emp_history.last_name, emp_history.title as current_title from emp_history join latest_emp on ((emp_history.emp_no=latest_emp.emp_no) and (emp_history.from_date=latest_emp.most_recent));



-- Count the total number of employees about to retire by their current job title

with latest_title as (
with emp_history as (
with about_to_retire as (select * from employees 
where birth_date between '1952-01-01' and '1955-12-31')
	
select  about_to_retire.emp_no, 
		about_to_retire.first_name,
		about_to_retire.last_name,
		about_to_retire.birth_date,
		titles.title,
		titles.from_date,
		titles.to_date
		from about_to_retire join titles 
		on about_to_retire.emp_no=titles.emp_no
		order by emp_no),
		
latest_emp as (
select emp_no, max(from_date) as most_recent from titles group by emp_no)

select emp_history.emp_no, emp_history.first_name, emp_history.last_name, emp_history.title as current_title from emp_history join latest_emp on ((emp_history.emp_no=latest_emp.emp_no) and (emp_history.from_date=latest_emp.most_recent)))

select current_title, count (*) as emp_cnt from latest_title group by current_title;


-- Count the total number of employees per department
with cnt_by_dept as(
select dept_no, count(emp_no) as emp_cnt from dept_emp group by dept_no )
select dept_name, cnt_by_dept.emp_cnt from departments join cnt_by_dept on (departments.dept_no=cnt_by_dept.dept_no);


-- Bonus: Find the highest salary per department and department manager

--Highest salary per department manager
with latest_manager_salaries as (
with latest_salaries as (
with latest_emp as( 
select emp_no,
		max(from_date) as latest_appt 
		from salaries group by emp_no)
select latest_emp.*, 
		salaries.salary 
		from salaries join latest_emp 
		on salaries.emp_no=latest_emp.emp_no 
		and salaries.from_date=latest_emp.latest_appt
		order by emp_no),

current_managers as(
select dept_no, emp_no, from_date from dept_manager where to_date= '9999-01-01')
	
select current_managers.dept_no, 
		latest_salaries.emp_no, 
		latest_salaries.salary 
		from current_managers join
		latest_salaries on current_managers.emp_no=latest_salaries.emp_no)
select max(salary) from latest_manager_salaries


--Highest salary per department
with latest_emp_salaries as (
with latest_emp_date as(
with latest_emp as (select emp_no, max(from_date) as from_date from dept_emp group by emp_no)
select latest_emp.emp_no, 
		latest_emp.from_date, 
		dept_emp.dept_no
		from latest_emp join dept_emp 
		on latest_emp.emp_no=dept_emp.emp_no
			and dept_emp.from_date=latest_emp.from_date)
			select latest_emp_date.emp_no,
					latest_emp_date.dept_no,
					salaries.salary
					from latest_emp_date join salaries
					on latest_emp_date.emp_no=salaries.emp_no
					and latest_emp_date.from_date=salaries.from_date
					order by emp_no)
		select dept_no, 
				max(salary) as highest_salary from
				latest_emp_salaries
				group by dept_no
				order by dept_no 