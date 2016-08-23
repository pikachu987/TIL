package com.company;

import org.springframework.scheduling.annotation.Async;
import org.springframework.scheduling.annotation.EnableAsync;


@EnableAsync
public class AsyncService {
	
	@Async
	public void async(String msg, String hp){
		try {
			System.out.println("async");
		} catch (Exception e) {e.printStackTrace();}
	}
}
