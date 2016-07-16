package ex1.process2;

public class ON implements State {
	private static ON on = new ON();
	private ON(){};
	public static ON getInstance(){
		return on;
	}
	@Override
	public void on_button_pushed(Light light) {
		// TODO Auto-generated method stub
		System.out.println("Sleep ON");
		light.setState(SLEEP.getInstance());
	}

	@Override
	public void off_button_pushed(Light light) {
		// TODO Auto-generated method stub
		System.out.println("Light Off");
		light.setState(OFF.getInstance());
	}

}
