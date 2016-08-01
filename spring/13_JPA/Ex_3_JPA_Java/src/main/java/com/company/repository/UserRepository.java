package com.company.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.Repository;

import com.company.domain.User;

public interface UserRepository extends Repository<User, Integer>{
	public int countByIdAndNickname(String id, String nickname);
	public List<User> findBySeqGreaterThan(int seq, Pageable pageable);
	public User findById(String id);
}
