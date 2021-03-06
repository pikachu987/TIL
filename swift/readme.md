# swift

### 일급객체
* 전달인자로 전달할 수 있다.
* 동적 프로퍼티 할당이 가능하다.
* 변수나 데이터 구조 안에 담을 수 있다.
* 반환 값으로 사용할 수 있다.
* 할당할 때 사용된 이름과 관계없이 고유한 객체로 구별할 수 있다.

> Any는 모든것
> AnyObject는 클래스의 인스턴스만 할당 가능

> typealias 별칭

> Array는 Linked-List의 형태를 띄고 있음

### 사용자 지정 연산자
perfix operator
postfix operator
infix operator


> switch case
> fallthrough


> 종료되지 않는 함수 - 비반환 함수
> func aa -> Never{
> }


## 구조체와 클래스
* 값을 저장하기 위해 프로퍼티를 정의할 수 있음
* 기능 수행을 위해 메서드를 정의할 수 있음
* 서브스크립트 문법을 통해 구조체 또는 클래스가 가지는 값(프로퍼티)에 접근하도록 서브스크립트를 정의할 수 있음
* 초기화될 때의 상태를 지정하기 위해 이니셜라이저를 정의할 수 있음
* 초기구현과 더불어 새로운 기능 추가를 위해 익스텐션을 통해 확장할 수 있음
* 특정 기능을 수행하기 위해 특정 프로토콜을 준수할 수 있음

### 클래스

* 타입캐스팅은 클래스의 인스턴스에만 허용
* 디이니셜라이저는 클래스의 인스턴스에만 활용
* 참조횟수계산은 클래스의 인스턴스에만 적용


### 구조체

* 구조체는 상속불가
* 구조체는 대입시 내용이 복사된다.
* 구조체는 값의 타입을 정의하기 위해 사용된다. 객체(Object) 레퍼런스 타입을 정의하는 class와 다르다.
* 레퍼런스 형태가 아니기 때문에 공유가 불가능하다.
* ARC(참조카운트)가 없다.
* 멀티스레딩에 안전하다.
* Object가 아니여서 AnyObject로 캐스팅이 되지 않는다.




## 구조체 사용
* 연관된 간단한 값의 집합을 캡슐화하는 것만이 목적
* 캡슐화된 값이 참조되는 것보다는 복사되는 것이 합당
* 구조체에 저장된 프로퍼티가 값 타입이며 참조되는 것보다 복사되는 것이 합당
* 다른 타입으로부터 상속받거나 자신이 상속될 필요가 없을때


## 프로퍼티
* 저장 프로퍼티
- 지연 저장 프로퍼티(lazy)
- 프로퍼티 감시자(Property Observers) (willSet- 변경되기 직전, didSet-변경된 직후) 
* 연산 프로퍼티(get, set)
* 타입 프로퍼티(static)
- 인스턴스들이 생성되기 전에 사용할 수 있는 타입 자체에 속하는 프로퍼티

 메서드
* 인스턴스 메스드
- mutating - **구조체나 열거형** 등은 값 타입이므로 메서드 앞에 mutating를 붙여서 해당 메서드가 인스턴스 내부의 값을 변경한다는 것을 명시
* 타입 메서드
- 메서드 앞에 static 키워드를 사용하면 상속 후 메서드 재정의가 불가능하고 class로 사용하면 메서드 재정의가 가능함



## 접근 수준

open 모듈외부(클래스에서만) - 개방 접근수준

public 모듈외부 - 공개 접근수준

Internal 모듈내부 - 내부 접근수준

fileprivate 파일내부 - 파일외부비공개 접근수준

private 기능 정의 내부 - 비공개 접근수준


open 과 pubilc 차이점

* 개방 접근수준을 제외한 다른 모든 접근수준의 클래스는 그 클래스가 정의된 모듈 안에서만 상속될수 있음
* 개방 접근수준을 제외한 다른 모든 접근수준의 클래스 멤버는 그 멤버가 정의된 모듈 안에서만 재정의될 수 있음
* 개방 접근수준의 클래스는 그 클래스가 정의된 모듈 밖의 다른 모듈에서도 상속될수 있음
* 개방 접근수준의 클래스 멤버는 그 멤버가 정의된 모듈 밖의 다른 모듈에서도 재정의 될 수 있음

클래스를 개방 접근수준으로 명시하는 것은 그 클래스를 다른 모듈에서도 부모클래스로 사용할 수 있으며, 그 목적으로 클래스를 설계하고 코드를 작성했음을 의미



## @escape 탈출 클로저
* 비동기 작업으로 함수가 종료되고 난 후 작업이 끝나고 호출될 필요가 있는 클로저를 사용해야 할 때

## @autoclosure 자동 클로저
* 함수의 전달인자로 전달되는 표현을 자동으로 변환해주는 클로저를 자동클로저라고 하고 자동클로저는 전달인자를 갖지 않는다.
* 자동 클로저는 자신이 감싸고 있는 코드의 결괏값을 반환한다.
* 자동클로저는 클로저가 호출되기 전까지는 클로저 내부의 코드는 동작하지 않는다.
* autoclosure 는 @noescape 속성을 포함 만약 @escape로 하려면 @autoclosure @escape 같이 써줘야함

> override 부모의 메서드 재정의

## 서브스크립트

~~~~
subscript(index: Int) -> Int{
    get{
    
    }
    set(newValue){
	
    }
}

subscript(index: Int) -> Int{
//get{}
}
~~~~


### 상속시 재정의 방지
재정의를 방지하고 싶은 특성 앞에 final 키워드를 명시하면 됨


### 클래스의 이니셜라이저

* 지정 이니셜라이저는 클래스의 주요 이니셜라이저.
* 편의 이니셜라이저는 초기화를 좀 더 쉽게 도와주는 역활. 편의 이니셜라이저는 지정 이니셜라이저를 자신 내부에서 호출. 필수는 아님. 

편의 이니셜라이저는 convenience 라는 지정자를 붙여야함

* 자식클래스의 지정 이니셜라이저는 부모클래스의 지정 이니셜라이저를 반드시 호출해야함
* 편의 이니셜라이저는 자신이 정의된 클래스의 다른 이니셜라이저를 반드시 호출해야함
* 편의 이니셜라이저는 궁극적으로는 지정 이니셜라이저를 반드시 호출해야함

* 자식클래스에서 부모클래스의 편의 이니셜라이저는 절대로 호출할 수 없음

### 이니셜라이저 자동 상속
자식클래스에서 별도의 지정 이니셜라이저를 구현하지 않는다면, 부모클래스의 지정 이니셜라이저가 자동으로 상속됨

자식클래스에서 부모클래스의 지정 이니셜라이저를 자동으로 상속받은 경우 또는 부모클래스의 지정 이니셜라이저를 모두 재정의하여 부모클래스와 동일한 지정 이니셜라이저를 모두 사용할수 있는 상황이라면 부모클래스의 편의 이니셜라이저가 모두 자동으로 상속됨


### 요구 이니셜라이저

required 수식어를 클래스의 이니셜라이저 앞에 명시해주면 이 클래스를 상속받은 자식클래스에서 반드시 해당 이니셜라이저를 구현해주어야 한다. 상속받을 때 반드시 재정의되어야 하는 이니셜라이저 앞에 required 수식어를 붙여주면 된다. 자식클래스에서는 재정의할 때 required 수식어를 사용함.

부모클래스의 일반 이니셜라이저를 자신의 클래스**부터** 요구 이니셜라이저로 변경할 경우는 required override를 명시해줌.
편의 이니셜라이저도 요구 이니셜라이저로 변경될 수 있는데 이 경우는 required convenience 명시해 주면 됨.




### 메타 타입
메타타입은 타입의 타입을 뜻함
클래스의 메타타입은 Foo.Type라 하고 프로토콜의 메타타입은 FooProtocol.Protocol 으로 표현
self를 값으로 표현가능하다.
ex) let foo: Foo.Type = Foo.self

프로그램 실행중 인스턴스의 타입을 표현한 값을 알아보고자 한다면 type(of:) 함수를 사용.
type(of: someInstance).self라고 하면 someInstance의 타입을 값으로 표현한 값을 반환.

### 프로토콜
프로토콜은 프로퍼티,메서드 등과 마찬가지로 특정한 이니셜라이저를 요구할 수 있다. 하지만 중괄호를 포함한 몸통은 적지 않는다.
이니셜라이저를 포함한 프로토콜을 상속받은 struct는 신경을 쓸께 없이 구현하면 되지만 class는 그 이니셜라이저가 지정 이니셜라이저인지 편의 이니셜라이저인지는 중요하지 않고 required 식별자를 붙인 요구 이니셜라이저로 구현해야 한다.
만약에 클래스 자체가 상속받을 수 없는 final 클래스라면 required 식별자를 붙여줄 필요가 없다.

만약 특정 클래스에 프로토콜이 요구하는 이니셜라이저가 이미 구현되어 있는 상황에서 그 클래스를 상속받은 클래스가 있다면, 프로토콜에서 요구하는 이니셜라이저를 required와 override 식별자를 모두 명시하여 이니셜라이저를 구현해주어야 한다.
