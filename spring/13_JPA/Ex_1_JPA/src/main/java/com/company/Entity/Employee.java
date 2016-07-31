package com.company.Entity;

import java.util.Date;

import javax.persistence.AttributeOverride;
import javax.persistence.AttributeOverrides;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name ="EMPLOYEE")
public class Employee {
	@Id
	@Column(name="SEQ")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long seq;
	
	@Column(name= "NAME")
	private String name;
	
	@Embedded
	@AttributeOverrides({
		@AttributeOverride(name="addr1",
				column= @Column(name="addr1")),
		@AttributeOverride(name="addr2",
		column= @Column(name="addr2"))
	})
	private Address address;
	
	@ManyToOne
	@JoinColumn(name="TEAMSEQ")
	private Team team;
	
	@Temporal(TemporalType.DATE)
	@Column(name = "JOINDATE")
	private Date joinDate;

	public Employee(Long seq, String name, Address address, Team team, Date joinDate) {
		super();
		this.seq = seq;
		this.name = name;
		this.address = address;
		this.team = team;
		this.joinDate = joinDate;
	}

	public Long getSeq() {
		return seq;
	}

	public String getName() {
		return name;
	}

	public Address getAddress() {
		return address;
	}

	public Team getTeam() {
		return team;
	}

	public Date getJoinDate() {
		return joinDate;
	}
	
	
}
