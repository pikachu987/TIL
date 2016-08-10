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
import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.beans.PropertyEditorRegistrar;
import org.springframework.beans.PropertyEditorRegistry;
import org.springframework.beans.propertyeditors.CustomDateEditor;

public class CustomPropertyEditorRegistrar implements PropertyEditorRegistrar{

	private String datePattern;

	@Override
	public void registerCustomEditors(PropertyEditorRegistry registry){
		CustomDateEditor propertyEditor = new CustomDateEditor(new SimpleDateFormat(datePattern), true);
		registry.registerCustomEditor(Date.class, propertyEditor);
	}

	public void setDatePattern(String datePattern){
		this.datePattern = datePattern;
	}
}
~~~~

registry.registerCustomEditor() 메서드에서 첫 번째 파라미터는 변환 대상이 되는 타입을 지정하고, 두 번째 파라미터는 문자열을 지저아 타입으로 변환할 때 사용할 PropertyEditor 객체를 지정한다. 위 코드에서는 Date 타입의 변환 처리를 위해 CustomDateEditor 객체를 지정하였다.

PropertyEditorRegistrar 인터페이스 구현 클래스를 작성했다면, 그 다음으로는 CustomEditorConfigurer가 해당 클래스를 사용하도록 설정해주면 된다. 다음 코드는 설정 예이다. 이 설정에서 CustomEditorConfigurer의 propertyEditorRegistrars프로퍼티에 앞서 구현한 customPropertyEditorRegistrar를 등록했다. CustomPropertyEditorRegistrar는 Date 타입을 위한 PropertyEditor를 등록해주므로, 아래 코드에서 restClient 빈의 apiDate 프로퍼티 값을 Date 타입으로 알맞게 변환할 수 있게 된다.

~~~~
<bean calss="org.springframework.beans.factory.config.CustomEditorConfigurer">
	<property name="customEditor">
		<map>
			<entry key="com.company.Money" value="com.company.MoneyEditor2" />
		</map>
	</property>

	<property name="propertyEditorRegistrars">
		<list>
			<ref bean="customPropertyEditorRegistrar"/>
		</list>
	</property>
</bean>
<bean id="customPropertyEditorRegistrar" class="com.company.CustomPropertyEditorRegistrar ">
	<property name="datePattern" value="yyyy-MM-dd HH:mm:ss" />
</bean>
<bean id="restClient" class="com.company.RestClient">
	<property name="serverUrl" value="https://www.googleapis.com/language/translate/v2" />
	<property name="apiDate" value="2010-03-01 09:30:00" />
</bean>
~~~~


#### ConverionService를 이용한 타입 변환

스프링 3 버전부터 ConversionService 가 추가 되었다. ConversionService는 좀 더 범용적인 타입 변환을 처리하기 위한 인터페이스다. 앞서 살펴본 PropertyEditor는 자바빈 규약에 따라 문자열과 타입 간의 변환을 처리해주는 방식인데 반해, ConversionService는 타입과 타입간의 변환을 처리하기 위한 기능을 정의하고 있다.

ConversionService를 스프링 빈으로 등록하면, 스프링은 PropertyEditor 대신 ConversionService 를 이용해서 타입 변환을 처리한다. ConversionService인터페이스는 다음과 같이 타입 변환을 위해 필요한 메서드를 정의하고 있다.

~~~~
package org.springframework.core.convert;

public interface ConversionService{
	boolean canConvert(Class<?> sourceType, Class<?> targetType);
	boolean canConvert(TypeDescriptor sourceType, TypeDescriptor targetType);
	<T> T convert(Object source, Class<?> targetType);
	Object convert(Object source, TypeDescriptor sourceType, TypeDescriptor targetType);
}
~~~~

스프링은 이미 ConversionService 인터페이스를 구현한 클래스를 제공하고 있으므로, 이 구현체를 사용하면 된다.


##### ConversionServiceFactoryBean를 이용한 ConversionService 등록

DefaultConversionService 클래스는 스프링이 제공하는 ConversionService 구현이다. 이 클래스를 ConversionService로 사용하려면 ConversionServiceFactoryBean클래스를 빈으로 등록하면 된다. ConversionServiceFactoryBean는 팩토리로서 DefaultConversionService를 빈 객체로 생성해준다.

~~~~
<bean id="conversionService" class="org.springframework.context.support.ConversionServiceFactoryBean"></bean>
~~~~

ConversionServiceFactoryBean 클래스를 설정할 때 주의할 점은 빈 객체의 이름을 "conversionService" 로 등록해야 한다는 점이다. 그렇지 않을 경우 PropertyEditor 를 사용한다.

위와 같이 "conversionService" 빈 객체를 등록하면, 스프링은 빈 객체를 설정할 때 conversionService의 convert() 메서드를 이용해서 String 데이터를 int 타입으로 변환한다.

~~~~
<bean id="collector1" class="com.company.DataCollector">
	<!-- conversionService 를 통해 타입 변환 -->
	<property name="threshold" value="5" />
</bean>
~~~~

DefaultConversionService 클래스는 타입 변환을 직접 하지 않고 내부에 등록된 GenericConverter에 위임한다. DefaultConversionService는 다수의 컨버터를 갖고 있으며, convert()메서드를 실행하면 다음과 같은 방식으로 타입을 변환한다.

* 등록된 GenericConverter들 중에서 소스 객체 타입을 대상 타입으로 변환해주는 Generic Converter를 찾는다.
* GenericConverter가 존재할 경우, 해당 GenericConverter를 이용해서 타입 변환을 수행한다.
* 존재하지 않을 경우, 익셉션을 발생한다.

 PropertyEditor와 마찬가지로 DefaultConversionService는 이미 기본적인 타입 변환을 위한 GenericConverter를 등록하고 있다. 따라서, DefaultConversionService 만 등록하면 추가 설정없이 기본 데이터 타입이나, Properties, URL 타입 등에 대한 변환을 처리할 수 있다.
 
 ##### GenericConverter를 이용한 커스텀 변환 구현
 
 DefaultConversionService 가 타입 변환을 위해 사용하는 GenericConverter 인터페이스는 다음과 같다.
 
~~~~
pagkage org.springframework.core.convert.converter;

import org.springframework.core.convert.TypeDescriptor;
import java.util.Set;

public interface GenericConverter{
	Set<ConvertiblePair> getConvertibleTypes();
	Object convert(Object source, TypeDescriptor sourceType, TypeDescriptor targetType);

	public static final class ConvertiblePair{
		private final Class<?> sourceType;
		private final Class<?> targetType;

		public ConvertiblePair(Class<?> sourceType, Class<?> targetType){
			this.sourceType = sourceType;
			this.targetType = targetType;
		}
	}
}


~~~~

getConvertibleTypes() 메서드는 변환 가능한 타입 쌍(ConvertiblePair)의 집합을 리턴한다. convert() 메서드는 TypeDescriptor 정보를 이용해서 source객체를 대상 타입으로 변환해서 리턴한다.

~~~~
import java.util.Collections;
import java.util.HashMapSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.core.convert.TypeDescriptor;
import org.springframework.core.convert.converter.GenericConverter;

public class MoneyGenericConverter implements GenericConverter{
	private Set<ConvertiblePair> pairs;
	public MoneyGenericConverter(){
		Set<ConvertiblePair> pairs = new HashSet<>();
		pairs.add(new ConvertiblePair(String.class, Money.class));
		this.pairs = Collections.unmodifiableSet(pairs);
	}

	@Override
	public Set<ConvertiblePair> getConvertibleTypes(){
		return pairs;
	}

	@Override
	public Object convert(Object source, typeDescriptor sourceType, TypeDescriptor targetType){
		if(targetType.getType() != Money.class) throw new IllegalArgumentException("invalid targetType");
		if(sourceType.getType() != String.class) throw new IllegalArgumentException("invalid sourceType");

		String moneyString = (String) source;
		Pattern pattern = Pattern.compile("([0-9]+)([A-Z]{3})");
		Matcher matcher = pattern.matcher(moneyString);
		if(!matcher.matches()) throw new IllegalArgumentException("invalid format");

		int amount = Integer.parseInt(matcher.group(1));
		String currency = matcher.group(2);
		return new Money(amount, currency);
	}
}

~~~~


이렇게 타입 변환을 처리하는 GenericConverter 를 구현했다면, ConversionService 가 해당 GenericConverter를 사용하도록 등록해주어야 하는데, 다음과 같이 ConversionServiceFactoryBean 의  converteres프로퍼티에 구현한 GenericConverter를 설정해주면 등록이 된다.

~~~~
<bean id="conversionService" class="org.sprinframework.context.support.ConversionServiceFactoryBean">
	<property name="converters">
		<set>
			<bean class="com.company.MoneyGenericConverter" />
		</set>
	</property>
</bean>

<bean class="com.company.InvestmentSimulator">
	<!-- "10000WON"을 Money로 변환할 때 MoneyGenericConverter 사용 -->
	<property name="minimumAmount" value="10000WON" />
</bean>
~~~~


##### Converter를 이용한 커스텀 변환 구현

여러 타입에 대해 타입 변환 기능을 제공할 경우 GenericConverter 인터페이스를 구현하는 것이 적합하다. 그런데, 많은 경우 원본 타입과 대상 타입이 하나이다. 예를 들어, 앞서 예에서도 String을 Date로 변환하거나 String을 Money로 변환하는 것과 같이 타입 변환 쌍이 한 개였다. 이렇게 단순 타입 변환을 위해 GenericConverter 인터페이스를 상속받아 구현하기에는 코드가 다소 복잡하다.

타입 변환이 단순한 경우에는 GenericConverter 대신에 Converter 인터페이스를 사용하면 보다 쉽게 구현할 수 있다. Converter 인터페이스는 다음과 같이 단순하게 정의되어 있다.

~~~~
package org.sprinframework.core.convert.converter;
public interface Converter<S,T>{
	T convert(S source);
}
~~~~

제네릭 타입을 사용하고 있는데, S는 소스타입이고, T는 변환 대상 타입이다. 따라서, String 을 Money 로 변환하는 것과 같이 타입 변환 쌍이 한 개만 존재한다면, Converter인터페이스를 사용함으로써 코드를 단순하게 만들 수 있다.

~~~~

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.core.convert.converter.Converter;

public class StringToManeyConverter implements Converter<String, Money>{

	@Override
	public Money convert(String source){
		Pattern pattern = Pattern.compile("([0-9]+)([A-Z]{3})");
		Matcher matcher = pattern.matcher(source);
		if(!matcher.matches()) throw new IllegalArgumentException("invalid format");
		int amount = Integer.parseInt(matcher.group(1));
		String currency = matcher.group(2);
		return new Money(amount, currency);
	}
}

~~~~

Converter 인터페이스를 이용한 경우에도 ConversionServiceFactoryBean 의 converters 프로퍼티에 구현한 Converter를 설정해주면 된다

~~~~
<bean id="conversionService" class="org.sprinframework.context.support.ConversionServiceFactoryBean">
	<property name="converters">
		<set>
			<bean class="com.company.StringToManeyConverter" />
		</set>
	</property>
</bean>

<bean class="com.company.InvestmentSimulator">
	<!-- "10000WON"을 Money로 변환할 때 MoneyGenericConverter 사용 -->
	<property name="minimumAmount" value="10000WON" />
</bean>
~~~~

##### FormattingConversionServiceFacoryBean 을 이용한 ConversionService 등록

스프링은 DefaultConversionService 외에 DefaultFormattingConversionService 를 추가로 제공하고 있다. DefaultFormattingConversionService 클래스는 Converter/GenericConverter뿐만 아니라 Formatter를 이용해서 타입 변환을 수행하는 ConversionService 구현체이다. DefaultFormattingConversionSErvice를 ConversionService로 사용하려면 다음과 같이 FormattingConversionServiceFactoryBean 클래스를 빈으로 등록하면 된다. 이 팩토리 클래스는 DefaultFormattingConversionService 빈 객체를 생성해준다.

~~~~
<bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean"> </bean>
~~~~

DefaultFormattingConversionService은 앞서 살펴본 DefaultConversionService가 기본으로 등록하는 Converter/GenericConverter 외에 날짜/시간 변환을 위한 Formatter 와 Converter를 추가로 등록한다. 이 중에는 @DateTimeFormat 애노테이션과 @NumberFormat을 이용해서 타입 변환을 처리할 수 있는 Formatter도 포함되어 있다.

~~~~
import org.springframework.format.annotation.DateTimeFormat;

public class RestClient{
	private Date apiDate;

	@DateTimeFormat(pattern="yyyy-MM-dd HH:mm:ss")
	public void setApiDate(Date apiDate){
		this.apiDate = apiDate;
	}
}

~~~~

위 설정에서는 java.text.DateFormat 의 패턴을 사용했는데, @DateTimeFormat 애노테이션을 이용하면, DefaultFormattingConversionService은 내부적으로(스프링에 포함된) DateFormatter를 이용해서 문자열을 Date타입으로 변환한다.

~~~~
<bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
</bean>


<bean id="restClient" class="com.company.RestClient">
	<property name="serverUrl" value="https://www.googleapis.com/language/translate/v2" />
	<property name="apiDate" value="2010-03-01 09:30:00" />
</bean>



~~~~

> ConversionService와 관련된 인터페이스와 클래스간의 전반적인 관계가 궁금하면 http://javacan.tistory.com/339 참조

##### Formatter를 이용한 커스텀 변환 구현

DefaultFormattingConversionService는 GenericConverter/Converter와 함께 Formatter/Parser/Printer 타입을 이용한 타입 변환을 지원한다. 이들 타입은 다음과 같이 정의되어 있다.

~~~~
package org.springframework.format;

public interface Printer<T>{
	String print(T object, Locale, locale);
}

public interface Parse<T>{
	T parse(String text, Locale locale) throws ParseException;
}

public interface Formatter<T> extends Printer<T>, Parser<T>{}



~~~~


위 타입 정의를 보면 알 수 있겠지만, Printer 인터페이스는 객체를 문자열로 변환해주고 Parse인터페이스는 문자열을 지정한 타입으로 변환해준다. print() 메서드와 parse() 메서드는 Locale을 파라미터로 전달받는데, 이는 로케일에 따라 변환결과를 만들어낼수있다는 것을 뜻한다.

Formatter인터페이스는 Printer와 Parser 인터페이스를 상속받은 인터페이스로, 두 기능을 함께 제공할 클래스는 Formatter 인터페이스를 상속받아 구현하면 된다. 

~~~~
import java.text.ParseException;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.sprinframework.format.Formatter;

public class MoneyFormatter implements Formatter<Money>{
	@Override
	public String print(Money object, Locale locale){
		return object.getAmount()+object.getCurrenct();
	}


	@Override
	public Money parse(String text, Locale locale) throws ParseException{
		Pattern pattern = Pattern.compile("([0-9]+)([A-Z]{3})");
		Matcher matcher = pattern.matcher(text);
		if(!matcher.matches()) throw new IllegalArgumentException("invalid format");
		
		int amount = Integer.parseInt(matcher.group(1));		
		String currency = matcher.group(2);
		return new Money(amount, currency);
	}
}

~~~~


Formatter를 구현했다면, 다음과 같은 설정을 이용해서 Formatter를 추가할 수 있다.

~~~~
<bean id="conversionService" class="org.springframework.format.support.FormattingConversionServiceFactoryBean">
	<property name="formatters">
		<set>
			<bean calss="com.company.MoneyFormatter" />
		</set>
	</property>
</bean>


<bean class="com.company.InverstmentSimulator">
	<property name="minimumAmount" value="1000WON"/>
</bean>
~~~~

 FormattingConversionServiceFactoryBean의 formatters르포퍼티는 Formatter의 집합을 전달받는데, 전달받은 Formatter 집합을 DefaultFormattingConversionService에 등록한다. 따라서, 등록한 Formatter를 이용해서 문자열을 특정 타입으로 변환할 수 있다.