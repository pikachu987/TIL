package ex2.process1;

public class Keep implements State {
	private static Keep keep = new Keep();
	private Keep(){};
	public static Keep getInstance(){
		return keep;
	}
	@Override
	public void checkout(Book book) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void reserve(Book book) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void cancel(Book book) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void timeout(Book book) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void bookReturn(Book book) {
		// TODO Auto-generated method stub
		
	}
}
