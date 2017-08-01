<!--#include file="lib/aspJSON.asp"-->
<!--#include file="lib/formCreator.asp"-->
<!--#include file="HepsiPayRequest.asp"-->
<%

Const HEPSIPAY_PAY_ADDRESS = "https://apientgr.hepsipay.com/payments/pay"
Const HEPSIPAY_3D_PAY_ADDRESS = "https://entgr.hepsipay.com/payment/threedsecure"
Const HEPSIPAY_REFUND_ADDRESS = "https://apientgr.hepsipay.com/payments/refund"

Class cHepsiPAY
	
	Private pNormalPayUrl
	
	' Holds ApiKey
	Private pApiKey
	' Holds SecretKey
	Private pSecretKey
	
	' Holds Last Request
	Private pLastRequest
	Public Property Get LastRequest
		Set LastRequest = pLastRequest
	End Property
	
	' Set ApiKey
	Public Property Let ApiKey(value)
		Dim pTypeNum : pTypeNum = VarType(value)
		If (pTypeNum = 8 OR pTypeNum = 3 OR pTypeNum = 2) Then pApiKey = value
	End Property
	
	' Set SecretKey
	Public Property Let SecretKey(value)
		Dim pTypeNum : pTypeNum = VarType(value)
		If (pTypeNum = 8 OR pTypeNum = 3 OR pTypeNum = 2) Then pSecretKey = value
	End Property
	
	' TransactionId
	Public Property Get CreateTransactionId
		CreateTransactionId = "tx_" & DateDiff("s", "01/01/1970 00:00:00", now)
	End Property
	
	' Holds response
	Private pResponse
	
	' ThreeD Pay Response
	Public Sub SendSecurePayRequest(pRequest)
		If (TypeName(pRequest) <> "cHepsiPayRequest") Then Err.Raise 6001, "Invalid argument. cHepsiPayRequest required"
		' Set ApiKey
		pRequest.ApiKey = pApiKey
		' Calculate Signature
		pRequest.Signature = SHA256(pSecretKey & pRequest.TransactionId & pRequest.TransactionTime & pRequest.Amount & pRequest.Curr & pRequest.Installment)
		Dim pFormCreator : Set pFormCreator = new cHepsiPayFormCreator
		Dim pFormStr : pFormStr = pFormCreator.Create(pRequest.toDict, HEPSIPAY_3D_PAY_ADDRESS)
		Set pFormCreator = Nothing
		Response.Write "<h3>Ýþleminiz Gerçekleþtiriliyor. Lütfen bekleyiniz</h3>"
		Response.Write pFormStr
	End Sub
	
	' Pay Response
	Public Sub SendPayRequest(pRequest)
		If (TypeName(pRequest) <> "cHepsiPayRequest") Then Err.Raise 6001, "Invalid argument. cHepsiPayRequest required"
		' Set ApiKey
		pRequest.ApiKey = pApiKey
		' Calculate Signature
		pRequest.Signature = SHA256(pSecretKey & pRequest.TransactionId & pRequest.TransactionTime & pRequest.Amount & pRequest.Curr & pRequest.Installment)
		' Generate Header
		Dim pHeader : Set pHeader = Server.CreateObject("Scripting.Dictionary")
		pHeader.Add "Accept", "application/json"
		pHeader.Add "Content-Type", "application/json"
		' Get Response 
		GetResponse "POST", HEPSIPAY_PAY_ADDRESS, pRequest.toDict, pHeader
		If (NOT IsDictionary(pResponse)) Then Err.Raise 6001, "Unexpected response: " & pResponse
		CheckGeneralPayResponse
	End Sub
	
	Private Property Get GetResponse(pMethod, pUrl, pData, pHeader)
		If (IsObject(pResponse)) Then Set pResponse = Nothing : pResponse = Empty
		If (IsEmpty(pMethod)) Then pMethod = "GET"
		If (IsEmpty(pHeader)) Then Set pHeader = Server.CreateObject("Scripting.Dictionary")
		Set pLastRequest = Server.CreateObject("Scripting.Dictionary")

		Dim pRequestBody : pRequestBody = ""
		If (pMethod = "POST" OR pMethod = "PUT") Then
			If (TypeName(pData) = "Dictionary") Then 
				Dim oJSON : Set oJSON = New HepsiPayJson
				Set oJSON.data = pData
				pRequestBody = oJSON.JSONoutput()
				Set oJSON = Nothing
			Else
				pRequestBody = pData
			End If
		Else
			If (TypeName(pData) = "Dictionary") Then 
				Dim qs : qs = ""
				If (pData.Count > 0) Then
					Dim pKeyValues(), pKey, Cursor : ReDim pKeyValues(pData.Count - 1) : Cursor = 0
					For Each pKey In pData.Keys
						pKeyValues(Cursor) = "pKey=" & Server.URLEncode(pData.Item(pKey))
						Cursor = Cursor + 1
					Next
					qs = Join(pKeyValues, "&")
				End If
				If (InStr("?", pUrl) > 0) Then pUrl = pUrl & "&" & qs Else pUrl = pUrl & "?" & qs
			End If
		End If
		
		Dim objXML : Set objXML = Server.CreateObject("Msxml2.ServerXMLHTTP.6.0")
		objXML.setTimeouts 100000, 100000, 200000, 200000
		
		pLastRequest.Add "Method", pMethod
		pLastRequest.Add "Header", pHeader
		pLastRequest.Add "Url", pUrl
		pLastRequest.Add "Data", ""
		If (TypeName(pData) = "Dictionary") Then Set pLastRequest("Data") = pData
		pLastRequest.Add "Body", pRequestBody
		
		objXML.Open pMethod, pUrl, False
		If (pHeader.Count > 0) Then
			Dim pHeaderKey
			For Each pHeaderKey In pHeader.Keys
				objXML.setRequestHeader pHeaderKey, pHeader.Item(pHeaderKey)
			Next
		End If
		objXML.Send pRequestBody
		
		Dim pResponseType : pResponseType = objXML.getResponseHeader("Content-Type")
		Select Case 1
			Case InStr(pResponseType, "application/json")
				On Error Resume Next
				Dim pParseError, pJson : pParseError = False
				Set pJson = new HepsiPayJson
				pJson.loadJSON(objXML.ResponseText)
				If Err.Number <> 0 Then pParseError = True : Err.Clear
				On Error GoTo 0
				If (pParseError) Then 
					Set pJson = Nothing
					Set objXML = Nothing
					Err.Raise 60001, "JSON Parse Error"
				Else
					Set pResponse = pJson.data
				End If
				Set pJson = Nothing
			Case Else
				pResponse = objXML.ResponseText
		End Select
		
		GetResponse = objXML.ResponseText
		Set objXML = Nothing
	End Property
	
	Public Sub ParseSecurePayResponse
		Set pResponse = Server.CreateObject("Scripting.Dictionary")
		If (Request.ServerVariables("REQUEST_METHOD") = "POST" AND Request.ServerVariables("HTTP_CONTENT_TYPE") = "application/x-www-form-urlencoded") Then
			Dim pItem
			For Each pItem In Request.Form
				pResponse.Add pItem, Utf8Decode(Request.Form(pItem))
			Next
			CheckGeneralPayResponse
		Else
			pResponse.Add "MessageCode", "999999"
			pResponse.Add "Success", False
			pResponse.Add "UserMessage", "Þu anda iþleminiz gerçekleþtirilemiyor. Lütfen daha sonra tekrar deneyiniz."
			pResponse.Add "Message", "POST request expected"
		End If
	End Sub
	
	Private Sub CheckGeneralPayResponse
		If (NOT pResponse.Exists("Success")) Then pResponse.Add "Success", False
		If (pResponse.Item("Success") = "True" OR pResponse.Item("Success") = True) Then pResponse.Item("Success") = True Else pResponse.Item("Success") = False
		
		If (pResponse.Item("Success") = True) Then
			If (NOT CheckFields(pResponse, Array("TransactionId", "TransactionTime", "Amount", "Currency", "Installment", "MessageCode", "MessageCode", "Signature"))) Then 
				pResponse.Item("Success") = False
				If (NOT pResponse.Exists("UserMessage")) Then pResponse.Add "UserMessage", ""
				If (NOT pResponse.Exists("Message")) Then pResponse.Add "Message", ""
				If (NOT pResponse.Exists("MessageCode")) Then pResponse.Add "MessageCode", ""
				
				pResponse.Item("MessageCode") = "999999"
				pResponse.Item("Success") = False
				pResponse.Item("UserMessage") = "Þu anda iþleminiz gerçekleþtirilemiyor. Lütfen daha sonra tekrar deneyiniz."
				pResponse.Item("Message") = "Empty response"
			Else
				If (SHA256(pSecretKey & pResponse.Item("TransactionId") & pResponse.Item("TransactionTime") & pResponse.Item("Amount") & pResponse.Item("Currency") & pResponse.Item("Installment") & pResponse.Item("MessageCode")) <> pResponse.Item("Signature")) Then
					pResponse.Item("MessageCode") = "999999"
					pResponse.Item("Success") = False
					pResponse.Item("UserMessage") = "Þu anda iþleminiz gerçekleþtirilemiyor. Lütfen daha sonra tekrar deneyiniz."
					pResponse.Item("Message") = "Geçersiz imza"
				End If
			End If
		End If
		
		If (NOT pResponse.Exists("Extras")) Then
			pResponse.Add "Extras", Server.CreateObject("Scripting.Dictionary")
			Dim pKey 
			For Each pKey In pResponse.Keys
				If (InStr(pKey, "Extras[") = 1) Then
					Dim pIndex
					Select Case True
						Case (InStr(pKey, ".Key") > 1)
							pIndex = RegexReplace("Extras\[([0-9]+)\]\.Key", pKey, "$1")
							If (NOT pResponse.Item("Extras").Exists(pIndex)) Then pResponse.Item("Extras").Add pIndex, Server.CreateObject("Scripting.Dictionary")
							pResponse.Item("Extras").Item(pIndex).Add "Key", pResponse.Item(pKey)
						Case (InStr(pKey, ".Value") > 1)
							pIndex = RegexReplace("Extras\[([0-9]+)\]\.Value", pKey, "$1")
							If (NOT pResponse.Item("Extras").Exists(pIndex)) Then pResponse.Item("Extras").Add pIndex, Server.CreateObject("Scripting.Dictionary")
							pResponse.Item("Extras").Item(pIndex).Add "Value", pResponse.Item(pKey)
					End Select
					pResponse.Remove(pKey)
				End If
			Next
		End If
		
		Dim oExtras, pItem : Set oExtras = Server.CreateObject("Scripting.Dictionary")
		For Each pItem In pResponse.Item("Extras").Items
			oExtras.Add pItem.Item("Key"), pItem.Item("Value")
		Next
		Set pResponse.Item("Extras") = oExtras
		Set oExtras = Nothing
	End Sub
	
	Private pRegEx
	Private Property Get RegEx
		If (IsEmpty(pRegEx)) Then Set pRegEx = New RegExp
		Set RegEx = pRegEx
	End Property
	
	Private Property Get RegexReplace(ByRef pRegEx, ByRef pHaystack, ByRef pNeedle)
		With RegEx
			.Pattern = pRegEx
			.IgnoreCase = True
			.Global = True
			.MultiLine = True
		End With
		RegexReplace = regEx.Replace(pHaystack, pNeedle)
	End Property
	
	Private Property Get CheckFields(pDict, pFields)
		Dim pField : CheckFields = True
		For Each pField In pFields
			If (NOT pDict.Exists(pField)) Then CheckFields = False
		Next
	End Property
	
	Public Property Get Utf8Decode(ByRef UTF8_Data)
		If Len(UTF8_Data) = 0 Then Exit Property
		UTF8_Data = Replace(UTF8_Data ,"Ãœ","Ü",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Ã‡","Ç",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Ä°","Ý",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Ã®","î",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Ã–","Ö",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Ã¼","ü",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"ÅŸ","þ",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Åž","Þ",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"ÄŸ","ð",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Äž","Ð",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Ã§","ç",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Ä±","ý",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Ã¶","ö",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Ã¢","â",1,-1,0)
		UTF8_Data = Replace(UTF8_Data ,"Ã‚","Â",1,-1,0)
		Utf8Decode = UTF8_Data
	End Property
	
	Private Property Get SHA256(pVal)
		Set oCrypt = Server.CreateObject("System.Security.Cryptography.SHA256Managed")
		SHA256 = ToHexString(oCrypt.ComputeHash_2(ToBytes(pVal)))
		Set oCrypt = Nothing
	End Property
	
	Private Property Get ToBytes(pStr)
		Dim objStrm : Set objStrm = CreateObject("ADODB.Stream")
		objStrm.Open
		objStrm.Type = 2
		objStrm.CharSet = "ASCII"
		objStrm.WriteText pStr
		objStrm.Position = 0
		objStrm.Type = 1
		ToBytes = objStrm.Read
		Set objStrm = Nothing
	End Property
	
	Private Property Get ToHexString(Binary)
		Dim i : ToHexString = ""
		For i = 1 To LenB(Binary)
			ToHexString = ToHexString & Right("0" & LCase(CStr(Hex(AscB(MidB(Binary, i, 1))))), 2)
		Next
	End Property
	
	' Constructor
	Public Sub Class_Initialize
		'pr(Request.ServerVariables)
	End Sub
	
	' Destructor
	Public Sub Class_Terminate
		If (IsObject(pResponse)) Then Set pResponse = Nothing
		If (IsObject(pLastRequest)) Then Set pLastRequest = Nothing
		If (IsObject(pRegEx)) Then Set pRegEx = Nothing
	End Sub
	
	' Returns response
	Public Property Get Response
		If (IsEmpty(pResponse)) Then 
			Set pResponse = Server.CreateObject("Scripting.Dictionary")
			If (Request.ServerVariables("REQUEST_METHOD") = "POST" AND Request.ServerVariables("CONTENT_TYPE") <> "application/json") Then
				For Each item In Request.Form
					pResponse.Add item, Request.Form(item)
				Next
			End If
		End If
		Set Response = pResponse
	End Property
	
	Public Sub pr(ByVal pObj)
		Response.Write "<pre>"
		Response.Write DebugStr(pObj)
		Response.Write "</pre>"
	End Sub	
	
	Public Property Get IsType(ByRef pVal, ByRef pTypeName)
		IsType = (TypeName(pVal) = pTypeName)
	End Property
	
	Public Property Get IsString(ByVal pStr)
		IsString = (TypeName(pStr) = "String")
	End Property
	
	Public Property Get IsArray(ByVal pArr)
		IsArray = (TypeName(pArr) = "Variant()")
	End Property
		
	Public Property Get IsDictionary(ByVal pDict)
		IsDictionary = (TypeName(pDict) = "Dictionary")
	End Property
	
	Public Property Get IsAspJson(ByVal pJson)
		IsAspJson = (TypeName(pJson) = "aspJSON")
	End Property
	
	Public Property Get IsRequestCollection(ByVal pReq)
		IsRequestCollection = (TypeName(pReq) = "IRequestDictionary")
	End Property

	Public Property Get IsApplicationObj(ByVal pReq)
		IsApplicationObj = (TypeName(pReq) = "IApplicationObject")
	End Property

	Public Property Get IsBoolean(ByVal pReq)
		IsBoolean = (TypeName(pReq) = "Boolean")
	End Property
	
		Public Property Get DebugStr(ByVal pObj)
		Dim dKey, Cursor, resultArr, arrObj
		If (IsNull(pObj)) Then pObj = "" : Exit Property
		If (IsArray(pObj)) Then
			Cursor = 0 : ReDim resultArr(UBOUND(pObj))
			For Each arrObj In pObj
				resultArr(Cursor) = resultArr(Cursor) & VBTAB & "[" & Cursor & "] => " & Replace(DebugStr(arrObj), VBCRLF, VBCRLF & VBTAB)
				Cursor = Cursor + 1
			Next
			DebugStr = "Array (" & VBCRLF & Join(resultArr, VBCRLF) & ")"
		ElseIf (IsDictionary(pObj)) Then
			Cursor = 0 : ReDim resultArr(pObj.Count)
			For Each dKey In pObj.Keys
				resultArr(Cursor) = resultArr(Cursor) & VBTAB & "[" & dKey & "] => " & Replace(DebugStr(pObj(dKey)), VBCRLF, VBCRLF & VBTAB)
				Cursor = Cursor + 1
			Next
			DebugStr = TypeName(pObj) & " (" & VBCRLF & Join(resultArr, VBCRLF) & ")"
		ElseIf (IsAspJson(pObj)) Then
			Cursor = 0 : ReDim resultArr(pObj.data.Count)
			For Each dKey In pObj.data.Keys
				resultArr(Cursor) = resultArr(Cursor) & VBTAB & "[" & dKey & "] => " & Replace(DebugStr(pObj.data(dKey)), VBCRLF, VBCRLF & VBTAB)
				Cursor = Cursor + 1
			Next
			DebugStr = "aspJSON (" & VBCRLF & Join(resultArr, VBCRLF) & ")"
		ElseIf (IsRequestCollection(pObj)) Then
			Cursor = 0 : ReDim resultArr(pObj.Count)
			For Each dKey In pObj
				resultArr(Cursor) = resultArr(Cursor) & VBTAB & "[" & dKey & "] => " & Replace(DebugStr(pObj(dKey)), VBCRLF, VBCRLF & VBTAB)
				Cursor = Cursor + 1
			Next
			DebugStr = "IRequestDictionary (" & VBCRLF & Join(resultArr, VBCRLF) & ")"
		ElseIf (IsType(pObj, "Files")) Then
			Cursor = 0 : ReDim resultArr(pObj.Count)
			For Each dKey In pObj
				resultArr(Cursor) = resultArr(Cursor) & VBTAB & "[" & Cursor & "] => " & Replace(DebugStr(dKey), VBCRLF, VBCRLF & VBTAB)
				Cursor = Cursor + 1
			Next
			DebugStr = "Files (" & VBCRLF & Join(resultArr, VBCRLF) & ")"
		ElseIf (IsApplicationObj(pObj)) Then
			Cursor = 0 : ReDim resultArr(pObj.Contents.Count)
			For Each dKey In pObj.Contents
				resultArr(Cursor) = resultArr(Cursor) & VBTAB & "[" & dKey & "] => " & Replace(DebugStr(pObj(dKey)), VBCRLF, VBCRLF & VBTAB)
				Cursor = Cursor + 1
			Next
			DebugStr = "IRequestDictionary (" & VBCRLF & Join(resultArr, VBCRLF) & ")"
		ElseIf (IsObject(pObj)) Then
			On Error Resume Next
			DebugStr = Cstr(pObj)
			If (Err.Number <> 0) Then DebugStr = "[Object] " & TypeName(pObj)
			Err.Clear
		Else
			DebugStr = Server.HTMLEncode(pObj)
		End If
	End Property
	
End Class
%>