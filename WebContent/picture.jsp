<%@ page language="java" import="java.util.*,java.sql.*"
         contentType="text/html; charset=utf-8"%>
<%request.setCharacterEncoding("utf-8");%>
<%  
request.setCharacterEncoding("utf-8");  
String msg ="";  
String login_msg ="";
String token =""; 
String cookie_token =""; 
String apply_page =request.getParameter("apage");
String id =request.getParameter("id"); 
String connectString = "jdbc:mysql://172.18.187.233:53306/15352365_project"  
                + "?autoReconnect=true&useUnicode=true"  
                + "&characterEncoding=UTF-8";    
try{  
  Class.forName("com.mysql.jdbc.Driver");  
  Connection con=DriverManager.getConnection(connectString,   
                 "user", "123");  
  Statement stmt=con.createStatement();  
  ResultSet rs=stmt.executeQuery("select * from user_list WHERE ID="+id);  
  while(rs.next()){
	  token= rs.getString("TOKEN");
  }
  rs.close();  
  stmt.close();  
  con.close();  
  
  Cookie cookies[]=request.getCookies(); //读出用户硬盘上的Cookie，并将所有的Cookie放到一个cookie对象数组里面
  Cookie sCookie=null; 
  for(int i=0;i<cookies.length;i++){   
  sCookie=cookies[i]; 
  if(sCookie!=null){
        if(("token").equals(sCookie.getName())){      
  //        pageContext.setAttribute("SavedUserName",sCookie.getValue());
          cookie_token=sCookie.getValue();
        }
     }
  }
  if(!cookie_token.equals(token)){
	  response.sendRedirect(request.getContextPath()+"/indexin.jsp");
  }else{
	  login_msg="恭喜";
  }
  
}  
catch (Exception e){  
  msg = e.getMessage();  
}  
request.setCharacterEncoding("utf-8");  

    StringBuilder table=new StringBuilder("");  
try{  
  Class.forName("com.mysql.jdbc.Driver");  
  Connection con=DriverManager.getConnection(connectString,   
                 "user", "123");  
  Statement stmt=con.createStatement();  
  ResultSet rs=stmt.executeQuery("select * from photo_list WHERE ID="+id);  
  while(rs.next()) {  
         table.append(String.format(  
             "<figure><a href=\"%s\"><img src=\"%s\"></a><figcaption>%s</figcaption></figure>",  
             rs.getString("PHOTO_LINK"), rs.getString("PHOTO_LINK"),rs.getString("PHOTO_DESCRIPTION") 
             )  
          );  
  }  
  table.append("</table>");  
  rs.close();  
  stmt.close();  
  con.close();  
}  
catch (Exception e){  
  msg = e.getMessage();  
}  
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>MyPictures</title>
	        <script src="js/FancyZoom.js" language="JavaScript" type="text/javascript"></script>
        <script src="js/FancyZoomHTML.js" language="JavaScript" type="text/javascript"></script>

	<link type="text/css" rel="stylesheet" href="css/css2.css" media="screen" />
</head>
<body onLoad="setupZoom();">
	<div class="htmleaf-container">
		<div id="back">
			<a href="main.jsp?id=<%=id %>"><img src="img/back.png " height="30px"></a>
		</div>
		<div id="mypictures">
			<a href="#"><img src="img/MyPictures.png " height="50px"></a>
		</div>
		<div id="columns">
		<%=table %>
		</div>

	</div>
</body>
</html>