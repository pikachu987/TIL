package com.company.common;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;

import com.company.domain.Option;

public class CustomJpaRepository<T, ID extends Serializable>
		extends SimpleJpaRepository<T, ID>
		implements CustomRepository<T, ID> {

	private EntityManager entityManager;

	public CustomJpaRepository(Class<T> domainClass, EntityManager em) {
		super(domainClass, em);
		this.entityManager = em;
	}

	public CustomJpaRepository(JpaEntityInformation<T, ?> entityInfomation, EntityManager entityManager) {
		super(entityInfomation, entityManager);
		this.entityManager = entityManager;
	}

	@Override
	public Option<T> getOption(ID id) {
		return Option.value(entityManager.find(getDomainClass(), id));
	}

}
