<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>任务节点配置</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
<script type="text/javascript" src="${ctx}/views/cap/bpm/bizsolmgr/task_node_cfg/js/usertask_node.js"></script>
</head>
<script type="text/javascript">
var exeUser_ = '${bpmReNodeCfg.exeUser_}';
var notice_ = '${bpmReNodeCfg.notice_}';
var tableName = '${tableName}';
var redPrint_ = '${bpmReNodeCfg.redPrint_}';
var hq = '${bpmReNodeCfg.isHqNode_}';
var tr = '${bpmReNodeCfg.isTrNode_}';
var symbol_ = '${bpmReNodeCfg.symbol_}';
var actId = '${actId}';
var procDefId = '${bpmReNodeCfg.procDefId_}';
var array = [];
if (notice_ != "") {
	array = notice_.split(",");
}
var checkedbox = document.getElementsByName("notice_");
$(function () {
	if (exeUser_ == '1') {
		document.getElementById("exeUser_").checked = true;
	};
	if (array.length > 0) {
		$(array).each(function (index) {
			checkedbox[array[index]].checked = true;
		})
	};
	$("#no").attr("checked", "checked");
	if (redPrint_ == '1') {
		$("#yes").attr("checked", "checked");
		/* $('#template').show(); */
	} else {
		$("#no").attr("checked", "checked");
		/* $('#template').hide(); */
	}
	/* 	$("input[name=redPrint_]").click(function(){
	switch($("input[name=redPrint_]:checked").attr("id")){
	case "no":
	$('#template').hide();
	break;
	case "yes":
	$('#template').show();
	break;
	default:
	break;
	}
	}); */

	initCommontColumn();
	if (hq == '1') {
		$('#entrust').hide();
		$("#no_tr").attr("checked", "checked");
	} else {
		$('#entrust').show();
	}
	$("input[name=isHqNode_]").click(function () {
		switch ($("input[name=isHqNode_]:checked").attr("id")) {
		case "is_hq":
			$('#entrust').hide();
			$("#no_tr").attr("checked", "checked");
			break;
		case "no_hq":
			$('#entrust').show();
			break;
		default:
			break;
		}
	});
	if (tr == '1') {
		$('#trustinfo').show();
		InitTableData();
	} else {
		$('#trustinfo').hide();
	}
	$("input[name=isTrNode_]").click(function () {
		switch ($("input[name=isTrNode_]:checked").attr("id")) {
		case "is_tr":
			$('#trustinfo').show();
			InitTableData();
			break;
		case "no_tr":
			$('#trustinfo').hide();
			break;
		default:
			break;
		}
	});

	/**
	 * 自由驳回复选框点击事件
	 */
	$("#backType_").click(function () {
		if (this.checked) {
			//被选中则其他 取消勾选并禁用
			$(this).siblings().attr({
				"checked": false,
				"disabled": true
			});
		} else {
			//未选中 则其他框接触禁用
			$(this).siblings().attr("disabled", false);
		}
	});
	
	backTypeData();
});

/**
 * 回显驳回选项数据
 */
function backTypeData() {
	var values = '${bpmReNodeCfg.backType_}';
	if (values!= null && values.length > 0) {
	    var valueArr = values.split(',');
	    $.each(valueArr, function(index, value){
	        $("input[name='backType_']").each(function () {
	            if($(this).val() == value) {
	                $(this).attr("checked",true);
	            }
	        });
	    });
	    if($("#backType_").attr('checked')) {
	    	$("#backType_").siblings().attr({
				"checked": false,
				"disabled": true
			});
	    }
	}
}

function selectFreeCommontColumn(data) {
	var columnName = "${bpmReNodeCfg.columnName_}";
	$(data).each(function () {
		if (this.col_code == columnName) {
			$("#columnName_").combobox("select", this.col_code);
			return false;
		}
	})
}

function selectCommontColumn(data) {
	var columnName = "${bpmReNodeCfg.columnName_}";
	$(data).each(function () {
		if (this.columnName == columnName) {
			$("#columnName_").combobox("select", this.columnName);
			return false;
		}
	})
}

function initCommontColumn() {
	var formType = "${formType}";
	if (formType != null && formType == "2") {
		//自由表单
		$('#columnName_').combobox({
			url: "${ctx}/bizSolMgr/findCommentColumnsByFreeFormId?freeFormId=${freeFormId}",
			valueField: 'col_code',
			textField: 'col_name',
			onLoadSuccess: selectFreeCommontColumn
		});
	} else {
		//超链接表单
		$('#columnName_').combobox({
			url: "${ctx}/bizSolMgr/findCommentColumnsByTableName?tableName=" + tableName,
			valueField: 'columnName',
			textField: 'columnComent',
			onLoadSuccess: selectCommontColumn
		});
	}

}

function formSubmit() {
	$.ajax({
		url: '${ctx}/bizSolMgr/doSaveBpmReNodeCfgEntity',
		type: 'post',
		dataType: 'text',
		data: $('#bpmReNodeCfgFm').serialize(),
		success: function (data) {
			if (data == 'Y') {
				window.parent.$.messager.show({
					title: '提示',
					msg: '保存成功',
					timeout: 2000,
				});
				closeDialog();
				window.parent.document.getElementById("nodeconfigure").contentWindow.reloadTableData();
			} else {
				window.parent.$.messager.show({
					title: '提示',
					msg: '保存失败',
					timeout: 2000,
				});
			}
		}
	});
}

/**
 * 关闭弹出的dialog
 */
function closeDialog() {
	window.parent.closeDialog('dialog');
}

//模板选定
function makesureTemp() {
	var name = document.getElementById("tempDialogIframe").contentWindow.makesureTemp();
	$("#tempDialog").dialog('close');
	$("#redPrintTemplate_").textbox('setValue', name);
}

</script>
<body class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',heigh:'auto'">
		<div id="detialTab" class="easyui-tabs" data-options="fit:true"> 
	    	<div title="基本配置" style="display:none;overflow:auto">
	   			<form id="bpmReNodeCfgFm" class="window-form">
					<input type="hidden" id="id" name="id" value="${bpmReNodeCfg.id}">
					<input type="hidden" id="nodeInfoId_" name="nodeInfoId_" value="${bpmReNodeCfg.nodeInfoId_}">
					<input type="hidden" id="procDefId_" name="procDefId_" value="${bpmReNodeCfg.procDefId_}">
					<input type="hidden" id="solId_" name="solId_" value="${bpmReNodeCfg.solId_}">
					<input type="hidden" id="freeSelect_" name="freeSelect_" value="${bpmReNodeCfg.freeSelect_}">
					<input type="hidden" id="attachment_" name="attachment_" value="${bpmReNodeCfg.attachment_}">
					<input type="hidden" id="mainBody_" name="mainBody_" value="${bpmReNodeCfg.mainBody_}">
					<table border= "1" style="width: 100%"  class="table-style">
						<tr style="height: 35px">
							<th style="width:20%;text-align: right;">自定义审批按钮：</th>
							<td style="width:30%;text-align: left;">
							</td>
							<th style="width:20%;text-align: right;">允许选择执行路径：</th>
							<td style="width:30%;text-align: left;">
							</td>
						</tr>
						<tr style="height: 35px">
							<th style="width:20%;text-align: right;">前置处理器：</th>
							<td style="width:30%;text-align: left;">
							</td>
							<th style="width:20%;text-align: right;">后置处理器：</th>
							<td style="width:30%;text-align: left;">
							</td>
						</tr>
						<tr style="height: 35px">
							<th style="width:20%;text-align: right;">绑定意见字段：</th>
							<td style="width:30%;text-align: left;">
								<input id="columnName_" name="columnName_" value="">
							</td>
							<th style="width:20%;text-align: right;">文号配置：</th>
							<td style="width:30%;text-align: left;">
								<input id="symbol_" name="symbol_" type="hidden"  value="${bpmReNodeCfg.symbol_}" />
								<input id="symbolname_" name="symbolname_" style="width:150px;" value="${bpmReNodeCfg.symbolname_}" />&nbsp;<input id="xzwh" type="button" name="xzwh" value="选择文号" />
							</td>
						</tr>
						<tr style="height: 35px">
							<th style="width:20%;text-align: right;">节点是否会签：</th>
							<td style="width:30%;text-align: left;">
								<input type="radio" id="is_hq" name="isHqNode_" value="1" <c:if test="${bpmReNodeCfg.isHqNode_=='1'}">checked="checked"</c:if>>是
								<input type="radio" id="no_hq" name="isHqNode_" value="0" <c:if test="${bpmReNodeCfg.isHqNode_!= '1'}">checked="checked"</c:if>>否
							</td>
							<th style="width:20%;text-align: right;">允许套红：</th>
							<td style="width:30%;text-align: left;">
								<input type="radio" id="yes" name="redPrint_" value="1">是
								<input type="radio" id="no" name="redPrint_" value="0"/>否
							</td>
						</tr>
		<%-- 				<tr id="template" style="height: 35px">
							<th style="width:20%;text-align: right;">套红模板：</th>
							<td colspan="3">
								<!-- 弹出模板选择界面 -->
								<input class="easyui-textbox" style="width:100%;height: 55px" id="redPrintTemplate_" name="redPrintTemplate_" value="${bpmReNodeCfg.redPrintTemplate_}"
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
										$('#tempDialogIframe').attr('src','${ctx}/bizSolMgr/tofindRedTempList');
			                        }
			                    }]
			                    "></td>
						</tr> --%>
						<tr style="height: 35px">
							<th style="width:20%;text-align: right;">下一步通知配置：</th>
							<td colspan="3">
								<input type="checkbox" name="notice_" value="0">短信</input>
								<input type="checkbox" name="notice_" value="1">邮件</input>
								<input type="checkbox" name="notice_" value="2">微信</input>
								<input type="checkbox" name="notice_" value="3">内部消息</input>
							</td>
						</tr>
						<tr style="height: 35px">
							<th style="width:20%;text-align: right;">驳回选项：</th>
							<td colspan="3">
								<input type="checkbox" name="backType_" value="0">驳回拟稿节点</input>
								<input type="checkbox" name="backType_" value="1">驳回上一节点</input><span style="margin: 0px 15px;">|</span> 
								<input type="checkbox" id="backType_" name="backType_" value="2">自由驳回</input>
							</td>
						</tr>
						<tr style="height: 35px">
							<th style="width:20%;text-align: right;">允许选择执行人：</th>
							<td colspan="3">
								<input type="checkbox" id="exeUser_" name="exeUser_" value="1"></input>
							</td>
						</tr>
						<tr id="entrust">
						<th style="width:20%;text-align: right;">节点是否委托：</th>
							<td colspan="3" style="width:30%;text-align: left;">
							    <input type="radio"  id="is_tr" name="isTrNode_" value="1" <c:if test="${bpmReNodeCfg.isTrNode_=='1'}">checked="checked"</c:if>>是
								<input type="radio"  id="no_tr" name="isTrNode_" value="0" <c:if test="${bpmReNodeCfg.isTrNode_!= '1'}">checked="checked"</c:if>>否			
							</td>
						</tr>
					</table>
				</form>
				<div id="trustinfo" data-options="region:'center',title:'委托配置'">
				<hr>
				<div id="toolbar" style="padding: 5px; height: auto">
					<a href="javascript:void(0)" onclick="add()"
						class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</div>
				<!-- 委托信息列表 -->
				<table class="easyui-datagrid" id="bizTrustInfoList"
				data-options="idField:'id',toolbar:'#toolbar',striped:true,fitColumns:true,rownumbers:true,showFooter:true,nowrap:false">
					<thead frozen="true">
						<tr>
							<th data-options="field :'act_id',hidden:true"></th>
							<th data-options="field:'id',width:100,formatter: formatterOpert">操作</th>
						</tr>
					</thead>
					<thead>
						<tr>
							<th data-options="field:'trust_user_name',width:150,align:'center'">委托人</th>
							<th data-options="field:'trust_user_id',hidden:true">委托人id</th>
							<th data-options="field:'user_name',width:150,align:'center'">被委托人</th>
							<th data-options="field:'user_id',hidden:true">被委托人id</th>
							<th data-options="field:'start_time_',width:200,align:'center',formatter: formatterTime">委托开始日期</th>
							<th data-options="field:'end_time_',width:200,align:'center',formatter: formatterTime">委托结束日期</th>
							<th data-options="field:'comment_',hidden:true">委托意见</th>
							<th data-options="field:'remark_',hidden:true">备注</th>
						</tr>
					</thead>
				</table>
				</div>
					<!-- 委托配置新增编辑窗口 -->
				<div id="trustInfoDlg" style="overflow:hidden;" closed="true" data-options="maximizable:true,resizable:false,modal:true">
					<iframe scrolling="no" id="trustFrame" frameborder="0" border="0" marginwidth="0"
							marginheight="0" style="width:100%;height:100%;"></iframe>
				<!-- 	<div id="chooseper_tb" style="text-align: center;">
						<a class="easyui-linkbutton" data-options="plain:true" onclick="btnOk()">确定</a>
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#chooseper').dialog('close')" plain="true">取消</a>
					</div>	 -->			
				</div>
	   		</div>	   		
		    <!-- <div title="会签配置" style="display:none;overflow:auto">
		    	<iframe scrolling="no" id="" src="bizSolMgr/toTaskNodeHqCfg" frameborder="0" width="100%" height="800px"></iframe>
		    </div> -->
		</div>
	</div>
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<span>
				<a href="javascript:void(0)" onclick="formSubmit()"
						class="easyui-linkbutton" plain="true">保存</a>
			</span>
			<span>
				<a href="javascript:void(0)" onclick="closeDialog()"
						class="easyui-linkbutton" plain="true">关闭</a>
			</span>
		</div>
	</div>
	<div id="dialogl" style="overflow:hidden;" data-options="closed:true,resizable:false,modal:true">
		<iframe scrolling="no" id="iframel" frameborder="0" width="100%" height="100%"></iframe>
	</div>
 <!-- 套红模板 -->
	<!-- <div id="tempDialog" class="easyui-dialog" closed="true" buttons="#dlg-buttons" title="套红模板" style="width:80%;height:200px;max-width:800px;padding:10px" data-options="
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
	</div>  -->
</body>
<script type="text/javascript">
	$(document).ready(function(){
		//选择文号
		$("#xzwh").click(function(){
			var url = '${ctx}/docNumMgrController/docListl';
			var iWidth=850;                          //弹出窗口的宽度; 
           	var iHeight=450;                         //弹出窗口的高度; 
           	//获得窗口的垂直位置 
           	var iTop = (window.screen.availHeight - 30 - iHeight) / 2; 
           	//获得窗口的水平位置 
           	var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; 
           	window.open(url, '文号选择', 'height=' + iHeight + ',,innerHeight=' + iHeight + ',width=' + iWidth + ',innerWidth=' + iWidth + ',top=' + iTop + ',left=' + iLeft + ',status=no,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=0,titlebar=no'); 
		});
	});
</script>
</html>