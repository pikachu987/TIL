package com.company.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.CrudRepository;

import com.company.domain.User;

public interface UserRepository extends CrudRepository<User, Integer>{
	public int countById(String id);
	public int countByNickname(String nickname);
	public Page<User> findBySeqNotNull(Pageable pageable);
}
