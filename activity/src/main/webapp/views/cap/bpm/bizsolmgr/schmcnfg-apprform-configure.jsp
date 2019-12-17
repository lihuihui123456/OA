<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务配置页</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:100%">
<div data-options="region:'center',heigh:'auto'">
<table border= "1" style="width: 100%"  class="table-style">
				<tr style="height: 35px">
					<th style="width:18%;text-align: right;">属性配置</th>
					<td colspan="3">
                        <input type="checkbox" id="mainBody_" name="mainBody_" value="">正文</input>
						<input type="checkbox" id="attachment_" name="attachment_" value="">关联文档</input>
						<input type="checkbox" id="earc" name="earc" value="">档案信息</input>
					</td>
				</tr>
				
			</table>
</div>
	 <div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<a href="javascript:void(0)" onclick="doSave()"
				class="easyui-linkbutton" plain="true">确定</a>
			<a href="javascript:void(0)"
				onclick="closeDialog()" class="easyui-linkbutton" plain="true">关闭</a>
		</div>
	</div>
</body>
<script type="text/javascript">
var attachment_ = '${attachment_}';
var mainBody_ = '${mainBody_}';
var earc = '${earc}';
 $(function(){
	if(mainBody_ == '1'){
		document.getElementById("mainBody_").checked = true;
	}
	if(attachment_ == '1'){
		document.getElementById("attachment_").checked = true;
	}
	if(earc == '1'){
		document.getElementById("earc").checked = true;
	}
});
function doSave(){
		var id = '${id}';
		var mainBody='';
		var attachment='';
		var earc = '';
		if(document.getElementById("mainBody_").checked){
			mainBody='1';
		}
		if(document.getElementById("attachment_").checked){
			attachment='1';
		}
		if(document.getElementById("earc").checked){
			earc='1';
		}
		$.ajax({
			url : '${ctx}/bizSolMgr/doSaveBpmReFormNode',
			type : 'post',
			dataType :  'text',
			data : {id:id,mainBody:mainBody,attachment:attachment,earc:earc},
			success : function(data){
				if(data=='Y') {
					window.parent.$.messager.show({title:'提示',msg:'保存成功！',timeout:2000,});
				}else{
					window.parent.$.messager.show({title:'提示',msg:'保存失败！',timeout:2000,});
				}
			}
		});
		window.parent.closeDialog('dialog');
}
/**
 * 关闭弹出的dialog
 */
function closeDialog(){
	window.parent.closeDialog('dialog');
}
</script>
</html>