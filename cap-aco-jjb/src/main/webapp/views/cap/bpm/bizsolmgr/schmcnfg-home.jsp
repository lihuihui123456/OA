<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>模型配置首页</title>
<link rel="stylesheet" href="${ctx}/views/cap/bpm/bizsolmgr/css/ystep.css">
<!-- 引入jquery -->
<script src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<!-- 引入ystep插件 -->
<script src="${ctx}/views/cap/bpm/bizsolmgr/js/ystep.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
<style type="text/css">
#ystep{width:100%;height:100px;margin: 35px 0px 0px 25px;padding-bottom: 5px;overflow: hidden;}
.iframe_div{padding-bottom:10px;overflow: hidden;display:none;}
</style>
</head>
<body>
<div class="easyui-layout" data-options="fit:true" >
	<div region="north" split="false" title="模型配置" style="width:100%;height: 135px;overflow: hidden;">
		<div id="ystep" class="ystep"></div>
	</div>
	<!-- 业务是否存在流程的标志 -->
	<input id="isProcess_" name="isProcess_" type="hidden" value="${isProcess_}" />
	<div id="content" region="center" style="width:100%;">
		<div id="tab" class="easyui-tabs" data-options="fit:true" style="margin: 0px;padding: 0px;">   
		    <div class="iframe_div" title="模型概述">   
				 <iframe id="fags" src="${ctx}/bizSolMgr/toSolSummary?id=${solInfoId }"  width="100%" height="100%" frameborder="no" border="0" marginwidth="0"
							marginheight="0" scrolling="yes" style=""></iframe>
		    </div>
		    <c:if test="${isProcess_=='1'}">
			    <div class="iframe_div" title="流程定义">   
			          <iframe id="procdef" src=""  width="100%" height="100%" frameborder="no" border="0" marginwidth="0"
								marginheight="0" scrolling="yes" style=""></iframe>
			    </div>   
		    </c:if>
		    <div class="iframe_div" title="业务表单">   
				 <iframe id="apprform" src=""  width="100%" height="100%" frameborder="no" border="0" marginwidth="0"
							marginheight="0" scrolling="yes" style=""></iframe>
		    </div>
		    <c:if test="${isProcess_=='1'}">
			    <div class="iframe_div" title="变量配置">   
			        <iframe id="varcnfg" src="" class="iframe" width="100%" height="100%" frameborder="no" border="0" marginwidth="0"
								marginheight="0" scrolling="yes" style=""></iframe>
			    </div>
			    <div class="iframe_div" title="审批人员">   
			        <iframe id="assessofc" class="iframe" src=""  width="100%" height="100%" frameborder="no" border="0" marginwidth="0"
								marginheight="0" scrolling="yes" style=""></iframe>
			    </div>
			    <div class="iframe_div" title="节点配置">   
			         <iframe id="nodeconfigure" src=""  width="100%" height="100%" frameborder="no" border="0" marginwidth="0"
								marginheight="0" scrolling="yes" style=""></iframe>
			    </div>
			</c:if>
	<!-- 	    <div title="测试" style="padding:20px;display:none;" >   
		       
		    </div>
		    <div title="授权" style="padding:20px;display:none;" >   
		       
		    </div> -->
		</div>
	</div>
</div>
<!-- 流程定义新增编辑窗口 -->
<div id="dialog" style="overflow:hidden;" data-options="closed:true,resizable:false,modal:true">
	<iframe scrolling="no" id="iframe" frameborder="0" width="100%" height="100%"></iframe>
</div>
<div id="dialog_formrule" class="easyui-dialog" style="overflow:hidden;" data-options="closed:true,resizable:false,modal:true">
	<iframe  id="iframe_formrule" style="overflow: auto;width:98%;height:98%;" frameborder="0" ></iframe>
</div>
<!-- 流程定义新增编辑窗口 -->
<div id="dialog_" style="overflow:hidden;" data-options="closed:true,resizable:false,modal:true">
	<iframe scrolling="no" id="iframe_" frameborder="0" width="100%" height="100%"></iframe>
</div>

<!-- 弹出选人界面 -->
<!-- 流程定义新增编辑窗口 -->
<div id="chooseper" style="overflow:hidden;" data-options="buttons:'#chooseper_tb',closed:true,resizable:false,modal:true">
	<iframe scrolling="no" id="choose_user" frameborder="0" width="100%" height="100%"></iframe>
	<div id="chooseper_tb" style="text-align: center;">
		<a class="easyui-linkbutton" data-options="plain:true" onclick="makesure()">确定</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#chooseper').dialog('close')" plain="true">取消</a>
	</div>
</div>
</body>
<script type="text/javascript">
var procdefId = "${procdefId}";
var solId = "${solInfoId}";
var isProcess_ = "${isProcess_}";
$(function() {
	if (isProcess_ == "0") {
		$('#tab').tabs('disableTab', 2);
		$('#tab').tabs('disableTab', 3);
		$('#tab').tabs('disableTab', 4);
		$('#tab').tabs('disableTab', 5);
	}
	/** tab标签点击触发事件 **/
	$('#tab').tabs({
		border: false,
		onSelect: function(title, index) {
			if(isProcess_=='1') {
				
			}
			$(".ystep").setStep(index + 1);
			if(index == 0){
				if ($("#fags").attr("src") == "") {
					$("#fags").attr("src", "${ctx}/bizSolMgr/toSolSummary?id="+solId);
				}
			}else if (index == 1) {
				if ($("#procdef").attr("src") == "") {
					/*旧版流程定义信息*/
					//$("#procdef").attr("src", "${ctx}/bizSolMgr/toProcdefInfo?solId="+solId);
					/*新版流程定义信息*/
					$("#procdef").attr("src", "${ctx}/bizSolMgr/toProcDefInfoPage?solId="+solId);
				}
			} else if (index == 2) {
				if ($("#apprform").attr("src") == "") {
					$("#apprform").attr("src", "${ctx}/bizSolMgr/toApprForm?solId="+solId+"&isProcess_="+isProcess_);
				}
			} else if (index == 3) {
				if ($("#varcnfg").attr("src") == "") {
					$("#varcnfg").attr("src", "${ctx}/bizSolMgr/varcnfg?solId="+solId);
				}
			} else if (index == 4) {
				if ($("#assessofc").attr("src") == "") {
					/*原来的人员配置*/
					//$("#assessofc").attr("src","${ctx}/bizSolMgr/approveuser?solId=${solInfoId}");
					/*现在的人员配置*/
					$("#assessofc").attr("src", "${ctx}/bizSolMgr/toApproveUser?solId="+solId+"&procDefId="+procdefId);
				}
			} else if (index == 5) {
				if ($("#nodeconfigure").attr("src") == "") {
					$("#nodeconfigure").attr("src", "${ctx}/bizSolMgr/toNodeConfigure?solId="+solId+"&procdefId=" + procdefId);
				}
			}
		}
	});
});

if(isProcess_=='1') {
	$(".ystep").loadStep({
		size: "large",
		color: "blue",
		steps: [{
			title: "初始化",
			content: "初始化流程解决模型"
		}, {
			title: "流程定义",
			content: "进行流程定义的设计,并且进行发布"
		}, {
			title: "业务表单",
			content: "绑定或设计和流程相关的业务展示表单模型"
		}, {
			title: "变量配置",
			content: "设置流程各环节的流程需要使用的变量"
		}, {
			title: "审批人员",
			content: "绑定流程节点的执行人员"
		}, {
			title: "节点配置",
			content: "设置节点配置参数及绑定流程数据交互配置"
		}/* , {
			title: "测试",
			content: "流程模拟测试"
		}, {
			title: "授权",
			content: "流程授权配置"
		} */]
	});
}else if(isProcess_=='0') {
	$(".ystep").loadStep({
		size: "large",
		color: "blue",
		steps: [{
			title: "初始化",
			content: "初始化流程解决模型"
		}, {
			title: "业务表单",
			content: "绑定或设计和流程相关的业务展示表单模型"
		}]
	});
}


/**
 * 关闭弹出的dialog
 */

function closeDialog(divId) {
	$('#' + divId + '').dialog('close');
}

function reload(){
	window.location.reload();
}

function updateProcDefId(procDefId){
	if(procDefId != null && procDefId != ""){
		procdefId = procDefId;
		$("#procdef")[0].contentWindow.location.reload();
		removeUrl('procDefId');
	}
}

function removeUrl(state){
	if(state == "procDefId"){
		$('#tab').tabs('enableTab', 2);
		$('#tab').tabs('enableTab', 3);
		$('#tab').tabs('enableTab', 4);
		$('#tab').tabs('enableTab', 5);
		$("#apprform").attr("src", "");
	}
	$("#varcnfg").attr("src", "");
	$("#assessofc").attr("src", "");
	$("#nodeconfigure").attr("src", "");
}

function makesure() {
	var arr = $("#choose_user")[0].contentWindow.doSaveMessage();
	$(".iframe")[1].contentWindow.makesure(arr);
}

$("#apprform").attr("src", "${ctx}/bizSolMgr/toApprForm?solId="+solId+"&isProcess_="+isProcess_);
</script>
</html>