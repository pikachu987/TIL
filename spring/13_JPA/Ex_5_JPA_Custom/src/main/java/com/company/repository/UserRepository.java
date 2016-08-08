package com.company.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.company.domain.User;

public interface UserRepository extends UserCustomRepository, JpaRepository<User, Integer>{
	
}
