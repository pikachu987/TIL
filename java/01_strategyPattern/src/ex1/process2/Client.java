package ex1.process2;

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
