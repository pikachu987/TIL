## strategyPattern
스트래티지 패턴은 전략을 쉽게 바꿀 수 있도록 해주는 디자인 패턴이다. 여기에서 전략이란 어떤 목적을 달성하기 위해 일을 수행하는 방식, 비지니스 규칙, 문제를 해결하는 알고리즘 등으로 이해할 수 있다.
프로그램에서 전략을 실행할 때는 쉽게 전략을 바꿔야 할 필요가 있는 경우가 많이 발생한다. 특히 게임 프로그래밍에서 게임 캐릭터가 자신이 처한 상황에 따라 공격이나 행동하는 방식을 바꾸고 싶을 때 스트래티지 패턴은 매우 유용하다.
(스트래티지 패턴은 같은 문제를 해결하는 여러 알고리즘이 클래스별로 캡슐화되어 있고 이들이 필요할 때 교체할 수 있도록 함으로써 동일한 문제를 다른 알고리즘으로 해결할 수 있게 하는 디자인 패턴이다.)

### ex1 로봇 만들기

##### ex1.process1 의문제점
* 기존 로봇의 공격 또는 이동 방법을 수정하려면 어떤 변경 작업을 해야 하는가? 예를 들어 아톰이 날 수는 없고 오직 걷게만 만들고 싶다면? 또는 태권V를 날게 하려면?
* 새로운 로봇을 만들어 기존의 공격 또는 이동 방법을 추가하거나 수정하려면? 예를 들어 새로운 로봇으로 지구의 용사 선가드를 만들어 태권V의 미사일 공격 기능을 추가하려면?
  
  
> 만약 움직임이나 공격에 대해 바꾸려면 TaekwonV 클래스와 Atom클래스의 코드를 바꿔야 할것이다. 기존 코드의 내용을 수정 해야하니까 OCP에 위배된다.
> 새로운 로봇에 공격/이동 방법을 추가/수정할 경우는 새로운 클래스를 만들어서 Robot를 상속 받으면 되지만 move, attack코드가 중복이 될 수 있다.
> * 캡슐화! 인터페이스를 만들자!!

###### ex1.process2 수정

> Attack와 Moving 을 인터페이스로 만들고 할수 있는 Action을 다 인터페이스를 상속받은 클래스로 만들었다.
> main함수 내에서 set으로 클래스를 추가했다. 이제 OCP에 위배되지 않는다.
> 기능에 따라 패키지를 나누자.(나누는 방법도 상황에따라 다른대 여기서는 attack, move, robot의 패키지로 나눠보자) ->ex1.process3

### ex2 스트래티지패턴 만들기
* 회원은 이름과 누적 대여 금액을 같는다.
* 책은 서명, 출판년도, 가격을 갖는다(재고는 무한대라고 가정)
* 회원은 하나의 책을 1권 이상 살 수 있다.
* 회원이 책을 살 때마다 누적 금액이 저장된다.
* 가격 정책에 따라 책 값이 할인되며 다른 가격 정책이 추가될 수 있다.
* 10년 이상된 책은 책 자체할인, 누적대여금액이 만원 이상이며 회원할인, 그 외의 경우에는 할인이 되지 않는다.

> 멘붕..... 일단 회원객체 User를 만들자.
> 다음은 책객체 Book를 만들자.
> 여기까진 일반적으로 생각이 가능하다.
> 회원이 책을 사는 것을 List로 만들어야 되나?
> 음.... 회원 입장에서 보는게 아니라 판매점 입장에서 보자.
> 판매점 입장에서 보면 팔다라는 Buy 객체가 필요할듯 하다.
> Buy는 회원과 책의 객체들이 필요할꺼 같다.
> Buy는 일단 생성자에 회원, 책과 갯수를 받자
> 회원이 책을 살때 마다 누적금액을 받아야 한다. addPrice method를 만들어보자
> 가격 정책이 있다... 책마다 금액이 잇는데 이 금액이 가격정책따라 다르다.
> 역시 디자인패턴이란 멘붕이다.
> 여기서 스트래티지 패턴이 들어갈듯 하다.
> 가격정책이라는 인터페이스를 만들고 여러가지 가격정책 인터페이스를 상속받은 클래스를 만들어야 할거 같다.
> 가격정책 클래스는 메인클래스를 짤때 만들어도 무방할거 같다.
> 먼저 인터페이스를 만든 뒤 Buy객체의 상속자에 넣어보자.
> 이제 위에설명에 따라 가격정책 클래스들을 만들어보자.
> 이제 main클래스에 멋대로 넣어보자!!!

##### ex2.process1 정리
> 패키지를 이제는 가격정책, 객체로 나눠보자!