<%@ page language="java" import="java.util.*,java.sql.*"
         contentType="text/html; charset=utf-8"%>
<%request.setCharacterEncoding("utf-8");%>
<%  
request.setCharacterEncoding("utf-8");  
 
%>
<table>
    <tr>
        <td>用户名：</td>
        <td><input id="demo_input1" type="text" /></td>
        <td>密码：</td>
        <td><input id="demo_input2" type="text" /></td>
    </tr>
    <tr>
        <td colspan="2" align="center"><input id="demo_button1" type="button" value="设置Cookie" /></td>
        <td colspan="2" align="center"><input id="demo_button2" type="button" value="获取Cookie" /></td>
    </tr>
</table>
<script type="text/javascript">
    document.getElementById("demo_button1").onclick=function(){
        var cookie_username="username="+escape(document.getElementById("demo_input1").value)+";"+
                        "expire="+((new Date()).getTime()+600*1000);
        var cookie_password="password="+escape(document.getElementById("demo_input2").value)+";"+
                        "expire="+((new Date()).getTime()+600*1000);
        document.cookie=cookie_username;
        document.cookie=cookie_password;
    }
    document.getElementById("demo_button2").onclick=function(){
        var cookieObj=getCookieObj();
        alert(
            "用户名："+unescape(cookieObj.username)+"\n"+
            "密码："+unescape(cookieObj.password)
        );
    }
</script>