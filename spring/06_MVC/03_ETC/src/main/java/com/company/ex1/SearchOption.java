package com.company.ex1;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class SearchOption {
	@DateTimeFormat(pattern="yyyyMMdd")
	private Date birthday;
}
