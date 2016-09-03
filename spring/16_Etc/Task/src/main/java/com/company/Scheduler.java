package com.company;


import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;


@Component
public class Scheduler{
	@Scheduled(cron = "*/5 * * * * *")
	public void cron0(){
		System.out.println("??");
	}
	
	@Scheduled(cron = "0 0 6 * * ?")
	public void cron(){
		
	}
	
	@Scheduled(cron = "0 0 3 * * ?")
	public void cron2(){
		
	}
	@Scheduled(cron = "0 0 12 ? * MON")
	public void cron3(){
		
	}
}