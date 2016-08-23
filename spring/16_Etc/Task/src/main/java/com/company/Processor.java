package com.company;

import java.util.concurrent.Future;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

public class Processor {
	
	@Autowired
	private ThreadPoolTaskExecutor taskExecutor;
	
	
	public void process(final Work work){
		Future<?> future = taskExecutor.submit(new Runnable() {
			@Override
			public void run() {
				work.doWork();
			}
		});
		try{
			future.get();//작업이 끝날때 까지 대기
		}catch(Exception e){
			
		}
		return;
	}
}

class Work{
	public void doWork(){
		System.out.println("dddd");
	}
}