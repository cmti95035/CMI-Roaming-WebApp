<%@page import="java.io.*"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.net.URL"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.lang.Thread"%>
<%@page import="java.util.Random"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Found User Details</title>
<style>
.no-js #loader { display: none;  }
.js #loader { display: block; position: absolute; left: 100px; top: 0; }
.se-pre-con {
	position: fixed;
	left: 0px;
	top: 0px;
	width: 100%;
	height: 100%;
	z-index: 9999;
	background: url(/CMI-Roaming-WebApp/img/Preloader_2.gif) center no-repeat #fff;
}
</style>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
<script src="http://cdnjs.cloudflare.com/ajax/libs/modernizr/2.8.2/modernizr.js"></script>
<script>
	$(window).load(function() {
		// Animate loader off screen
		$(".se-pre-con").fadeOut("slow");
	});
</script>


    </head>
    <body>
    <div class="se-pre-con"></div>
    <div class="content">
        <%
            String latitudeStr = request.getParameter("lat");
            System.out.println(new java.util.Date() + " lat: " + latitudeStr);
            String longitudeStr = request.getParameter("lng");
            System.out.println("lng: " + longitudeStr);
            String radiusStr = request.getParameter("radius");
            System.out.println("radius: " + radiusStr);
            Random random = new Random();
            String outputFile = "/tmp/FindUserOutput" + random.nextLong() + ".csv";

            try {
              String line;
              String execStr = "/usr/bin/java -cp /Users/jianli/Downloads/cmidata/xdr_http/raw/XdrHttp-1.0-SNAPSHOT.jar HorseRaceProcess " + latitudeStr + " " + longitudeStr + " " + radiusStr + " /Users/jianli/Downloads/cmidata/xdr_http/raw/hk_data_small.csv /Users/jianli/Downloads/cmidata/xdr_http/raw/cell_towers_select.csv /Users/jianli/Downloads/cmidata/xdr_http/raw/number_imsi.csv " + outputFile;

              System.out.println("Will execute: " + execStr);
              Process p = Runtime.getRuntime().exec(execStr);
              BufferedReader bri = new BufferedReader
                (new InputStreamReader(p.getInputStream()));
              BufferedReader bre = new BufferedReader
                (new InputStreamReader(p.getErrorStream()));
              while ((line = bri.readLine()) != null) {
                System.out.println(line);
              }
              bri.close();
              while ((line = bre.readLine()) != null) {
                System.out.println(line);
              }
              bre.close();
              p.waitFor();
              System.out.println("Done.");
            }
            catch (Exception err) {
              err.printStackTrace();
            }

            BufferedReader reader = new BufferedReader(new FileReader(outputFile));
            StringBuilder sb = new StringBuilder();
            sb.append("<table border=\"1\">");
            String line;
            int count = 0;
            while((line = reader.readLine())!= null){
                String[] parts = line.split(",");
                sb.append("<tr>");
                for(int i = 0; i < parts.length; i++){
                    if(parts[i] != null && !parts[i].equals("") && !parts[i].equals("rule")){
                        if(i == 0 || i == 1)
                            sb.append("<td>" + parts[i].replaceAll("\\d\\d\\d\\d$", "XXXX") + "</td>");
                        else
                            sb.append("<td>" + parts[i] + "</td>");
                    }
                }
                sb.append("</tr>");
                count++;
            }
            sb.append("</table>");

            String result = "<h3> 在谷歌地图上选取的GPS坐标 (" + latitudeStr + "," + longitudeStr + ") 为中心的 " + radiusStr + " 英里半径内</h3>";
            out.println(result);
            result = "<h3>一共找到 " + (count == 0 ? count : count - 1) + " 移动用户</h3>";
            out.println(result);
            out.println(sb.toString());

        %>
    </div>
    </body>
</html>