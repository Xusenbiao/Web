<%@ page pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page language="java" import="java.util.*,java.sql.*"   %>
<%@ page import="java.io.*, java.util.*,org.apache.commons.io.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<%@ page import="java.util.Date"%>
<html><head><title>文件传输例子</title></head>
<body><%request.setCharacterEncoding("utf-8");%>
<%!public  static boolean myfile(String contentType, String... allowTypes) {  
    if (null == contentType || "".equals(contentType)) {  
        return false;  
    }  
    for (String type : allowTypes) {  
        if (contentType.indexOf(type.toUpperCase()) > -1) {  
            return true;  
        }  
    }  
    return false;  
}   %>


<% 
String msg ="";  
String sta_msg =""; 
String fileName="";
DiskFileItem dfi=null;
String pid="";
int num=0;
int id=0;
int photonum=0;
int musicnum=0;
int othernum=0;
String content="";
String account="";
java.text.SimpleDateFormat simpleDateFormat = new java.text.SimpleDateFormat(    
	     "yyyy-MM-dd HH:mm:ss");    
	   java.util.Date currentTime = new java.util.Date();    
	   String time = simpleDateFormat.format(currentTime).toString();  
	   out.println("当前时间为："+time); 

	// 得到web根路径//绝对路径
	// getServletContext().getRealPath("/")得到web应用的根路径
	// D:\web\excel，“D:\web”是web应用的根路径，“excel”是根目录下的文件夹
	String Save_Location = application.getRealPath("/") + "file\\";
	try {
	if (!(new java.io.File(Save_Location).isDirectory())) { // 如果文件夹不存在
	new java.io.File(Save_Location).mkdir();// 不存在 excel 文件夹，则建立此文件夹
	} else { // 存在excel文件夹，则直接建立此文件夹
	// 文件夹下名为的文件夹
	}
	} catch (Exception e) {
	e.printStackTrace(); // 创建文件夹失败
	// 在链接中使用URLEncoder编码，传递中文参数。
	// 接收页面可以使用getParameter()取得该参数，页面的charset=GB2312。
	String ErrName = java.net.URLEncoder.encode("文件夹不存在。创建文件夹出错！");
	}
	   
	   
	   
boolean isMultipart
        = ServletFileUpload.isMultipartContent(request);//检查表单中是否包含文件
        
        String connectString = "jdbc:mysql://172.18.187.233:53306/15352365_project"  
                + "?autoReconnect=true&useUnicode=true"  
                + "&characterEncoding=UTF-8";   
        if (isMultipart) {
        FileItemFactory factory = new DiskFileItemFactory();
        
//factory.setSizeThreshold(yourMaxMemorySize); //设置使用的内存最大值
  //      factory.setRepository(); //设置文件临时目录
        ServletFileUpload upload = new ServletFileUpload(factory);
//upload.setSizeMax(yourMaxRequestSize); //允许的最大文件尺寸
        List items = upload.parseRequest(request);
        for (int i = 0; i < items.size(); i++) {
        FileItem fi = (FileItem) items.get(i);
        if (fi.isFormField()) {//如果是表单字段
   //     out.print(fi.getFieldName()+":"+fi.getString("utf-8"));
        if(fi.getFieldName().equals("content")){
        	content=fi.getString("utf-8");
        }else if(fi.getFieldName().equals("pid")){
        	pid=fi.getString("utf-8");
        }else if(fi.getFieldName().equals("user")){
        	account=fi.getString("utf-8");
        }
        
        }
        else {//如果是文件
        dfi = (DiskFileItem) fi;
        if (!dfi.getName().trim().equals("")) {//getName()返回文件名称或空串
        out.print("文件被上传到服务上的实际位置： ");
        fileName=application.getRealPath("/file")
        + System.getProperty("file.separator")
        +pid+"_"+FilenameUtils.getName(dfi.getName());
        
        out.print(new File(fileName).getAbsolutePath());
        try{
        	dfi.write(new File(fileName));
        }catch(Exception e){
        	msg = e.getMessage();  
        }
        sta_msg="尝试保存数据库";
        try{
        	


            Class.forName("com.mysql.jdbc.Driver");  
            Connection con=DriverManager.getConnection(connectString,   
                         "user", "123");  

            Statement stmt=con.createStatement(); 
            ResultSet rs;
            id=Integer.parseInt(pid);
            out.println("islink?"); 
            String link=request.getContextPath()+"/file/"+id+"_"+FilenameUtils.getName(dfi.getName());
            
            String[] pic = new String[] { ".jpg", ".png", ".gif", ".bmp", ".jpeg", ".jpe", ".tga", ".tif", ".tiffxif", ".wmf", ".dib", ".jif" };
            String[] mus = new String[] { ".wav", ".mp3",".mp3", ".ogg" };

            int suc=0;
            if(myfile(FilenameUtils.getName(dfi.getName()).toUpperCase(), pic)){
            	out.println("是图片<br/>");
            	
            	suc=stmt.executeUpdate(String.format("insert into photo_list(ID,PHOTO_NAME,PHOTO_LINK,PHOTO_DATE,PHOTO_DESCRIPTION)values('%d','%s','%s','%s','%s')", new Object[] { id, pid+"_"+FilenameUtils.getName(dfi.getName()),link,time,content }));
            	photonum++;
            }else if(myfile(FilenameUtils.getName(dfi.getName()).toUpperCase(), mus)){
            	out.println("是音乐<br/>");
            	
                //suc=stmt.executeUpdate(String.format("insert into photo_list(ID,PHOTO_ID,PHOTO_LINK,PHOTO_DATE,PHOTO_DESCRIPTION)values('%d','%s','%s','%s','%s')", new Object[] { id, pid+"_"+FilenameUtils.getName(dfi.getName()),link,time,content }));
            	suc=stmt.executeUpdate(String.format("insert into music_list(USER_UPDATE,MUSIC_NAME,MUSIC_LINK,MUSIC_DATE,USER_NAME)values('%d','%s','%s','%s','%s')", new Object[] { id, FilenameUtils.getName(dfi.getName()),link,time,account }));
            	musicnum++;
            }else{
            	
            	suc=stmt.executeUpdate(String.format("insert into file_list(ID,FILE_NAME,FILE_LINK,FILE_DATE)values('%d','%s','%s','%s')", new Object[] { id, FilenameUtils.getName(dfi.getName()),link,time }));
            	othernum++;
            }
            out.println(suc+"must here"); 
            if(suc==0){
            	sta_msg="保存数据库失败";
            }else{
            	sta_msg="保存数据库成功";
            }
            
            stmt.close();  
            con.close();
            
            
        }catch(Exception e){
        	msg = e.getMessage();
        	num=-1;
        }
        
        } //if
        } //if
        } //for
        } //if
        if(num!=-1){
        	num=photonum+musicnum+othernum;
        }
        response.sendRedirect(request.getContextPath()+"/upload.jsp?id="+pid+"&num="+num+"&photo="+photonum+"&music="+musicnum+"&other="+othernum);
        %>
        <br/>
        <p><%=sta_msg %></p>
        <br/>
        <a href='<%=request.getContextPath()+"\\file\\"+pid+"_"+FilenameUtils.getName(dfi.getName()) %>'><%=pid+"_"+FilenameUtils.getName(dfi.getName()) %></a>
        <br/>
</body>
</html>