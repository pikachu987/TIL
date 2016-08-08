package com.company.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.company.domain.User;

public interface UserRepository extends CrudRepository<User, Integer>{
	public int countById(String id);
	public int countByNickname(String nickname);
	public Page<User> findBySeqNotNull(Pageable pageable);
	@Modifying
	@Query("update user u set u.nickname = :nickname, u.hp = :hp where u.id = :id")
	public int nickNameAndHpConvert(@Param("id") String id,@Param("nickname")  String nickname,@Param("hp")  String hp); 
	
	@Query("select u.seq, u.id, u.nickname, u.hp from user u where u.id like %:id%")
	public List<User> search(@Param("id") String id); 
}
