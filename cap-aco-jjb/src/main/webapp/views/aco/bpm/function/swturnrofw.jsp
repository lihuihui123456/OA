<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>收文转发文</title>
<%@ include file="/views/aco/common/head.jsp"%>
<style>
.control-label {
	text-align: left !important;
	padding-top: 5px;
}
.form-control{
	padding:0;
}
</style>
<script type="text/javascript">
	
	$(function(){
		addOption(initDict('10011001'));
	})
	/** 查询发文类型 **/
	function initDict(bizCode) {
		var temp;
		$.ajax({
			url : "bpmRunController/getFwType",
			type : "post",
			async : false,
			dataType : "json",
			data : {
				"bizCode" : bizCode
			},
			success : function(data) {
				temp = data;
			}
		});
		return temp;
	}

	function addOption(obj) {
		var value;
		var text;
		$(obj).each(function(index) {
			document.getElementById("solId").options.add(
				new Option(this.formName, this.solId)
			);
		})
	}
	
	function selectFwType(){
		var returnData = null;
		$.ajax({
			url : "bpmRunController/doSwTurnToFw",
			type : "post",
			dataType : "json",
			data : $("#myFm").serialize(),
			async : false,
			success : function(data){
				returnData = data;
			}
		});
		return returnData;
	}
	
</script>
</head>
<body>
	<form id="myFm">
		<input type="hidden" name="bizId" value="${bizId}" />
		<div class="form-group">
			<label for="recipient-name" class="control-label col-xs-4">&nbsp;&nbsp;发文类型：</label>
			<div class=" col-xs-8">
				<select class="selectpicker select input-sm" id="solId" name="solId" style="width: 100%;padding: 5px;">
				</select>
			</div>
		</div>
	</form>
</body>
</html>