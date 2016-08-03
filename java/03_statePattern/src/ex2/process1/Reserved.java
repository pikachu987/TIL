package ex2.process1;

public class Reserved implements State {
	private static Reserved reserved = new Reserved();
	private Reserved(){};
	public static Reserved getInstance(){
		return reserved;
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
		System.out.println("book cancel - loan");
		book.setState(Loan.getInstance());
	}
	@Override
	public void timeout(Book book) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void bookReturn(Book book) {
		// TODO Auto-generated method stub
		System.out.println("book return - kept");
		book.setState(Kept.getInstance());
	}
}