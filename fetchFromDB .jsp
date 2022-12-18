<%@ page import="com.newgen.wfdesktop.xmlapi.*"%>
<%@ page import="com.newgen.wfdesktop.util.*"%>
<%@page import="org.apache.log4j.PropertyConfigurator"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.File"%>
<%@page import="java.nio.charset.Charset"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>


<%!public String ExecuteAPI(String sInputXML, String serverIP, String serverPort) {
		String sOutputXML = "";
		String serverType = "JTS";
		//NGEjbClient objNGEjbClient=null;
		try {
			//objNGEjbClient = NGEjbClient.getSharedInstance();
			//sOutputXML =objNGEjbClient.makeCall(serverIP,"3333",serverType,sInputXML);
			sOutputXML = WFCallBroker.execute(sInputXML, serverIP, 3333, 1);
		} catch (Exception e) {
			sOutputXML = "error";
			System.out.println("error from wrapper");
			e.printStackTrace();
		}
		return sOutputXML;
	}

	private String getApselectXML() {
		String ret = "<?xml version=\"1.0\"?>" + "<APSelect_Input>" + "<Option>APSelectWithColumnNames</Option>"
				+ "<Query>InsertYourQueryHere</Query>" + "<EngineName>InsertCabinetNameHere</EngineName>"
				+ "<SessionId></SessionId>" + "</APSelect_Input>";
		return ret;
	}

	public String getTagValues(String sXML, String sTagName) {
		String sTagValues = "";
		String sStartTag = "<" + sTagName + ">";
		String sEndTag = "</" + sTagName + ">";
		String tempXML = sXML;
		tempXML = tempXML.replaceAll("&", "#amp#");
		try {
			for (int i = 0; i < sXML.split(sEndTag).length - 1; i++) {
				if (tempXML.indexOf(sStartTag) != -1) {
					sTagValues += tempXML.substring(tempXML.indexOf(sStartTag) + sStartTag.length(),
							tempXML.indexOf(sEndTag));
					//System.out.println("sTagValues"+sTagValues);
					tempXML = tempXML.substring(tempXML.indexOf(sEndTag) + sEndTag.length(), tempXML.length());
				}
				if (tempXML.indexOf(sStartTag) != -1) {
					sTagValues += ",";
					//System.out.println("sTagValues"+sTagValues);
				}
			}
			if (sTagValues.indexOf("#amp#") != -1) {
				System.out.println("Index found");
				sTagValues = sTagValues.replaceAll("#amp#", "&");
			}
			//System.out.println(" Final sTagValues"+sTagValues);
		} catch (Exception e) {
		}
		System.out.println(sTagValues);
		return sTagValues;
	}

	private String getDataForTag(String outputXML, String callMethod) {
		String responseData = "";
		responseData = responseData + "<option value='Select'>--Select--</option>";
		if (callMethod.equalsIgnoreCase("Folder_Name")) {
			String operationType = getTagValues(outputXML, "DCNAME").trim();
			String operationArr[] = operationType.split(",");
			System.out.println("Check operationArr :" + operationArr.length + " opertion type = " + operationType);
			for (int i = 0; i < operationArr.length && !operationType.equals(""); i++) {
				System.out.println("Naman array " + operationArr[i]);
				responseData = responseData + "<option value=" + operationArr[i] + ">" + operationArr[i] + "</option>";
			}
		} else if (callMethod.equalsIgnoreCase("DC_Name")) {
			responseData = getTagValues(outputXML, "ENGLISHNAME");
			responseData = responseData + "," + getTagValues(outputXML, "DOCNUMBER");
			responseData = responseData + "," + getTagValues(outputXML, "ARABICNAME");
		}
		return responseData;
	}%>
<%
	String params = request.getParameter("data").trim();
String callMethod = request.getParameter("method").trim();
System.out.println("Naman : " + params);
System.out.println("Naman : " + callMethod);
String cabname = "";
String serverIP = "";
String serverPort = "";
String query = "";
String inputXML = "";
String outputXML = "";
Properties prop = null;
String strFilePath = System.getProperty("user.dir");
String fileSeparator = System.getProperty("file.separator");
try {
	prop = new Properties();
	System.setProperty("file.encoding", "UTF-8");
	FileInputStream input = new FileInputStream(
	new File(strFilePath + fileSeparator + "HBTF_Property" + fileSeparator + "Property.properties"));
	prop.load(new InputStreamReader(input, Charset.forName(System.getProperty("file.encoding"))));
	serverIP = (prop.getProperty("serverIP"));
	serverPort = (prop.getProperty("JTSPort"));
	cabname = (prop.getProperty("cabinetName"));
} catch (FileNotFoundException ex) {
	ex.printStackTrace();
} catch (IOException ex) {
	ex.printStackTrace();
}
String responseData = "";
if (callMethod.equalsIgnoreCase("Folder_Name")) {
	String dataDefNames = request.getParameter("datadef").trim();
	dataDefNames = dataDefNames.replaceAll(",", "','");
	query = "select distinct(dcname) from ng_hbtf_dc_property where foldername='" + params + "' and dcname in ('"
	+ dataDefNames + "')";
	System.out.println("Fetch From Db Query : " + query);
} else if (callMethod.equalsIgnoreCase("DC_Name")) {
	query = "select distinct englishname, arabicname, docnumber from ng_hbtf_dc_property where dcname='" + params + "'";
}
inputXML = getApselectXML();
inputXML = inputXML.replace("InsertYourQueryHere", query).replace("InsertCabinetNameHere", cabname);
System.out.println("input xml to get opeartion type value is " + inputXML);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
System.out.println("input xml to get opeartion type value is " + outputXML);
responseData = getDataForTag(outputXML, callMethod);
//operationType=getTagValues(outputXML, "DCNAME");
System.out.println("input xml to get responseData  is " + responseData);
/*
operationArr=operationType.split(",");
String options="";
for(int i=0;i<operationArr.length;i++){
	System.out.println("Naman array "+operationArr[i]);
options = options+"<option value="+operationArr[i]+">"+operationArr[i]+"</option>";
}*/
//}
out.print(responseData);
%>
