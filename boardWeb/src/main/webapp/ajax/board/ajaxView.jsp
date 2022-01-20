<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*" %>
<%
	String bidx = request.getParameter("bidx");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		String sql = "select * from board where bidx="+bidx;
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		JSONArray list = new JSONArray();
		if(rs.next()){
			JSONObject obj = new JSONObject();
			obj.put("bidx",rs.getInt("bidx"));
			obj.put("subject",rs.getString("subject"));
			obj.put("writer",rs.getString("writer"));
			obj.put("content",rs.getString("content"));
			
			list.add(obj);
		}
		
		out.print(list.toJSONString());
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
	}

%>