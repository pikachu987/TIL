package com.company;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.greaterThan;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.transaction.annotation.Transactional;

import config.MvcConfig;
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(classes=MvcConfig.class)
@TransactionConfiguration(defaultRollback=false)
@Transactional
public class Test_9DB {
	@Autowired
	private MemberDAO memberDAO;
	
	@Rollback(true)
	@Test
	public void count(){
		assertThat(memberDAO.count(), equalTo(22));
	}
	
	@Test
	public void insert(){
		int seq = memberDAO.insert();
		
		assertThat(seq, greaterThan(1));
	}
}