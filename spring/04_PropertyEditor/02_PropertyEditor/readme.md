### PropertyEditor와 ConversionService

~~~~

public class DataConllector implements ThresholdRequired{
	private int threshold;
	@Override
	public void setThreshold(int threshold){
		this.threshold = threshold;
	}
	...
}
~~~~

DataCollector 클래스를 스프링 빈으로 등록할 때 다음의 설정을 사용할 것이다.

~~~~
<bean id="collector1" class="com.company.DataCollector">
	<property name="threshold" value="5" />
</bean>
~~~~

여기서 threshold 프로퍼티의 값을 설정할 때 사용한 "5" 는 문자열이고, 실제 setThreshold() 메서드의 파라미터는 int 타입이다. 스프링은 내부적으로 문자열을 "5"를 int 타입 5로 변환한 뒤에 setThreshold() 메서드에 값을 전달한다. 스프링은 int 타입외에 long, double, boolean 타입 등 기본 데이터 타입으로의 변환을 지원할 뿐만 아니라 문자열을 Properties 타입이나 URL등으로 변환할 수 있다.

스프링은 내부적으로 PropertyEditor를 이용해서 문자열을 알맞은 타입으로 변환한다. 또한, 스프링 3버전부터는 ConversionService를 이용해서 타입 변환을 처리할수 있게 되었다.

#### PropertyEditor를 이용한 타입 변환

자바빈 규약은 문자열을 특정 타입의 프로퍼티로 변환할 때 java.beans.PropertyEditor 인터페이스를 사용한다. 자바는 기본 데이터 타입을 위한 PropertyEditor를 이미 제공하고 있다. sun.beans.editors 패키지에는 BooleanDeitor, LongEditor, EnumEditor 등 기본 타입을 위한 PropertyEditor를 제공하고 있으면, 이들은 통해서 문자열을 boolean, long, enum 등을 타입으로 변환할 수 있다.

자바에 기본으로 포함된 PropertyEditor 구현체는 기본적인 타입만 지원하기 떄문에, 스프링은 설정 등의 편의를 위해 PropertyEditor를 추가로 제공하고 있다. 얘를들어, 스프링은 URL을 위한 URLEditor를 제공하고 있다. 따라서, 다음과 같이 URL 타입의 프로퍼티를 정의하고 XML에서 문자열을 이용해서 값을 설정할 수 있다.

~~~~
import java.net.URL;
public class RestClient{
	private URL serverUrl;
	public void setServerUrl(URL serverUrl){
		this.serverUrl = serverUrl;
	}
}
~~~~
> 자바 코드



~~~~
<bean class="com.company.RestClient">
	<!-- URLEditor를 이용해서 문자열을 URL타입으로 변환 -->
	<property name="serverUrl" value="https://www.googleapis.com/language/translate/v2" />
</bean>
~~~~
> XML 설정

##### 스프링이 제공하는 주요 PropertyEditor
스프링은 URL을 비롯해 주요 타입에 대한 PropertyEditor를 제공하고 있으며 이들 목록은 밑에 표와 같다. 모든 클래스는 org.springframework.beans.propertyeditors 패키지에 위치하며, '기본' 이라고 푷시한 것은 별도 설정 없이 사용되는 것이다.

<table>
<tr>
<th>PropertyEditor</th><th>설명</th><th>기본 사용</th>
</tr>
<tr>
<td>ByteArrayPropertyEditor</td><td>String.getBytes()를 이용해서 문자열 byte 배열로 변환</td><td>기본</td>
</tr>
<tr>
<td>CharArrayPropertyEditor</td><td>String.toCharArray()를 이용해서 문자열을 char 배열로 변환</td><td></td>
</tr>
<tr>
<td>CharsetEditor</td><td>문자열을 Charset으로 변환</td><td>기본</td>
</tr>
<tr>
<td>ClassEditor</td><td>문자열을 Class타입으로 변환</td><td>기본</td>
</tr>
<tr>
<td>CurrencyEditor</td><td>문자열을 java.util.Currency로 변환</td><td></td>
</tr>
<tr>
<td>CustomBooleanEditor</td><td>문자열을 Boolean 타입으로 변환</td><td>기본</td>
</tr>
<tr>
<td>CustomerDateEditor</td><td>DateFormat을 이용해서 문자열을 java.util.Date로 변환</td><td></td>
</tr>
<tr>
<td>CustomNumberEditor</td><td>Long, Double, BigDecimal 등 숫자 타입을 위한 프로퍼티 에디터</td><td>기본</td>
</tr>
<tr>
<td>FileEditor</td><td>문자열을 java.io.File로 변환</td><td>기본</td>
</tr>
<tr>
<td>LocaleEditor</td><td>문자열을 Locale로 변환</td><td>기본</td>
</tr>
<tr>
<td>PatternEditor</td><td>정규 표현식문자열을 Pattern으로 변환</td><td>기본</td>
</tr>
<tr>
<td>PropertiesEdito</td><td>문자열을 Properties로 변환</td><td>기본</td>
</tr>
<tr>
<td>URLEditor</td><td>문자열을 URL로 변환</td><td>기본</td>
</tr>
</table>

CustomDateEditor나 PatternEditor는 기본으로 사용되지 않는다. 따라서 XML 설정에서 Date 타입의 프로퍼티를 설정하면 스프링 익셉션을 발생시킨다.

~~~~
<bean class="com.company.RestClient">
	<property name="serverUrl" value="https://www.googleapis.com/language/translate/v2" />
	<!-- apiDate가 java.util.Date 타입인 경우, 변환을 위한 PropertyEditor가 존재하지 않아 익셉션 발생 -->
	<property name="apiDate" value="2010-03-04 10:48:66:00" />
</bean>
~~~~

기본으로 사용되지 않는 PropertyEditor를 사용하려면, PropertyEditor를 추가로 등록 해주어야 한다.

#####  커스텀 PropertyEditor 구하기

직접 구현한 클래스처럼 PropertyEditor가 존재하지 않는 경우 PropertyEditor를 직접 구현해 주어야 한다.

~~~~
public class Money{
	private int amount;
	private String currency;

	public Money(int amount, String currency){
		this.amount = amount;
		this.currency = currency;
	}

}
~~~~

문자열을 Money 클래스로 변환해주는 PropertyEditor를 구현하려면 PropertyEditor 인터페이스를 상속 받아 알맞은 메서드를 구현해주면 된다. 그런데, PropertyEditor인터페이스는 문자열을 Money 타입으로 변환하기 위한 메서드 외에 추가적인 메서드를 많이 정의하고 있기 때문에, 단순히 변환 기능만 필요하다면 PropertyEditorSupport 클래스를 상속받아 setAsText() 메서드를 재정의하면 된다.

> String 을 Money로 변환하기 위한 PropertyEditor 구현

~~~~
import java.beans.PropertyEditorSupport;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MoneyEditor extends PropertyEditorSupport{

	@override
	public void setAsText(String text) throws IllegalArgumentException{
		Pattern pattern = Pattern.compile("([0-9]+)([A-Z]{3})");
		Matcher matcher = pattern.matcher(text);
		if (!matcher.matchers())
			throw new IllegalArgumentException("invalid format");

		int amount = Integer.parseInt(matcher.group(1));
		String currency = matcher.group(2);
		setValue(new Money(amount, currency));
	}
}

~~~~

이제 MoneyEditor 클래스를 이용하면 Money 타입의 프로퍼티 값을 문자열로 설정할 수 있다.

~~~~
<bean class="com.company.InvestmentSimulator">
	<!-- minimumAmount 프로퍼티가 Money 타입 -->
	<property name="minimumAmount" value="10000WON" />
</bean>
~~~~

실제로 위 설정이 올바르게 동작하려면, 문자열을 Money로 변환할 때 MoneyEditor를 사용하도록 추가로 설정해주어야 한다.


##### PropertyEditor 추가 : 같은 패키지에 PropertyEditor 위치시키기

PropertyEditor를 구현했다면, 실제로 PropertyEditor를 사용하도록 PropertyEditor를 등록해주어야 한다. 이를 위한 가장 쉬운 방법은 다음과 같은 규칙에 따라 PropertyEditor를 작성하는 것이다.( 이 규칙은 자바빈 규약에 명시된 것이다.)

* 변환 대상 타입과 동일한 패키지에 '타입Editor' 이름으로 PropertyEditor를 구현

예를 들어, Money 클래스가 com.company.foo 패키지에 존재한다고 할 경우, 같은 패키지에 MoneyEditor라는 이름으로 PropertyEditor를 구현한다. 그러면, 문자열을 Money 타입으로 변환할때 MoneyEditor를 사용해서 변환을 수행한다.

##### PropertyEditor 추가 :  CustomEditorConfigurer 사용하기

특정 타입을 위해 구현한 PropertyEditor가 다른 패키지에 위치하거나 이름이 '타입Editor'가 아니라면, CustomEditorConfigurer를 이용해서 설정해주어야 한다. CustomEditorConfigurer는 BeanFactoryPostProcessor로서 스프린 빈을 초기화하기 전에 필요한 PropertyEditor를 등록할 수 있도록 해준다.

~~~~
<bean class="org.springframework.beans.factory.config.CustomEditorConfigurer">
	<property name="customEditors">
		<map>
			<entry key="com.company.Money" value="com.company.MoneyEditor2" />
		</map>
	</property>
</bean>

<bean class="com.company.InverstmentSimulator">
	<!-- minimumAmount 가 Money 타입일 경우, MoneyEditor2를 이용해서 타입 변환 -->
	<property name="minimumAmount" value="10000WON" />
</bean>
~~~~

customEditors 프로퍼티는 (타입, 타입 PropertyEditor) 상을 맵으로 전달받는다. 위 코드의 경우 Money 타입을 위한 PropertyEditor로 MoneyEditor2를 사용한다고 설정했으므로, Money 타입인 minimumAmount 프로퍼티의 값인 "10000WON"을 변환할 때 MoneyEditor2를 사용한다.

##### PropertyEditor 추가 : PropertyEditorRegistrar 사용하기

CustomEditorConfigurer 의 customEditors 프로퍼티를 이용해서 설정할 때 단점은 PropertyEditor에 매개변수를 설정할 수 없다는 점이다. 예를 들어, 특정 패턴에 맞게 입력한 문자열을 Date 타입으로 변환하고 싶은 경우 패턴을 지정할 수 있어야 하는데, 앞서 설정 방식은 PropertyEditor의 클래스 이름을 사용하므로 이런 매개변수를 지정할 수 없다. 이렇게 PropertyEditor에 매개 변수를 지정하고 싶을 때 사용할 수 있는 것이 PropertyEditorRegistrar이다.

PropertyEditorRegistrar 인터페이스로서 다음과 같이 정의되어 있다.

~~~~
package org.springframework.beans;

public interface PropertyEditorRegistrar{
	void registerCustomEditors(PropertyEditorRegistry registry);
}
~~~~

특정 타입을 위한 PropertyEditor 객체를 직접 생성해서 설정하고 싶다면 다음과 같은 방법으로 PropertyEditorRegistrar를 사용하면 된다.

* PropertyEditorRegistrar 인터페이스를 상속받은 클래스에서 PropertyEditor를 직접 생성하고 등록한다.
* 1번 과정에서 생성한 클래스를 빈으로 등록하고, CustomEditorConfigurer에 propertyEditorRegistrars 프로퍼티로 등록한다.

먼저 할 작업은 PropertyEditorRegistrar 인터페이스를 상속받아 구현하는 것이다. 상속받은 클래스는 registerCustomEditors() 메서드에서 원하는 PropertyEditor를 생성해서 등록하면 된다. 예를 들어, CustomDateEditor를 사용하고 싶다면, 다음과 같이 구현할 수 있다.

~~~~


~~~~


