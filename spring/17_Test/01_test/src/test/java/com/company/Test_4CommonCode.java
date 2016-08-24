package com.company;


import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;

@ContextConfiguration
@WebAppConfiguration
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
public @interface Test_4CommonCode {
}
