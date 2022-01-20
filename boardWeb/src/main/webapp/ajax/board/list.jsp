<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="<%=request.getContextPath()%>/js/jquery-3.6.0.min.js"></script>
<script>
	var clickBtn;
	var printTable = false;
	
	function callList(){
		printTable = true;
		$.ajax({
			url: "ajaxList.jsp",
			type: "get",
			success: function(data){
				var json = JSON.parse(data.trim());
				console.log(json);
				var html = "";
				html += "<table border='1'>";
				html += "<thead>";
				html += "<tr>";
				html += "<th>글번호</th><th>제목</th><th>작성자</th><th> </th>"
				html += "</tr>";
				html += "</thead>";
				html += "<tbody>";
				for(var i=0; i<json.length; i++){
					html += "<tr>";
					html += "<td>"+json[i].bidx+"</td>";
					html += "<td>"+json[i].subject+"</td>";
					html += "<td>"+json[i].writer+"</td>";
					html += "<td><button onclick='modify("+json[i].bidx+",this)'>수정</button>"
					      +"<button onclick='deleteFn("+json[i].bidx+",this)'>삭제</button></td>";
					html += "</tr>";
				}
				html += "</tbody>";
				html += "</table>";
				
				$("#list").html(html);
			}
		});
	}
	
	function deleteFn(bidx,obj){
		$.ajax({
			url:"delete.jsp",
			type:"post",
			data:"bidx="+bidx,
			success:function(data){
				if(data>0){
					$(obj).parent().parent().remove();
				}
			}
			
		});
	}
	
	function modify(bidx,obj){
		clickBtn = obj;
		
		$.ajax({
			url:"ajaxView.jsp",
			type:"get",
			data:"bidx="+bidx, // { bidx : bidx , data: 1}
			success:function(data){
				var json = JSON.parse(data.trim());
				
				$("input[name='subject']").val(json[0].subject);
				$("input[name='writer']").val(json[0].writer);
				$("textarea").val(json[0].content);
				$("input[name='bidx']").val(json[0].bidx);
			}
		});
	}
	
	function save(){
		//저장버튼 클릭시 ajax를 이용하여 해당 데이터 수정
		var subject = $("input[name='subject']").val();
		var writer = $("input[name='writer']").val();
		var bidx = $("input[name='bidx']").val();
		
		var YN;
		
		if(bidx == ""){
			YN=confirm("등록하시겠습니까?");
			if(YN){
				$.ajax({
					url : "ajaxInsert.jsp",
					type : "post",
					data : $("form").serialize(),
					success : function(data){
						//화면에 게시글 목록이 출력되고 있는 경우에만
						//응답 데이터 한건 테이블 맨 윗 행으로 추가
						//jQuery prepend()사용
						if(printTable){	
							var json = JSON.parse(data.trim());
							var html = "<tr>";
							html += "<td>"+json[0].bidx+"</td>";
							html += "<td>"+json[0].subject+"</td>";
							html += "<td>"+json[0].writer+"</td>";
							html += "<td><button onclick='modify("+json[0].bidx+",this)'>수정</button>"
						      +"<button onclick='deleteFn("+json[0].bidx+",this)'>삭제</button></td>";
							html += "</tr>";
							$("tbody").prepend(html);
						}
						
					
					}
					
				});
			}
		}else{
			YN=confirm("수정하시겠습니까?");
			if(YN){
				$.ajax({
					url:"ajaxUpdate.jsp",
					type:"post",
					data: $("form").serialize(), //bidx=?&subject=?&writer=?&content=?
					success:function(data){
						if(data.trim()>0){
							alert("수정이 완료 되었습니다.");
						}else{
							alert("수정 실패했습니다.");
						}
						
						$(clickBtn).parent().prev().text(writer);
						$(clickBtn).parent().prev().prev().text(subject);
						
						//$("form").eq(0).reset();
						document.frm.reset();
						$("input[name='bidx']").val("");
					}
					
				});	
			}
		}
	}
	
	function resetFn(){
		document.frm.reset();
		$("input[name='bidx']").val("");
	}
</script>
</head>
<body>
	<button onclick="callList()">목록 출력</button>
	<h2>ajax를 이용한 게시판 구현</h2>
	<div id="list">
	
	</div>
	<div id="write">
		<form name="frm">
		<input type="hidden" name="bidx">
			<p>
				<label>
					제목 : <input type="text" name="subject" size="50">
				</label>
			</p>
			<p>
				<label>
					작성자 : <input type="text" name="writer">
				</label>
			</p>
			<p>
				<label>
					내용 : <textarea name="content"></textarea>
				</label>
			</p>
			<input type="button" value="저장" onclick="save()">
			<input type="button" value="초기화" onclick="resetFn()">
		</form>
	</div>
</body>
</html>