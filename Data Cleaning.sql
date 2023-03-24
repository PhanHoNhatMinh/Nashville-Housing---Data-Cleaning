-- Cleaning Data in SQL Queries


Select Top 1000 *
From NashvilleHousing

-----------------------------------------------------------------------------

-- Standardize Data Format

Select Saledate, Convert(Date,Saledate)
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = Convert(Date,Saledate)

Select SaleDateConverted
From NashvilleHousing






-----------------------------------------------------------------------------

-- Populate Property Address Data

Select PropertyAddress
From NashvilleHousing
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is NULL

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is NULL





-----------------------------------------------------------------------------

-- Breaking out Address into Individual Colummns (Address, City, State)

Select PropertyAddress
From NashvilleHousing

Select
Substring(PropertyAddress, 1, charindex(',',PropertyAddress) -1) as Address
, Substring(PropertyAddress, charindex(',',PropertyAddress) +2, Len(PropertyAddress)) as City
From NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertyAddressFixed Nvarchar(255)

Update NashvilleHousing
SET PropertyAddressFixed = Substring(PropertyAddress, 1, charindex(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertyCityFixed Nvarchar(255)

Update NashvilleHousing
SET PropertyCityFixed = Substring(PropertyAddress, charindex(',',PropertyAddress) +2, Len(PropertyAddress))


Select Top 1000 *
From NashvilleHousing



Select OwnerAddress
From NashvilleHousing


---------------------------------------------------
Select
Parsename(Replace(OwnerAddress, ',', '.'), 3)
,Parsename(Replace(OwnerAddress, ',', '.'), 2)
,Parsename(Replace(OwnerAddress, ',', '.'), 1)
From NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitAddress = Parsename(Replace(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitCity = Parsename(Replace(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
SET OwnerSplitState = Parsename(Replace(OwnerAddress, ',', '.'), 1)





Select Top 1000*
From NashvilleHousing


-----------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
	   When SoldAsVacant = 'N' Then 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------

-- Remove Duplicates



WITH RowNumCTE as (
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From NashvilleHousing

)
SELECT*
FROM RowNumCTE
WHERE Row_num > 1 
--ORDER BY PropertyAddress

SELECT*
FROM NashvilleHousing





-----------------------------------------------------------------------------

-- Delete Unused Columns



Select*
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate