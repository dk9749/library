<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	String res = "";
String name = request.getParameter("data");
if (name.equalsIgnoreCase("Alphabet")) {
	res = "a,b,c,d,e";
} else if (name.equalsIgnoreCase("Number")) {
	res = "1,2,3,4,5";
} else if (name.equalsIgnoreCase("Symbol")) {
	res = "!,@,#,$,%";
}
out.print(res);
%>
