package ex1.process4;

public class Main {
	private static final int USER_NUM = 9;
	public static void main(String[] args) {
		UserThread[] user = new UserThread[USER_NUM];
		for(int i=0; i<user.length; i++){
			user[i] = new UserThread((i + 1) + "-user");
			user[i].start();
		}
	}
}
