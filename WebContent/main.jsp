<%@ page language="java" import="java.util.*,java.sql.*"
         contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.Date"%>
<%request.setCharacterEncoding("utf-8");%>
<%  
request.setCharacterEncoding("utf-8");  
String msg ="";  
String login_msg ="";
String token =""; 
String cookie_token =""; 
String account ="123"; 
String id =request.getParameter("id"); 
String logout =request.getParameter("logout"); 

String connectString = "jdbc:mysql://172.18.187.233:53306/15352365_project"  
                + "?autoReconnect=true&useUnicode=true"  
                + "&characterEncoding=UTF-8";   
    StringBuilder table=new StringBuilder("");  
try{  
  Class.forName("com.mysql.jdbc.Driver");  
  Connection con=DriverManager.getConnection(connectString,   
                 "user", "123");  
  Statement stmt=con.createStatement();  
  ResultSet rs=stmt.executeQuery("select * from user_list WHERE ID="+id);  
  while(rs.next()){
	  token= rs.getString("TOKEN");
	  account=rs.getString("ACCOUNT");
  }
  rs.close();  
  stmt.close();  
  con.close();  
  
  Cookie cookies[]=request.getCookies(); //读出用户硬盘上的Cookie，并将所有的Cookie放到一个cookie对象数组里面
  Cookie sCookie=null; 
  for(int i=0;i<cookies.length;i++){    //用一个循环语句遍历刚才建立的Cookie对象数组
  sCookie=cookies[i];   //取出数组中的一个Cookie对象
  if(sCookie!=null){
        if(("token").equals(sCookie.getName())){      
  //        pageContext.setAttribute("SavedUserName",sCookie.getValue());
          if(logout!=null&&logout.equals("true")){
        	  cookie_token=sCookie.getValue();
        	  sCookie.setValue("444");
        	  response.addCookie(sCookie);
        	  response.sendRedirect(request.getContextPath()+"/indexin.jsp");
          }
          cookie_token=sCookie.getValue();
        }
     }
  }
//  out.println("token:"+token);
//  out.println("cooki:"+cookie_token);
  if(!cookie_token.equals(token)){
	  response.sendRedirect(request.getContextPath()+"/indexin.jsp");
  }else{
	  login_msg="恭喜";
  }
  if(request.getMethod().toUpperCase().equals("POST")){
	  account=request.getParameter("user_id");
	  java.text.SimpleDateFormat simpleDateFormat = new java.text.SimpleDateFormat(    
			    "yyyy-MM-dd HH:mm:ss");    
			   java.util.Date currentTime = new java.util.Date();    
			   String time = simpleDateFormat.format(currentTime).toString();  
			String save_msg=request.getParameter("memo");
			
			String sql="insert into text_list(FRIENDID,TEXT,T_DATE) values('%s','%s','%s');";
			String ex_sql=String.format(sql,account,save_msg,time);
			System.out.println(account+"kong");
			
			
			
			con=DriverManager.getConnection(connectString,   
	                "user", "123");
			stmt=con.createStatement();
			int rs_change=stmt.executeUpdate(ex_sql);

			response.sendRedirect(request.getContextPath()+"/note.jsp?id="+id);
			
  }

  
}  
catch (Exception e){  
  msg = e.getMessage();  
}  



%>
<!DOCTYPE html>
<html>
<head>
	<title>MyZone</title>
	<link type="text/css" rel="stylesheet" href="css/main.css" media="screen" />
</head>
<body>
	<div id="title">Hello, <%=account %></div>
	<a href="main.jsp?id=<%=id %>&logout=true" id="logout">logout</a>
	<header>SAY SOMETHING...</header>
	<div id="input">
		<form method="post">
			<textarea name="memo"></textarea>
			<br>
			<input type="submit" name="submit" id="submit" value="">
			<input type="hidden" name="user_id" value=<%=account %>>
		</form>
	</div>
	
	<div id="icons">

		<span id="icon2" class="icon"><a href="picture.jsp?id=<%=id %>"><img src="images/picture1.png" height="60px"></a></span>
		<span id="icon3" class="icon"><a href="note.jsp?id=<%=id %>"><img src="images/diary.png" height="60px"></a></span>
		<span id="icon4" class="icon"><a href="myFile.jsp?id=<%=id %>"><img src="images/files.png" height="60px"></a></span>
		<span id="icon5" class="icon"><a href="upload.jsp?id=<%=id %>"><img src="images/upload.png" height="60px"></a></span>
	</div>
	<div id="show_time">
	<script>
	setInterval("show_time.innerHTML=new Date().toLocaleString('chinese',{hour12:false})",1000);
	</script>

	</div>
</body>
</html>
