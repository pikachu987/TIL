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
	<form action="" method="post">
		<input type="text" name="id" value="" placeholder="id"><br>
		<input type="text" name="password" value="" placeholder="pwd"><br>
		<input type="submit" value="로그인">
	</form>
	<a href="<c:url value="/user/join"/>">회원가입</a>
</body>
</html>