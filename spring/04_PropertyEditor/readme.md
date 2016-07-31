## 확장포인트와 PropertyEditor/ConversionService

여기서는 스프링이 실제 내부적으로 어떻게 동장하는지 파악하는데 도움이 될 것이다.

### 스프링 확장 포인트
스프링은 다음의 두 가지 방법을 이용해서 기능을 확장하는 방법을 제공한다.
* BeanFactoryPostProcessor를 이용한 빈 설정 정보 변경
* BeanPostProcessor을 이용한 빈 객체 변경

두 가지는 적용되는 시점이 각각 다른데, 한 방법은 빈 객체를 생성하기 전에 적용되고 다른 하나는 빈 객체를 생성한 이후에 적용된다. 

### PropertyEditor와 ConversionService