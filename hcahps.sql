with hospital_bed_prep as 
(
SELECT 
	Lpad(CAST(provider_ccn AS varchar),6,'0') as provider_ccn,
	hospital_name, 
	to_date(fiscal_year_begin_date, 'MM/DD/YYYY') as fiscal_years_begin_date,  
	to_date(fiscal_year_end_date, 'MM/DD/YYYY') as fiscal_years_end_date,
	number_of_beds,
	row_number () over (partition by Lpad(CAST(provider_ccn AS varchar),6,'0') order by to_date(fiscal_year_end_date, 'MM/DD/YYYY') ) as nth
FROM hospital_data.hospital_beds
)


SELECT Lpad(CAST(facility_id AS varchar),6,'0') as facility_id,
	to_date(start_date, 'MM/DD/YYYY') as start_date,  
	to_date(end_date, 'MM/DD/YYYY') as end_date,
	*
FROM hospital_data.hcahps_data as hcahps
left join hospital_bed_prep as beds
on Lpad(CAST(facility_id AS varchar),6,'0') = Lpad(CAST(provider_ccn AS varchar),6,'0') 
and beds.nth = 1;


