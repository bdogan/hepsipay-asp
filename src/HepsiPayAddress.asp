<%

Class cHepsiPayAddress

	Public Name
	Public Address
	Public Country
	Public CountryCode
	Public City
	Public CityCode
	Public ZipCode
	Public District
	Public DistrictCode
	Public ShippingCompany

	Public Property Get toDict
		Set toDict = Server.CreateObject("Scripting.Dictionary")
		If (NOT IsEmpty(Me.Name)) Then toDict.Add "Name", Me.Name
		If (NOT IsEmpty(Me.Address)) Then toDict.Add "Address", Me.Address
		If (NOT IsEmpty(Me.Country)) Then toDict.Add "Country", Me.Country
		If (NOT IsEmpty(Me.CountryCode)) Then toDict.Add "CountryCode", Me.CountryCode
		If (NOT IsEmpty(Me.City)) Then toDict.Add "City", Me.City
		If (NOT IsEmpty(Me.CityCode)) Then toDict.Add "CityCode", Me.CityCode
		If (NOT IsEmpty(Me.ZipCode)) Then toDict.Add "ZipCode", Me.ZipCode
		If (NOT IsEmpty(Me.District)) Then toDict.Add "District", Me.District
		If (NOT IsEmpty(Me.DistrictCode)) Then toDict.Add "DistrictCode", Me.DistrictCode
		If (NOT IsEmpty(Me.ShippingCompany)) Then toDict.Add "ShippingCompany", Me.ShippingCompany
	End Property
	
End Class

%>