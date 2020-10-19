# Solution 1
SELECT  
	  innerquery.customer_id
	, innerquery.claim_datetime
	, innerquery.claim_amount 
FROM  ( SELECT 
					customer_id
					, claim_datetime
					, claim_amount 
					, row_number() over(partition by customer_id order by claim_datetime desc) as rownum
FROM claim) as innerquery
where innerquery.rownum = 1;




# Solution 2
SELECT
 innerquery.province
,innerquery.average_balance_per_province
 FROM(
	SELECT
		 cci.account_number
         ,cci.province
		,AVG(balance) OVER (PARTITION BY province) AS average_balance_per_province
	FROM customer_contact_info  AS cci
	LEFT JOIN customer_status AS cs
	ON cci.account_number = cs.account_number
	WHERE cs.status != 'CLOSED'
    )  as innerquery
order by innerquery.average_balance_per_province DESC
LIMIT 1;



#Solution 3
WITH 
crew_CTE AS(
	SELECT 
	  fs.emp_id
	, fs.date
	, fs.destination
	, fs.flight_number
	, sm.last_name
	, sm.first_name
	, sm.state
	, pm.job_code
	, substring(pm.job_code,1,2) as filterd_jobcode
	FROM test.flight_schedule as fs
	LEFT JOIN test.staff_master as sm
		ON fs.emp_id = sm.emp_id
	LEFT JOIN payroll_master as pm
		ON fs.emp_id = pm.emp_id
), 
supervisors_CTE AS (
SELECT 
	  sv.emp_id
	, sv.job_category
	, sm.last_name
	, sm.first_name
	, sm.state
FROM test.supervisors as sv
LEFT JOIN test.staff_master as sm
	ON sv.emp_id = sm.emp_id
)
 SELECT 
	  cw_CTE.last_name as 'CM_Last_Name'
    , cw_CTE.first_name as 'CM_First_Name'
    , cw_CTE.state as  'CM_State'
	, sp_CTE.last_name as 'Supervisor_Last_Name'
    , sp_CTE.first_name as 'Supervisor_Last_Name'
    , sp_CTE.state as 'Supervisor_State'
FROM crew_CTE as cw_CTE
LEFT JOIN supervisors_CTE as sp_CTE
 ON( cw_CTE.state = sp_CTE.state AND  
       cw_CTE.filterd_jobcode = sp_CTE.job_category)
WHERE cw_CTE.destination = 'CPH' AND cw_CTE.date = 'March 4, 2013'
 

