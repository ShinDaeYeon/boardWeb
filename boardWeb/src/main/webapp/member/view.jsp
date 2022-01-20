<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	String midx = request.getParameter("midx");

	String url  = "jdbc:oracle:thin:@localhost:1522:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	// 회원 아이디, 회원 비밀번호, 회원 명, 주소, 연락처, 이메일  
	String memberid_ = "";
	String memberpwd_ = "";
	String membername_ = "";
	String addr_ = "";
	String phone_ = "";
	String email_ = "";
	int midx_ = 0;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = " select * from member where midx="+midx;
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
	
		if(rs.next()){
			memberid_ = rs.getString("memberid");
			memberpwd_ = rs.getString("memberpwd");
			membername_ = rs.getString("membername");
			addr_ = rs.getString("addr");
			phone_ = rs.getString("phone");
			email_ = rs.getString("email");
			midx_ = rs.getInt("midx");
		}
		
		
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
	}

%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>
<style>
	section{
		height:60vh;
	}
</style>
</head>
<body>
	<%@ include file="/header.jsp" %>
	<section>
		<h2>회원 상세조회</h2>
		<article>
			<table border="1" class="table table-hover">
				<tr>
					<th>회원 아이디</th>
					<td><%=memberid_ %></td>
					<th>회원 비밀번호</th>
					<td><%=memberpwd_ %></td>
				</tr>
				<tr>
					<th>회원 이름</th>
					<td><%=membername_ %></td>
					<th>주소</th>
					<td><%=addr_ %></td>
				</tr>
				<tr>
					<th>회원 연락처</th>
					<td><%=phone_ %></td>
					<th>회원 이메일</th>
					<td><%=email_ %></td>
				</tr>
			</table>
			<button onclick="location.href='list.jsp'">목록</button>
			<button onclick="location.href='modify.jsp?midx=<%=midx_%>'">수정</button>
			<button onclick="deleteFn()">삭제</button>
			<form name="frm" method="post">
				<input type="hidden" name="midx" value="<%=midx_ %>">
			</form>
		</article>
	</section>
	<%@ include file="/footer.jsp" %>
	<script>
		function deleteFn(){
			document.frm.action = "deleteOk.jsp";
			document.frm.submit();
		}
	</script>
</body>
</html>