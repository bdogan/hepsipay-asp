<%
If (Request.ServerVariables("REQUEST_METHOD") = "POST") Then
	Dim HepsiPayNormalRequest : Set HepsiPayNormalRequest = new cHepsiPayRequest
	
	HepsiPayNormalRequest.TransactionId = HepsiPay.CreateTransactionId
	
	HepsiPayNormalRequest.Amount = Request.Form("Amount")
	HepsiPayNormalRequest.Installment = Request.Form("Installment")
	HepsiPayNormalRequest.Curr = "TRY"
	
	HepsiPayNormalRequest.Card.CardHolderName = Request.Form("CardHolderName")
	HepsiPayNormalRequest.Card.CardNumber = Request.Form("CardNumber")
	HepsiPayNormalRequest.Card.ExpireYear = Request.Form("ExpireYear")
	HepsiPayNormalRequest.Card.ExpireMonth = Request.Form("ExpireMonth")
	HepsiPayNormalRequest.Card.SecurityCode = Request.Form("SecurityCode")
	
	HepsiPayNormalRequest.Customer.IpAddress = "85.109.59.244"
	
	' Opsiyonel Alanlar Başlangıc
	'HepsiPayNormalRequest.Customer.Name = "Ali"
	'HepsiPayNormalRequest.Customer.Surname = "Veli"
	'HepsiPayNormalRequest.Customer.Email = "ali.veli@alivelimarket.com.tr"
	'HepsiPayNormalRequest.Customer.PhoneNumber = "5334654321"
	'HepsiPayNormalRequest.Customer.Code = "7cefdf61-38cd-4b35-b5f0-4c98c5805d41"
	'HepsiPayNormalRequest.Customer.TCKN = "12345678910"
	'HepsiPayNormalRequest.Customer.VatNumber = "12345678910"
	
	'HepsiPayNormalRequest.BasketItems(0).Description = "Boyama Kalem Seti"
	'HepsiPayNormalRequest.BasketItems(0).ProductCode = "7cefdf61-38cd-4b35-b5f0-4c98c5805d41"
	'HepsiPayNormalRequest.BasketItems(0).Amount = 87.50
	'HepsiPayNormalRequest.BasketItems(0).VatRatio = 18
	'HepsiPayNormalRequest.BasketItems(0).Count = 1
	'HepsiPayNormalRequest.BasketItems(0).Url = "http://www.alivelimarket.com.tr/boyama-kalem-seti"
	'HepsiPayNormalRequest.BasketItems(0).BasketItemType = 1
	'HepsiPayNormalRequest.BasketItems(0).BasketItemId = "basket_1"
	
	'HepsiPayNormalRequest.BasketItems(1).Description = "Boyama Kitabı"
	'HepsiPayNormalRequest.BasketItems(1).ProductCode = "7cefdf61-38cd-4b35-b5f0-4c98c5805d41"
	'HepsiPayNormalRequest.BasketItems(1).Amount = 25.50
	'HepsiPayNormalRequest.BasketItems(1).VatRatio = 18
	'HepsiPayNormalRequest.BasketItems(1).Count = 3
	'HepsiPayNormalRequest.BasketItems(1).Url = "http://www.alivelimarket.com.tr/boyama-kitabi"
	'HepsiPayNormalRequest.BasketItems(1).BasketItemType = 1
	'HepsiPayNormalRequest.BasketItems(1).BasketItemId = "basket_2"
	
	'HepsiPayNormalRequest.BasketItems(2).Description = "Kargo Bedeli"
	'HepsiPayNormalRequest.BasketItems(2).Amount = 10
	'HepsiPayNormalRequest.BasketItems(2).VatRatio = 18
	'HepsiPayNormalRequest.BasketItems(2).Count = 1
	'HepsiPayNormalRequest.BasketItems(2).BasketItemType = 3
	'HepsiPayNormalRequest.BasketItems(2).BasketItemId = "basket_3"
	
	'HepsiPayNormalRequest.ShippingAddress.Name = "Ali Veli"
	'HepsiPayNormalRequest.ShippingAddress.Address = "Kuştepe Mahallesi Mecidiyeköy Yolu Cad. No:12 Trump Towers Kule:2 Kat:11 Mecidiyeköy"
	'HepsiPayNormalRequest.ShippingAddress.Country = "Türkiye"
	'HepsiPayNormalRequest.ShippingAddress.CountryCode = "TUR"
	'HepsiPayNormalRequest.ShippingAddress.City = "İstanbul"
	'HepsiPayNormalRequest.ShippingAddress.CityCode = "34"
	'HepsiPayNormalRequest.ShippingAddress.ZipCode = "34580"
	'HepsiPayNormalRequest.ShippingAddress.District = "Şişli"
	'HepsiPayNormalRequest.ShippingAddress.DistrictCode = Null
	'HepsiPayNormalRequest.ShippingAddress.ShippingCompany = "XXX"
	
	'HepsiPayNormalRequest.InvoiceAddress.Name = "Ali Veli"
	'HepsiPayNormalRequest.InvoiceAddress.Address = "Kuştepe Mahallesi Mecidiyeköy Yolu Cad. No:12 Trump Towers Kule:2 Kat:11 Şişli"
	'HepsiPayNormalRequest.InvoiceAddress.Country = "Türkiye"
	'HepsiPayNormalRequest.InvoiceAddress.CountryCode = "TUR"
	'HepsiPayNormalRequest.InvoiceAddress.City = "İstanbul"
	'HepsiPayNormalRequest.InvoiceAddress.CityCode = "34"
	'HepsiPayNormalRequest.InvoiceAddress.ZipCode = "34580"
	'HepsiPayNormalRequest.InvoiceAddress.District = "Şişli"
	'HepsiPayNormalRequest.InvoiceAddress.DistrictCode = Null
	'HepsiPayNormalRequest.InvoiceAddress.ShippingCompany = "XXX"
	
	HepsiPayNormalRequest.AddExtra "INT_SIPARIS_KODU", "spr_123456789" ' Response içinde tekrar gönderiliyor
	' Opsiyonel Alanlar Bitiş
	
	HepsiPay.SendPayRequest(HepsiPayNormalRequest)
	
	Dim pIcon : If (HepsiPay.Response.Item("Success") = True) Then pIcon = "glyphicon-ok-sign" Else pIcon = "glyphicon-exclamation-sign"
	Dim pAlertClass : If (HepsiPay.Response.Item("Success") = True) Then pAlertClass = "alert-success" Else pAlertClass = "alert-danger"
%>
	<div class="alert <%=pAlertClass%>" role="alert">
		<strong><span class="glyphicon <%=pIcon%>"></span></strong> <%=HepsiPay.Response.Item("Message")%>
	</div>
	<div class="panel panel-default">
		<div class="panel-heading"><h3 class="panel-title">İstek</h3></div>
		<div class="panel-body"><% HepsiPay.pr(HepsiPay.LastRequest) %></div>
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

