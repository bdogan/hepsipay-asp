<%

Class cHepsiPayCard

	Public CardHolderName
	Public CardNumber
	
	Public SecurityCode
	
	Private pExpireMonth
	Public Property Get ExpireMonth
		ExpireMonth = pExpireMonth
		If (IsEmpty(ExpireMonth)) Then Exit Property
		If (ExpireMonth < 1 OR ExpireMonth > 12) Then 
			ExpireMonth = Empty
			Exit Property
		End If
		ExpireMonth = CStr(ExpireMonth)
		If (Len(ExpireMonth) = 1) Then ExpireMonth = "0" & ExpireMonth
	End Property
	Public Property Let ExpireMonth(value)
		Dim typeNumber : typeNumber = VarType(value)
		
		If (typeNumber = 2 OR typeNumber = 3) Then
			pExpireMonth = value
			Exit Property
		ElseIf (typeNumber = 0 OR typeNumber = 1 OR typeNumber = 9 OR typeNumber = 8192) Then
			pExpireMonth = Empty
			Exit Property
		ElseIf (typeNumber = 8 OR typeNumber = 4 OR typeNumber = 5 OR typeNumber = 6) Then
			If (IsNumeric(value)) Then
				pExpireMonth = CInt(value)
			Else
				pExpireMonth = Empty
			End If
			Exit Property
		End If
		
		pExpireMonth = Empty
	End Property
	
	
	Private pExpireYear
	Public Property Get ExpireYear
		ExpireYear = pExpireYear
		If (IsEmpty(ExpireYear)) Then Exit Property
		ExpireYear = Right(CStr(ExpireYear), 2)
	End Property
	Public Property Let ExpireYear(value)
		Dim typeNumber : typeNumber = VarType(value)
		
		If (typeNumber = 2 OR typeNumber = 3) Then
			pExpireYear = value
			Exit Property
		ElseIf (typeNumber = 0 OR typeNumber = 1 OR typeNumber = 9 OR typeNumber = 8192) Then
			pExpireYear = Empty
			Exit Property
		ElseIf (typeNumber = 8 OR typeNumber = 4 OR typeNumber = 5 OR typeNumber = 6) Then
			If (IsNumeric(value)) Then
				pExpireYear = CInt(value)
			Else
				pExpireYear = Empty
			End If
			Exit Property
		End If
		
		pExpireYear = Empty
	End Property
	
	Public Property Get toDict
		Set toDict = Server.CreateObject("Scripting.Dictionary")
		If (NOT IsEmpty(Me.CardHolderName)) Then toDict.Add "CardHolderName", Me.CardHolderName
		If (NOT IsEmpty(Me.CardNumber)) Then toDict.Add "CardNumber", Me.CardNumber
		If (NOT IsEmpty(Me.ExpireYear)) Then toDict.Add "ExpireYear", Me.ExpireYear
		If (NOT IsEmpty(Me.ExpireMonth)) Then toDict.Add "ExpireMonth", Me.ExpireMonth
		If (NOT IsEmpty(Me.SecurityCode)) Then toDict.Add "SecurityCode", Me.SecurityCode
	End Property
	
End Class
%>