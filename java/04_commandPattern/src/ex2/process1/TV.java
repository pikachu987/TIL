package ex2.process1;

public class TV {
	private boolean powerOn = false;
	private boolean muteOn = false;
	
	public void power(){
		powerOn =! powerOn;
		if(powerOn)
			System.out.println("Power On");
		else
			System.out.println("Power Off");
	}
	
	public void mute(){
		if(!powerOn)
			return;
		
		muteOn =! powerOn;
		if(muteOn)
			System.out.println("muteOn On");
		else
			System.out.println("muteOn Off");
	}
}
