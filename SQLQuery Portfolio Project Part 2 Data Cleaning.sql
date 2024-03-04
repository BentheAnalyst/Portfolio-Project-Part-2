--Project 3 - Data Cleaning

Select *
From NashvilleHousing

--Standardize Date Format

Select SaleDateConverted, convert(Date,saledate)
From NashvilleHousing

Update NashvilleHousing
Set SaleDate = convert(Date,saledate)

Alter Table NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
Set SaleDateConverted = convert(Date,saledate)


--Populate Property Address date

Select *
From NashvilleHousing
--where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set propertyaddress = isnull(a.propertyaddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address into Individual columns (Address,City,State)

Select PropertyAddress
From NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

Select
SUBSTRING(Propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address  
,SUBSTRING(Propertyaddress, CHARINDEX(',', propertyaddress)+1, len (propertyaddress)) as Address  

From NashvilleHousing

--Now we can't separate two values from one column without creating two other columns. So we are going to create two new columns
 
Alter Table NashvilleHousing
Add propertysplitAddress nvarchar(255)

Update NashvilleHousing
Set propertysplitAddress = SUBSTRING(Propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) 


Alter Table NashvilleHousing
Add propertysplitCity nvarchar(255)

Update NashvilleHousing
Set propertysplitCity = SUBSTRING(Propertyaddress, CHARINDEX(',', propertyaddress)+1, len (propertyaddress))  

Select *
from NashvilleHousing





Select OwnerAddress
from NashvilleHousing





Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousing




Alter Table NashvilleHousing
Add ownersplitAddress nvarchar(255)

Update NashvilleHousing
Set ownersplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


Alter Table NashvilleHousing
Add ownersplitCity nvarchar(255)

Update NashvilleHousing
Set propertysplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

Alter Table NashvilleHousing
Add ownersplitstate nvarchar(255)

Update NashvilleHousing
Set ownersplitstate = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


Select *
From NashvilleHousing

--Change Y and N to Yes and No in 'Sold as Vacant' field


 Select Distinct (SoldAsVacant), count(SoldAsVacant)
 from NashvilleHousing
 Group by SoldAsVacant
 order by 2

 Select SoldAsVacant
 ,Case when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
end
From NashvilleHousing

Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' THEN 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
end



--Remove Duplicates

WITH ROWNUMCTE AS(
Select *,
ROW_NUMBER() over ( 
Partition BY ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by
			UniqueID
			) row_num

from NashvilleHousing
)
Select *
from ROWNUMCTE
WHERE row_num > 1
--ORDER BY PropertyAddress



--Delete Unused Columns

Select *
FROM NashvilleHousing

Alter Table NashvilleHousing
Drop column owneraddress, TaxDistrict, Propertyaddress

Alter Table NashvilleHousing
Drop column saledate






Select *
from NashvilleHousing
