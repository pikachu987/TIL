package ex2.process2.pricePolicy;

public class NonePricePolicy implements PricePolicy {

	@Override
	public int priceCal(int price, int volume) {
		// TODO Auto-generated method stub
		return price*volume;
	}

}