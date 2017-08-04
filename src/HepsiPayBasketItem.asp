<%
Class oHepsiPayBasketItem

	Public Description
	Public ProductCode
	
	Private pAmount
	Public Property Get Amount
		Amount = pAmount
		If (Not IsEmpty(Amount)) Then Amount = Int(Replace(FormatNumber(Amount, 2, 0, 0, 0), ",", ""))
	End Property
	Public Property Let Amount(value)
		Dim typeNumber : typeNumber = VarType(value)
		
		If (typeNumber = 2 OR typeNumber = 3) Then
			pAmount = value
			Exit Property
		ElseIf (typeNumber = 0 OR typeNumber = 1 OR typeNumber = 9 OR typeNumber = 8192) Then
			pAmount = Empty
			Exit Property
		ElseIf (typeNumber = 8) Then
			value = Replace(value, ".", "")
			If (NOT IsNumeric(value)) Then 
				pAmount = Empty
				Exit Property
			End If
			If (InStr(value, ",") > 0) Then
				pAmount = CDbl(value)
			Else
				pAmount = Int(value)
			End If
			Exit Property
		ElseIf (typeNumber = 4 OR typeNumber = 5 OR typeNumber = 6) Then
			pAmount = value
			Exit Property
		End If
		
		pAmount = Empty
	End Property
	
	Private pVatRatio
	Public Property Get VatRatio
		VatRatio = pVatRatio
		If (IsEmpty(VatRatio)) Then Exit Property
		If (VatRatio < 0) Then VatRatio = Empty
	End Property
	Public Property Let VatRatio(value)
		Dim typeNumber : typeNumber = VarType(value)
		
		If (typeNumber = 2 OR typeNumber = 3) Then
			pVatRatio = value
			Exit Property
		ElseIf (typeNumber = 0 OR typeNumber = 1 OR typeNumber = 9 OR typeNumber = 8192) Then
			pVatRatio = Empty
			Exit Property
		ElseIf (typeNumber = 8) Then
			If (NOT IsNumeric(value)) Then 
				pVatRatio = CInt(Empty)
			Else
				pVatRatio = Empty
			End If
			Exit Property
		ElseIf (typeNumber = 4 OR typeNumber = 5 OR typeNumber = 6) Then
			pVatRatio = CInt(value)
			Exit Property
		End If
		
		pVatRatio = Empty
	End Property
	
	Private pCount
	Public Property Get Count
		Count = pCount
		If (IsEmpty(Count)) Then Exit Property
		If (Count < 0) Then Count = Empty
	End Property
	Public Property Let Count(value)
		Dim typeNumber : typeNumber = VarType(value)
		
		If (typeNumber = 2 OR typeNumber = 3) Then
			pCount = value
			Exit Property
		ElseIf (typeNumber = 0 OR typeNumber = 1 OR typeNumber = 9 OR typeNumber = 8192) Then
			pCount = Empty
			Exit Property
		ElseIf (typeNumber = 8) Then
			If (NOT IsNumeric(value)) Then 
				pCount = CInt(Empty)
			Else
				pCount = Empty
			End If
			Exit Property
		ElseIf (typeNumber = 4 OR typeNumber = 5 OR typeNumber = 6) Then
			pCount = CInt(value)
			Exit Property
		End If
		
		pCount = Empty
	End Property
	
	Public Url
	Public BasketItemType
	Public BasketItemId
	
	Public Property Get toDict
		Set toDict = Server.CreateObject("Scripting.Dictionary")
		If (NOT IsEmpty(Me.Description)) Then toDict.Add "Description", Me.Description
		If (NOT IsEmpty(Me.ProductCode)) Then toDict.Add "ProductCode", Me.ProductCode
		If (NOT IsEmpty(Me.Amount)) Then toDict.Add "Amount", Me.Amount
		If (NOT IsEmpty(Me.VatRatio)) Then toDict.Add "VatRatio", Me.VatRatio
		If (NOT IsEmpty(Me.Count)) Then toDict.Add "Count", Me.Count
		If (NOT IsEmpty(Me.Url)) Then toDict.Add "Url", Me.Url
		If (NOT IsEmpty(Me.BasketItemType)) Then toDict.Add "BasketItemType", Me.BasketItemType
		If (NOT IsEmpty(Me.BasketItemId)) Then toDict.Add "BasketItemId", Me.BasketItemId
	End Property

End Class
%>