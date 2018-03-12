<%@ page language="java" import="java.util.*,java.sql.*"
         contentType="text/html; charset=utf-8"%>

<%@ page import="java.util.Date"%>
<%@ page import="java.net.*" %>
<%@ page import= "mytools.*"%>
<%request.setCharacterEncoding("utf-8");%>
<%  
    request.setCharacterEncoding("utf-8");  
    String msg ="";  
    String connectString = "jdbc:mysql://172.18.187.233:53306/15352365_project"  
                    + "?autoReconnect=true&useUnicode=true"  
                    + "&characterEncoding=UTF-8";   
    
    int cn=0;
    int page1=0;
    String account="";
    String password="";
    String login_msg="";
    String token="";
    String pid="";
    java.text.SimpleDateFormat simpleDateFormat = new java.text.SimpleDateFormat(    
   	     "yyyyMMddHHmmss");    

   	   java.util.Date currentTime = new java.util.Date();    
   	   String time = simpleDateFormat.format(currentTime).toString(); 
   	String sec=time.substring(time.length()-1,time.length());
 //      out.println(sec);
 //  	out.println(time);
    if(request.getMethod().toUpperCase().equals("POST")){
   // 	out.println("post没问题");
   try{           Class.forName("com.mysql.jdbc.Driver");  
          Connection con=DriverManager.getConnection(connectString,   
                       "user", "123");  
          Statement stmt=con.createStatement(); 
          ResultSet rs;
      
    	  account=request.getParameter("user");
    	  password=request.getParameter("password");
    	  sec=request.getParameter("sec");
    	  rs=stmt.executeQuery(String.format("select * from user_list where ACCOUNT='%s'",new Object[] {account})); 
    //	  out.println("数据库没问题");
    	  //Where ACCOUNT="+account
          while(rs.next()) {  
        	  if(rs.getString("ACCOUNT").equals(account)){
        		  if(rs.getString("PASSWORD").equals(password)){
        			  pid=rs.getString("ID");
        			  login_msg="登录成功";
        			  //生成token签名
        			  Mybase64 mybase64=new Mybase64();
        			  StringBuilder header = new StringBuilder("[");
        			  header.append("\"typ\":\"JWT\",");
        			  header.append("\"alg\":\"HS256\"");
        			  header.append("]");
        			  String jwt1 = mybase64.encodebase(header.toString());
        			  
        			  StringBuilder payload = new StringBuilder("[");
        			  payload.append("\"sub\":\""+account+"\",");
        			  payload.append("\"iat\":\""+time.substring(0,10)+sec+"\",");
        			  String jwt2 = mybase64.encodebase(payload.toString());
        			  
        			  token=jwt1+"."+jwt2+"."+mybase64.encodebase("myzone"+jwt1);
          //            token=header.toString()+payload.toString();
        			  System.out.println(token);
        			  
        	          Class.forName("com.mysql.jdbc.Driver");  
        	          Connection con1=DriverManager.getConnection(connectString,   
                              "user", "123");  
        	          Statement stmt1=con.createStatement(); 

        	          int id=Integer.parseInt(pid);
        	          int cnt1=stmt1.executeUpdate(String.format("UPDATE user_list set ACCOUNT='%s',PASSWORD='%s',TOKEN='%s' WHERE ID='%d'" , new Object[] { account,password,token,id }));
        			  
        	          con1.close();
        	          stmt1.close();
        	    	  
        			  //保存到cookies
    //    			  String str = URLEncoder.encode(account,"utf-8");

    //    			  Cookie name = new Cookie("name",str);
        			  Cookie ctoken = new Cookie("token",token);
    //    			   name.setMaxAge(-1); 
        			   ctoken.setMaxAge(60*60*365);
   //     			   name.setPath(request.getContextPath());
        			   ctoken.setPath(request.getContextPath());
        			   
   //     			   response.setHeader("P3P","CP=CAO PSA OUR");
  //      			   response.addCookie(name);
  
        			   response.addCookie(ctoken);
  //      			   out.println("cookie没问题");
        			   
        			   response.sendRedirect(request.getContextPath()+"/main.jsp?id="+pid);
        			  
        		  }
        		  else{
        			  login_msg="密码错误";

        		  }
        		  break;
        	  }
        	  
          }
          if(login_msg.equals("")){
        	  login_msg="用户名不存在";
          }
          
          rs.close();  
          stmt.close();  
          con.close();
      
     
  
    }  
    catch (Exception e){  
      msg = e.getMessage();  
      out.println(e.getMessage());
      login_msg="连接失败";
    }  }
    System.out.println(login_msg);
%>
<!DOCTYPE html>
<html>
<head>
	<title>MyZone</title>
	<link type="text/css" rel="stylesheet" href="css/login.css" media="screen" />
	<script type="text/javascript">
	<%
	if(!login_msg.equals("")){
		out.println("alert('"+login_msg+"')");
	} 
	%>

	</script>
</head>
<body>

	<div id="register">
			<a href="signup.jsp"><img src="images/register1.png " width="105px"></a>
	</div>

	<div id="main">	
	<div id="title">
			<img src="images/title.png" width="430px">
	</div>
	<div id="input">
		<form method="post" action="indexin.jsp">
			<input type="text" autocomplete="off" name="user" id="user" placeholder="Account" value="<%=account%>">
			<br>
			<input type="password" autocomplete="off" name="password" id="user" placeholder="Password" value="<%=password%>">
			<br>
			<input type="hidden" name="sec" value=<%=sec %>>
			<input type="submit" name="submit" id="submit" value="">
		</form>
	</div>
	<div id="forget">
			<a onclick="alert('你记性太差了')" href="#">Forget your password?</a>
	</div>
	</div>
</body>
</html>