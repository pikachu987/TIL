package ex1.process2;

public class OFF implements State {
	private static OFF off = new OFF();
	private OFF(){}
	public static OFF getInstance(){
		return off;
	}
	@Override
	public void on_button_pushed(Light light) {
		// TODO Auto-generated method stub
		System.out.println("Light On");
		light.setState(ON.getInstance());
	}

	@Override
	public void off_button_pushed(Light light) {
		// TODO Auto-generated method stub
		System.out.println("반응 없음");
		light.setState(OFF.getInstance());
	}

}
