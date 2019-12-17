<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>个人文件夹</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script type="text/javascript">
var name="";
var id="";
$(function(){
	var parent_id_=window.parent.checktreeId;
	$("#parent_id_").val(parent_id_);
});
function saveFolderInfo(){
	name=$("#folder_name_").val();
	$.ajax({
		url : "${ctx}/docmgt/doSaveFolderInfo",
		dataType : 'json',
		async: false,
		data : $("#folderInfo").serialize(),
		success : function(data) {
			id=data.id;
		}
	});
}
</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="overflow-x:hidden;overflow-y:hidden;">
<form id="folderInfo" action="">
<input type="hidden" id="parent_id_" name="parent_id_" value=""/>
<table>
	<tr>
		<td>文件夹名称</td>
		<td><input type="text" id="folder_name_" name="folder_name_" value=""/></td>
		<td>文件夹类型</td>
		<td>
			<select id="folder_type_" name="folder_type_">
			  <option value ="1">个人文件</option>
			  <option value ="2">部门文件</option>
			  <option value="3">局文件</option>
			</select>
		</td>
	</tr>
</table>
</form>
</body>
</html>