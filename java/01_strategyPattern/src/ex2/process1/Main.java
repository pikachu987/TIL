package ex2.process1;

public class Main {
	public static void main(String[] args) {
		User user1 = new User("user1");
		User user2 = new User("user2");

		Book book1 = new Book("foo", 1900, 15000);
		Book book2 = new Book("boo", 2010, 27000);
		Book book3 = new Book("coo", 2016, 12500);

		Buy buy1 = new Buy(user1, book1, new BookPricePolicy(), 3);
		Buy buy2 = new Buy(user1, book3, new UserPricePolicy(), 2);
		Buy buy3 = new Buy(user2, book2, new NonePricePolicy(), 4);
		Buy buy4 = new Buy(user1, book3, new UserPricePolicy(), 3);
		Buy buy5 = new Buy(user2, book3, new UserPricePolicy(), 2);
		Buy buy6 = new Buy(user1, book1, new BookPricePolicy(), 1);

		buy1.log();
		buy2.log();
		buy3.log();
		buy4.log();
		buy5.log();
		buy6.log();

		System.out.println("user1 - book buy price = "+user1.getPrice());
		System.out.println("user2 - book buy price = "+user2.getPrice());
	}
}
