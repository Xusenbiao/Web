<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.lang.*,java.util.Date,java.util.Locale,java.sql.*,java.text.*,java.io.*" %>
<%request.setCharacterEncoding("utf-8");%>
<%! %>
<%
	String msg ="";
	String connectString = "jdbc:mysql://172.18.187.233:53306/15352365_project"
			+ "?autoReconnect=true&useUnicode=true"
			+ "&characterEncoding=UTF-8&useSSL=false";
    StringBuilder table=new StringBuilder("");
	Integer pgno=0;
	Integer pgcnt=4;
	String param=request.getParameter("pgno");
	if (param!=null &&!param.isEmpty()){
		pgno=Integer.parseInt(param);
	}
	param=request.getParameter("pgcnt");
	if (param!=null &&!param.isEmpty()){
		pgcnt=Integer.parseInt(param);
	}
	int pgprev=(pgno>0)?pgno-1:0;
	int pgnext=pgno+1;
	
	//playing
	String music_to_play="";
	if (request.getParameter("playing")!=null){
		music_to_play=request.getParameter("playing");
	}
	
	//
	try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection(connectString, 
	                 "user", "123");
		Statement stmt=con.createStatement();
		//delete
		int delete=-1;
		if (request.getParameter("delete")!=null)
			delete=Integer.parseInt(request.getParameter("delete"));
		if (delete!=-1){
			String fileurl=application.getRealPath("/file");
			ResultSet rs_delete2=stmt.executeQuery(String.format("select MUSIC_NAME from music_list where ID='%d'",delete));
			if (rs_delete2.next()) fileurl=fileurl+"\\"+rs_delete2.getString(1); 
			String sql="delete from music_list where ID='%d'";
			String ex_sql=String.format(sql,delete);
			int rs_delete=stmt.executeUpdate(ex_sql);
			ex_sql="alter table music_list drop ID";
			rs_delete=stmt.executeUpdate(ex_sql);
			ex_sql="alter table music_list add ID int primary key not null auto_increment first";
			rs_delete=stmt.executeUpdate(ex_sql);
			File f=new File(fileurl);
			if (f.exists()) {
				boolean flag=f.delete();
				System.out.print(fileurl);
				if (flag) System.out.print("delete success");
				else System.out.print("delete false");
			}
		}
		
		//show
		ResultSet rs=stmt.executeQuery("select count(*) from music_list");
		Integer max=0;
		while (rs.next()) max=rs.getInt(1);
		if (pgnext>max/pgcnt) pgnext--;
		msg=":"+pgnext;
		rs=stmt.executeQuery(String.format("select * from music_list limit %d,%d;",pgno*pgcnt,pgcnt));
		table.append("<tr><td>歌名</td><td>上传时间</td><td>上传用户</td><td>--</td></tr>");
		while(rs.next()) {
			String del="<a href=\"MusicPlayer.jsp?delete="+rs.getString("ID")+"\">删除</a>";
			String play_music="<a href=\"MusicPlayer.jsp?playing="+rs.getString("MUSIC_LINK")+"\">"+rs.getString("MUSIC_NAME")+"</a>";
		  	table.append(String.format("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>",
			play_music,rs.getString("MUSIC_DATE"),rs.getString("USER_NAME"),del)
			);
		}
		rs.close();
		stmt.close();
		con.close();
		  
	}catch(Exception e){
		msg = e.getMessage();
	}
	
%>    

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<javascript>
</javascript>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
	#main{
		width:100%;
		height:80%;
		border-radius: 12px;
		box-shadow: 0px 1px 5px #9c9c9c;
		padding:10px;
		box-sizing:border-box;
	}
	audio {
		width:100%;
	}
	td:first-child{width:400px;}
	td:nth-child(2){width:100px;}
	td:nth-child(3){width:100px;}
	td:last-child{width:100px;}
	a:link, a:visited, a:active { 
      text-decoration: none;
      font-family: 'Arial Rounded MT Bold',微软雅黑;
      font-weight: bold;
      font-size: 15px;
      padding-right: 20px;
      color: #adadad;
    }
	.page:link,.page:visited,.page:active{
		font-weight:normal;
	}
    a:hover{
      text-decoration: none;
      font-family: 'Arial Rounded MT Bold',微软雅黑;
      font-weight: bold;
      font-size: 15px;
      padding-right: 20px;
      color: #e8a7af;
      text-shadow: 0px 0px 1px #9a9898;
    }
    @font-face{
    font-family: 'Arial Rounded MT Bold';
    src:url('../fonts/ARLRDBD.TTF');
    }
    td{
    font-size: 15px;
    font-family: 'Arial Rounded MT Bold',微软雅黑;
    color: #adadad;
    width: 300px;
    }
</style>
<title>MusicPlayer</title>
</head>
<body>
	<div id="main">
		<form action="Music.jsp">
		</form>
		<table>
		<%=table %>
		</table>
		<div>
			<a class="page" id="prev" href="MusicPlayer.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>">上一页</a>
			<a class="page" id="next" href="MusicPlayer.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>">下一页</a>
		</div>
		<audio src="<%=music_to_play %>" controls="controls" autoplay="false"></audio>
	</div>
</body>
</html>