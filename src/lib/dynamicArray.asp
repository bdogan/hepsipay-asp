<%
Class oDynamicArray
	
	Private pCollection()
	
	' Constructor
	Public Sub Class_Initialize
		ReDim pCollection(-1)
	End Sub
	
	' Destructor
	Public Sub Class_Terminate
		Dim i
		For i = 0 to UBOUND(pCollection) 
			If (IsObject(pCollection(i))) Then Set pCollection(i) = Nothing
		Next
	End Sub
	
	Public Property Get Count
		Count = UBOUND(pCollection) + 1
	End Property
	
	Public Sub Add(pValue)
		ReDim Preserve pCollection(Count)
		If (IsObject(pValue)) Then
			Set pCollection(UBOUND(pCollection)) = pValue
		Else 
			pCollection(UBOUND(pCollection)) = pValue
		End If
	End Sub
	
	Public Default Property Get Item(pKey)
		If (IsObject(pCollection(pKey))) Then 
			Set Item = pCollection(pKey)
		Else
			Item = pCollection(pKey)
		End If
	End Property
	
	Public Property Get IsSet(pKey)
		IsSet = (Me.Count > pKey)
	End Property
	
End Class

%>