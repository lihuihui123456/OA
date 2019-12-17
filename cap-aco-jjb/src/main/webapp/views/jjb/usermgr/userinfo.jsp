<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html lang="zh-CN">
<head>
<title>基金办人员管理</title>
<%@ include file="/views/aco/common/head.jsp"%>
<!-- 引入bootstrap-table-css -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<!-- end -->
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/jquery/jquery-1.9.1.js"></script>
<script src="${ctx}/views/jjb/usermgr/js/userlist.js"></script>
<script src="${ctx}/views/jjb/usermgr/js/deptpost.js"></script>
<!-- 引入jQuery-Validation-Engine js -->
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/js/jquery.validationEngine.min.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/jquery/jQuery-Validation-Engine-2.6.2/js/jquery.validationEngine-zh_CN.js"></script>
<!-- end -->
<!-- 引入bootstrap-table-js -->
<script src="${ctx}/static/cap/plugins/bootstrap/js/bootstrap.min.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- end -->
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<link rel="stylesheet"
	href="${ctx}/static/cap/plugins/plupload/queue/css/jquery.plupload.queue.css"
	type="text/css"></link>
<%@ include file="/views/cap/common/theme.jsp"%>
<style>
.control-label {
	text-align: left !important;
}

.treeDiv {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	margin-top: 20px;
	display: none;
	position: absolute;
	margin-top: -160px;
	background-image: url('${ctx}/views/aco/dispatch/img/treeImg.png');
	background-color: black;
}
select.form-control{
	padding:0;
}
</style>
<script type="text/javascript">
	function makerUpload(chunk, flag) {
		picurl = '${ctx}/userManager/uploadImg';
		var resultStr = window
				.showModalDialog("${ctx}/userManager/openUploadWindow?chunk="
						+ chunk + "&url=" + picurl, window,
						"dialogWidth:500px; dialogHeight: 310px; help: no; scroll: no; status: no");
		$('#picUrl').val(resultStr);
		refreshPicture(resultStr);
	}
	function refreshPicture(fileName) {
		$("#picImg").attr('src', '${ctx}/uploader/uploadfile?pic=' + fileName);
	}
</script>
</head>
<body>
<div style="width: 100%">
<form id="ff" action="" method="post" enctype="multipart/form-data"
		class="form-horizontal" target="_top">
		<%-- <div class="text-center" style="margin-top:0px;margin-right:670px;margin-bottom:15px;">
        	<img style="border-radius:10px;max-height:120px" id="picImg" onclick="makerUpload(false)" src="uploader/uploadfile?pic=${userInfo.picUrl }">
        </div> --%>
		<input type="hidden" id="userId" name="userId" value="${userInfo.userId }"> <input
			type="hidden" id="ts" name="ts"> <input type="hidden"
			id="userCertType" name="userCertType" value="${userInfo.userCertType }"> <input type="hidden"
			id="userCreateTime" name="userCreateTime" value="${userInfo.userCreateTime }"> <input
			type="hidden" id="userAge" name="userAge" value="${userInfo.userAge }"> <input
			type="hidden" id="userSource" name="userSource" value="${userInfo.userSource }"> <input
			type="hidden" id="picUrl" name="picUrl" value="${userInfo.picUrl }">
		<div >
			<div id="userNameForm" class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userName">&nbsp;&nbsp;&nbsp;&nbsp;人员名称
					<span style="color:red">*</span>
				</label>
				<div class="col-sm-8">
					<input type="text" id="userName" name="userName" value="${userInfo.userName }"
						class="validate[required,custom[notSpecial]] form-control view input-sm"
						placeholder="" maxlength=64>
				</div>
			</div>
			<div class="form-group col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userSex">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;性别</label>
				<div class="col-sm-8">
					<select id="userSex" name="userSex" class="selectPiker select view input-sm" style="width: 100%;padding: 5px;">
						<option value=""></option>
						<option value="2">未知</option>
						<option value="1">男</option>
						<option value="0">女</option>
					</select>
				</div>
			</div>
		</div>
		<div >
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userHeight">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身高</label>
				<div class="col-sm-8">
					<input type="text" id="userHeight" name="userHeight" value="${userInfo.userHeight }"
						class="validate[custom[notSpecial]] form-control input-sm" placeholder=""
						maxlength=32>
				</div>
			</div>
			<div class="form-group col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="maritalStatus">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;婚姻状况</label>
				<div class="col-sm-8">
					<select id="maritalStatus" name="maritalStatus"
						class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
						<option value=""></option>
						<option value="未婚">未婚</option>
						<option value="已婚">已婚</option>
					</select>
				</div>
			</div>
		</div>
		<div >
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userNativePlace">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;籍贯</label>
				<div class="col-sm-8">
					<input type="text" id="userNativePlace" name="userNativePlace" value="${userInfo.userNativePlace }"
						class="validate[custom[notSpecial]] form-control input-sm" placeholder=""
						maxlength=256>
				</div>
			</div>
			
		</div>
		<div >
			
			<div class="form-group col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userPoliceType">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;政治面貌</label>
				<div class="col-sm-8">
					<select id="userPoliceType" name="userPoliceType"
						class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
						<option value=""></option>
						<option value="中共党员">中共党员</option>
						<option value="中共预备党员">中共预备党员</option>
						<option value="共青团员">共青团员</option>
						<option value="无党派民主人士">无党派民主人士</option>
						<option value="群众">群众</option>
					</select>
				</div>
			</div>
		</div>
		<div >
			<div class="form-group col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userNation">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;民族</label>
				<div class="col-sm-8">
					<select id="userNation" name="userNation" class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
						<option value=""></option>
						<option value="汉族">汉族</option>
						<option value="满族">满族</option>
						<option value="达斡尔族">达斡尔族</option>
						<option value="壮族">壮族</option>					
						<option value="回族">回族</option>
						<option value="苗族">苗族</option>
						<option value="维吾尔族">维吾尔族</option>
						<option value="蒙古族">蒙古族</option>
						<option value="藏族">藏族</option>
						<option value="其他少数民族">其他少数民族</option>
					</select>
				</div>
			</div>
		</div>
		<div >
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userCertCode">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;身份证号</label>
				<div class="col-sm-8">
					<input type="text" id="userCertCode" name="userCertCode" value="${userInfo.userCertCode }"
						class="validate[custom[chinaId]] form-control input-sm" placeholder=""
						maxlength=18>
				</div>
			</div>
			<div class="form-group col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userBitrth">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;出生日期</label>
				<div class="col-sm-8">
					<input type="text" id="userBitrth" name="userBitrth" value="${userInfo.userBitrthStr }"
						class="form-control select input-sm" value="" maxlength=10
						onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"
						placeholder="">
				</div>
			</div>
		</div>
		<div >
			<div class="form-group col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userEducation">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;学历
				</label>
				<div class="col-sm-8">
					<select id="userEducation" name="userEducation"
						 class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
						 <option value=""></option>
						<option value="本科">本科</option>
						<option value="硕士研究生">硕士研究生</option>
						<option value="博士研究生">博士研究生</option>
						<option value="高中">高中</option>
						<option value="专科">专科</option>
						<option value="其它">其它</option>
					</select>
				</div>
			</div>
			<div class="form-group  col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userDegree">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;学位</label>
				<div class="col-sm-8">
					<select id="userDegree" name="userDegree" class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
						<option value=""></option>
						<option value="学士">学士</option>
						<option value="硕士">硕士</option>
						<option value="博士">博士</option>
						<option value="副学士">副学士</option>
						<option value="其它">其它</option>
					</select>
				</div>
			</div>
		</div>
		<div >
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="joinTime">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;入党时间</label>
				<div class="col-sm-8">
					<input type="text" id="joinTime" name="joinTime" value="${userInfo.joinTime }"
						class="form-control select input-sm" value="" maxlength=10
						onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"
						placeholder="">
				</div>
			</div>
		</div>
		<div >
			<div class="form-group col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="entryTime">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调入时间</label>
				<div class="col-sm-8">
					<input type="text" id="entryTime" name="entryTime" value="${userInfo.entryTime }"
						class="form-control select input-sm" value="" maxlength=10
						onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"
						placeholder="">
				</div>
			</div>
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="workTime">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;参加工作时间</label>
				<div class="col-sm-8">
					<input type="text" id="workTime" name="workTime" value="${userInfo.workTime }"
						class="form-control select input-sm" value="" maxlength=10
						onclick="laydate({istime: true, format: 'YYYY-MM-DD'})"
						placeholder="">
				</div>
			</div>
		</div>
		<div >
			<div class="form-group col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="officePhone">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;办公电话</label>
				<div class="col-sm-8">
					<input type="text" id="officePhone" name="officePhone"
						class="validate[custom[phone]] form-control input-sm" placeholder=""
						value="${userInfo.officePhone }" maxlength=11>
				</div>
			</div>
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userMobile">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;手机号</label>
				<div class="col-sm-8">
					<input type="text" id="userMobile" name="userMobile"
						class="validate[custom[phone]] form-control input-sm" placeholder=""
						value="${userInfo.userMobile }" maxlength=11>
				</div>
			</div>
		</div>
		<div >
			<div class="form-group col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userEmail">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Email</label>
				<div class="col-sm-8">
					<input type="text" id="userEmail" name="userEmail"
						class="validate[custom[email]] form-control input-sm" placeholder=""
						value="${userInfo.userEmail }" maxlength=64>
				</div>
			</div>
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userAddress">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;现住址</label>
				<div class="col-sm-8">
					<input type="text" id="userAddress" name="userAddress"
						value="${userInfo.userAddress }" class="form-control input-sm" placeholder="" maxlength=256>
				</div>
			</div>
		</div>
		<div >
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userSeniority">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;工龄</label>
				<div class="col-sm-8">
					<input type="text" id="userSeniority" name="userSeniority"
						value="${userInfo.userSeniority }" class="validate[custom[integer]] form-control input-sm" placeholder="" maxlength=32>
				</div>
			</div>
		</div>
		<div >
			<div class="form-group col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userDutyTyp">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;人员类型</label>
				<div class="col-sm-8">
					<select id="userDutyTyp" name="userDutyTyp" class="selectPiker input-sm" style="width: 100%;padding: 5px;">
						<option value="0">正式-在职</option>
						<option value="2">正式-聘用</option>
						<option value="1">借调</option>
						<option value="5">实习</option>
					</select>
				</div>
			</div>
		</div>
		<div >
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="deptName">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;部门</label>
				<div class="col-sm-8">
					<div id="treeDiv_deptId" class="treeDiv">
						<div id="treeDemo_deptId" class="ztree"
							style="width:240px;height:120px; margin-top:25px; overflow:hidden;font-size: 13px;">
							<ul id="groupTree_deptId" class="ztree" style="margin-top: 5px;"></ul>
						</div>
					</div>
					<input id="deptId" class="form-control" name="deptId" type="hidden"
						maxlength=32 value="${userInfo.deptId }" /> <input id="deptName" name="deptName"
						class="form-control select view input-sm" onclick="postTree(0,'deptId');"
						 type="text" maxlength=10 value="${userInfo.deptName }" />
				</div>
			</div>
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="postName">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;职务</label>
				<div class="col-sm-8">
					<div id="treeDiv_postId" class="treeDiv">
						<div id="treeDemo_postId" class="ztree"
							style="width:240px;height:120px; margin-top:25px; overflow:visible;font-size: 13px;">
							<ul id="groupTree_postId" class="ztree" style="margin-top: 5px;"></ul>
						</div>
					</div>
					<input id="postId" class="form-control" name="postId" type="hidden"
						maxlength=32 value="${userInfo.postId }" /> <input id="postName" name="postName"
						class="form-control select view input-sm" onclick="postTree(1,'postId');"
						 type="text" maxlength=10 value="${userInfo.postName }" />
				</div>
			</div>
		</div>
		<div>
			<div class="form-group has-feedback col-sm-6"
				style="margin-left: 0; margin-right: 0">
				<label class="col-sm-4 control-label" for="userQq">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;QQ</label>
				<div class="col-sm-8">
					<input type="text" id="userQq" name="userQq"
						value="${userInfo.userQq }" class="form-control input-sm" placeholder="" maxlength=32>
				</div>
			</div>
		</div>
	</form>
	</div>
</body>
<script type="text/javascript">
	
	var submitUrl;
	$(function(){
		var edittype="${edittype}";
		$('#userSex').val("${userInfo.userSex }");
        $('#userDutyTyp').val("${userInfo.userDutyTyp }");
		$('#maritalStatus').val("${userInfo.maritalStatus }");
		$('#userPoliceType').val("${userInfo.userPoliceType }");
		$('#userNation').val("${userInfo.userNation }");
		$('#userEducation').val("${userInfo.userEducation }");
		$('#userDegree').val("${userInfo.userDegree }");
		var userSource="${userInfo.userSource }";
		if(edittype=='hide'){
			$('input,textarea',$('form[id="ff"]')).attr('readonly',true);
			$('.select').attr("disabled",true);
		}else{
			$('input,textarea',$('form[id="ff"]')).attr('readonly',false);
			$('.select').attr("disabled",false);
		}
		 if(edittype=='hide'){
		$('#userDutyTyp').attr("disabled",true);
		} 	
		if(edittype=='edit'){
			if(userSource!='1'){
				$('.view').attr("disabled",true);
			}
		}
        
		//开启表单验证引擎(修改部分参数默认属性)
		$('#ff').validationEngine({
			promptPosition:'topRight', //提示框的位置 
			autoHidePrompt:true, //是否自动隐藏提示信息 默认为false
			autoHideDelay:100000, //自动隐藏提示信息的延迟时间 (ms)
			maxErrorsPerField:false,//单个元素显示错误提示的最大数量，值设为数值。默认 false 表示不限制。
			showOneMessage:false, //是否只显示一个提示信息
			onValidationComplete:submitForm,//表单提交验证完成时的回调函数 function(form, valid){}，参数：form：表单元素 valid：验证结果（ture or false）使用此方法后，表单即使验证通过也不会进行提交，交给定义的回调函数进行操作。
		});
		//laydate.skin('dahong');
	})

	function doSave(url){
		submitUrl = url;
		$('.view').attr("disabled",false);
		$('#userDutyTyp').attr("disabled",false);
	    $("#ff").submit();
	}
	
	function submitForm(form, valid){
		if(valid){
		//处理一下工龄
		if($("#userSeniority").val()==null||$("#userSeniority").val()==""){
		$("#userSeniority").val("0");
		}
			$.ajax({
				type : "POST",
				url : submitUrl,
				data: form.serialize(),
				success : function(data) {
					if(data == "true"){
						window.parent.closeDialog();
					}else{
						window.parent.layerAlert("数据保存异常！")
					}
				}
			});
		}
	}
</script>
</html>