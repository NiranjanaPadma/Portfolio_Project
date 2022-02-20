

select * from Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning

--Changing the date format to standard one by removing the time values appended with date

update Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning
set SaleDate=convert(date,SaleDate)

--Trying to fill in the NULL value of PropertyAddress by checking for duplicate entry with the same ParcelId (using self join) 

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
from Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning a 
join Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning b
on a.ParcelId=b.ParcelId AND a.UniqueID<>b.UniqueID
where a.ParcelID IS NULL

update a
set a.PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress) --if a.propertyaddress is null,then replace it with b.propertyaddress
from Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning a 
join Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning b
on a.ParcelId=b.ParcelId AND a.UniqueID<>b.UniqueID


select * from Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning

--Splitting the OwnerAddress ,city,and state from the combined one 

select parsename(replace(OwnerAddress,',','.'),3), --parsename parses from right to left ,hence to get leftmost part of the combined owneraddress first ,we give 3 
      parsename(replace(OwnerAddress,',','.'),2),
      parsename(replace(OwnerAddress,',','.'),1)
from Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning 

-- Adding three new columns for address , city and state respectively

alter table Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning
add owners_updated_address nvarchar(50)

alter table Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning
add city nvarchar(50)

alter table Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning
add state nvarchar(50)


--Updating the columns with the split address,city and state

update Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning
set owners_updated_address= parsename(replace(OwnerAddress,',','.'),3)

update Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning
set city= parsename(replace(OwnerAddress,',','.'),2)

update Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning
set state= parsename(replace(OwnerAddress,',','.'),1)

select * from Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning

--Dealing with incorrectly typed data (in our table some entries have Yes and some have Y but basically both are the same)

select SoldAsVacant,
CASE
	WHEN SoldasVacant='Y' then 'Yes'
	WHEN SoldasVacant='N' then 'No'
	ELSE
	SoldasVacant
END
from  Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning


update Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning
set SoldAsVacant= CASE
	WHEN SoldasVacant='Y' then 'Yes'
	WHEN SoldasVacant='N' then 'No'
	ELSE
	SoldasVacant
END

--Removing duplicates using Rownumber function 
 
	with ownersCTE as (
		select *,
		row_number() over(
		partition by ParcelID,PropertyAddress,
					 SalePrice,
					 SaleDate
		order by UniqueID) rnum
		from Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning
		)

		select * 
		from ownersCTE 
		where rnum>1
		order by PropertyAddress
		
		delete from Nir_PortfolioProject.dbo.Nashville_Housing_Data_for_Data_Cleaning
		where 
		rnum >1

		
