package ex2.process2.pricePolicy;

public class UserPricePolicy implements PricePolicy {

	@Override
	public int priceCal(int price, int volume) {
		// TODO Auto-generated method stub
		return (int)(price*volume*0.95);
	}

}
