package ex2.process1;


public interface State {
	public void checkout(Book book);
	public void reserve(Book book);
	public void cancel(Book book);
	public void timeout(Book book);
	public void bookReturn(Book book);
}
