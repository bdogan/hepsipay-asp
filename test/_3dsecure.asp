<%
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	
	If (Request.QueryString("from3d") <> "1") Then
		Dim HepsiPaySecureRequest : Set HepsiPaySecureRequest = new cHepsiPayRequest
		
		HepsiPaySecureRequest.TransactionId = HepsiPay.CreateTransactionId
		
		HepsiPaySecureRequest.Amount = Request.Form("Amount")
		HepsiPaySecureRequest.Installment = Request.Form("Installment")
		HepsiPaySecureRequest.Curr = "TRY"
		
		HepsiPaySecureRequest.Card.CardHolderName = Request.Form("CardHolderName")
		HepsiPaySecureRequest.Card.CardNumber = Request.Form("CardNumber")
		HepsiPaySecureRequest.Card.ExpireYear = Request.Form("ExpireYear")
		HepsiPaySecureRequest.Card.ExpireMonth = Request.Form("ExpireMonth")
		HepsiPaySecureRequest.Card.SecurityCode = Request.Form("SecurityCode")
		
		HepsiPaySecureRequest.Customer.IpAddress = "85.109.59.244"
		
		HepsiPaySecureRequest.SuccessUrl = "http://" & Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("URL") & "?route=3dsecure&from3d=1&result=success"
		HepsiPaySecureRequest.FailUrl = "http://" & Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("URL") & "?route=3dsecure&from3d=1&result=fail"
		
		' Opsiyonel Alanlar Başlangıc
		'HepsiPaySecureRequest.Customer.Name = "Ali"
		'HepsiPaySecureRequest.Customer.Surname = "Veli"
		'HepsiPaySecureRequest.Customer.Email = "ali.veli@alivelimarket.com.tr"
		'HepsiPaySecureRequest.Customer.PhoneNumber = "5334654321"
		'HepsiPaySecureRequest.Customer.Code = "7cefdf61-38cd-4b35-b5f0-4c98c5805d41"
		'HepsiPaySecureRequest.Customer.TCKN = "12345678910"
		'HepsiPaySecureRequest.Customer.VatNumber = "12345678910"
		
		HepsiPaySecureRequest.BasketItems(0).Description = "Boyama Kalem Seti"
		HepsiPaySecureRequest.BasketItems(0).ProductCode = "7cefdf61-38cd-4b35-b5f0-4c98c5805d41"
		HepsiPaySecureRequest.BasketItems(0).Amount = 87.50
		'HepsiPaySecureRequest.BasketItems(0).VatRatio = 18
		'HepsiPaySecureRequest.BasketItems(0).Count = 1
		'HepsiPaySecureRequest.BasketItems(0).Url = "http://www.alivelimarket.com.tr/boyama-kalem-seti"
		'HepsiPaySecureRequest.BasketItems(0).BasketItemType = 1
		'HepsiPaySecureRequest.BasketItems(0).BasketItemId = "basket_1"
		
		HepsiPaySecureRequest.BasketItems(1).Description = "Boyama Kitabı"
		HepsiPaySecureRequest.BasketItems(1).ProductCode = "7cefdf61-38cd-4b35-b5f0-4c98c5805d41"
		HepsiPaySecureRequest.BasketItems(1).Amount = 25.50
		'HepsiPaySecureRequest.BasketItems(1).VatRatio = 18
		'HepsiPaySecureRequest.BasketItems(1).Count = 3
		'HepsiPaySecureRequest.BasketItems(1).Url = "http://www.alivelimarket.com.tr/boyama-kitabi"
		'HepsiPaySecureRequest.BasketItems(1).BasketItemType = 1
		'HepsiPaySecureRequest.BasketItems(1).BasketItemId = "basket_2"
		
		HepsiPaySecureRequest.BasketItems(2).Description = "Kargo Bedeli"
		HepsiPaySecureRequest.BasketItems(2).Amount = 10
		HepsiPaySecureRequest.BasketItems(2).VatRatio = 18
		'HepsiPaySecureRequest.BasketItems(2).Count = 1
		'HepsiPaySecureRequest.BasketItems(2).BasketItemType = 3
		'HepsiPaySecureRequest.BasketItems(2).BasketItemId = "basket_3"
		
		'HepsiPaySecureRequest.ShippingAddress.Name = "Ali Veli"
		'HepsiPaySecureRequest.ShippingAddress.Address = "Kuştepe Mahallesi Mecidiyeköy Yolu Cad. No:12 Trump Towers Kule:2 Kat:11 Mecidiyeköy"
		'HepsiPaySecureRequest.ShippingAddress.Country = "Türkiye"
		'HepsiPaySecureRequest.ShippingAddress.CountryCode = "TUR"
		'HepsiPaySecureRequest.ShippingAddress.City = "İstanbul"
		'HepsiPaySecureRequest.ShippingAddress.CityCode = "34"
		'HepsiPaySecureRequest.ShippingAddress.ZipCode = "34580"
		'HepsiPaySecureRequest.ShippingAddress.District = "Şişli"
		'HepsiPaySecureRequest.ShippingAddress.DistrictCode = Null
		'HepsiPaySecureRequest.ShippingAddress.ShippingCompany = "XXX"
		
		'HepsiPaySecureRequest.InvoiceAddress.Name = "Ali Veli"
		'HepsiPaySecureRequest.InvoiceAddress.Address = "Kuştepe Mahallesi Mecidiyeköy Yolu Cad. No:12 Trump Towers Kule:2 Kat:11 Şişli"
		'HepsiPaySecureRequest.InvoiceAddress.Country = "Türkiye"
		'HepsiPaySecureRequest.InvoiceAddress.CountryCode = "TUR"
		'HepsiPaySecureRequest.InvoiceAddress.City = "İstanbul"
		'HepsiPaySecureRequest.InvoiceAddress.CityCode = "34"
		'HepsiPaySecureRequest.InvoiceAddress.ZipCode = "34580"
		'HepsiPaySecureRequest.InvoiceAddress.District = "Şişli"
		'HepsiPaySecureRequest.InvoiceAddress.DistrictCode = Null
		'HepsiPaySecureRequest.InvoiceAddress.ShippingCompany = "XXX"
		
		HepsiPaySecureRequest.AddExtra "INT_SIPARIS_KODU", "spr_123456789" ' Response içinde tekrar gönderiliyor
		' Opsiyonel Alanlar Bitiş
		
		HepsiPay.SendSecurePayRequest(HepsiPaySecureRequest)
	End If
	
	HepsiPay.ParseSecurePayResponse
	
	If (HepsiPay.Response.Item("Success") = True) Then pIcon = "glyphicon-ok-sign" Else pIcon = "glyphicon-exclamation-sign"
	If (HepsiPay.Response.Item("Success") = True) Then pAlertClass = "alert-success" Else pAlertClass = "alert-danger"
%>
	<div class="alert <%=pAlertClass%>" role="alert">
		<strong><span class="glyphicon <%=pIcon%>"></span></strong> <%=HepsiPay.Response.Item("Message")%>
	</div>
	<div class="panel panel-default">
		<div class="panel-heading"><h3 class="panel-title">Cevap</h3></div>
		<div class="panel-body"><% HepsiPay.pr(HepsiPay.Response) %></div>
	</div>	
<%
Else
%>
	<div class="alert alert-info" role="alert">
		<strong><span class="glyphicon glyphicon-info-sign"></span></strong> Test etmek için yandaki formu doldurup Gönder tuşuna basınız
	</div>
<%
End If
%>