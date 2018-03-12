<%@ page language="java" import="java.lang.*,java.util.*,java.sql.*"
         contentType="text/html; charset=utf-8"%>
<%request.setCharacterEncoding("utf-8");%>
<%  
String id=request.getParameter("id"); 
String token =""; 
String cookie_token =""; 
String account =""; 
String apply_page =request.getParameter("apage");
String num =request.getParameter("num"); 
StringBuilder p=new StringBuilder("");

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
          cookie_token=sCookie.getValue();
        }
     }
  }
  
  if(!cookie_token.equals(token)){
	  response.sendRedirect(request.getContextPath()+"/indexin.jsp");
  }else{
	  String photonum=request.getParameter("photo");
	  String musicnum=request.getParameter("music");
	  String othernum=request.getParameter("other");
	  if(num!=null&&!num.equals("-1")){
		    p.append("<p id=\"ms\">Upload succeed</p>");
			p.append("<p id=\"ms\">"+num+" files in total:  ");
			p.append(photonum+" pictures; ");
			p.append(musicnum+" music; ");
			p.append(othernum+" other files; ");
			p.append("</p>");
		}else if(num.equals("-1")){
			int nnum=Integer.parseInt(photonum)+Integer.parseInt(musicnum)+Integer.parseInt(othernum);
			p.append("<p id=\"ms\">Upload failed</p>");
			p.append("<p id=\"ms\">"+nnum+" files in total:  ");
			p.append(photonum+" pictures; ");
			p.append(musicnum+" music; ");
			p.append(othernum+" other files; ");
			p.append("</p>");
		}
  }
}  
catch (Exception e){  

}

%>

<!DOCTYPE html>
<html>
<head>
	<title>MyZone</title>
	<link type="text/css" rel="stylesheet" href="css/upload.css" media="screen" />
	<script>(function(e,t,n){var r=e.querySelectorAll("html")[0];r.className=r.className.replace(/(^|\s)no-js(\s|$)/,"$1js$2")})(document,window,0);</script>
</head>
<body>
	<div id="title">Hello, <%=account %></div>
	<header>Please upload your files</header>
	<a href="main.jsp?id=<%=id %>" id="back">Back</a>
	<div class="box">
		<form name="tj" action="fileUpload.jsp" method="POST"
enctype="multipart/form-data">
            <input type="hidden" name="pid" value=<%=id %>>
            <input type="hidden" name="user" value=<%=account %>>
			<input type="file" name="file-6[]" id="file-6" class="inputfile inputfile-5" data-multiple-caption="{count} files selected" multiple />		<label for="file-6"><figure><svg xmlns="http://www.w3.org/2000/svg" width="20" height="17" viewBox="0 0 20 17"><path d="M10 0l-5.2 4.9h3.3v5.1h3.8v-5.1h3.3l-5.2-4.9zm9.3 11.5l-3.2-2.1h-2l3.4 2.6h-3.5c-.1 0-.2.1-.2.1l-.8 2.3h-6l-.8-2.2c-.1-.1-.1-.2-.2-.2h-3.6l3.4-2.6h-2l-3.2 2.1c-.4.3-.7 1-.6 1.5l.6 3.1c.1.5.7.9 1.2.9h16.3c.6 0 1.1-.4 1.3-.9l.6-3.1c.1-.5-.2-1.2-.7-1.5z"/></svg></figure> <span></span></label>
			<br>
		</form>
		<img src="images/ok.png" onclick="tj.submit()" style="cursor: pointer;">
	</div>
	<%=p %>
	<p id="ms">Multiple files supported, and files will be sorted automatically</p>
	<script src="js/custom-file-input.js"></script>
</body>
</html>