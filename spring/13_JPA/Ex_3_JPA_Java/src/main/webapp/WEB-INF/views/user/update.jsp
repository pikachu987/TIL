<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html5>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form method="POST" action="<c:url value="/user/update/${requestScope.user.seq }"/>">
		<input type="text" name="seq" readonly="readonly" value="${requestScope.user.seq }"><br>
		<input type="text" name="id" readonly="readonly" value="${requestScope.user.id }"><br>
		<input type="text" name="password" value="${requestScope.user.password }"><br>
		<input type="text" name="nickname" value="${requestScope.user.nickname }"><br>
		<input type="text" name="hp" value="${requestScope.user.hp }"><br>
		<input type="submit" value="수정">
	</form>
</body>
</html>