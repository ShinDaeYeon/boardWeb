<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.vo.*" %>
<%
	Member login = (Member)session.getAttribute("loginUser");

	String userName ="";
	if(login != null){
		userName = login.getMembername();
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
</head>
<body>
	<%@include file="/header.jsp" %>
	<section>
		<h2>게시글 등록</h2>
		<article>
			<form action="insertOk.jsp" method="post">
				<table border="1" class="table table-hover">
					<tr>
						<th>제목</th>
						<td><input type="text" name="subject" required></td>
					</tr>
					<tr>
						<th>작성자</th>
						<td><input type="text" name="writer" value="<%=userName%>" readonly></td>
					</tr>
					<tr height="300">
						<th>내용</th>
						<td>
							<textarea name="content" rows="15"></textarea>
						</td>
					</tr>
				</table>
				<input type="button" value="취소" onclick="location.href='list.jsp'">
				<input type="submit" value="등록">
			</form>
		</article>
	</section>
	<%@include file="/footer.jsp" %>
</body>
</html>