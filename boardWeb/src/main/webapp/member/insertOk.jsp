<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	String memberid  = request.getParameter("memberid");
	String memberpwd  = request.getParameter("memberpwd");
	String membername  = request.getParameter("membername");
	String gender  = request.getParameter("gender");
	
	String url = "jdbc:oracle:thin:@localhost:1522:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "insert into member(midx,memberid,memberpwd,membername,gender)"
				   + "values(midx_seq.nextval,?,?,?,?)";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1,memberid);
		psmt.setString(2,memberpwd);
		psmt.setString(3,membername);
		psmt.setString(4,gender);
		
		int result = psmt.executeUpdate();
		
		response.sendRedirect("list.jsp");
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		
	}
%>    