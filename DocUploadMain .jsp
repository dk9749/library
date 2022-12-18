<%@page import="org.apache.log4j.Logger"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="org.apache.commons.fileupload.FileItemIterator"%>
<%@page
	import="org.apache.commons.fileupload.servlet.ServletRequestContext"%>
<%@page import="com.newgen.omni.wf.util.app.NGEjbClient"%>
<%@page import="java.io.ObjectInputStream.GetField"%>
<%@page import="ISPack.ISUtil.JPISIsIndex"%>
<%@page import="ISPack.ISUtil.JPDBRecoverDocData"%>
<%@page import="ISPack.CPISDocumentTxn"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.io.FilenameUtils"%>
<%@page import="com.sun.media.jai.codec.FileSeekableStream"%>
<%@page import="com.sun.media.jai.codec.ImageCodec"%>
<%@page import="com.sun.media.jai.codec.ImageDecoder"%>
<%@page import="java.util.Properties"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.FileNotFoundException"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.log4j.PropertyConfigurator"%>
<%@page import="java.nio.charset.Charset"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.FileInputStream"%>
<%@ page import="com.newgen.wfdesktop.xmlapi.*"%>
<%@ page import="com.newgen.wfdesktop.util.*"%>

<script type="text/javascript">
	alert('jsp page hit !!');
</script>

<%!HashMap ht = new HashMap();

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

	private String getAddFolderXML(String sUserDBID, String sFolderName, String parentFolderIndex, String sCabName) {
		return "<?xml version=\"1.0\"?>" + "<NGOAddFolder_Input>" + "<Option>NGOAddFolder</Option>" + "<CabinetName>"
				+ sCabName + "</CabinetName>" + "<UserDBId>" + sUserDBID + "</UserDBId>" + "<Folder>"
				+ "<ParentFolderIndex>" + parentFolderIndex + "</ParentFolderIndex>" + "<FolderName>" + sFolderName
				+ "</FolderName>" + "<CreationDateTime></CreationDateTime>" + "<ExpiryDateTime></ExpiryDateTime>"
				+ "<AccessType>I</AccessType>" + "<ImageVolumeIndex>1</ImageVolumeIndex>" + "<Location></Location>"
				+ "<Comment></Comment>" + "<NoOfDocuments></NoOfDocuments>" + "<NoOfSubFolders></NoOfSubFolders>"
				+ "<DuplicateName>N</DuplicateName>" + "</Folder>" + "</NGOAddFolder_Input>";
	}

	public String ExecuteAPI(String sInputXML, String serverIP, String serverPort) {
		String sOutputXML = "";
		String serverType = "JTS";
		//NGEjbClient objNGEjbClient=null;
		try {
			//objNGEjbClient = NGEjbClient.getSharedInstance();
			//sOutputXML =objNGEjbClient.makeCall(serverIP,"3333",serverType,sInputXML);
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

	private String getAddDocumentInput(String sCabinetName, String sUserDBID, String sParentFolderIndex,
			String sNoOfPages, String sDocumentName, String sDocType, String sDocumentSize, String sCreatedbyAppName,
			String sISIndex, String strDataclassData) {
		return "<?xml version=\"1.0\"?>" + "<NGOAddDocument_Input>" + "<Option>NGOAddDocument</Option>"
				+ "<CabinetName>" + sCabinetName + "</CabinetName>" + "<UserDBId>" + sUserDBID + "</UserDBId>"
				+ "<GroupIndex>0</GroupIndex>" + "<DuplicateName>A</DuplicateName>" + "<Document>"
				+ "<ParentFolderIndex>" + sParentFolderIndex + "</ParentFolderIndex>" + "<NoOfPages>" + sNoOfPages
				+ "</NoOfPages>" + "<AccessType>I</AccessType>" + "<DocumentName>" + sDocumentName + "</DocumentName>"
				+ "<CreationDateTime></CreationDateTime>" + "<DocumentType>" + sDocType + "</DocumentType>"
				+ "<DocumentSize>" + sDocumentSize + "</DocumentSize>" + "<CreatedByAppName>" + sCreatedbyAppName
				+ "</CreatedByAppName>" + "<ISIndex>" + sISIndex + "</ISIndex>"
				+ "<ODMADocumentIndex></ODMADocumentIndex>" + "<Comment>Original Document</Comment>"
				+ "<EnableLog>Y</EnableLog>" + "<FTSFlag>PP</FTSFlag>" + strDataclassData + "<Keywords></Keywords>"
				+ "</Document>" + "</NGOAddDocument_Input>";
	}

	private String getDataClassIDFromNameInput(String sCabinetName, String sUserDBID, String strDataclassName) {
		return "<?xml version=\"1.0\"?><NGOGetIDFromName_Input>" + "<Option>NGOGetIDFromName</Option> " + "<UserDBId>"
				+ sUserDBID + "</UserDBId>  " + "<CabinetName>" + sCabinetName + "</CabinetName>  "
				+ "<ObjectType>X</ObjectType>  " + "<ObjectName>" + strDataclassName + "</ObjectName>"
				+ "<Index></Index>" + "<MainGroupIndex>0</MainGroupIndex>" + "</NGOGetIDFromName_Input>";
	}

	private String getDataclassPropertiesInput(String sCabinetName, String sUserDBID, String strDataclassId) {
		return "<?xml version=\"1.0\"?><NGOGetDataDefProperty_Input>" + "<Option>NGOGetDataDefProperty</Option>"
				+ "<CabinetName>" + sCabinetName + "</CabinetName>" + "<UserDBId>" + sUserDBID + "</UserDBId>"
				+ "<DataDefIndex>" + strDataclassId + "</DataDefIndex>" + "</NGOGetDataDefProperty_Input>";
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
	}

	public static String stackTraceToString(Throwable e) {
		StringBuilder sb = new StringBuilder();
		sb.append(e.getMessage());
		sb.append("\n");
		sb.append(e.getCause());
		sb.append("\n");
		for (StackTraceElement element : e.getStackTrace()) {
			sb.append(element.toString());
			sb.append("\n");
		}
		return sb.toString();
	}%>



<%
	String tagValue = "";
String foldername = "";
String dcname = "";
String docname = "";
String docnumber = "";
String username = "";
String insertDate = "";
String cif = "";
String cifBranch = "";
String account = "";
String transaction = "";
String sessionID = "";
String operationtype = "";
File file = null;
File folder = null;
String path_to_store_image = "";
String sCabName = "";
String sVolumeID = "";
String filename = "";
String file_name = "";
String file_ext = "";
FileSeekableStream fileStream = null;
String noOfPages = "1";
String file_name_with_file_path = "";
JPISIsIndex NewIsIndex = new JPISIsIndex();
String inputXML = "";
String outputXML = "";
String query = "";
String serverIP = "";
String serverPort = "";
String folder_index = "";
String isIndex = "";
String strDataclassData = "";
String dataclass_index = "";
Logger logger = null;
loadLog4j();
logger = Logger.getLogger("docUploadMain");
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
	sCabName = (prop.getProperty("cabinetName"));
	sVolumeID = (prop.getProperty("volumeID"));
} catch (FileNotFoundException ex) {
	ex.printStackTrace();
} catch (IOException ex) {
	ex.printStackTrace();
}
//add the value to hashmap 
tagValue = request.getParameter("content");
logger.debug("content is " + tagValue);
String[] tempStrArray = tagValue.split("~");
for (int loop = 0; loop < tempStrArray.length; loop++) {
	logger.debug("inside for loop");
	String keyValue[] = tempStrArray[loop].split("=");
	try {
		if (keyValue[0].length() >= 1 && keyValue[1].length() >= 1) {
	logger.debug("RLOS : keyValue : " + keyValue[1]);
	ht.put(keyValue[0], keyValue[1]);
	System.out.println("RLOS : ht.size() : 1 :" + ht.size());
		} else if (keyValue[1].length() < 1) {
	logger.debug("RLOS : keyValue[1].length() < 1 :" + ht.size());
		}
	} catch (Exception ex) {
		ht.put(keyValue[0], "");
		logger.debug("RLOS : ht.size() : 2 :" + ht.size());
	}
	logger.debug("outside for loop:");
}
//end
foldername = ht.get("folder").toString();
dcname = ht.get("dcname").toString();
docnumber = ht.get("docnumber").toString();
username = ht.get("username").toString();
insertDate = ht.get("insertdate").toString();
cif = ht.get("cif").toString();
cifBranch = ht.get("cifbranch").toString();
account = ht.get("account").toString();
transaction = ht.get("transaction").toString();
sessionID = ht.get("dbID").toString();
//sessionID = request.getParameter("UserDbId12");
operationtype = ht.get("opeationtype").toString();
docname = ht.get("docname").toString();
logger.debug("abc : " + ht.toString());
logger.debug("session ***************** " + sessionID);
//sessionID="1108663488";
//File ImageName;
List<FileItem> items = null;
long maxFileSize = (2 * 1024 * 1024);
int maxMemSize = (2 * 1024 * 1024);
try {
	items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(request);
} catch (Throwable e) {
	logger.debug("Erooorrrrrr");
	System.out.println("error is here---");
	e.printStackTrace();
}
logger.debug("File is:" + items);
for (FileItem item : items) {
	if (item.isFormField()) {
		logger.debug("field " + item.getFieldName());
		// here the values of the form fields can be reterieved if any	
	} else {
		filename = FilenameUtils.getName(item.getName());
		// Get filename.
		logger.debug("file : " + filename);
		path_to_store_image = System.getProperty("user.dir") + File.separator + "uploadTemp";
		logger.debug("the path for temp file " + path_to_store_image);
		logger.debug("the path for temp file " + path_to_store_image);
		folder = new File(path_to_store_image); // creating the folder to store the image temp.
		folder.mkdir();
		logger.debug("folder created successfully");
		logger.debug("folder created successfully");
		file = new File(path_to_store_image, filename);
		//File file = new File("C:\\", filename);
		// Define destination file.
		item.write(file);
		logger.debug("filename: " + filename);
		logger.debug("filename: " + filename);
		logger.debug("file: " + file);
		logger.debug("file: " + file);
		file_name = filename.substring(0, filename.lastIndexOf("."));
		file_ext = filename.substring(filename.lastIndexOf(".") + 1);
		if (file_ext.equalsIgnoreCase("tif") || file_ext.equalsIgnoreCase("tiff")) {
	fileStream = new FileSeekableStream(file);
	ImageDecoder dec = ImageCodec.createImageDecoder("tiff", fileStream, null);
	noOfPages = "" + dec.getNumPages();
	logger.debug("the number of pages are " + noOfPages);
	logger.debug("the number of pages are " + noOfPages);
		}
	}
}
//adding file to SMS
file_name_with_file_path = path_to_store_image + File.separator + filename;
logger.debug("sVolumeID " + sVolumeID);
logger.debug("before adding in sms");
logger.debug("file_name_with_file_path " + file_name_with_file_path);
//file_name_with_file_path="C://Users//Administrator//Desktop//Desert.jpg";
file = new File(file_name_with_file_path);
try {
	CPISDocumentTxn.AddDocument_MT(null, serverIP, (short) Integer.parseInt(serverPort), sCabName,
	(short) Integer.parseInt(sVolumeID), file_name_with_file_path, new JPDBRecoverDocData(), null, NewIsIndex);
} catch (Throwable e) {
	logger.debug("Exception while add in sms ");
	logger.debug(stackTraceToString(e));
	e.printStackTrace();
}
isIndex = (new StringBuilder()).append(NewIsIndex.m_nDocIndex).append("#").append(NewIsIndex.m_sVolumeId).append("#")
		.toString();
logger.debug("isIndex:" + isIndex);
//adding folder in OD
String getFolderStructureQuery = "select distinct(folderstructure) from ng_hbtf_dc_property where dcname='" + dcname
		+ "'";
inputXML = getApselectXML();
inputXML = inputXML.replace("InsertYourQueryHere", getFolderStructureQuery).replace("InsertCabinetNameHere", sCabName);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
String folderStructure = getTagValues(outputXML, "FOLDERSTRUCTURE");
String folderStrucArr[] = folderStructure.split("/");
logger.debug("Folder Structure :" + folderStructure);
logger.debug("Folder Structure[] length :" + folderStrucArr.length);
query = "select folderindex from pdbfolder where name='HBTF'";
inputXML = getApselectXML();
inputXML = inputXML.replace("InsertYourQueryHere", query).replace("InsertCabinetNameHere", sCabName);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
logger.debug("OUTPUT XML Folder Index :" + outputXML);
String hbtfFolderIndex = getTagValues(outputXML, "FOLDERINDEX");
logger.debug("Folder Index :" + hbtfFolderIndex);
//Add or Check Folder for CIF ID exists or not.
inputXML = getAddFolderXML(sessionID, cif, hbtfFolderIndex, sCabName);
logger.debug("input xml to add folder is " + inputXML);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
logger.debug("output received is  " + outputXML);
String folderStatus = getTagValues(outputXML, "Status");
logger.debug("FolderStatus is  : " + folderStatus);
//getting folder index of the newly_created/existing  folder
inputXML = getApselectXML();
query = "select folderindex from pdbfolder where name='" + cif + "' and parentfolderindex='" + hbtfFolderIndex + "'";
inputXML = inputXML.replace("InsertYourQueryHere", query).replace("InsertCabinetNameHere", sCabName);
logger.debug("input xml to get folder index " + inputXML);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
logger.debug("output is " + outputXML);
folder_index = getTagValues(outputXML, "FOLDERINDEX");
logger.debug("folder index is " + folder_index);
//Check Folder Structure to add folder if required
if (folderStrucArr.length == 3) {
	String folderName = folderStrucArr[2];
	inputXML = getAddFolderXML(sessionID, folderName, folder_index, sCabName);
	logger.debug("input xml to add folder is " + inputXML);
	outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
	logger.debug("output received is  " + outputXML);
	//String folderStatus = getTagValues(outputXML, "Status");
	//logger.debug("FolderStatus is  : "+folderStatus);
	folder_index = getTagValues(outputXML, "FolderIndex");
	logger.debug("folder_index is  : " + folder_index);
}
//Add Document
//getting dataclass index from dataclass name
inputXML = getDataClassIDFromNameInput(sCabName, sessionID, dcname);
logger.debug("input to get dataclass index from name is " + inputXML);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
logger.debug("output is " + outputXML);
dataclass_index = getTagValues(outputXML, "ObjectIndex");
logger.debug("dataclass index is " + dataclass_index);
//getting dataclass properties
inputXML = getDataclassPropertiesInput(sCabName, sessionID, dataclass_index);
logger.debug("input xml to get dataclass properties " + inputXML);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
logger.debug("output received is " + outputXML);
logger.debug("dataclass name is *********************** " + dcname);
strDataclassData += "<DataDefinition>";
strDataclassData += "<DataDefName>" + dcname + "</DataDefName>";
strDataclassData += "<DataDefIndex>" + dataclass_index + "</DataDefIndex>";
strDataclassData += "<Fields>";
logger.debug("str dataclass is ************ " + strDataclassData);
String cif_numberdb = outputXML.substring(outputXML.indexOf("CIF_Number<") + "CIF_Number</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("CIF_Number<")));
logger.debug("CIF Number DB : " + cif_numberdb + " CIF Nu. " + cif);
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + cif_numberdb + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>" + cif + "</IndexValue>";
strDataclassData += "</Field>";
String doc_namedb = outputXML.substring(
		outputXML.indexOf("Document_Name<") + "Document_Name</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("Document_Name<")));
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + doc_namedb + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>" + docname + "</IndexValue>";
strDataclassData += "</Field>";
String doc_numberdb = outputXML.substring(
		outputXML.indexOf("Document_No<") + "Document_No</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("Document_No<")));
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + doc_numberdb + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>" + docnumber + "</IndexValue>";
strDataclassData += "</Field>";
String transaction_no_db = outputXML.substring(
		outputXML.indexOf("Transaction_Branch_Number<") + "Transaction_Branch_Number</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("Transaction_Branch_Number<")));
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + transaction_no_db + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>" + transaction + "</IndexValue>";
strDataclassData += "</Field>";
String account_id_db = outputXML.substring(
		outputXML.indexOf("Account_Id<") + "Account_Id</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("Account_Id<")));
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + account_id_db + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>" + account + "</IndexValue>";
strDataclassData += "</Field>";
String operation_type_db = outputXML.substring(
		outputXML.indexOf("Operation_Type<") + "Operation_Type</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("Operation_Type<")));
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + operation_type_db + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>" + operationtype + "</IndexValue>";
strDataclassData += "</Field>";
String cif_branch_db = outputXML.substring(
		outputXML.indexOf("CIF_Branch_Number<") + "CIF_Branch_Number</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("CIF_Branch_Number<")));
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + cif_branch_db + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>" + cifBranch + "</IndexValue>";
strDataclassData += "</Field>";
String usercode_db = outputXML.substring(outputXML.indexOf("User_Code<") + "User_Code</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("User_Code<")));
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + usercode_db + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>" + username + "</IndexValue>";
strDataclassData += "</Field>";
/*String uploadedby_db=outputXML.substring(outputXML.indexOf("Uploaded_By<")+
		"Uploaded_By</IndexName><IndexId>".length(), outputXML.indexOf("</IndexId>",
		outputXML.indexOf("Uploaded_By<")));

strDataclassData+="<Field>";
strDataclassData+="<IndexId>"+uploadedby_db+"</IndexId>";
strDataclassData+="<IndexType>S</IndexType>";
strDataclassData+="<IndexValue>"+username+"</IndexValue>";
strDataclassData+="</Field>";*/
String confidentialdoc_db = outputXML.substring(
		outputXML.indexOf("Confidential_Doc<") + "Confidential_Doc</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("Confidential_Doc<")));
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + confidentialdoc_db + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>N</IndexValue>";
strDataclassData += "</Field>";
String originaldoc_db = outputXML.substring(
		outputXML.indexOf("Original_Doc_Received<") + "Original_Doc_Received</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("Original_Doc_Received<")));
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + originaldoc_db + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>N</IndexValue>";
strDataclassData += "</Field>";
String status_db = outputXML.substring(outputXML.indexOf("Status_Type<") + "Status_Type</IndexName><IndexId>".length(),
		outputXML.indexOf("</IndexId>", outputXML.indexOf("Status_Type<")));
strDataclassData += "<Field>";
strDataclassData += "<IndexId>" + status_db + "</IndexId>";
strDataclassData += "<IndexType>S</IndexType>";
strDataclassData += "<IndexValue>Pending</IndexValue>";
strDataclassData += "</Field>";
//strDataclassData+="</Field>";
strDataclassData += "</Fields>";
strDataclassData += "</DataDefinition>";
logger.debug("value od dataclass fields are -----  " + strDataclassData);
//adding document in the newly created folder
// I  is the file type needs to be changed
//Code added by Sandeep to resolve file type issue.
String sDocImageType = "N";
if (file_ext.equalsIgnoreCase("tif") || file_ext.equalsIgnoreCase("tiff") || file_ext.equalsIgnoreCase("JPG")
		|| file_ext.equalsIgnoreCase("JPEG") || file_ext.equalsIgnoreCase("JPE") || file_ext.equalsIgnoreCase("JFIF")
		|| file_ext.equalsIgnoreCase("DIB") || file_ext.equalsIgnoreCase("BMP") || file_ext.equalsIgnoreCase("PNG")
		|| file_ext.equalsIgnoreCase("DIB")) {
	sDocImageType = "I";
}
inputXML = getAddDocumentInput(sCabName, sessionID, folder_index, noOfPages, docname, sDocImageType,
		String.valueOf(file.length()), file_ext, isIndex, strDataclassData);
logger.debug("input xml to add document in od " + inputXML);
outputXML = ExecuteAPI(inputXML, serverIP, serverPort);
logger.debug("output is " + outputXML);
String status = getTagValues(outputXML, "Status");
/* if (outputXML.length() > 0) {
	request.getSession().setAttribute("StatusUpload","Set");
} */
logger.debug("Done **************************");
//response.sendRedirect("DocUpload.jsp?SessionId="+sessionID+"&username="+username+"&status="+status);
response.sendRedirect("DocUpload.jsp?userDBid=" + sessionID + "&userName=" + username + "&status=" + status);
//end
%>