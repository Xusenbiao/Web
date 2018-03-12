<%@ page language="java" import="java.util.*,java.sql.*,java.lang.*,java.io.*"   
         contentType="text/html; charset=utf-8"  
%><%  
    request.setCharacterEncoding("utf-8");  
    String msg ="";  
    String forpage ="";
    String nextpage ="";
    String token =""; 
    String account =""; 
    String cookie_token ="";
    String delete =request.getParameter("delete");
    String id =request.getParameter("id");
    String connectString = "jdbc:mysql://172.18.187.233:53306/15352365_project"  
                    + "?autoReconnect=true&useUnicode=true"  
                    + "&characterEncoding=UTF-8";   
        StringBuilder table=new StringBuilder("");  
    int cn=0;
    int page1=0;
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
    	  }
    	  
    	}  
    	catch (Exception e){  
    	  msg = e.getMessage();  
    	}  
    try{  
      String a=request.getParameter("pgno");
      if(a==null){
    	  a="1";
      }
      page1= Integer.parseInt(a);
      Class.forName("com.mysql.jdbc.Driver");  
      Connection con=DriverManager.getConnection(connectString,   
                     "user", "123");  
      Statement stmt=con.createStatement();  
      
      
      
      ResultSet rs=stmt.executeQuery("select * from file_list WHERE ID="+id); 
      table.append("<table><tr><th>File Name</th><th>Date</th>");  
      while(rs.next()&&cn<10*page1) {  
   // 	  String del="<a href=\"myFile.jsp?id="+id+"&delete="+rs.getString("FILE_NAME")+"\">删除</a>";
    	  if(cn>=10*page1-10&&cn<10*page1){
    		  String datetime=rs.getString("FILE_DATE");
              table.append(String.format(  
                      "<tr><td><a href=\"%s\">%s</a></td><td>%s</td></tr>",  
                      rs.getString("FILE_LINK"),rs.getString("FILE_NAME"),datetime.substring(0, datetime.length()-2)
                      )  
                   );  
    	  }

            cn++;
      }  
      table.append("</table>");  
      rs.close();  
      stmt.close();  
      con.close();  
    }  
    catch (Exception e){  
      msg = e.getMessage();  
    }  
%><!DOCTYPE HTML>  
<html>  
 
<head>  
<title>My Files</title>  
<link type="text/css" rel="stylesheet" href="css/file.css" media="screen" />
</head>  
<body>  
<div id="title">Hello, <%=account %></div>
  <a href="main.jsp?id=<%=id %>" id="back">Back</a>
  <div class="container">   
      <%=table%><br>
  </div>  
	<div style="text-align: center">
	 <a href="myFile.jsp?id=<%=id %>&pgno=<%=page1-1 %>&pgcnt=10">
	                    Last</a>    &nbsp;	            
	    <a href="myFile.jsp?id=<%=id %>&pgno=<%=page1+1 %>&pgcnt=10">
	                   Next</a>
	  </div>
	  <br>
  
</body>  
</html>  