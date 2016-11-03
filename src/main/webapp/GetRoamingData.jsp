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
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.google.gson.Gson"%>
<%@page contentType="html/text" pageEncoding="UTF-8"%>
        <%
            String dateindexStr = request.getParameter("dateindex");
            int index = Integer.parseInt(dateindexStr);
            int day = 14 + index;
            String outputFile = "/Users/jianli/Downloads/cmidata/xdr_http/usertrace-withmcc-201602" + day + "-gps.csv";

            BufferedReader reader = new BufferedReader(new FileReader(outputFile));
            StringBuilder sb = new StringBuilder();

            String line;
            HashMap<String, Integer> gpsCount = new HashMap<String, Integer>();
            while((line = reader.readLine())!= null){
                String[] parts = line.split(",");
                if(parts[3].equals("454")) {
                    if(parts.length == 12){
                        String key = parts[10] + "," + parts[11];
                        if(gpsCount.containsKey(key)){
                            gpsCount.put(key, gpsCount.get(key) + 1);
                        } else {
                            gpsCount.put(key, 1);
                        }
                    }
                }
            }

            boolean isStart = true;
            for(Map.Entry<String, Integer> entry : gpsCount.entrySet()){
                if(isStart)
                    isStart = false;
                else
                    sb.append(",");
                sb.append(entry.getKey() + "," + entry.getValue());
            }

            out.println(sb.toString());
            System.out.println(sb.toString());

        %>