<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="java.sql.*" %>
<%
	String bidx = request.getParameter("bidx");


	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		conn = DBManager.getConnection();
		String sql = "delete from board where bidx="+bidx;
		psmt = conn.prepareStatement(sql);
		//psmt.setInt(1, Integer.parseInt(bidx));
		
		int result = psmt.executeUpdate();
		
		out.print(result);
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn);
	}
%>