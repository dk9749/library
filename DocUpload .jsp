<%@page import="org.apache.log4j.PropertyConfigurator"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.File"%>
<%@page import="java.nio.charset.Charset"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.util.Properties"%>
<%@page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*"%>
<%@ page import="com.newgen.wfdesktop.util.*"%>
<!-- 
<script language=javascript src="jquery.js" type="text/javascript"></script>
<script language=javascript src="jquery.json-2.3.js" type="text/javascript"></script>
-->

<style>
table.center {
	margin: 0;
	margin-left: auto;
	margin-right: auto;
}

select {
	width: 170px;
}

select:focus {
	min-width: 170px;
}
</style>

<script>
var status=<%=request.getParameter("status")%>;
/*if(status=='' || status=='null' || status==null)
	{}
else
	{
		if(status=='0')
			{
				alert('Document Uploaded Successfully')
			}
		else
			{
				alert('Error occured while uploading document');					
			}
		
	}*/
	/*
	if(status!='' || status!='null' || status!=null)
    {
        if(status=='0'||status==0)
            {
                alert('Document Uploaded Successfully')
            }
        else
            {
                alert('Error occured while uploading document');                   
            }
    }
*/
if(status!='' || status!='null' || status!=null)
    {
        if(status=='0'||status==0)
            {
                alert('Document Uploaded Successfully');
			
			}
        else 
            {
				if(status===null || status=='null')
				{
				//	alert('Welcome to manual upload');
				}
				
				else{
					//alert(status);
                alert('Error occured while uploading document');
						
				}                  
            }
    }

</script>

<script>
<%--  var status = <%=request.getSession().getAttribute("StatusUpload")%>; 
 alert(status); 
 if(status !="null"){
	 alert('dds'); 
 } --%>
	function goBack() {
		var form2 = document.getElementById('form2');
		form2.action = '/omnidocs/ExtendSession.jsp';
		form2.submit();
	}
</script>

<script>
	//Naman Purwar
	function basicAjax(callMethod, datadefnames) {
		//alert('xx');
		//var config=document.getElementById('Folder_Name').value; 
		var callMethodValue = document.getElementById(callMethod).value;
		if (callMethodValue.trim().length > 0
				&& callMethodValue.trim() != 'Select') {

			//alert(callMethodValue);
			var xmlhttp;
			var listData;
			if (callMethod == "Folder_Name") {
				var url = "fetchFromDB.jsp?data=" + callMethodValue
						+ "&method=" + callMethod + "&datadef=" + datadefnames;
			} else {
				var url = "fetchFromDB.jsp?data=" + callMethodValue
						+ "&method=" + callMethod;
			}

			//alert(url);
			if (window.XMLHttpRequest) {
				xmlhttp = new XMLHttpRequest();
			} else {
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
			xmlhttp.onreadystatechange = function() {
								//alert('status is '+xmlhttp.status);
				if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {

					//document.getElementById("myDiv").innerHTML=xmlhttp.responseText;
					listData = xmlhttp.responseText;
					//alert(listData);
					//alert(callMethod);
					if (callMethod == "Folder_Name") {

						document.getElementById("DC_Name").innerHTML = listData;
					} else if (callMethod == "DC_Name") {
					//alert('list data is '+listData);
						var ar = listData.split(',');
						ar[0]=ar[0].substring(ar[0].indexOf("<\/script>")+9,ar[0].length);
						document.getElementById("Doc_Name_Eng").value = ar[0];
						document.getElementById("Doc_Number").value = ar[1];
						document.getElementById("Doc_Name_Arabic").value = ar[2];
					}
				}
			}

			xmlhttp.open("POST", url, true);
			xmlhttp.send();
		}

		//document.getElementById("DC_Name").innerHTML="hello";
		//document.getElementById("DC_Name").innerHTML=listDropDown;

	}

	function checkOperation() {

		var checkCRM = document.getElementById("Operation_Type").value;
		if (checkCRM == "CRM") {
			var setForCRM = document.getElementById("Account_Number").readOnly = true;
			document.getElementById("Account_Number").innerHTML = setForCRM;
		} else {
			var setForCRM = document.getElementById("Account_Number").readOnly = false;
			document.getElementById("Account_Number").innerHTML = setForCRM;
		}

	}

	function clearDCNameDropDown() {

		var dcname = document.getElementById("DC_Name").innerHTML = "";
	}

	function changeFolderName() {
		//alert('inside change folder name');
		document.getElementById('Doc_Name').value = "";
		var foldername = document.getElementById("Folder_Name").value;
		var dcname = document.getElementById("DC_Name");

		//alert('folder name is '+foldername);
		
	}
</script>

<script>
	function submit_form() {
		//alert('submit form button clicked');

		var doc = document.getElementById('hbtf_doc').value;
		if (doc == "") {
			alert('Please select any document to upload');
			document.getElementById('hbtf_doc').focus();
			return false;
		}

		var folder = document.getElementById('Folder_Name').value;
		if (folder == "" || folder == "Select") {
			alert('Please select Folder Name');
			document.getElementById('Folder_Name').focus();
			return false;
		}

		var dcname = document.getElementById('DC_Name').value;
		if (dcname == "" || dcname == "--Select--") {
			alert('Please select DataClass Name');
			document.getElementById('DC_Name').focus();
			//return false;
		}

		var cif = document.getElementById('CIF_Number').value;
		if (cif == "") {
			alert('CIF Number cannot be left empty');
			document.getElementById('CIF_Number').focus();
			return false;
		}

		var cifBranch = document.getElementById('CIF_Branch_Number').value;
		if (cifBranch == "") {
			alert('CIF Branch Number cannot be left empty');
			document.getElementById('CIF_Branch_Number').focus();
			return false;
		}

		var accountBranch = document.getElementById('Account_Number').value;
		var checkCRM = document.getElementById("Operation_Type").value;
		if (checkCRM != "CRM") {

			if (accountBranch == "") {
				alert('Account Branch Number cannot be left empty');
				document.getElementById('Account_Number').focus();
				return false;
			}
		}
		/* Naman
		var accountBranch=document.getElementById('Account_Number').value;
		if(accountBranch=="")
			{
				alert('Account Branch Number cannot be left empty');
				document.getElementById('Account_Number').focus();
				return false;
			}
		 */

		var transaction = document.getElementById('Transaction_Number').value;
		/*
		if(transaction=="")
			{
				alert('Transaction Number cannot be left empty');
				document.getElementById('Transaction_Number').focus();
				return false;
			}
		 */
		var docname_eng = document.getElementById('Doc_Name_Eng').value;
		var docname_arabic = document.getElementById('Doc_Name_Arabic').value;

		var operationtype = document.getElementById('Operation_Type').value;
		if (operationtype == "--Select--" || operationtype == "") {
			alert('Operation Type cannot be left empty');
			document.getElementById('Operation_Type').focus();
			return false;
		}
		var docnumber = document.getElementById('Doc_Number').value;
		var user = document.getElementById('User_Name').value;
		var dateval = document.getElementById('Insert_Date').value;

		var sessionID = document.getElementById('UserDbId12').value;
		//var sessionID="1108663488";
		//alert(sessionID);
		var docname = docname_eng + "_" + docname_arabic;
		console.log('docname is ' + docname);
		var content = "1~folder=" + folder + "~dcname=" + dcname + "~docname="
				+ docname + "~docnumber=" + docnumber + "~username=" + user
				+ "~insertdate=" + dateval + "~cif=" + cif + "~cifbranch="
				+ cifBranch + "~account=" + accountBranch + "~transaction="
				+ transaction + "~opeationtype=" + operationtype + "~dbID="
				+ sessionID;

		//alert('content is ' + content);
		//var finalcontent=encodeURIComponent($.toJSON(content));
		
		
		
		var form1 = document.getElementById("myform1");
		var url = "DocUploadMain.jsp?content=" + content;
		//alert('url is before calling DocUploadMain.jsp--'+url);
		document.getElementById("myform1").action = url;
		form1.submit();
		
		
		//alert(url);
		//var url="DocUploadMain.jsp";
		//form1.method="POST";
		//form1.enctype = "multipart/form-data";
		//form1.action=url;
		//form1.submit();

	}
</script>

<script>
	function getDocName() {
		//alert("inside getdoc name function");
		document.getElementById('Doc_Name').value = "";
		var dcname = document.getElementById('DC_Name').value;
		var subStr = dcname.substring(dcname.indexOf("_") + 1);
		var finalStr = subStr.substring(subStr.indexOf("_") + 1);

		document.getElementById('Doc_Name').value = finalStr;
	}

	function cifFunction() {
		var cif = document.getElementById('CIF_Number').value;
		if (cif != "" && cif.length != 8) {
			alert('CIF Number should be 8 digits');
			document.getElementById('CIF_Number').value = '';
			document.getElementById('CIF_Number').focus();
			return false;
		}
		else{
		document.getElementById('Account_Number').value = cif;
		}

	}

	function cifBranchFunction() {
		var cifBranch = document.getElementById('CIF_Branch_Number').value;
		if (cifBranch != "" && cifBranch.length != 3) 
		{
			
				alert('CIF Branch Number should be 3 Digits');
			document.getElementById('CIF_Branch_Number').value = '';
			document.getElementById('CIF_Branch_Number').focus();
			return false;
		}

	}
		
		
	function accountFunction()
	{
		var account=document.getElementById('Account_Number').value;
		if(account!="" && account.length != 16)
			{
				alert('Account Number should be 16 digits');
				document.getElementById('Account_Number').value = '';
				document.getElementById('Account_Number').focus();
				return false;				
			}
	}
	
	
	
</script>



<%!SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	String startDateTime = sdf.format(new Date());

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
					//logger.debug("sTagValues"+sTagValues);
					tempXML = tempXML.substring(tempXML.indexOf(sEndTag) + sEndTag.length(), tempXML.length());
				}
				if (tempXML.indexOf(sStartTag) != -1) {
					sTagValues += ",";
					//logger.debug("sTagValues"+sTagValues);
				}
			}
			if (sTagValues.indexOf("#amp#") != -1) {
				//logger.debug("Index found");
				sTagValues = sTagValues.replaceAll("#amp#", "&");
			}
			//logger.debug(" Final sTagValues"+sTagValues);
		} catch (Exception e) {
		}
		return sTagValues;
	}

	public String ExecuteAPI(String sInputXML, String serverIP, String serverPort) {
		String sOutputXML = "";
		//String serverType = "JTS";
		String serverType = "WebSphere";
		NGEjbClient objNGEjbClient = null;
		try {
			objNGEjbClient = NGEjbClient.getSharedInstance();
			//sOutputXML = objNGEjbClient.makeCall(serverIP, "2809", serverType,sInputXML);
			sOutputXML = WFCallBroker.execute(sInputXML, serverIP, 3333, 1);
		} catch (Exception e) {
			sOutputXML = "error";
			//logger.debug("error from wrapper");
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

	private String getDataClassXML(String cabinetName, String sessionID) {
		String inputXML = "<?xml version=\"1.0\"?>" + "<NGOGetDataDefListExt_Input>"
				+ "<Option>NGOGetDataDefListExt</Option>" + "<CabinetName>" + cabinetName + "</CabinetName>"
				+ "<UserDBId>" + sessionID + "</UserDBId>" + "<OrderBy>2</OrderBy>" + "<SortOrder>A</SortOrder>"
				+ "<PreviousIndex>0</PreviousIndex>" + "<NoOfRecordsToFetch>5000</NoOfRecordsToFetch>"
				+ "<Type>G</Type>" + "<GroupId>0</GroupId>" + "</NGOGetDataDefListExt_Input>";
		return inputXML;
	}

	//Log Function
	public void loadLog4j() {
		Properties properties;
		try {
			properties = new Properties();
			properties.load(new FileInputStream(System.getProperty("user.dir") + System.getProperty("file.separator")
					+ "HBTF_Property" + System.getProperty("file.separator") + "log4j.properties"));
			PropertyConfigurator.configure(properties);
		} catch (Exception glbExp) {
			glbExp.printStackTrace();
		} finally {
		}
	}%>

<%
	String inputXML = "";
String outputXML = "";
String query = "";
String cabname = "";
String serverIP = "";
String serverPort = "";
String operationType = "";
String dataDefNames = "";
String sessionID = "";
String username = "";
Logger logger = null;
String foldername = "";
loadLog4j();
logger = Logger.getLogger("docUpload");
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
sessionID = request.getParameter("userDBid");
logger.debug("Session ID : " + sessionID);
username = request.getParameter("userName");
//username="Supervisor";
inputXML = getDataClassXML(cabname, sessionID);
logger.debug("input to get dataclass names naman************* " + inputXML);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
logger.debug("NGOGetDataDefListExt XML Output : Naman :" + outputXML);
dataDefNames = getTagValues(outputXML, "DataDefName");
logger.debug("Data Def Names : " + dataDefNames);
query = "select operationType from ng_hbtf_operation_type_table where isActive='Y'";
inputXML = getApselectXML();
inputXML = inputXML.replace("InsertYourQueryHere", query).replace("InsertCabinetNameHere", cabname);
logger.debug("input xml to get opeartion type value is " + inputXML);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
logger.debug("output xml is " + outputXML);
operationType = getTagValues(outputXML, "OPERATIONTYPE");
String operationArr[] = operationType.split(",");
logger.debug("Naman Dste : " + startDateTime);
query = "select foldername from ng_hbtf_folder_master where isactive='Y'";
inputXML = getApselectXML();
inputXML = inputXML.replace("InsertYourQueryHere", query).replace("InsertCabinetNameHere", cabname);
logger.debug("input xml to get folder name is " + inputXML);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
logger.debug("output xml is " + outputXML);
foldername = getTagValues(outputXML, "FOLDERNAME");
String folderArr[] = foldername.split(",");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Manual Document Upload</title>
</head>
<body bgcolor="#EAECEE">



	<!-- 
	<table style="width: 100%">

		<tr>
			<td align="right"
				style="padding-right: 20px; background-color: #EAECEE"><img
				alt="OmniDocs" src="../estyle/images/doccab/logo_new.gif"></td>
			<td></td>
		</tr>
		<!-- 
		<tr style="background-color:white ">
		<td align=center><img src="/omnidocs/HBTF_DMS/hbtf.jpg" style="height:90px" /></td>			
		</tr>
		


	</table>
	 -->
	<table style="width: 100%">

		<tr>

			<td align="right"
				style="padding-right: 20px; background-color: #EAECEE"><img
				alt="OmniDocs" src="../estyle/images/doccab/logo_new.gif"></td>

		</tr>
	</table>
	<table style="width: 100%; border-collapse: collapse">
		<!-- 
		<tr style="background-color:white ">
		<td align=center><img src="/omnidocs/HBTF_DMS/hbtf.jpg" style="height:90px" /></td>			
		</tr>
		 -->
		<tr>
			<td align="left" style="color: #5DADE2; padding-top: 0"><b>Hi
					<%=username%> , Welcome to HBTF Document Archival
			</b></td>
		</tr>
		<tr>

			<td style="height: -10px">
				<hr width="99%">
			</td>
		</tr>


	</table>

	<form id="myform1" name="myform1" method="post"
		enctype=multipart/form-data>
		<!--  <table border="0" align="center"
			style='margin-top: 20; font-family: Arial; font-size: 12; background-image: url(../webaccess/images/bg_login.gif); background-size: cover; height: auto"'>-->
		<table align="center"
			style='margin-top: 30; padding-top: 10; font-family: Calibri; border: 2px solid black; border-radius: 20px; background-color: #AED6F1'>

			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>

			<tr>
				<td style="padding-left: 20">Add HBTF Document</td>
				<td><input type="file" id="hbtf_doc" name="hbtf_doc"></td>
				<td></td>
				<td>Folder Name</td>
				<td style="padding-right: 20"><select id="Folder_Name"
					name="Folder_Name"
					onChange="basicAjax(this.id,'<%=dataDefNames%>')">
						<option value="Select">--Select--</option>
						<!--<option value="CIF">CIF</option>
						<option value="Account">Account</option>
						<option value="Credit_Card">Credit Card</option>
						<option value="LG">LG</option>
						<option value="LC">LC</option>
						<option value="Bill_Collection">Bill Of Collection</option>
						<option value="E-Statement">E-Statement</option>
						<option value="Deposit_Box">Safety Deposit Box</option>
						<option value="Electronic_Channels">Electronic Channels</option>-->

						<%
							for (int i = 0; i < folderArr.length; i++) {
						%>
						<option><%=folderArr[i]%></option>
						<%
							}
						%>

				</select></td>
			</tr>

			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>


			<tr>
				<td style="padding-left: 20">DataClass Name</td>
				<td><select id="DC_Name" name="DC_Name"
					onchange="basicAjax(this.id)">
						<option value="Select">--Select--</option>

				</select></td>

			</tr>

			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>

			<tr>
				<td style="padding-left: 20">Operation Type</td>
				<td><select id="Operation_Type" name="Operation_Type"
					onchange="checkOperation()">

						<%
							for (int i = 0; i < operationArr.length; i++) {
						%>
						<option><%=operationArr[i]%></option>

						<%
							}
						%>

				</select></td>
				<td></td>
				<td>Document Name - English</td>
				<td style="padding-right: 20"><input type="text"
					id="Doc_Name_Eng" name="Doc_Name_Eng" readonly="readonly"></td>


			</tr>

			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>

			<tr>
				<td style="padding-left: 20">Document Name - Arabic</td>
				<td><input type="text" id="Doc_Name_Arabic"
					name="Doc_Name_Arabic" readonly="readonly"></td>


				<td></td>
				<td>Document Number</td>
				<td style="padding-right: 20"><input type="text" value="123"
					readonly="readonly" id="Doc_Number" name="Doc_Number"></td>
			</tr>

			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>


			<tr>
				<td style="padding-left: 20">User Name</td>
				<td><input type="text" value="<%=username%>"
					readonly="readonly" id="User_Name" name="User_Name"></td>

				<td></td>
				<td>Inserted Date</td>
				<td style="padding-right: 20"><input type="text"
					value="<%=startDateTime%>" readonly="readonly" id="Insert_Date"
					name="Insert_Date"></td>
			</tr>

			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>


			<tr>
				<td style="padding-left: 20" align="left">CIF Number</td>
				<td><input type="number" id="CIF_Number" name="CIF_Number"
					onfocusout="cifFunction()"></td>


				<td></td>
				<td>CIF Branch Number</td>
				<td style="padding-right: 20"><input type="number"
					id="CIF_Branch_Number" name="CIF_Branch_Number"
					onfocusout="cifBranchFunction()"></td>
			</tr>

			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>


			<tr>
				<td style="padding-left: 20">Account Branch Number</td>
				<td><input type="number" id="Account_Number"
					name="Account_Number" onfocusout="accountFunction()"></td>

				<td></td>
				<td>Transaction Branch Number</td>
				<td style="padding-right: 20"><input type="text"
					id="Transaction_Number" name="Transaction_Number"></td>
			</tr>


			<tr>
				<td><input type="hidden" id="UserDbId12" name="UserDbId12"
					value="<%=sessionID%>"></td>
			</tr>

			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
			</tr>

			<tr>
				<td></td>
				<td align="center"><input type="button" value="Submit"
					onclick="submit_form()"></td>
				<td><input type="button" value="Back" onclick="goBack();"></td>
				<td></td>
				<td></td>
			</tr>

			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
			</tr>

		</table>

	</form>

	<table style="width: 100%">
		<tr>
			<td style="height: 50px">
				<hr width="99%">
			</td>
		</tr>
		<tr>
			<td></td>
		</tr>
		<tr>
			<td align="center"
				style="font-family: Arial; color: #434343; font-size: 9pt;">Copyright
				© 2017 Newgen Software Technologies Limited. All rights reserved.</td>
		</tr>

	</table>

	<form id="form2" name="form2" method="post">
		<input type="hidden" name="CabinetName" value="<%=cabname%>">
		<input type="hidden" name="UserDbId" value="<%=sessionID%>"> <input
			type="hidden" name="DesktopOption" value="ODWebDesktop"> <input
			type="hidden" name="ShowLogOut" value="Yes">
	</form>

</body>
</html>


