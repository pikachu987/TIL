## commandPattern
커맨드패턴은 이벤트가 발생했을 때 실행될 기능이 다양하면서도 변경이 필요한 경우에 이벤트를 발생시키는 클래스를 변경하지 않고 재사용하고자 할 때 유용하다.
예를 들어 'FileOpen'이라는 메뉴 항목이 선택되었을 때 실행될 기능과 'FileClone'라는 메뉴 항목이 선택되었을 때 실행되는 기능은 다를 것이다. 이런 경우 MenuItem클래스에서 직접 구체적인 기능을 구현한다면 'FileOpen' 메뉴 항목을 위한 MenuItem클래스와 'FileClose' 메뉴항목을 위한 MenuItem클래스를 각각 구현해야 한다. MenuItem 클래스는 하나이므로 'FileOpen', 'FileClose' 메뉴 항목을 재사용하기 어려울 수 있기 때문이다.
이런 경우에는 커맨드패턴을 이용하면 MenuItem 클래스를 재사용할 수 있다. 먼저 'FileOpen' 메뉴의 기능과 'FileClose'메뉴의 기능을 담당하는 클래스가 Command라는 인터페이스를 구현하도록 한다.
그리고 MenuItem 클래스가 Command 인터페이스를 사용하도록 설계하면 MenuItem클래스는 'FileOpen' 메뉴항목과 'FileClose' 메뉴 항목에서 그대로 재사용 할수있게 된다.
* **Command**: 실행될 기능에 대한 인터페이스, 실행될 기능을 execute 메서드로 선언함
* **ConcreateCommand**: 실제로 실행되는 기능을 구현. 즉, Command라는 인터페이스를 구현함
* **Invoker**: 기능의 실행을 요청하는 호출자 클래스
* **Receiver**: ConcreateCommand에서 execute 메서드를 구현할 때 필요한 클래스. 즉, ConcreateCommand의 기능을 실행하기 위해 사용하는 수신자 클래스

---

### ex1 만능버튼 만들기
눌리면 특정 기능을 수행하는 버튼을 생각해보자. 버튼을 눌렀을때 램프의 불이 켜지는 프로그램을 개발하려면 버튼이 눌려졌음을 인식하는 Button 클래스, 불을 켜는 기능을 제공하는 Lamp 클래스가 필요하다.
그리고 버튼이 눌렸을때 램프를 켜려면 Button 클래스는 Lamp 객체를 참조해야 한다.

#### ex1.process1 의문제점
* 누군가 버튼을 눌렀을 때 램프가 켜지는 대신 다른 기능을 실행하게 하려면 어떤 변경 작업을 해야 하는가? 예를 들어 버튼을 눌렀을 때 알람이 시작되게 하려면?
* 버튼을 누르는 동작에 따라 다른 기능을 실행하게 하려면 어떤 변경 작업을 해야 하는가? 예를 들어 버튼을 처음 눌렀을 때는 램프를 켜고, 두번째 눌렀을 때는 알람을 동작하게 하려면?

#### ex1.process1 해결책
> 버튼을 처음 눌렀을 때는 램프를 켜고 두번 눌렀을 때는 알람을 동작하게 할 경우에 Button 클래스는 2가지 기능을 모두 구현해야 한다.
> 하지만 코드 안에 기능을 전부 넣으면 기능을 새로 추가할때마다 반복적이니까 재사용이 힘들다.
> 구체적인 기능을 직접 구현하는 대신 버튼을 눌렀을 때 실행될 기능을 Button 클래스 외부에서 제공받아 캡슐화 하자.
  
* Button 클래스는 Invoker 역활을 수행한다.
* LampOnCommmand와 LampOffCommand는 각각 ConcreateCommand 역활을 수행한다.
* Lamp 클래스는 Receiver 역활을 수행한다.

---

### ex2 TwoButtonContrller 개선해보기
* TwoButtonController 클래스를 이용해 TV 전원과 음소거를 제어할 수 있다.
* TwoButtonController 클래스의 각 버튼을 눌렀을 때 실행되는 기능은 전원과 음소거 중에서 임의의 방식으로 결정할 수 있다. 버튼이 2개(button1, button2)고 동작할 수 있는 기능이 2가지(전원과 음소거)이므로 다음과 같은 4가지 조합이 가능해야 한다.

>   조합		button1	button2
>   조합1		전원제어	전원제어
>   조합2		전원제어	음소거제어
>   조합3		음소거제어	전원제어
>   조합4		음소거제어	음소거제어

* TwoButtonController 클래스는 각 버튼이 눌렀을 때 동작하는기능을 변경할 수 있어야 한다. 그러나 TwoButtonController 클래스의 코드가 변경되지 않도록 해야 한다.