package ex2.process1;

public class Loan implements State {
	private static Loan loan = new Loan();
	private Loan(){};
	public static Loan getInstance(){
		return loan;
	}
	@Override
	public void checkout(Book book) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void reserve(Book book) {
		// TODO Auto-generated method stub
		System.out.println("book reserve - reseved");
		book.setState(Reserved.getInstance());
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
		System.out.println("book return - Avaliable");
		book.setState(Avaliable.getInstance());
	}
}
