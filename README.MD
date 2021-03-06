## HepsiPay ##
### Hakkında
Türkiye’nin öncü finansal teknoloji şirketlerinden Hepsipay’in öncelikli hedefi en yeni teknolojileri, ödeme özelliklerini, yüksek hızı finans dünyasına taşıyarak, işletmelere ve tüketicilere kolay ulaşılır ve güvenilir hizmetler sağlamaktır. Daha fazla bilgi için [hepsipay.com](http://www.hepsipay.com).

## HepsiPay ASP
HepsiPay ASP kütüphanesini kullanarak klasik asp ile HepsiPay altyapısı üzerinden normal veya 3D ödeme alabilirsiniz.

### Gerekenler
* ASP arabellek aktif olmalı
* ASP üzerinden üst yollara erişim açık olmalı

### Hatırlatma
Kütüphane `ISO-8859-9 Türkçe` olarak yazılmıştır. UTF-8 kullanmak için tüm dosyaların encoding ayarlarını UTF-8'e çevirmeniz gerekmektedir. Aksi halde karakterler bozuk görünecektir.

### Test
Test işlemi için lokal sunucunuzun kök dizinine `hepsipay-asp` içinde bulunan tüm dosya ve klasörleri atın. `test` klasörü içinde bulunan `config.inc.default` dosyasını `config.inc` olarak değiştirin. `config.inc` dosyasındaki `APIKEY`,`SECRETKEY` değerlerini hepsipay.com üzerinden aldığınız bilgilerle doldurun. Browser üzerinde `http://localhost/test` adresine gidin. Hem normal ödeme hemde 3D Ödeme için deneme kredi kartı kullanarak test yapabilirsiniz.

### Kurulum
`src` klasörü altında bulunan tüm dosya ve klasörleri sunucunuzda erişilebilir bir yere kaydedin.

### Kullanım

#### Normal Ödeme
```asp
<!--#include file="src/HepsiPay.asp"-->

Dim HepsiPAY : Set HepsiPAY = new cHepsiPAY

HepsiPay.ApiKey = "%APIKEY%" 'Almış olduğunuz ApiKey
HepsiPay.SecretKey = "%SECRETKEY%" 'Almış olduğunuz SecretKey

' Normal Ödeme
Dim HepsiPayNormalRequest : Set HepsiPayNormalRequest = new cHepsiPayRequest
	
HepsiPayNormalRequest.TransactionId = "tr_123456789" ' Her işlem için farklı
HepsiPayNormalRequest.Amount = 123.10
HepsiPayNormalRequest.Installment = 1 ' TekÇekim => 1 Taksit => 2 <-> 12 arası
HepsiPayNormalRequest.Curr = "TRY"

HepsiPayNormalRequest.Card.CardHolderName = "Ali Veli" ' Kart üzerindeki isim
HepsiPayNormalRequest.Card.CardNumber = "123456789" ' Kart Numarası
HepsiPayNormalRequest.Card.ExpireYear = 2018 ' Son kullanma sene
HepsiPayNormalRequest.Card.ExpireMonth = 12 ' Son kullanma yıl
HepsiPayNormalRequest.Card.SecurityCode = "123" ' Güvenlik numarası

HepsiPayNormalRequest.Customer.IpAddress = "85.109.59.244" ' Müşteri Ip adresi

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

' HepsiPayNormalRequest.AddExtra "INT_SIPARIS_KODU", "spr_123456789" ' Response içinde geri gönderiliyor
' Opsiyonel Alanlar Bitiş

HepsiPay.SendPayRequest(HepsiPayNormalRequest) ' İstek gönderiyoruz

If (HepsiPay.Response.Item("Success") = True) Then
	Response.Write "Ödeme Başarılı TransactionId : " & HepsiPay.Response.Item("TransactionId")
Else
	Response.Write "Ödeme Başarısız: " & HepsiPay.Response.Item("Message")
End If
```

#### 3D Secure Ödeme

Döküman hazırlanıyor. Örnek çalışma için `test/_3dsecure.asp` sayfasına bakabilirsiniz.