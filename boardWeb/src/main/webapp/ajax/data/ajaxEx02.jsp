<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	function callJSON(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var jObj = JSON.parse(request.responseText);
					console.log(jObj);
					
					for(var i=0; i<jObj.length; i++){
						var obj = jObj[i];
						
						document.getElementById("result").innerHTML += 
							obj.name + ","+obj.publisher+","+obj.author+","+obj.price+"<br>";
					}
				}
			}
			
		}
		
		request.open("GET","data/json/data1.json",false);
		request.send();
	}
	//json2 버튼 클릭시 data2.json ajax를 사용하여 불러오기
	function callJSON2(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var jObj = JSON.parse(request.responseText);
					//jObj 가 가지고 있는 field3 들을 result 태그에 출력
					
					for(var i =0; i<jObj.length;i++){
						var field3 = jObj[i].field3;
						for(var j=0; j<field3.length; j++){
							document.getElementById("result").innerHTML +=
								field3[j].subField1 + ","+ field3[j].subField2+"<br>";
						}
					}
				}
			}
		}
		
		request.open("GET","data/json/data2.json",false);
		request.send();
		
	}
	
	
	function callXML(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status ==200){
					var xml = request.responseXML;

					var books = xml.getElementsByTagName("book");
					
					//console.log(books);
					for(var i =0; i<books.length; i++){
						var name = books[i].getElementsByTagName("name")[0].textContent;
						console.log(name);
						//각 책의 책이름, 출판사,저자, 가격 정보를 result 태그에 전부 출력하세요
						
						var publisher = books[i].getElementsByTagName("publisher")[0].textContent;
						var author = books[i].getElementsByTagName("author")[0].textContent;
						var price = books[i].getElementsByTagName("price")[0].textContent;
						
						document.getElementById("result").innerHTML 
											+= name+","+publisher +","+author+","+price+"<br>"
					}
					
				}
			}
		}
		
		request.open("GET","data/xml/data1.xml",false);
		request.send();
		
	}
	
	//xml2 버튼 클릭시 data2.xml에 있는 모든 subItem의 
	//name태그 값을 resulte 태그에 출력하세요
	
	function callXML2(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var xml = request.responseXML;
					var items = xml.getElementsByTagName("item");
					for(var i=0; i<items.length; i++){
						var subItems = items[i].getElementsByTagName("subItem");
						for(var j=0; j<subItems.length; j++){
							var name = subItems[j].getElementsByTagName("name")[0].textContent;
							document.getElementById("result").innerHTML += name +"<br>";
						}
					}
				}
			}
		}
		request.open("GET","data/xml/data2.xml",false);
		request.send();
	}
</script>
</head>
<body>
	<h2>XML,JSON ajax 통신 예제</h2>
	<button onclick="callJSON()">json</button>
	<button onclick="callJSON2()">json2</button>
	<button onclick="callXML()">xml</button>
	<button onclick="callXML2()">xml2</button>
	<div id="result">
	</div>
</body>
</html>

