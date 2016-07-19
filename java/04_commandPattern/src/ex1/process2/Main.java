package ex1.process2;

public class Main {
	public static void main(String[] args) {
		Lamp lamp = new Lamp();
		Command lampOn = new LampOnCommand(lamp);
		Command lampOff = new LampOffCommand(lamp);
		Command alarm = new Alarm();
		Button button = new Button(lampOn);
		button.pressed();
		
		button.setCommand(alarm);
		button.pressed();
		
		button.setCommand(lampOff);
		button.pressed();
		
		button.setCommand(lampOn);
		button.pressed();
	}
}
