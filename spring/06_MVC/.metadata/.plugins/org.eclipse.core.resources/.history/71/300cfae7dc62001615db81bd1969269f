package com.company.ex2.aop;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;

@Aspect
public class Profiler {
	@Pointcut("execution(public * com.company..*(..))")
	private void profileTarget(){}
	
	@Around("profileTarget()")
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
