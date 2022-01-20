<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.sql.*" %>
<%
	String ridx = request.getParameter("ridx");
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from reply where ridx="+ridx;
		
		psmt = conn.prepareStatement(sql);

		rs = psmt.executeQuery();
		
		JSONArray list = new JSONArray();
		if(rs.next()){
			JSONObject jObj = new JSONObject();
			jObj.put("ridx", rs.getInt("ridx"));
			jObj.put("rcontent", rs.getString("rcontent"));
			jObj.put("bidx", rs.getInt("bidx"));
			jObj.put("midx", rs.getInt("midx"));
			
			list.add(jObj);
		}
		
		out.print(list.toJSONString());
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
	}