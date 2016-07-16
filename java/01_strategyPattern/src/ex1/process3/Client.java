package ex1.process3;

import ex1.process3.attack.MissileStrategy;
import ex1.process3.attack.PunchStrategy;
import ex1.process3.move.FlyingStrategy;
import ex1.process3.move.WalkingStrategy;
import ex1.process3.robot.Atom;
import ex1.process3.robot.Robot;
import ex1.process3.robot.TaekwonV;

public class Client {
	public static void main(String[] args) {
		Robot taekwonV = new TaekwonV("TaekwonV");
		Robot atom = new Atom("Atom");
		 
		taekwonV.setAttackStrategy(new MissileStrategy());
		taekwonV.setMovingStrategy(new WalkingStrategy());
		
		atom.setAttackStrategy(new PunchStrategy());
		atom.setMovingStrategy(new FlyingStrategy());
		
		System.out.println("My name is "+taekwonV.getName());
		taekwonV.attack();
		taekwonV.move();
		
		System.out.println("My name id "+atom.getName());
		atom.attack();
		atom.move();
	}
}
