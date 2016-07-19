package ex2.process1;

public class Mute implements Command{
	private TV tv;
	
	public Mute(TV tv){
		this.tv = tv;
	}

	@Override
	public void execute() {
		// TODO Auto-generated method stub
		tv.mute();
	}
	
}
