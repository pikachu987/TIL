package ex2.process1;

public class Book {
	private State state;
	
	public Book(){
		state = Avaliable.getInstance();
	}
	
	public void setState(State state){
		this.state = state;
	}
	public void checkout(){
		state.checkout(this);
	}
	public void reserve(){
		state.reserve(this);
	}
	public void cancel(){
		state.cancel(this);
	}
	public void timeout(){
		state.timeout(this);
	}
	public void bookReturn(){
		state.bookReturn(this);
	}
}
