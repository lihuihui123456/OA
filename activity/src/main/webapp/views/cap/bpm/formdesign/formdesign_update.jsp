<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>更新业务表单</title>
<style type="text/css">
.left-th{
	width: 18%;
}
.right-td{
	width: 32%;
	text-align: left;
}
.key{
	background-color:#e4e4e4;
}
.hidden {
    display: none;
}
</style>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/aco/upload/js/plupload.full.min.js"></script> 
	<script type="text/javascript" src="${ctx}/views/aco/upload/js/customized-upload.js"></script>
</head>
<body class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',height:'auto'" style="overflow: hidden">
	<%-- <form id="upload" action="${ctx}/formDesignController/uploadFreeForm" method="post" enctype="multipart/form-data"> --%>
		<form id="bpmReForm" class="window-form">
			<input type="hidden" id="id" name="id" value="${bpmReForm.id}" />
			<input type="hidden" id="state_" name="state_" value="${bpmReForm.state_}" />
			<input type="hidden" id="sameSeries_" name="sameSeries_" value="${bpmReForm.sameSeries_}" /> 
			<input type="hidden" id="version_" name="version_" value="${bpmReForm.version_}" /> 
			<input type="hidden" id="mainVersion_" name="mainVersion_" value="${bpmReForm.mainVersion_}" /> 
			<input type="hidden" id="createUserId_" name="createUserId_" value="${bpmReForm.createUserId_}" /> 
			<input type="hidden" id="createTime_" name="createTime_" value="${bpmReForm.createTime_}" />
			<input type="hidden" id="updateUserId_" name="updateUserId_" value="${bpmReForm.updateUserId_}" /> 
			<input type="hidden" id="updateTime_" name="updateTime_" value="${bpmReForm.updateTime_}" />
			<input type="hidden" id="ts_" name="ts_" value="${bpmReForm.ts_}" />
			<input type="hidden" id="dr_" name="dr_" value="${bpmReForm.dr_}" />
			<input type="hidden" id="remark_" name="remark_" value="${bpmReForm.remark_}" />
			<table border="1" style="width: 100%;" class="table-style">
				<tr style="height: 35px">
					<th class="Theader" colspan="4">业务表单信息
					</td>
				</tr>
				<tr style="height: 35px">
					<th class="left-th" style="width: 23%">业务应用类别<span class="input-must">*</span>：</th>
					<td class="right-td">
						<input id="formCtlgId_" name="formCtlgId_" value="${bpmReForm.formCtlgId_ }" style="width:100%" /></td>
					<th class="left-th">表单类型：</th>
					<td class="right-td">
						<input id="online" type="radio" name="formType_" value="2" />自由表单 
						<input id="self" type="radio" name="formType_" value="1" />超链接表单</td>
				</tr>
				<tr style="height: 35px">
					<th class="left-th">业务表单名称<span class="input-must">*</span>：</th>
					<td class="right-td"><input
						class="easyui-textbox" id="formName_" name="formName_"
						value="${bpmReForm.formName_}" data-options="required:true"
						missingMessage="不能为空" style="width:100%;"></td>
					<th class="left-th">标识Key<span class="input-must">*</span>：
					</th>
					<td class="right-td key"><input
						class="easyui-textbox" id="key_" name="key_"
						value="${bpmReForm.key_}" data-options="required:true"
						missingMessage="不能为空" readonly="readonly" style="width: 100%;" /></td>
				</tr>
				<tr id="tableName" style="height: 35px">
					<th class="left-th">数据库表：</th>
					<td class="right-td">
						<input class="easyui-textbox" id="tableName_" name="tableName_" value="${bpmReForm.tableName_ }" style="width: 98%;padding-left: 2px"" />
					</td>
					<th class="left-th">打印模板：</th>
					<td class="right-td">
						<input class="easyui-textbox" id="printTemplate_" name="printTemplate_"
						value="${bpmReForm.printTemplate_}" style="width: 95%" 
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
					<th class="left-th">自由表单<span class="input-must">*</span>：</th>
					<td colspan="2">
						<input id="freeFormId_" class="easyui-combotree" name="freeFormId_" value="${bpmReForm.freeFormId_}" 
							data-options="required:true" missingMessage="不能为空" style="width:300px;width:320px\0;"> 
						<a href="javascript:void(0)" onclick="desForm()" class="easyui-linkbutton" plain="true">表单设计</a>
					</td>
					<td>
						<!-- <input type="file" name="file" />
						<input type="button" id="btn_upload" value="上传打印模板" /> -->
						<div id="upload-container">
							<div id="pickFiles" class="easyui-linkbutton">选择文件</div>
							<div id="wenjianming"></div>
						</div>
					</td>
				</tr>
				<tr style="height: 35px">
					<th class="left-th">表单URL<span class="input-must">*</span>：</th>
					<td colspan="3" class="right-td">
						<input class="easyui-textbox" id="formUrl_" name="formUrl_" value="${bpmReForm.formUrl_}"
							data-options="required:true" missingMessage="不能为空" style="width:100%;padding-left: 2px" />
					</td>
				</tr>
				<tr style="height: 60px">
					<th class="left-th">描述：</th>
					<td colspan="3">
						<textarea id="desc_" name="desc_" style="width: 100%;border: 0px" rows="4" cols="">${bpmReForm.desc_}</textarea>
						<%-- <input class="easyui-textbox" style="width: 100%" data-options="multiline:true"
							id="desc_" name="desc_" value="${bpmReForm.desc_}"> --%></td>
				</tr>
			</table>
	  </form>
	</div>

	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<span><a href="javascript:void(0)" onclick="formSubmit('save')" class="easyui-linkbutton" plain="true">保存</a></span> 
			<span id="publish"><a href="javascript:void(0)" onclick="formSubmit('publish')" class="easyui-linkbutton" plain="true">发布</a></span> 
			<!-- <span id="saveNewEdtion"><a href="javascript:void(0)" onclick="saveNewEdtion('save')" class="easyui-linkbutton" plain="true">保存为新版</a></span>  -->
			<span id="publishNewEdtion"><a href="javascript:void(0)" onclick="saveNewEdtion('publish')" class="easyui-linkbutton" plain="true">发布为新版</a></span> 
			<span><a href="javascript:void(0)" onclick="closeDig()" class="easyui-linkbutton" plain="true">关闭</a></span>
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
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a class="easyui-linkbutton" data-options="plain:true" onclick="makesureTemp()">确定</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#tempDialog').dialog('close')" plain="true">取消</a>
	</div>
</body>
<script type="text/javascript">
	var formType = '${bpmReForm.formType_}';
	var state = '${bpmReForm.state_}';
	var divId = '${divId}';
</script>
<script type="text/javascript">
$(function() {
	init();
	$("#key_").next().find("input").addClass("key");
	$("input[name=formType_]").click(function() {
		var tr = document.getElementById("url");
		switch ($("input[name=formType_]:checked").attr("id")) {
		case "online":
			$("#freeFormId_").combotree({
				required: true
			});
			$("#form_id").show();
			$("#tableName").hide();
			break;
		case "self":
			$("#freeFormId_").combotree({
				required: false
			});
			$("#form_id").hide();
			$("#tableName").show();
			break;
		default:
			break;
		}
	});
	
	showFile();

	$("#formCtlgId_").combotree({
		url: "${ctx}/formDesignController/formCtlgTree",
		required: true,
		readonly : true,
		panelHeight: 150
	});
	
	$('a').on('click', function(e) {
	    e.preventDefault();
	    $(this).closest('input[type=file]').trigger('click');
	})

	$("#form_datasource").combotree({
		url: "${ctx}/formTableController/findAllFormTable",
		panelHeight: 150
	});
	
/* 	$("#btn_upload").click(function(){
		$('#form_datasource').form('disableValidation');  
		$('#upload').form('disableValidation')
		$("#upload").submit;
	}) */
	
	$("#btn_upload").click(function(){
		$("input[name="+file+"]").
		$("#upload").submit();
		
	})
	
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
	upload();
});

function init() {
	if (state == '0') {
		$('#publish').show();
		$('#saveNewEdtion').hide();
		$('#publishNewEdtion').hide();
	}
	if (state == '1') {
		$('#publish').hide();
		$('#saveNewEdtion').show();
		$('#publishNewEdtion').show();
	}
	if (formType == '1') {
		$("#self").attr("checked", "checked");
		$("#freeFormId_").combotree({
			required: false
		});
		$("#form_id").hide();
		$("#tableName").show();
	}
	if (formType == '2') {
		$("#online").attr("checked", "checked");
		$("#freeFormId_").combotree({
			required: true
		});
		$("#form_id").show();
		$("#tableName").hide();
	}
}
/*
 * 保存  / 发布
 * action 动作标识  save ：保存  ,publish ：发布
 */

function formSubmit(action) {
	if ($('#bpmReForm').form('validate')) {
		$.ajax({
			url: '${ctx}/formDesignController/doSaveBpmReForm?action=' + action,
			type: 'post',
			dataType: 'text',
			async: false,
			data: $('#bpmReForm').serialize(),
			success: function(data) {
				var msg = '';
				if (data == 'Y') {
					if (action == 'save') msg = '更新成功！';
					if (action == 'publish') msg = '发布成功！';
					window.parent.$.messager.show({
						title: '提示',
						msg: msg,
						timeout: 2000,
					});
					window.parent.closeDialog(divId);
					if (divId == 'dialog_') {
						window.parent.document.getElementById('iframe').contentWindow.reloadTableData();
					}
					window.parent.reloadTableData();
				} else {
					if (action == 'save') msg = '更新失败！';
					if (action == 'publish') msg = '发布失败！';
					window.parent.$.messager.show({
						title: '提示',
						msg: '更新失败',
						timeout: 2000,
					});
				}
			}
		});
	}
}
//发布为新版${ctx}
function upload(){
	var defaults={
			runtimes : 'flash,html4,html5',//指定上传方式
			browse_button:"pickFiles",//指定弹出上传文件框的按钮ID
			url:ctx+"/formDesignController/uploadFreeForm", //服务器页面地址，后面跟你想传递的参数
			prevent_duplicates:false,//是否允许上传相同文件 :用文件名和size匹配
			max_retries:0,//错误上传的重试次数
			//chunk_size: '50mb',
			multi_selection:true,//是否允许多选
			unique_names:true,//当值为true时会为每个上传的文件生成一个唯一的文件名，并作为额外的参数post到服务器端，参数明为name,值为生成的文件名。
			file_data_name:"file",//指定文件上传时文件域的名称
			container:"upload-container", //容器的地址
			multipart:true,
			multipart_params:{},//参数，可以传递到后台。使用request.getParameter()取值
			flash_swf_url : ctx+'/views/aco/upload/js/Moxie.swf',//flash上传组件的url地址，如果是相对路径，则相对的是调用Plupload的html文档。当使用flash上传方式会用到该参数。
			silverlight_xap_url : ctx+'/views/aco/upload/js/Moxie.xap',
			init: {
				PostInit: function() {
				},
				/**
				 *  上传到后台前触发
					监听函数参数：(uploader,file)
					uploader为当前的plupload实例对象，file为触发此事件的文件对象
				 * */
				BeforeUpload:function(uploader,file){
					uploader.settings.multipart_params.url=$("#formUrl_").val();
				},
				/**
				 *  当文件添加到上传队列后触发
					监听函数参数：(uploader,files)
					uploader为当前的plupload实例对象，files为一个数组，里面的元素为本次添加到上传队列里的文件对象
				 * */
				FilesAdded: function(uploader,files){
					uploader.start();
				},
				FileUploaded:function(uploader,file,responseObject){
				},
				/**
				 *  会在文件上传过程中不断触发，可以用此事件来显示上传进度
					监听函数参数：(uploader,file)
					uploader为当前的plupload实例对象，file为触发此事件的文件对象
				 * */
				UploadProgress:function(uploader,file){
				}, 
				UploadComplete:function(uploader,files){
					alert("已上传!");
					showFile();
				},
				error:function(uploader,errObject){
					alert(errObject.code+","+errObject.message);
					return false;
				}
				
			}	
		};
		var params;
		var params_ = $.extend({}, defaults, params);//合并上传参数
		var uploader = new plupload.Uploader(params_);//new plupload对象
		uploader.init();//初始化uploader对象
		return uploader;
}
function saveNewEdtion(action) {
	if ($('#bpmReForm').form('validate')) {
		if(action == 'save'){
			$("#state_").val("0");
		}
		$.ajax({
			url: '${ctx}/formDesignController/doSaveNewEditionBpmReForm',
			type: 'post',
			dataType: 'text',
			async: false,
			data: $('#bpmReForm').serialize(),
			success: function(data) {
				if (data == 'Y') {
					window.parent.$.messager.show({
						title: '提示',
						msg: '发布成功',
						timeout: 2000,
					});
					window.parent.closeDialog(divId);
					if (divId == 'dialog_') {
						window.parent.document.getElementById('iframe').contentWindow.reloadTableData();
					}
					window.parent.reloadTableData();
				} else {
					window.parent.$.messager.show({
						title: '提示',
						msg: '发布失败',
						timeout: 2000,
					});
				}
			}
		});
	}
}

function closeDig() {
	window.parent.closeDialog(divId);
}

function desForm() {
	var formid = $("#freeFormId_").combotree("getValue");
	if (formid == "") {
		alert("请选择表单!");
	} else {
		window.open("${ctx}/formModelDesginController/formdesginer?formid=" + formid);
	}
}

function showFile(){
	$.ajax({
		url: "${ctx}/jjbupload/loadByFileType",
		type: 'post',
		data: {
			refId : $("#formUrl_").val(),
			refType : "ftl"
		},
		success: function(data) {
			if(data.length > 0){
				$("#wenjianming").html(data[data.length-1].fileName);
			}
		}
	});
}
</script>
</html>