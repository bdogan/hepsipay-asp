<% Response.Charset = "ISO-8859-9" %>
<!--#include file="../src/HepsiPay.asp"-->
<!--#include file="config.inc"-->
<%
	Dim HepsiPAY : Set HepsiPAY = new cHepsiPAY
	
	HepsiPay.ApiKey = APIKEY
	HepsiPay.SecretKey = SECRETKEY
%>

<%
	Dim route : route = Request.QueryString("route")
	If (IsEmpty(route)) Then route = "normal" Else route = Trim(route)
%>
<!doctype html>
<html lang="tr">
<head>
	<meta charset="ISO-8859-9">
	<title>HepsiPAY - ASP</title>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>
	<style> 
		body { font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif; }
		.panel-title {display: inline;font-weight: bold;}
		.checkbox.pull-right { margin: 0; }
		.pl-ziro { padding-left: 0px; }
	</style>
	<script>var route = "<%=route%>"</script>
</head>
<body>
	<nav class="navbar navbar-default">
	  <div class="container">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="default.asp">HepsiPAY ASP</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="" data-route="normal">Normal Ödeme</a></li>
				<li><a href="" data-route="3dsecure">3D Ödeme</a></li>
			</ul>
		<div>
	  </div>
	</nav>
	<div class="container">
		<div class="row">
			<!--#include file="payment_form.asp"-->
			<div class="col-xs-12 col-md-8">
				<%
					Select Case route
						Case "normal"
							%><!--#include file="_normal.asp"--><%
						Case "3dsecure"
							%><!--#include file="_3dsecure.asp"--><%
					End Select
				%>
			</div>
		</div>
	</div>
	
	<script>
		$(".navbar-nav li a").each(function(){
			$(this).attr("href", "default.asp?route=" + $(this).attr("data-route"));
			if (route == $(this).attr("data-route")) $(this).closest("li").addClass("active");
		});
	</script>
</body>
</html>
<%
	Set HepsiPAY = Nothing
%>