package ex1.process1;

public class Client {
	public static void main(String[] args) {
		Robot taekwonV = new TaekwonV("TaekwonV");
		Robot atom = new Atom("Atom");
		
		System.out.println("My name is "+taekwonV.getName());
		taekwonV.attack();
		taekwonV.move();
		
		System.out.println("My name id "+atom.getName());
		atom.attack();
		atom.move();
	}
}
