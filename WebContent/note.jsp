<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.lang.*,java.util.Date,java.util.Locale,java.sql.*,java.text.*" %>

<%request.setCharacterEncoding("utf-8");
	int changing=-1;
	int delete=-1;
	int save=-1;
	String user_id=request.getParameter("user_id");
	String id =request.getParameter("id"); 
	String new_msg="";
	
	String now_time4insert="";
	DateFormat format_time=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",Locale.ENGLISH);
	DateFormat format_time2=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S",Locale.ENGLISH);
	String now_time4change=format_time.format(new Date());
	if (request.getParameter("change")!=null)
		changing=Integer.parseInt(request.getParameter("change"));
	if (request.getParameter("delete")!=null)
		delete=Integer.parseInt(request.getParameter("delete"));
	if (request.getParameter("save")!=null)
		save=Integer.parseInt(request.getParameter("save"));
	if (request.getParameter("Self_msg")!=null){
		new_msg=request.getParameter("Self_msg");
		now_time4insert=request.getParameter("time");
	}
	
	String msg ="";
	String edit_msg="";
	String token =""; 
	String cookie_token =""; 
	String connectString = "jdbc:mysql://172.18.187.233:53306/15352365_project"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8&useSSL=false";

    StringBuilder table=new StringBuilder("");
    

    
    
    int counts=0;
	int msg_num=-1;
	int max_counts=100;
	String friends[]=new String[max_counts];
	String info_times[]=new String[max_counts];
	String info_msgs[]=new String[max_counts];
	boolean edited[]=new boolean[max_counts];
	String editor[]=new String[max_counts];
	String edit_time[]=new String[max_counts];
	boolean isyour[]=new boolean[max_counts];
	try{
		
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, 
	                 "user", "123");
		Statement stmt=con.createStatement();


		//insert
		if(!request.getMethod().toUpperCase().equals("POST")){
			  ResultSet rs1=stmt.executeQuery("select * from user_list WHERE ID="+id);  
			  while(rs1.next()){
				  user_id=rs1.getString("ACCOUNT");
		//		  token= rs1.getString("TOKEN");
			  }
			  rs1.close();
			  
			  Cookie cookies[]=request.getCookies(); //读出用户硬盘上的Cookie，并将所有的Cookie放到一个cookie对象数组里面
			  Cookie sCookie=null; 
			  for(int i=0;i<cookies.length-1;i++){    //用一个循环语句遍历刚才建立的Cookie对象数组
			  sCookie=cookies[i];   //取出数组中的一个Cookie对象
			  if(sCookie!=null){
			        if(("token").equals(sCookie.getName())){      
			  //        pageContext.setAttribute("SavedUserName",sCookie.getValue());
			          cookie_token=sCookie.getValue();
			        }
			     }
			  }
			  System.out.println(token);
			 // System.out.println(user_id);
			  if(!cookie_token.equals(token)){
//				  response.sendRedirect(request.getContextPath()+"/indexin.jsp");
//				  System.out.println(user_id);
			  }else
			  {
				  
			  }
		}
		ResultSet rs_num=stmt.executeQuery("select count(*) from text_list");
		if (rs_num.next()){
			msg_num=rs_num.getInt(1);
			if(!new_msg.equals("")){
				String sql="insert into text_list(FRIENDID,TEXT,T_DATE) values('%s','%s','%s');";
				String ex_sql=String.format(sql,user_id,new_msg,now_time4insert);
				System.out.println(user_id+"kong");
				int rs_insert=stmt.executeUpdate(ex_sql);
			}
		}
		//changing and save
	    if (save!=-1){
	    	String save_msg=request.getParameter("edit_"+save);
	    	String  sql="update text_list set TEXT='%s',IS_EDITED=1,EDITOR='%s',EDIT_TIME='%s' where ID='%d'";
	    	String ex_sql=String.format(sql,save_msg,user_id,now_time4change,msg_num+1-save);
	    	int rs_change=stmt.executeUpdate(ex_sql);
	    }
		//delete
		if (delete!=-1){
			String sql="delete from text_list where ID='%d'";
			String ex_sql=String.format(sql,msg_num+1-delete);
			int rs_delete=stmt.executeUpdate(ex_sql);
			ex_sql="alter table text_list drop ID";
			rs_delete=stmt.executeUpdate(ex_sql);
			ex_sql="alter table text_list add ID int primary key not null auto_increment first";
			rs_delete=stmt.executeUpdate(ex_sql);
		}
		
		//show
		ResultSet rs=stmt.executeQuery("select * from text_list order by ID desc");
		while(rs.next()) {
			if (rs.getString("ID")==null) break;
			counts++;
			friends[counts]=rs.getString("FRIENDID");
			isyour[counts]=rs.getString("FRIENDID").equals(user_id);

			info_times[counts]=format_time.format(format_time2.parse(rs.getString("T_DATE")));
			info_msgs[counts]=rs.getString("TEXT");
			edited[counts]=rs.getBoolean("IS_EDITED");
			if (edited[counts]){
				editor[counts]=rs.getString("EDITOR");
				edit_time[counts]=format_time.format(format_time2.parse(rs.getString("EDIT_TIME")));
			}else{
				editor[counts]="";
				edit_time[counts]="";
			}
		}
	    rs.close();
	    stmt.close();
	    con.close();
	}
	catch (Exception e){
	  msg = e.getMessage();
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script language="javascript">
  var value = document.getElementById("edit_<%=changing%>").value;
  alert(value);
</script>

<head>
<meta http-equiv="Content-Type" content="text/html;">
<title>Q_zone</title>
<link rel="stylesheet" href="http://fontawesome.io/assets/font-awesome/css/font-awesome.css">
<link type="text/css" rel="stylesheet" href="css/note.css" media="screen" />
</head>

<body>
	<div id="menu">
		
	</div>
	<div id="bk"></div>
	<div id="head_info">
		<h1 id="header_name">My Zone</h1>
	</div>
	<div id="title">Hello, <%=user_id %></div>
	<div id="main">
		<div id="middle">
			<form action="note.jsp?id=<%=id %>" id="-1" method="post">
				<div id="input_msg">
						<textarea id="text_msg" name="Self_msg" placeholder="saying something..."><%=msg %></textarea>
						 <input type="hidden" name="user_id" value=<%=user_id %>>
						 <input type="hidden" name="time" value="<%=format_time.format(new Date()) %>">
<!-- 						<div id="text_button">					   
						    <br>
							<input type="submit" id="input_button" name=time>
							<div id="button_info"></div>
						</div> -->	
				</div>
				<br>
				<input type="submit" name="submit" id="submit" value="">
			</form>
			
			<%for (int i=1;i<=counts;i++) {%>
			<div class="info">
				<div class="info_name" id="<%=i %>"><%=friends[i] %></div>
				<div class="info_time"><%=info_times[i] %></div>
				<form action="note.jsp?id=<%=id %>" id="info_form" method="post">
				    <input type="hidden" name="user_id" value=<%=user_id %>>
					<textarea class="info_msg info_msg_mask"  name="edit_<%=i %>" <%=changing==i?"autofocus":"readonly" %> ><%=info_msgs[i] %></textarea>
					<textarea class="info_msg"  <%=changing==i?"":"readonly" %> ><%=info_msgs[i] %></textarea>
					<a class="info_change" style="visibility:<%=isyour[i]?"visible":"hidden" %>"><%=changing==i?"SAVE":"EDIT"%> </a>
					<input type="<%=isyour[i]?"submit":"hidden" %>" class="info_change info_change_button" name="<%=changing==i?"save":"change" %>" value="<%=i %>" >
					<a class="info_delete" style="visibility:<%=isyour[i]?"visible":"hidden" %>">DELETE</a>
					<input type="<%=isyour[i]?"submit":"hidden" %>" class="info_delete info_delete_button" name="delete" value="<%=i%>" >
				</form>
				<div class="info_editor" style="display:<%=edited[i]?"block":"none"%>">Edited By <%=editor[i] %></div>
				<div class="info_edit_time" style="display:<%=edited[i]?"block":"none"%>">Edited Time:<%=edit_time[i] %></div>
			</div> 
			<%}%>
		</div>
	</div>
	<a id="reback" href="main.jsp?id=<%=id %>">Back</a>
</body>
</html>