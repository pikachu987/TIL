package com.company.application;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import com.company.Entity.Employee;
import com.company.Entity.EmployeeRepository;

public class SelectEmplyeeServiceImpl  implements SelectEmployeeService{
	@Autowired
	private EmployeeRepository employeeRepository;
	
	@Transactional
	@Override
	public Employee getEmployee(Long id) {
		// TODO Auto-generated method stub
		Employee emp = employeeRepository.findOne(id);
		if(emp == null) return null;
		
		return emp;
	}

}