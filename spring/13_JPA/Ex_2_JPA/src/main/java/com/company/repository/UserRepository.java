package com.company.repository;

import org.springframework.data.repository.CrudRepository;

import com.company.domain.User;

public interface UserRepository extends CrudRepository<User, Integer>{
	
}
