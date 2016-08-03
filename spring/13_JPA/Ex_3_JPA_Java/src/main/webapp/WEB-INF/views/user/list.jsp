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
	<div>request</div>
	<table border="1">
		<tr>
			<th>No</th><th>아이디</th><th>닉네임</th><th>번호</th><th>수정/삭제</th>
		</tr>
		<c:forEach items="${requestScope.page.content }" var="element">
			<tr>
				<td>${element.seq }</td>
				<td><a href="<c:url value="/user/list/${requestScope.page.getNumber() + 1 }/${element.seq }"/>">${element.id }</a></td>
				<td>${element.nickname }</td>
				<td>${element.hp }</td>
				<td>
					<button onclick="location.href='<c:url value="/user/update/${element.seq }"/>'">수정</button>
					<form method="POST" action="<c:url value="/user/delete/${element.seq }"/>">
						<input type="hidden" name="_method" value="DELETE">
						<button type="submit">삭제</button>
					</form>
				</td>
			</tr>
		</c:forEach>
	</table>
	<c:forEach begin="1" end="${requestScope.page.getTotalPages() }" step="1" var="idx">
		<a href="<c:url value="/user/list/${idx }"/>">${idx }</a>
	</c:forEach>
	<div>전체엔티티 : <span>${requestScope.page.getTotalPages() }</span></div>
	<div>전체엔티티 : <span>${requestScope.page.getTotalElements() }</span></div>
	<div>현재페이지 : <span>${requestScope.page.getNumber() }</span></div>
	<div>리턴엘리먼트갯수 : <span>${requestScope.page.getNumberOfElements() }</span></div>
	<div>페이지기준크기 : <span>${requestScope.page.getSize() }</span></div>
	<div>조회결과 : <span>${requestScope.page.hasContent() }</span></div>
	<div>첫번째페이지? : <span>${requestScope.page.isFirst() }</span></div>
	<div>마지막페이지? : <span>${requestScope.page.isLast() }</span></div>
	<div>다음페이지유무 : <span>${requestScope.page.hasNext() }</span></div>
	<div>전페이지유무 : <span>${requestScope.page.hasPrevious() }</span></div>
	
	<br><br>
	<div>model</div>
	<table border="1">
		<tr>
			<th>No</th><th>아이디</th><th>닉네임</th><th>번호</th><th>수정/삭제</th>
		</tr>
		<c:forEach items="${page.content }" var="element">
			<tr>
				<td>${element.seq }</td>
				<td><a href="<c:url value="/user/list/${page.getNumber() + 1 }/${element.seq }"/>">${element.id }</a></td>
				<td>${element.nickname }</td>
				<td>${element.hp }</td>
				<td>
					<button onclick="location.href='<c:url value="/user/update/${element.seq }"/>'">수정</button>
					<form method="POST" action="<c:url value="/user/delete/${element.seq }"/>">
						<input type="hidden" name="_method" value="DELETE">
						<button type="submit">삭제</button>
					</form>
				</td>
			</tr>
		</c:forEach>
	</table>
	
	
	
	<c:forEach begin="1" end="${page.getTotalPages() }" step="1" var="idx">
		<a href="<c:url value="/user/list/${idx }"/>">${idx }</a>
	</c:forEach>
	<div>전체페이지 : <span>${page.getTotalPages() }</span></div>
	<div>전체엔티티 : <span>${page.getTotalElements() }</span></div>
	<div>현재페이지 : <span>${page.getNumber() }</span></div>
	<div>리턴엘리먼트갯수 : <span>${page.getNumberOfElements() }</span></div>
	<div>페이지기준크기 : <span>${page.getSize() }</span></div>
	<div>조회결과 : <span>${page.hasContent() }</span></div>
	<div>첫번째페이지? : <span>${page.isFirst() }</span></div>
	<div>마지막페이지? : <span>${page.isLast() }</span></div>
	<div>다음페이지유무 : <span>${page.hasNext() }</span></div>
	<div>전페이지유무 : <span>${page.hasPrevious() }</span></div>
</body>
</html>