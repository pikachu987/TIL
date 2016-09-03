<%@ page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>채팅</title>
<script src="//cdn.jsdelivr.net/sockjs/1/sockjs.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
		var sock;
		
		
		$('#enter').click(function(){
			sock = new SockJS("http://localhost:8080/03_Websocket/chat.sockjs");
			sock.onopen = onOpen;
			sock.onmessage = onMessage;
			sock.onclose = onClose;
		});
		$('#disconnect').click(function(){
			sock.close();
		});
		
		
		function onOpen(e){
			$('#chatArea').append('연결<br>');
		}
		function onMessage(e){
			var data = e.data;
			if(data.substring(0,4) == "msg:"){
				$('#chatArea').append(data.substring(4)+"<br>");
			}
		}
		function onClose(e){
			$('#chatArea').append('연결 끊김<br>');
		}
		
		$('#send').click(function(){
			send();
		});
		
		$('#msg').keypress(function(event){
			var keycode = (event.keyCode ? event.keyCode : event.which);
			if(keycode == '13'){
				send();
			}
			event.stopPropagation();
		});
		
		function send(){
			var nickname = $('#nickname').val();
			var msg = $('#msg').val();
			sock.send("msg:"+nickname+":"+msg)
			$('#msg').val("");
		}
	});
</script>
<style>
#chatArea {
	width: 200px; height: 100px; overflow-y: auto; border: 1px solid black;
}
</style>
</head>
<body>
	<input id="nickname"><br>
	<input type="button" id="enter" value="입장">
	<input type="button" id="disconnect" value="종료">
	<br>
	<div id="chatArea"></div>
    <br/>
    <input type="text" id="msg">
    <input type="button" id="send" value="전송">
</body>
</html>