<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>送交选项</title>
<%@ include file="/views/aco/common/head.jsp"%>
<!-- bootstrop 样式 -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<script type="text/javascript">
	
	var bizId = "${bizId}";        //业务id
	var solId = "${solId}";        //业务解决方案Id
	var procdefId = "${procdefId}";//流程定义Id
	
	/**选人界面请求连接*/
	var chooseUserUrl = "";
	
	$(function() {
		//必填项验证
		$('#userName').bind('input propertychange', function() {  
			$('#userName').focus(); 
		});
		
		checkFirstNode();
		//环节节点被选中或被修改是触发的事件
		$("input[name=nodeId]").change(function() {
			$('#userId').val('');
			$('#userName').val('');
			node = $("input[name=nodeId]:checked");
			$('#actType').val(node.attr('id'));
			if (node.attr('id') == "endEvent") { // 目标节点类型为结束节点（隐藏人员选择）
				$('#blry').css('display', 'none');
				$('#userId').attr({"disabled" : "disabled"});
			} else { // 目标节点类型不是结束节点（获取目标节点配置）
				
				getNodeCfg(node.val());
			}
		});
		
		//开启表单验证引擎(修改部分参数默认属性)
		$("#myForm").validationEngine({
			promptPosition:'topRight', //提示框的位置 
			autoHidePrompt:true, //是否自动隐藏提示信息 默认为false
			autoHideDelay:100000, //自动隐藏提示信息的延迟时间 (ms)
			maxErrorsPerField:false,//单个元素显示错误提示的最大数量，值设为数值。默认 false 表示不限制。
			showOneMessage:false, //是否只显示一个提示信息
		});
	});
	
	/**获取目标任务节点配置*/
	function getNodeCfg(nodeId){
		var isExeUser = "0";  //目标节点是否允许选执行人
		var isHqNode = "0";   //目标节点是否会签节点
		if(nodeId){
			$.ajax({
				url : "bizSolMgr/findTaskNodeCfg",
				type : "post",
				dataType : "json",
				async : false,
				data : {
					"solId" : solId,
					"procdefId" : procdefId,
					"actId" : nodeId,
					"bizId": bizId
				},
				success : function(data) {
					if(data){
						isExeUser = data.exeUser_;
						isHqNode = data.isHqNode_;
						if(data.userId!=""&&data.userId!=null){
							$("#userId").val(data.userId);
							$("#userName").val(data.userName);
						}
					}else{
						isExeUser = "0";
						isHqNode = "0";
					}
					changeUser(isExeUser, isHqNode, nodeId);
				}
			})
		}
	}
	
	/** 控制选择人员是否显示*/
	function changeUser(isExeUser, isHqNode, nodeId){
		if(isExeUser == "1"){
			if(isHqNode == "1"){
				chooseUserUrl = "bizSolMgr/zTreeBackVar?state=1&&solId=${solId}&&procdefId=${procdefId}&&actId="+nodeId;
			}else{
				chooseUserUrl = "bizSolMgr/zTreeBackVar?state=0&&solId=${solId}&&procdefId=${procdefId}&&actId="+nodeId;
			}
			$('#blry').css('display', 'block');
			$('#userId').removeAttr("disabled");
		}else{
			chooseUserUrl = "";
			$('#blry').css('display', 'none');
			$('#userId').attr({"disabled" : "disabled"});
		}
	}
	
	/**默认下一送交节点选择第一个节点*/
	function checkFirstNode() {
		//默认选中第一个环节节点
		$("input[name=nodeId]:eq(0)").attr("checked", 'checked');
		node = $("input[name=nodeId]:checked");
		$('#actType').val(node.attr('id'));
		if (node.attr('id') == "endEvent") { // 目标节点类型为结束节点（隐藏人员选择）
			$('#blry').css('display', 'none');
			$('#userId').attr({"disabled" : "disabled"});
		} else { // 目标节点类型不是结束节点（获取目标节点配置）
			getNodeCfg(node.val());
		}
	}
	
	/**打开父页面选人窗口*/
	function choseUser() {
		window.parent.choseUser(chooseUserUrl);
	}
	
	/**页面初始化后为页面赋值*/
	function setValue() {
		window.parent.setValue();
	}
	
	/**为标题赋值*/
	function setTitle(title) {
		$('#title').val(title);
	}
	
	/**为意见隐藏域赋值*/
	function setComment(comment) {
		$('#comment').val(comment);
	}
	
	/**为手写签批意见隐藏域赋值*/
	function setSignature(signature) {
		$("#signature").val(signature);
	}
	
	
	
	function validateForm(){
		return $("#myForm").validationEngine('validate');
	}
	
	/**启动流程*/
	function startProcess() {
		var flag = "0";
		$.ajax({
			//url : 'bpm/doBtnSubmit',
			url : 'bpm/startBpmProcess',
			type : 'post',
			dataType : 'text',
			async : false,
			data : $('#myForm').serialize(),
			success : function(data) {
				flag = data;
			}
		});
		return flag;
	}
	function chehui() {
		return "N";
	}

</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="panel-body" style="padding-bottom: 0px; border: 0; background:#fff;overflow:hidden;" onload="setValue()">
	<form id="myForm" class="form-horizontal">
		<input type="hidden" id="bizId" name="bizId" value="${bizId}"> 
		<input type="hidden" name="procdefId" value="${procdefId}"> 
		<input type="hidden" id="isFreeSelect" name="isFreeSelect" value="${isFreeSelect}"> 
		<input type="hidden" id="comment" name="comment" value=""> 
		<input type="hidden" id="signature" name="signature" value=""> 
		<input type="hidden" id="fieldName" name="fieldName" value="${fieldName}"> 
		<input type="hidden" name="taskId" value="${taskId}"> 
		<c:if test="${list != null}">
			<div class="form-group">
				<label for="recipient-name" class=" col-xs-2">办理环节：</label>
				<div class="col-xs-10">
					<c:forEach items="${list}" var="node" varStatus="index"
						begin="0">
						<input type="radio" id="${node.actType}" 
							name="nodeId" value="${node.actId}" /><span>${node.actName}</span>
					</c:forEach>
				</div>
			</div>
		</c:if>
		<div class="form-group" id="blry" style="display: block">
			<label for="recipient-name" class="control-label col-xs-2">办理人员：</label>
			<div class=" col-xs-10">
				<input type="hidden" id="userId" name="userId" value="" disabled="disabled"/> 
				<input type="text" id="userName" class="validate[required] form-control" style="width: 300px" onclick="choseUser()"/>
			</div>
		</div>
		<div class="form-group">
			<label for="recipient-name" class="control-label col-xs-2">任务标题：</label>
			<div class=" col-xs-10">
				<input type="text" style="width: 300px"
					class="form-control col-xs-10" id="title" name="title" value=""
					readonly="readonly">
			</div>
		</div>
	</form>
</body>
</html>