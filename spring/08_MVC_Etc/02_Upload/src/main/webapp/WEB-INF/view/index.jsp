<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<body>
<form action="<c:url value="/view/upload1"/>" enctype="multipart/form-data" method="POST">
<input type="file" name="file">
<input type="submit">
</form>
<form action="<c:url value="/view/upload2"/>" enctype="multipart/form-data" method="POST">
<input type="file" name="file">
<input type="submit">
</form>
<form action="<c:url value="/view/upload3"/>" enctype="multipart/form-data" method="POST">
<input type="file" name="file">
<input type="file" name="file">
<input type="file" name="file">
<input type="file" name="file">
<input type="submit">
</form>
<form action="<c:url value="/view/upload4"/>" enctype="multipart/form-data" method="POST">
<input type="file" name="file">
<input type="submit">
</form>
</body>
</html>