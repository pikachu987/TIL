package com.company.ex3;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.core.Ordered;

//@Order(2)
public class TraceBeanPostProcessor implements BeanPostProcessor, Ordered {
	
	private int order;
	
	@Override
	public int getOrder() {
		return order;
	}
	
	public void setOrder(int order) {
		this.order = order;
	}

	@Override
	public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
		return bean;
	}

	@Override
	public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
		Class<?>[] interfaces = bean.getClass().getInterfaces();
		if(interfaces.length == 0) return bean;
		InvocationHandler handler = new InvocationHandler() {
			
			@Override
			public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
				long before = System.currentTimeMillis();
				Object result = method.invoke(bean, args);
				long after = System.currentTimeMillis();
				System.out.println(method.getName() + " 실행시간 = "+(after - before));
				return result;
			}
		};
		return Proxy.newProxyInstance(getClass().getClassLoader(), interfaces, handler);
	}

}
