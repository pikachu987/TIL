package ex2.process1;

public class Main {
	public static void main(String[] args) {
		TV tv = new TV();
		TwoButtonController btn = new TwoButtonController();
		Command power = new Power(tv);
		Command mute = new Mute(tv);
		btn.setCommand(power, mute);
		
		
		btn.button1Pressed();
		btn.button1Pressed();
		btn.button1Pressed();
		btn.button2Pressed();
		btn.button2Pressed();
		btn.button2Pressed();
		btn.button1Pressed();
		btn.button1Pressed();
		btn.button1Pressed();
		btn.button1Pressed();
		btn.button1Pressed();
		btn.button2Pressed();
		btn.button2Pressed();
		btn.button2Pressed();
		
	}
}
