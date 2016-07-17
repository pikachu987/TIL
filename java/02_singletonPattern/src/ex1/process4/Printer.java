package ex1.process4;


public class Printer {
	private static Printer printer = null;
	private int counter = 0;
	private Printer(){}
	
	public synchronized static Printer getPrinter(){
		if(printer == null){
			printer = new Printer();
		}
		return printer;
	}
	
	public void print(String str){
		synchronized (this) {
			counter++;
			System.out.println(str+"_"+counter);
		}
	}
}
