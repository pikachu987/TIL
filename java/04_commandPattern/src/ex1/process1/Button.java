package ex1.process1;

public class Button {
	private Lamp theLamp;
	public Button(Lamp lamp){
		this.theLamp = lamp;
	}
	
	public void pressed(){
		this.theLamp.turnOn();
	}
}
