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

