package com.company;

import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

public class ConnPool2{
	
	@PostConstruct
	public void initPool(){
		//커넥션 풀 초기화
	}
	
	@PreDestroy
	public void destoryPool(){
		//커넥션 풀 종료
	}
	
}
