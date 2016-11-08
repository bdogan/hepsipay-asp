<!--#include file="lib/dynamicArray.asp"-->
<!--#include file="HepsiPayAddress.asp"-->
<!--#include file="HepsiPayCard.asp"-->
<!--#include file="HepsiPayCustomer.asp"-->
<!--#include file="HepsiPayBasketItem.asp"-->
<%
Class cHepsiPayRequest
	
	' Class Members
	Public Version
	Public ApiKey
	Public TransactionId
	Public TransactionTime
	Public Signature
	Public Description
	Public Curr
	Public SuccessUrl
	Public FailUrl
	
	Private pAmount
	Public Property Get Amount
		Amount = pAmount
		If (Not IsEmpty(Amount)) Then Amount = CInt(Replace(FormatNumber(Amount, 2, 0, 0, 0), ",", ""))
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
				pAmount = CInt(value)
			End If
			Exit Property
		ElseIf (typeNumber = 4 OR typeNumber = 5 OR typeNumber = 6) Then
			pAmount = value
			Exit Property
		End If
		
		pAmount = Empty
	End Property	
	
	Private pInstallment
	Public Property Get Installment
		Installment = pInstallment
		If (IsEmpty(Installment)) Then Exit Property
		If (Installment < 1 OR Installment > 12) Then Installment = Empty
	End Property
	Public Property Let Installment(value)
		Dim typeNumber : typeNumber = VarType(value)
		
		If (typeNumber = 2 OR typeNumber = 3) Then
			pInstallment = value
			Exit Property
		ElseIf (typeNumber = 0 OR typeNumber = 1 OR typeNumber = 9 OR typeNumber = 8192) Then
			pInstallment = Empty
			Exit Property
		ElseIf (typeNumber = 8 OR typeNumber = 4 OR typeNumber = 5 OR typeNumber = 6) Then
			If (IsNumeric(pInstallment)) Then 
				pInstallment = CInt(value)
			Else 
				pInstallment = Empty
			End If 
			Exit Property
		End If
		
		pInstallment = Empty
	End Property
	
	' Class Members Objects
	Private pBasketItems
	Public Property Get BasketItems(pKey)
		If (IsEmpty(pBasketItems)) Then Set pBasketItems = new oDynamicArray
		If (NOT pBasketItems.IsSet(pKey)) Then pBasketItems.Add(new oHepsiPayBasketItem)
		Set BasketItems = pBasketItems(pKey)
	End Property
	
	' Card
	Public pCard
	Public Property Get Card
		If (IsEmpty(pCard)) Then Set pCard = new cHepsiPayCard
		Set Card = pCard
	End Property
	
	' Customer
	Public pCustomer
	Public Property Get Customer
		If (IsEmpty(pCustomer)) Then Set pCustomer = new cHepsiPayCustomer
		Set Customer = pCustomer
	End Property
	
	' ShippingAddress
	Public pShippingAddress
	Public Property Get ShippingAddress
		If (IsEmpty(pShippingAddress)) Then Set pShippingAddress = new cHepsiPayAddress
		Set ShippingAddress = pShippingAddress
	End Property
	
	' InvoiceAddress
	Public pInvoiceAddress
	Public Property Get InvoiceAddress
		If (IsEmpty(pInvoiceAddress)) Then Set pInvoiceAddress = new cHepsiPayAddress
		Set InvoiceAddress = pInvoiceAddress
	End Property
	
	Private Extras
	' Add Extra Key Value
	Public Sub AddExtra(pKey, pValue)
		If (IsEmpty(Extras)) Then Set Extras = Server.CreateObject("Scripting.Dictionary")
		Extras.Add pKey, pValue
	End Sub
	' Remove Extra Key
	Public Sub RemoveExtra(pKey)
		If (IsObject(Extras)) Then If (Extras.Exists(pKey)) Then Extras.Remove(pKey)
	End Sub
	' Remove Extra All
	Public Sub RemoveExtraAll(pKey)
		If (IsObject(Extras)) Then Set Extras = Nothing
		Extras = Empty
	End Sub

	Public Property Get toDict
		Set toDict = Server.CreateObject("Scripting.Dictionary")
		If (NOT IsEmpty(Me.Version)) Then toDict.Add "Version", Me.Version
		If (NOT IsEmpty(Me.ApiKey)) Then toDict.Add "ApiKey", Me.ApiKey
		If (NOT IsEmpty(Me.TransactionId)) Then toDict.Add "TransactionId", Me.TransactionId
		If (NOT IsEmpty(Me.TransactionTime)) Then toDict.Add "TransactionTime", Me.TransactionTime
		If (NOT IsEmpty(Me.Signature)) Then toDict.Add "Signature", Me.Signature
		If (NOT IsEmpty(Me.Description)) Then toDict.Add "Description", Me.Description
		
		' Charge
		If (NOT IsEmpty(Me.Amount)) Then toDict.Add "Amount", Me.Amount
		If (NOT IsEmpty(Me.Curr)) Then toDict.Add "Currency", Me.Curr
		If (NOT IsEmpty(Me.Installment)) Then toDict.Add "Installment", Me.Installment
		If (NOT IsEmpty(Me.Card) AND Me.Card.toDict.Count > 0) Then toDict.Add "Card", Me.Card.toDict
		If (NOT IsEmpty(Me.ShippingAddress) AND Me.ShippingAddress.toDict.Count > 0) Then toDict.Add "ShippingAddress", Me.ShippingAddress.toDict
		If (NOT IsEmpty(Me.InvoiceAddress) AND Me.InvoiceAddress.toDict.Count > 0) Then toDict.Add "InvoiceAddress", Me.InvoiceAddress.toDict
		If (NOT IsEmpty(Me.Customer) AND Me.Customer.toDict.Count > 0) Then toDict.Add "Customer", Me.Customer.toDict
		
		' Basket Items
		If (NOT IsEmpty(pBasketItems)) Then
			Dim tBasketItems() : ReDim tBasketItems(pBasketItems.Count - 1)
			Dim k : For k = 0 To UBOUND(tBasketItems)
				Set tBasketItems(k) = pBasketItems(k).toDict
			Next
			toDict.Add "BasketItems", tBasketItems
		End If
		
		' Extra
		If (NOT IsEmpty(Extras)) Then
			Dim pExtras() : ReDim pExtras(Extras.Count - 1)
			Dim i, keys, items : keys = Extras.Keys : items = Extras.Items
			For i = 0 To Extras.Count - 1
				Set pExtras(i) = Server.CreateObject("Scripting.Dictionary")
				pExtras(i).Add "Key", keys(i)
				pExtras(i).Add "Value", items(i)
			Next
			toDict.Add "Extras", pExtras
		End If
		
		' ThreeD Charge
		If (NOT IsEmpty(Me.SuccessUrl)) Then toDict.Add "SuccessUrl", Me.SuccessUrl
		If (NOT IsEmpty(Me.FailUrl)) Then toDict.Add "FailUrl", Me.FailUrl
		
	End Property
	
	' Constructor
	Public Sub Class_Initialize
		Me.Version = "1.0"
		Me.apikey = ""
		Me.TransactionId = ""
		Me.TransactionTime = DateDiff("s", "01/01/1970 00:00:00", now)
		Extras = Empty
		Me.pShippingAddress = Empty
	End Sub
	
	' Destructor
	Public Sub Class_Terminate
		If (IsObject(Extras)) Then Set Extras = Nothing
	End Sub
	

End Class
%>