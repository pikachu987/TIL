package ex2.process1;

public class NonePricePolicy implements PricePolicy {

	@Override
	public int priceCal(int price, int volume) {
		// TODO Auto-generated method stub
		return price*volume;
	}

}
