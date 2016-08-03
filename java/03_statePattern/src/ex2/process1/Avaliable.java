package ex2.process1;


public class Avaliable implements State {
	private static Avaliable avaliable = new Avaliable();
	private Avaliable(){};
	public static Avaliable getInstance(){
		return avaliable;
	}
	@Override
	public void checkout(Book book) {
		// TODO Auto-generated method stub
		System.out.println("book checkout - loan");
		book.setState(Loan.getInstance());
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