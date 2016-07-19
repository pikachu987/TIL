package ex1.process2;

public class LampOffCommand implements Command{
	private Lamp lamp;
	public LampOffCommand(Lamp lamp) {
		// TODO Auto-generated constructor stub
		this.lamp = lamp;
	}
	@Override
	public void execute() {
		// TODO Auto-generated method stub
		lamp.turnOff();
	}
}
