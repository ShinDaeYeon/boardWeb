<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="java.sql.*" %>
<%
	String bidx = request.getParameter("bidx");
	String subject = request.getParameter("subject");
	String writer = request.getParameter("writer");
	String content = request.getParameter("content");


	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		conn = DBManager.getConnection();
		String sql = " update board set "
				   + " subject = ?"
				   + ",writer = ? "
				   + ",content = ?"
				   + " where bidx = ?";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1, subject);
		psmt.setString(2, writer);
		psmt.setString(3, content);
		psmt.setInt(4, Integer.parseInt(bidx));
		
		int result = psmt.executeUpdate();
		
		out.print(result);
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn);
	}
%>