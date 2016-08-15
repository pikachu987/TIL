package com.company.ex1.aop;

import org.aspectj.lang.ProceedingJoinPoint;

public class Profiler {
	public Object trace(ProceedingJoinPoint joinPoint) throws Throwable{
		String sinatureString = joinPoint.getSignature().toShortString();
		System.out.println(sinatureString+" 시작");
		long start = System.currentTimeMillis();
		try{
			Object result = joinPoint.proceed();
			return result;
		}finally{
			long finish = System.currentTimeMillis();
			System.out.println(sinatureString+ "종료 시간:"+(finish - start)+"ms");
		}
	}
}
