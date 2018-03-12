<%@ page language="java" import="java.util.*,java.sql.*"
         contentType="text/html; charset=utf-8"%>
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
    String confirm="";
    String sign_msg="";
    try{ 
    if(request.getMethod().toUpperCase().equals("POST")){
          Class.forName("com.mysql.jdbc.Driver");  
          Connection con=DriverManager.getConnection(connectString,   
                       "user", "123");  
          Statement stmt=con.createStatement(); 
          ResultSet rs;
      
    	  account=request.getParameter("user");
    	  password=request.getParameter("password");
    	  confirm=request.getParameter("password1");
    	  if(!account.equals("")){
        	  rs=stmt.executeQuery(String.format("select * from user_list where ACCOUNT='%s'",new Object[] {account})); 
        	  //Where ACCOUNT="+account
        	  sign_msg="account_has_inputed";
              while(rs.next()) {  
            	  if(rs.getString("ACCOUNT").equals(account)){
            		  sign_msg="用户名已存在";
            		  break;
            	  }
              }
              rs.close(); 
              
    	  }
    	  if(sign_msg.equals("account_has_inputed")){
    		  if(!password.equals("")){
        		  if(password.equals(confirm)){
        			  sign_msg="匹配成功";
        			  int suc=stmt.executeUpdate(String.format("insert into user_list(ACCOUNT,PASSWORD)values('%s','%s')", new Object[] { account, password }));
        			  if(suc==0){
        				  sign_msg="注册失败";
        			  }
        			  else{
        				  sign_msg="注册成功";
        				  response.sendRedirect(request.getContextPath()+"/indexin.jsp");
        			  }
        		  }
        		  else{
        			  sign_msg="两次输入的密码不相同";
        		  }
    		  }else{
    			  sign_msg="密码不能为空";
    		  }

    	  }else if(sign_msg.equals("")){
    		  sign_msg="用户名不能为空";
    	  }
    	  
          
          
          stmt.close();  
          con.close();
      }
     
  
    }  
    catch (Exception e){  
      msg = e.getMessage();  
    }  
    System.out.println(sign_msg);
%>

<!DOCTYPE html>
<html>
<head>
	<title>SignUp</title>
	<link type="text/css" rel="stylesheet" href="css/style1.css" media="screen" />
	<script type="text/javascript">
	<%
	if(!sign_msg.equals("")){
		out.println("alert('"+sign_msg+"')");
	} 
	%>
	</script>
</head>
<body>
	<div id="login">
			<a href="indexin.jsp"><img src="images/Login.png " width="70px"></a>
	</div>
	<div id="title">
			<img src="images/registertitle.png" width="450px">
	</div>
	<div id="input">
		<form method="post">
			<input type="text" autocomplete="off" name="user" id="user" placeholder="Account" value=<%=account %> >
			<br>
			<input autocomplete="off" type="password" name="password" id="user" placeholder="Password" value=<%=password %>>
			<br>
			<input autocomplete="off" type="password" name="password1" id="user" placeholder="Confirm Password " value=<%=confirm %>>
			<br>
			<input type="submit" name="submit" id="submit" value="">
		</form>
	</div>
</body>
</html>