<%@ page language="java" import="java.util.*,java.sql.*,java.lang.*"   
         contentType="text/html; charset=utf-8"  
%>
<%
String id=request.getParameter("id");
%>

<!DOCTYPE html>
<html>
<head>
<title>MyZone</title>
<style>
	#main{
		position:static;
	}

	#icon1{
		position:fixed;
		width:50px;
		height:50px;
		bottom:30px;
		left:30px;
	}
	#icons {
	text-align: center;
	margin-top: 100px;
	}
	
	.icon img {
		transition-property: height;
		transition-duration: 0.4s;
		height: 50px;
		z-index=1000;
	}
	
	.icon img:hover {
		transition-property: height;
		transition-duration: 0.4s;
		height: 60px;
	}
	#frame_musicplayer{
		position:fixed;
		display:none;
		margin:10px auto;
		width:600px;
		height:250px;
		bottom:20px;
		left:70px;
	}
	#icon1:hover+#frame_musicplayer{
		display:block;
	}
	#frame_musicplayer:hover{
		display:block;
	}
	body {margin:0;}
</style>
</head>
<body>
	<iframe id="main" src="indexin.jsp?id=<%=id %>" frameborder="0" width="100%" height="944px" scrolling="yes"></iframe>
	<div id="icon1" class="icon" ><img src="images/music.png" height="60px"></div>
	<iframe id="frame_musicplayer"src="MusicPlayer.jsp?id=<%=id %>" frameborder="0" scrolling="no" ></iframe>

</body>
	
</html>