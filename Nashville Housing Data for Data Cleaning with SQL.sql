/*

Cleaning Data in SQL Queries

*/

select *
from PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format: changing the SaleDate

select SaleDate, CONVERT(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing


update PortfolioProject.dbo.NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)


-- If it doesn't Update properly

ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
Add SaleDate2 Date;

update PortfolioProject.dbo.NashvilleHousing
set SaleDate2= CONVERT(Date, SaleDate)

-- Check if it create it properly
select SaleDate2, CONVERT(Date, SaleDate)
from PortfolioProject.dbo.NashvilleHousing




 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null


Select*
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- add it in a db

update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- check it
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

-- our delimiter is a comma (,)

select PropertyAddress,
CHARINDEX(',', PropertyAddress) as Adress    --return the number of character(of PropertyAdress: from 1 to 20) of each row up to ','
from PortfolioProject.dbo.NashvilleHousing

select PropertyAddress,
CHARINDEX(',', PropertyAddress)-1 as Adress    --return the number of character(of PropertyAdress: from 1 to 19) of each row before ',': this correspond to the number of character of the 'Adress'
from PortfolioProject.dbo.NashvilleHousing

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Adress --return the string of PropertyAddress, with index from 1 to CHARINDEX(',', PropertyAddress)-1): this is the 'Adress'
from PortfolioProject.dbo.NashvilleHousing


-- separating PropertyAdress into Adress and City
select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Adress
, SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City

from PortfolioProject.dbo.NashvilleHousing

--creating 2 news columns and add the values above in

---------the Adress

ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAdress nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set PropertySplitAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


---------the city

ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) 


-------- check the new variables

select *
from PortfolioProject.dbo.NashvilleHousing


--------- AN easy way for creating these new variables

-----Take a look at the owner adress

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select OwnerAddress,
REPLACE(OwnerAddress, ',', '.')       -- replace in OwnerAdress the ',' by '.'
from PortfolioProject.dbo.NashvilleHousing


select OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)       --return the 1st string from the right of 'OwnerAdress' after '.', which is the 'State' in this case
from PortfolioProject.dbo.NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)       --Adress
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)      -- City
, PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)      -- State
from PortfolioProject.dbo.NashvilleHousing

---------the Adress

ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAdress nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set PropertySplitAdress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)



---------the City

ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)



---------the State

ALTER TABLE  PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState nvarchar(255);

update PortfolioProject.dbo.NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) 


-------- check the new variables

select *
from PortfolioProject.dbo.NashvilleHousing





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

---------------it contains at the same time Y, N, Yes and NO

select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2



-----------replacing Y by Yes and N by No

select SoldAsVacant
, CASE when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant         --keep it as it is
	   end
from PortfolioProject.dbo.NashvilleHousing


----add it the new variable with only Yes and No

Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant         --keep it as it is
	   end


-------Let's check it
select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2








-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

-----find where there are duplicates values

-------creating a CTE with variables that should be unique usually
WITH RowNumCTE AS(
select *,
     ROW_NUMBER() OVER(
	 PARTITION BY  ParcelID,          -- partition on variables that should be unique usually
				   PropertyAddress,
				   SalePrice,
				   LegalReference
				   ORDER BY 
						UniqueID
						) row_num

from PortfolioProject.dbo.NashvilleHousing
)
select *                 --printing duplicated rows
from RowNumCTE 
where row_num > 1       --selecting duplicated rows from the table RowNumCTE
order by PropertyAddress



----deleting duplicated rows

WITH RowNumCTE AS(
select *,
     ROW_NUMBER() OVER(
	 PARTITION BY  ParcelID,          -- partition on variables that should be unique usually
				   PropertyAddress,
				   SalePrice,
				   LegalReference
				   ORDER BY 
						UniqueID
						) row_num

from PortfolioProject.dbo.NashvilleHousing
)
DELETE                --deleting duplicated rows
from RowNumCTE 
where row_num > 1       
--order by PropertyAddress



---checking if we delete all duplicated rows: ok as none is printed now
WITH RowNumCTE AS(
select *,
     ROW_NUMBER() OVER(
	 PARTITION BY  ParcelID,          -- partition on variables that should be unique usually
				   PropertyAddress,
				   SalePrice,
				   LegalReference
				   ORDER BY 
						UniqueID
						) row_num

from PortfolioProject.dbo.NashvilleHousing
)
select *                 --printing duplicated rows
from RowNumCTE 
where row_num > 1       --selecting duplicated rows from the table RowNumCTE
order by PropertyAddress




select *
from PortfolioProject.dbo.NashvilleHousing



------Advise: don't remove duplicated rows from our data usually.

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


select *
from PortfolioProject.dbo.NashvilleHousing


--- deleting the columns OwnerAddress, TaxDistrict, PropertyAddress 

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate

----checking if we deleted them

select *
from PortfolioProject.dbo.NashvilleHousing




------------------------------------------------------------------------------------------------------------------------------------------------------------

---Exporting the cleaned data

select *
from PortfolioProject.dbo.NashvilleHousing

--Copy and paste the table into an Excel file and save it.











-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO




