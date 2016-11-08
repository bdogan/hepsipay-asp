<%
Class cHepsiPayFormCreator

	Private Property Get IsArray(ByVal pArr)
		IsArray = (TypeName(pArr) = "Variant()")
	End Property
		
	Private Property Get IsDictionary(ByVal pDict)
		IsDictionary = (TypeName(pDict) = "Dictionary")
	End Property
	
	Private Property Get CreateFormName
		CreateFormName = "form_hepsi_pay_3d_" & DateDiff("s", "01/01/1970 00:00:00", now)
	End Property
	
	Public Property Get Create(pDict, pUrl)
		Dim pKey, pFormName, pCursor : pFormName = CreateFormName
		Create = Create & "<form name=""" & pFormName & """ method=""POST"" action=""" & pUrl & """>"
		For Each pKey In pDict.Keys
			Select Case True
				Case IsArray(pDict.Item(pKey))
					Create = Create & FromArray(pKey, pDict.Item(pKey))
				Case IsDictionary(pDict.Item(pKey))
					Create = Create & FromDict(pKey, pDict.Item(pKey))
				Case Else
					Create = Create & CreateHiddenInput(pKey, pDict.Item(pKey))
			End Select
		Next
		Create = Create & "</form>"
		Create = Create & "<script>document.forms[""" & pFormName & """].submit();</script>"
	End Property
	
	Private Property Get FromDict(pParentKey, pDict)
		FromDict = ""
		Dim pKey
		For Each pKey In pDict.Keys
			Select Case True
				Case IsArray(pDict.Item(pKey))
					FromDict = FromDict & FromArray(pParentKey & "." & pKey, pDict.Item(pKey))
				Case IsDictionary(pDict.Item(pKey))
					FromDict = FromDict & FromDict(pParentKey & "." & pKey, pDict.Item(pKey))
				Case Else
					FromDict = FromDict & CreateHiddenInput(pParentKey & "." & pKey, pDict.Item(pKey))
			End Select
		Next
	End Property
	
	Private Property Get FromArray(pParentKey, pArr)
		FromArray = ""
		Dim pItem, pCursor : pCursor = 0
		For Each pItem In pArr
			Select Case True
				Case IsArray(pItem)
					FromArray = FromArray & FromArray(pParentKey & "[" & pCursor & "]", pItem)
				Case IsDictionary(pItem)
					FromArray = FromArray & FromDict(pParentKey & "[" & pCursor & "]", pItem)
				Case Else
					FromArray = FromArray & CreateHiddenInput(pParentKey & "[" & pCursor & "]", pDict.Item(pKey))
			End Select
			pCursor = pCursor + 1
		Next
	End Property
	
	Private Property Get CreateHiddenInput(pKey, pValue)
		CreateHiddenInput = "<input type=""hidden"" name=""" & pKey & """ value=""" & pValue & """ />"
	End Property

End Class
%>