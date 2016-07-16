package ex2.process2.obj;

import ex2.process2.pricePolicy.PricePolicy;

public class Buy {
	private User user;
	private Book book;
	private int volume;
	private PricePolicy pricePolicy;
	public Buy(User user, Book book, PricePolicy pricePolicy, int volume){
		this.user = user;
		this.book = book;
		this.volume = volume;
		this.pricePolicy = pricePolicy;
		user.addPrice(policyPrice());
	}
	
	public int policyPrice(){
		return pricePolicy.priceCal(book.getPrice(), volume);
	}
	
	public void log(){
		System.out.println("userName = "+user.getName()+" / price = "+policyPrice()+" won");
	}
}
