package ex1.process3.robot;

import ex1.process3.attack.AttackStrategy;
import ex1.process3.move.MovingStrategy;

public abstract class Robot {
	private String name;
	private MovingStrategy movingStrategy;
	private AttackStrategy attackStrategy;
	
	public Robot(String name){
		this.name = name;
	}
	
	public String getName(){
		return name;
	}
	
	public void move(){
		movingStrategy.move();
	}
	public void attack(){
		attackStrategy.attack();
	}
	
	public void setMovingStrategy(MovingStrategy movingStrategy){
		this.movingStrategy = movingStrategy;
	}
	public void setAttackStrategy(AttackStrategy attackStrategy){
		this.attackStrategy = attackStrategy;
	}
}
