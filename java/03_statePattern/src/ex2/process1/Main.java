package ex2.process1;

public class Main {
	public static void main(String[] args) {
		Book book = new Book();
		book.checkout();
		book.bookReturn();
		book.checkout();
		book.reserve();
		book.bookReturn();
		book.timeout();
	}
}
