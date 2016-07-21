package com.company.ex1_static;

public interface ErpClient {

	public void connect();

	public void close();

	public void sendPurchaseInfo(ErpOrderData oi);
}
