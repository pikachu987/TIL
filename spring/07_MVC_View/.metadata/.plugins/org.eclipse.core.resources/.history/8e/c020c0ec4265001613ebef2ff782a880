<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<html>
<body>

<form:form id="loginCommand">
<form:label path="email">회원ID</form:label>
<form:input path="email"/>
<form:errors path="email" />
<form:hidden path="defaultSecurityLevel"/>
<form:password path="password"/>
<form:select path="loginType" items="${loginTypes }" >
	<form:option value="">---선택---</form:option>
</form:select>
</form:form>


</body>
</html>
