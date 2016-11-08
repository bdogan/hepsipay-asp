<div class="col-xs-12 col-md-4">
	<form role="form" method="POST" action="default.asp?route=<%=route%>">
		<div class="panel panel-default">
			<div class="panel-heading"><h3 class="panel-title">Ödeme Formu</h3></div>
			<div class="panel-body">
				<div class="form-group">
					<input name="CardHolderName" type="text" class="form-control" id="CardHolderName" placeholder="Ýsim"
						required autofocus />
				</div>
				<div class="form-group">
					<div class="input-group">
						<input name="CardNumber" type="text" class="form-control" id="CardNumber" placeholder="Geçeri Kart Numarasý"
							required autofocus />
						<span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
					</div>
				</div>
				<div class="row">
					<div class="col-xs-7 col-md-7">
						<div class="form-group">
							<div class="col-xs-6 col-lg-6 pl-ziro">
								<input name="ExpireMonth" type="text" class="form-control" id="ExpireMonth" placeholder="AA" required />
							</div>
							<div class="col-xs-6 col-lg-6 pl-ziro">
								<input name="ExpireYear" type="text" class="form-control" id="ExpireYear" placeholder="YY" required /></div>
						</div>
					</div>
					<div class="col-xs-5 col-md-5 pull-right">
						<div class="form-group">
							<input name="SecurityCode" type="password" class="form-control" id="SecurityCode" placeholder="CV" required />
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="panel panel-default">
			<div class="panel-heading"><h3 class="panel-title">Ödeme Ayrýntýlarý</h3></div>
			<div class="panel-body">
				<div class="row">
					<div class="col-xs-7 col-md-7">
						<div class="form-group">
							<label for="Amount">
								TUTAR/TAKSÝT</label>
							<div class="col-xs-6 col-lg-6 pl-ziro">
								<input name="Amount" type="text" class="form-control" id="Amount" value="1.12" required />
							</div>
							<div class="col-xs-6 col-lg-6 pl-ziro">
								<input name="Installment" type="text" class="form-control" id="Installment" value="1" required /></div>
						</div>
					</div>
					<div class="col-xs-5 col-md-5 pull-right">
						<div class="form-group">
							<label for="TransactionId">
								TRANS.ID</label>
							<input name="TransactionId" type="text" class="form-control" id="TransactionId" placeholder="TransactionId" value="<%=HepsiPay.CreateTransactionId%>" required />
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
	<button class="btn btn-success btn-lg btn-block" type="submit" onclick="$('form').submit()">Gönder</button>
</div>