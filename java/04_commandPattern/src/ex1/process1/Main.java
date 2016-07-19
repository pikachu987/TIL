package ex1.process1;

public class Main {
	public static void main(String[] args) {
		Lamp lamp = new Lamp();
		Button button = new Button(lamp);
		button.pressed();
	}
}
