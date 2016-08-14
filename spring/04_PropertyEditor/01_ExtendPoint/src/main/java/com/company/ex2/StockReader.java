package com.company.ex2;

import java.util.Date;

public interface StockReader {
	public int getClosePrice(Date date, String code);
}
