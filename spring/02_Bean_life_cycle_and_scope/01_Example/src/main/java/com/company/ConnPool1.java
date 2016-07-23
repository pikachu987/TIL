package com.company;

import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;

public class ConnPool1 implements InitializingBean, DisposableBean{
	
	@Override
	public void afterPropertiesSet() throws Exception {
		// TODO Auto-generated method stub
		//커넥션 풀 초기화 실행
	}
	
	
	@Override
	public void destroy() throws Exception {
		// TODO Auto-generated method stub
		//커넥션 풀 종료 실행
	}

	
	
}
