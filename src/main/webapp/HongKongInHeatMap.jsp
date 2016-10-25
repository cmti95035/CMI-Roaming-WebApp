<%@page import="java.io.*"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.lang.Thread"%>
<%@page import="java.util.Random"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.google.gson.Gson"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>春节期间出访香港用户热力图分布</title>
    </head>
    <body>
    <script>
        function getUserTrace() {
          var e = document.getElementById("pickadate");
          var url = "HongKongRoamingHeatmap.jsp?date=" + e.selectedIndex;
          window.location.href = url;
        }
    </script>
    <h1>当前移动热点用户及其轨迹展示</h1>
        <%
            BufferedReader reader = new BufferedReader(new FileReader("/Users/jianli/Downloads/cmidata/xdr_http/hongkongdates.csv"));
            StringBuilder sb = new StringBuilder();
            sb.append("<select id='pickadate' name='pickadate'>");
            String line;
            int index = 1;
            while((line = reader.readLine())!= null){
                String s = "<option value=\"" + index + "\">" + line + "</option>";
                sb.append(s);
                index++;
            }
            sb.append("</select>");
            sb.append("<input type='button' onclick='getUserTrace()' value='显示漫游香港用户热力图'>");

            out.println(sb.toString());
            System.out.println(sb.toString());

        %>
    </body>
</html>