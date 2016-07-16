package ex2.process2.obj;

public class Book {
	private String sign;
	private int year;
	private int price;
	
	public Book(String sign, int year, int price){
		this.sign = sign;
		this.year = year;
		this.price = price;
	}
	public String getSign(){
		return this.sign;
	}
	public int getYear(){
		return this.year;
	}
	public int getPrice(){
		return this.price;
	}
}
