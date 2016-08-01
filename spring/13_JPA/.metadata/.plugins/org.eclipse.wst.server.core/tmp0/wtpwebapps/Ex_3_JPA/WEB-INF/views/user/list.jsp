<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table>
		<tr>
			<th>시컨</th>
			<th>아디</th>
			<th>비번</th>
			<th>닉넴</th>
		</tr>
		<c:forEach items="${requestScope.list }" var="element">
			<tr>
				<td>${element.seq }</td>
				<td>${element.id }</td>
				<td>${element.password }</td>
				<td>${element.nickname }</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>