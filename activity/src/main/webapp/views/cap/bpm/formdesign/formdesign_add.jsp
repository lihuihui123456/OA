<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>新增业务表单</title>
<style type="text/css">
.left-th{
	width: 18%;
}
.right-td{
	width: 32%;
	text-align: left;
}
</style>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',height:'auto'" style="overflow: hidden">
		<form id="bpmReForm" class="window-form">
			<input type="hidden" id="state_" name="state_" />
			<input type="hidden" id="sameSeries_" name="sameSeries_" />
			<input type="hidden" id="version_" name="version_"/>
			<input type="hidden" id="mainVersion_" name="mainVersion_" />
			<input type="hidden" id="createUserId_" name="createUserId_" />
			<input type="hidden" id="createTime_" name="createTime_" /> 
			<input type="hidden" id="updateUserId_" name="updateUserId_" /> 
			<input type="hidden" id="updateTime_" name="updateTime_" /> 
			<input type="hidden" id="ts_" name="ts_" /> 
			<input type="hidden" id="dr_" name="dr_" /> 
			<input type="hidden" id="remark_" name="remark_" />
			<table border="1" style="width: 100%;" class="table-style">
				<tr style="height: 35px">
					<th class="Theader" colspan="4">业务表单信息</th>
				</tr>
				<tr style="height: 35px">
					<th class="left-th"class="left-th" style="width: 23%">业务应用类别<span class="input-must">*</span>：</th>
					<td class="right-td">
						<input id="formCtlgId_" style="width:100%;" name="formCtlgId_" value="${formCtlgId_}" /></td>
					<th class="left-th">表单类型：</th>
					<td class="right-td"class="right-td">
						<input type="radio" id="online" name="formType_" value="2" />自由表单
						<input type="radio" id="self" name="formType_" value="1" />超链接表单
					</td>
				</tr>
				<tr style="height: 35px">
					<th class="left-th">业务表单名称<span class="input-must">*</span>：</th>
					<td class="right-td">
						<input class="easyui-textbox" id="formName_" name="formName_" 
							data-options="required:true" missingMessage="不能为空" style="width: 100%" /></td>
					<th class="left-th">标识Key<span class="input-must">*</span>：</th>
					<td class="right-td">
						<input class="easyui-textbox" id="key_" name="key_" 
							data-options="validType:'key_',required:true" missingMessage="不能为空" style="width: 100%" />
					</td>
				</tr>
				<tr id="tableName" style="height: 35px">
					<th class="left-th">数据库表：</th>
					<td class="right-td">
						<input class="easyui-textbox" id="tableName_" name="tableName_" style="width: 98%;padding-left: 2px;" />
					</td>
					<th class="left-th">打印模板：</th>
					<td class="right-td">
						<input class="easyui-textbox"  id="printTemplate_" name="printTemplate_" style="width: 100%;" 
						data-options="label: 'Icons:',
			                    labelPosition: 'top',
			                    iconWidth: 22,
			                    icons: [{
			                        iconCls:'icon-search',
			                        handler: function(e){
			                            $('#tempDialog').dialog({    
										    width: 600,
										    height: 350,
										    cache: false,
										    closed : false,
										    onResize:function(){
									           $(this).dialog('center');
									        }
										});
										$('#tempDialogIframe').attr('src','${ctx}/formDesignController/tofindPrintTempList');
			                        }
			                    }]
			                    "/>
					</td>
				</tr>
				<tr id="form_id" style="height: 35px">
					<th class="left-th">自由表单<span class="input-must">*</span>:</th>
					<td colspan="3" style="text-align: left;">
						<input id="freeFormId_" class="easyui-combotree" name="freeFormId_" value="${bpmReForm.freeFormId_}"
							  data-options="required:true"  missingMessage="不能为空" style="width:300px;width:320px\0;" />
						<a href="javascript:void(0)" onclick="desForm()" class="easyui-linkbutton" plain="true">表单设计</a> 
					</td>
				</tr>
				<tr style="height: 35px">
					<th class="left-th">表单URL<span class="input-must">*</span>：</th>
					<td class="right-td" colspan="3">
						<input class="easyui-textbox" id="formUrl_" name="formUrl_" 
							data-options="required:true" missingMessage="不能为空" style="width:100%;padding-left: 2px;" />
					</td>
				</tr>
				<tr style="height: 60px">
					<th class="left-th">描述： </th>
					<td colspan="3" style="text-align: left;">
						<textarea id="desc_" name="desc_" style="width: 100%;border: 0px" rows="4" cols=""></textarea>
						<!-- <input class="easyui-textbox" style="width:100%" data-options="multiline:true" id="desc_"
							name="desc_" /> --></td>
				</tr>
			</table>
		</form>
	</div>
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool" id="self-button">
			<a href="javascript:void(0)" onclick="formSubmit('save')" class="easyui-linkbutton" plain="true">保存</a>
			<a href="javascript:void(0)" onclick="formSubmit('publish')" class="easyui-linkbutton" plain="true">发布</a>
			<a href="javascript:void(0)" onclick="closeDig()" class="easyui-linkbutton" plain="true">关闭</a>
		</div>
		<div class="window-tool" id="online-button">
			<a href="javascript:void(0)" onclick="formSubmit('save')" class="easyui-linkbutton" plain="true">保存</a>
			<a href="javascript:void(0)" onclick="formSubmit('publish')" class="easyui-linkbutton" plain="true">发布</a>
			<a href="javascript:void(0)" onclick="closeDig()" class="easyui-linkbutton" plain="true">关闭</a>
		</div>
	</div>
	
	<!-- 打印导出模板 -->
	<div id="tempDialog" class="easyui-dialog" closed="true" buttons="#dlg-buttons" title="打印导出模板" style="width:80%;height:200px;max-width:800px;padding:10px" data-options="
	        iconCls:'icon-search',
	        onResize:function(){
	            $(this).dialog('center');
	        }">
	    <iframe id="tempDialogIframe" src=""  width="100%" height="350" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="no" style=""></iframe>
		<div id="dlg-buttons" class="window-tool">
			<a class="easyui-linkbutton" data-options="plain:true" onclick="makesureTemp()">确定</a>
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#tempDialog').dialog('close')" plain="true">取消</a>
		</div>
	</div>
</body>
<script type="text/javascript">
$.extend($.fn.validatebox.defaults.rules, {  
    key_ : {
    	validator : function(value) {  
            return  /^[a-zA-Z][a-zA-Z0-9]*$/.test(value);
        },  
        message : 'key格式：以字母开头，由字母数字组成' 
    }
});

$(function() {
	init();

	$("input[name=formType_]").click(function() {
		var tr = document.getElementById("url");
		switch ($("input[name=formType_]:checked").attr("id")) {
		case "online":
			$("#freeFormId_").combotree({
				required: true
			});
			$("#form_id").show();
			$("#tableName").hide();
			$("#online-button").show();
			$("#self-button").hide();
			break;
		case "self":
			$("#freeFormId_").combotree({
				required: false
			});
			$("#form_id").hide();
			$("#tableName").show();
			$("#online-button").hide();
			$("#self-button").show();
			break;
		default:
			break;
		}
	});

	$("#formCtlgId_").combotree({
		url: "${ctx}/formDesignController/formCtlgTree",
	    required: true,
	    panelHeight: 150
	});

	$("#form_datasource").combotree({
		url: "${ctx}/formTableController/findAllFormTable",
		panelHeight: 150
	});

	$("#freeFormId_").combotree({
		url: "${ctx}/formModelDesginController/findAllForm",
		panelHeight: 150,
		onSelect : function(data) {
			if(data.datasource!=null&&data.datasource!="") {
				$("#formUrl_").textbox("setValue",data.datasource);
			}else {
				$.messager.alert("提示", "重新绘制自由表单！", "info");
			}
		}
	});
});

function init() {
	$("#self").attr("checked", "checked");
	$("#freeFormId_").combotree({
		required: false
	});
	$("#url").show();
	$("#form_id").hide();
}

function formSubmit(action) {
	if ($('#bpmReForm').form('validate')) {
		$.ajax({
			url: "${ctx}/formDesignController/doSaveBpmReForm?action=" + action,
			type: 'post',
			dataType: 'text',
			async: false,
			data: $('#bpmReForm').serialize(),
			success: function(data) {
				if (data == 'Y') {
					window.parent.$.messager.show({
						title: '提示',
						msg: '新增成功',
						timeout: 2000,
					});
					window.parent.closeDialog('dialog');
					window.parent.reloadTableData();
				} else if(data == "W") {
					$("#key_").textbox("setValue","");
					window.parent.$.messager.alert("提示", "标志Key已存在！", "info");
				} else {
					window.parent.$.messager.show({
						title: '提示',
						msg: '新增失败',
						timeout: 2000,
					});
				}
			}
		});
	}
}

function closeDig() {
	window.parent.closeDialog('dialog');
}

function desForm() {
	var formid = $("#freeFormId_").combotree("getValue");
	if (formid == "") {
		alert("请选择表单!");
	} else {
		window.open("${ctx}/formModelDesginController/formdesginer?formid=" + formid);
	}
}
</script>
</html>