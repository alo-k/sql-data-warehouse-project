/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

--- First Table --- 
-- Check for nulls and duplicates in primary keys
-- Expectation - No result

SELECT * FROM silver.crm_cust_info;
SELECT 
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL;

--- Check for Unwanted Spaces ---
-- Expectation - No result
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

--- Check for Unwanted Spaces ---
-- Expectation - No result
SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

--- Check for Unwanted Spaces ---
-- Expectation - No result
SELECT cst_gndr
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

--- Check for Unwanted Spaces ---
-- Expectation - No result
SELECT cst_key
FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key);

--- DATA Standardization & consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;

--- DATA Standardization & consistency
SELECT DISTINCT cst_martial_status
FROM silver.crm_cust_info;

--- 2nd Table ---

SELECT * FROM silver.crm_prd_info;
SELECT 
	prd_id,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1 OR prd_id IS NULL;

--- Check for Unwanted Spaces ---
-- Expectation - No result
SELECT prd_nm
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

--- Check for Nulls or Negative Numbers
--- Expectation: No results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--- Data Standardization & consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

--- Check for Invalid Date orders ---
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

--- 3rd Table ---

SELECT * FROM silver.crm_sales_details;
--- Checking if trim or not ---
SELECT * FROM silver.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num) 

--- Checking wether we can connect sales with customer ---
SELECT * FROM silver.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);


--- Check for Invalid date orders ---
SELECT * FROM
silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

--- Check Data consistency: Between Sales, Quantity and Price
--->> Sales = Quantity*Price
--->> Values must not be null, zero or negative.

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0  OR sls_quantity <= 0 OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price;

--- 4th Table ---

--- Identify Out of range Dates ---
SELECT 
bdate
FROM silver.erp_cust_az12
WHERE bdate > GETDATE()  

--- Data Standardization and consistency ---
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

SELECT * FROM silver.erp_cust_az12;

--- 5th Table ---
--- Data Standardization and consistency ---
SELECT DISTINCT 
cntry FROM silver.erp_loc_a101
ORDER BY cntry;

SELECT * FROM silver.erp_loc_a101;

--- 6th Table ---
-- NO quality issue found ---
SELECT * FROM silver.erp_px_cat_g1v2;
