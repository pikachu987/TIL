package ex2.process1;

public class Power implements Command{
	private TV tv;
	public Power(TV tv){
		this.tv = tv;
	}
	@Override
	public void execute() {
		// TODO Auto-generated method stub
		tv.power();
	}
	
}
