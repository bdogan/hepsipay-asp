<%

Class cHepsiPayCustomer

	Public Name
	Public Surname
	Public EMail
	Public IpAddress
	Public PhoneNumber
	Public Code
	Public TCKN
	Public VatNumber
	Public MemberSince
	Public BirthDate

	Public Property Get toDict
		Set toDict = Server.CreateObject("Scripting.Dictionary")
		If (NOT IsEmpty(Me.Name)) Then toDict.Add "Name", Me.Name
		If (NOT IsEmpty(Me.Surname)) Then toDict.Add "Surname", Me.Surname
		If (NOT IsEmpty(Me.EMail)) Then toDict.Add "EMail", Me.EMail
		If (NOT IsEmpty(Me.IpAddress)) Then toDict.Add "IpAddress", Me.IpAddress
		If (NOT IsEmpty(Me.PhoneNumber)) Then toDict.Add "PhoneNumber", Me.PhoneNumber
		If (NOT IsEmpty(Me.Code)) Then toDict.Add "Code", Me.Code
		If (NOT IsEmpty(Me.TCKN)) Then toDict.Add "TCKN", Me.TCKN
		If (NOT IsEmpty(Me.VatNumber)) Then toDict.Add "VatNumber", Me.VatNumber
	End Property
	
End Class

%>