<%@page import="com.newgen.servlet.systemAccessReport"%>
<%@page import="org.apache.poi.hslf.record.SSSlideInfoAtom"%>
<%@page import="Component.Document.documentList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.DriverManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>


<script type="text/javascript">
	function sub(x) {
		var a = document.getElementById(x).value;
		var url = "NewFile1.jsp?data=" + a;
		var xmlhttp;
		var listData;
		if (window.XMLHttpRequest) {
			xmlhttp = new XMLHttpRequest();
		}
		xmlhttp.onreadystatechange = function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				listData = xmlhttp.responseText;
				if (x == "sel") {
					//document.getElementById("sel3").innerHTML = listData;
					var ar = listData.split(',');
					document.getElementById("sel3").value = ar[0];
				}
			}
		}
		xmlhttp.open("POST", url, true);
		xmlhttp.send();
	}
</script>
<!DOCTYPE html>
<html>

<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>

<body style="background: lightblue">
	<form action="">
		<div>
			Type <select id="sel" name="sel" onchange="sub(this.id)">
				<option value="Select">Select</option>
				<option value="Number">Number</option>
				<option value="Alphabet">Alphabet</option>
				<option value="Symbol">Symbol</option>
			</select>
		</div>
		<div>
			Type <select id="sel2" name="sel2" sub(this.id)>
				<option value="Select">Select</option>
				<%
					
				%>
				<%
					
				%>
				<%
					
				%>
			</select>
		</div>
		<br>
		<div>
			Result <input type="text" id="sel3" name="sel3" onchange="sub(this.id)">
		</div>
		<div>
			Name: <input type="text" id="name" name="name"
				readonly="readonly"> <input type="submit" value="submit">
		</div>
	</form>
</body>

</html>