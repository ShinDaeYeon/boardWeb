<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8");
	
	String midx = request.getParameter("midx");
	String memberpwd = request.getParameter("memberpwd");
	String addr = request.getParameter("addr");
	String phone = request.getParameter("phone");
	String email = request.getParameter("email");
	
	String url  = "jdbc:oracle:thin:@localhost:1522:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = " update member set "
				   + " memberpwd = '"+memberpwd+"' "
				   + ",addr = '"+addr+"' "
				   + ",phone = '"+phone+"' "
				   + ",email = '"+email+"' "
				   + " where midx = "+midx;
		
		psmt = conn.prepareStatement(sql);
		
		int result = psmt.executeUpdate();
		
		if(result>0){
			response.sendRedirect("view.jsp?midx="+midx);
		}else{
			response.sendRedirect("list.jsp");
		}
		
		
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
	}

%>    