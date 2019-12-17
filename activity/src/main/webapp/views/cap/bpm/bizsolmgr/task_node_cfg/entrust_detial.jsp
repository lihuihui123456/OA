<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<title>委托配置</title>
     <script type="text/javascript">
 function closeDig(){
	window.parent.closeDlg('dialog');
}
    </script>
</head>
<body class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',heigh:'auto'">
	<form id="trustInfo" class="window-form">
	<input type="hidden" id="act_id" name="act_id" value="${trustEntity.act_id}">
	<input type="hidden" id="pro_def_id_" name="pro_def_id_" value="${trustEntity.pro_def_id_}">
	<input type="hidden" id="id" name="id" value="${trustEntity.id}">
	<table border= "1" style="width: 100%"  class="table-style">
	<tr id="trustuser" style="height: 35px">
	    <th style="width:20%;text-align: right;">委托人</th>
	    <td colspan="3">
	     <input type="hidden" id="trust_user_id" name="trust_user_id" value="${trustEntity.trust_user_id}">
	     <input class="easyui-validatebox" id="trust_user_name" name="trust_user_name" value="${trustEntity.trust_user_name}" style="border-style:none;width:95%;" data-options="editable:false" >
		</td>
	</tr>
	<tr id="trustuser" style="height: 35px">
	    <th style="width:20%;text-align: right;">被委托人</th>
	    <td colspan="3">
	     <input type="hidden" id="user_id" name="user_id" value="${trustEntity.user_id}">
	     <input class="easyui-validatebox"  id="user_name" name="user_name" value="${trustEntity.user_name}" style="border-style:none;width:95%;" data-options="editable:false" >
		</td>
	</tr>
	<tr id="trusttime" style="height: 35px">
	    <th style="width:20%;text-align: right;">委托时限:</th>
	    <td><input class="easyui-validatebox" id="start_time_" name="start_time_" style="border-style:none;width:210px;" data-options="editable:false"  value="${trustEntity.start_time_.substring(0,10)}"></td>
	    <th style="width:20%;text-align: center;">至:</th>
	    <td><input class="easyui-validatebox" id="end_time_" name="end_time_" style="border-style:none;width:210px;" data-options="editable:false" value="${trustEntity.end_time_.substring(0,10)}">
		</td>
	</tr>
	<tr style="height: 35px">
	    <th style="width:20%;text-align: right;">委托意见:</th>
	    <td colspan="3">
	     <input class="easyui-validatebox" id="comment_" name="comment_" value="${trustEntity.comment_}" data-options="editable:false" style="border-style:none;width:95%;">
		</td>
	</tr>
	<tr style="height: 35px">
	    <th style="width:20%;text-align: right;">备注:</th>
	    <td colspan="3">
	     <input class="easyui-validatebox" id="remark_" name="remark_" value="${trustEntity.remark_}" data-options="editable:false" style="border-style:none;width:95%;">
		</td>
	</tr>
	</table>
	</form>
</div>
<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<a href="javascript:void(0)" onclick="closeDig()"
				class="easyui-linkbutton" plain="true">关闭</a>
		</div>
	</div>
</div>
</body>
</html>
