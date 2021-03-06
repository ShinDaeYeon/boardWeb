<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="boardWeb.vo.*" %>
<%@ page import="java.util.*" %>
<%

	Member login = (Member)session.getAttribute("loginUser");

	request.setCharacterEncoding("UTF-8");
	
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");

	String bidx = request.getParameter("bidx");

	String url  = "jdbc:oracle:thin:@localhost:1522:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	
	PreparedStatement psmtReply = null;
	ResultSet rsReply = null;
	
	String subject_ = "";
	String writer_ = "";
	String content_ = "";
	int bidx_ = 0;
	int midx_ = 0;
	ArrayList<Reply> rList = new ArrayList<>();
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = " select * from board where bidx="+bidx;
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
	
		if(rs.next()){
			subject_ = rs.getString("subject");
			writer_ = rs.getString("writer");
			content_ = rs.getString("content");
			bidx_ = rs.getInt("bidx");
			midx_ = rs.getInt("midx");
		}
		
		sql = "select * from reply r, member m where r.midx = m.MIDX AND bidx="+bidx;
		
		psmtReply = conn.prepareStatement(sql);
		
		rsReply = psmtReply.executeQuery();
		
		while(rsReply.next()){
			Reply reply = new Reply();
			reply.setBidx(rsReply.getInt("bidx"));
			reply.setMidx(rsReply.getInt("midx"));
			reply.setRidx(rsReply.getInt("ridx"));
			reply.setRcontent(rsReply.getString("rcontent"));
			reply.setRdate(rsReply.getString("rdate"));
			reply.setMembername(rsReply.getString("membername"));
			
			rList.add(reply);
		}
		
		
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		if(conn != null) conn.close();
		if(psmt != null) psmt.close();
		if(rs != null) rs.close();
		if(psmtReply != null) psmtReply.close();
		if(rsReply != null) rsReply.close();
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
<script src="<%=request.getContextPath()%>/js/jquery-3.6.0.min.js"></script>
<script>

	var midx = 0;
	
	<%
		if(login != null){
	%>
		midx = <%=login.getMidx()%>
	<%
		}
	%>
	
	function saveR(){
		//ajax ?????? (insert reply)
		
		$.ajax({
			url : "replyInsert.jsp",
			type: "post",
			data: $("form[name='reply']").serialize(),
			success: function(data){
				var json = JSON.parse(data.trim());
				var html = "<tr>";
				html += "<td>"+json[0].membername+" <input type='hidden' name='ridx' value='"+json[0].ridx+"'></td>";
				html += "<td>"+json[0].rcontent+"</td>";
				html += "<td>"
				
				if(midx == json[0].midx){
					html += "<input type='button' value='??????' onclick='modify(this)'>";
					html += "<input type='button' value='??????' onclick='deleteReply(this)'>";	
				}
				
				html += "</td>";
				html += "</tr>";
				
				$("#replyTable>tbody").append(html);
				
				document.reply.reset();
				
			}
			
		});
	}
	
	function modify(obj){
		var rcontent = $(obj).parent().prev().text();
		var html = "<input type='text' name='rcontent' value='"+rcontent+"'><input type='hidden' name='origin' value='"+rcontent+"'>";
		$(obj).parent().prev().html(html);
		
		html = "<input type='button' value='??????' onclick='updateReply(this)'><input type='button' value='??????' onclick='cancleReply(this)'>";
		$(obj).parent().html(html);
	}
	
	function cancleReply(obj){
		
		var originContent = $(obj).parent().prev().find("input[name='origin']").val();
		$(obj).parent().prev().html(originContent);
		
		var html = "";
		html += "<input type='button' value='??????' onclick='modify(this)'>";
		html += "<input type='button' value='??????' onclick='deleteReply(this)'>";
		
		$(obj).parent().html(html);
	}
	
	function updateReply(obj){
		var ridx = $(obj).parent().prev().prev().find("input:hidden").val();
		var rcontent = $(obj).parent().prev().find("input:text").val();
		
		$.ajax({
			url : "updateReply.jsp",
			type : "post",
			data : "ridx="+ridx+"&rcontent="+rcontent,
			success : function(data){
				$(obj).parent().prev().html(rcontent);
				
				// ?????? ?????? ?????? ??? ??????,?????? ???????????? ????????? ??? ????????? ???????????? ????????? ????????????
				// ??? ?????? ?????? midx hidden??? ???????????? ??????
				var html = "<input type='button' value='??????' onclick='modify(this)'>";
				html += "<input type='button' value='??????' onclick='deleteReply(this)'>";
				$(obj).parent().html(html);
			}
		});
	}
	
	function deleteReply(obj){
		var YN = confirm("?????? ?????????????????????????");
		
		if(YN){
			var ridx = $(obj).parent().prev().prev().find("input:hidden").val();
			
			$.ajax({
				url:"deleteReply.jsp",
				type:"post",
				data:"ridx="+ridx,
				success: function(){
					$(obj).parent().parent().remove();
				}
				
			});
		}
	}
	
</script>
</head>
<body>
	<%@ include file="/header.jsp" %>
	<section>
		<h2>????????? ????????????</h2>
		<article>
			<table border="1" class="table table-hover">
				<tr>
					<th>?????????</th>
					<td colspan="3"><%=subject_ %></td>
				</tr>
				<tr>
					<th>?????????</th>
					<td><%=bidx_ %></td>
					<th>?????????</th>
					<td><%=writer_ %></td>
				</tr>
				<tr height="300">
					<th>??????</th>
					<td colspan="3"><%=content_ %></td>
				</tr>
			</table>
			<button onclick="location.href='list.jsp?searchType=<%=searchType%>&searchValue=<%=searchValue%>'">??????</button>
			
			<% if(login != null && login.getMidx() == midx_){ %>
			
			<button onclick="location.href='modify.jsp?bidx=<%=bidx_%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">??????</button>
			<button onclick="deleteFn()">??????</button>
			<%
				} 
			%>
			<form name="frm" action="deleteOk.jsp" method="post">
				<input type="hidden" name="bidx" value="<%=bidx_%>">
			</form>

			<div class="replyArea">
				<div class="replyList">
				<table id="replyTable">
					<tbody>
				<%for(Reply r : rList){ %>
						<tr>
							<td><%=r.getMembername() %> : <input type="hidden" name="ridx" value="<%=r.getRidx()%>"></td>
							<td><%=r.getRcontent()%></td>
							<td>
								<%if(login != null && (login.getMidx() == r.getMidx())){ %>
								<input type="button" value="??????" onclick='modify(this)'>
								<input type="button" value="??????" onclick="deleteReply(this)">
								<%} %>
							</td>							
						</tr>						
				<%} %>
					</tbody>
				</table>
				</div>
				<div class="replyInput">
					<form name="reply">
					<input type="hidden" name="bidx" value="<%=bidx%>">
						<p>
							<label>
								?????? : <input type="text" name="rcontent" size="50">
							</label>
						</p>
						<p>
							<input type="button" value="??????" onclick="saveR()">
						</p>
					</form>				
				</div>  
			</div>		
		
		
		</article>
	</section>
	<%@ include file="/footer.jsp" %>
	<script>
		function deleteFn(){
			console.log(document.frm);
			document.frm.submit();
		}
	
	</script>
</body>
</html>








