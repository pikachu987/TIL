## DI

스프링의 가장 기본적인 기능은 객체를 생성하고 초기화하여 필요로 하는 곳에 제공하는 것인데, 이 중심에는 DI(Dependency Injection)라는 설계 패턴이 적용되어 있다.
DI는 의존 주입 이라는 단어로 번역되어 사용된다. **의존** 이라는 단어에서 알 수 있듯이 DI는 의존을 처리하는 방법에 대한 내용이다. 스프링은 기본적으로 DI를 기반으로 동작하기 때문에, 스프링을 설명하기에 앞서 DI에 대해 살펴 보겠다.

의존 객체를 직접 생성하는 방식의 단점
* 개발효율을 낮추는 상황을 만들기도 한다.
* 코드 완성이 늦어지게 된다.

> 생성자를 이용해서 의존 객체를 전달받는 방식이 DI에 따라 구현한 것이다.
> DI는 크게 생성자 방식과 프로퍼티 설정 방식이 있다.