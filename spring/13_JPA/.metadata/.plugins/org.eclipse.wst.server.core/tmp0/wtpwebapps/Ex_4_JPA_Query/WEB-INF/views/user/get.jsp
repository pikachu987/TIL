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
	<div>seq:${requestScope.user.seq }</div>
	<div>id:${requestScope.user.id }</div>
	<div>nickname:${requestScope.user.nickname }</div>
	<div>hp:${requestScope.user.hp }</div>
</body>
</html>