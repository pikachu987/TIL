package ex2.process1;

public class Kept implements State {
	private static Kept kept = new Kept();
	private Kept(){};
	public static Kept getInstance(){
		return kept;
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
		System.out.println("book cancel - Avaliable");
		book.setState(Avaliable.getInstance());
	}
	@Override
	public void timeout(Book book) {
		// TODO Auto-generated method stub
		System.out.println("book timout - Avaliable");
		book.setState(Avaliable.getInstance());
	}
	@Override
	public void bookReturn(Book book) {
		// TODO Auto-generated method stub
		
	}
}