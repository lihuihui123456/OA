<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html lang="zh-CN">
<head>
<title>基金办人员管理</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/jjb/usermgr/js/userlist.js"></script>
<script src="${ctx}/views/jjb/usermgr/js/deptpost.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<!-- 滑动end -->
<style>
.control-label {
	text-align: left !important;
	padding-top: 5px;
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
	$(function() {
		addOption(initDict('deptType'));
		addOptions(initDict('postType'));
		$(".radioItem").change(
				function() {
					var obj = document.getElementsByName('usertype');
					var userType;
					var src;
					var edittype = 'open';
					var userId = '';
					for (var i = 0; i < obj.length; i++) {
						if (obj[i].checked == true) {
							if (obj[i].value == '0') {
								userType = '0';
								src = "userManager/toUserPage?userType="
										+ userType + "&edittype=" + edittype
										+ "&userId=" + userId;
							} else if (obj[i].value == '1') {
								userType = '1';
								src = "userManager/toUserPage?userType="
										+ userType + "&edittype=" + edittype
										+ "&userId=" + userId;
							} else if (obj[i].value == '5') {
								userType = '5';
								src = "userManager/toUserPage?userType="
										+ userType + "&edittype=" + edittype
										+ "&userId=" + userId;
							}
						}
					}
					$('#mainBody_iframe').attr('src', src);
				});
	})
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
	
	/** 查询字段信息 **/
	function initDict(dicttype) {
		var temp;
		$.ajax({
			url : "dictController/findDictByTypeCode",
			type : "post",
			async : false,
			dataType : "json",
			data : {
				"showAll" : "showAll",
				"dictTypeCode" : dicttype
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
			document.getElementById("deptName").options.add(
				new Option(this.dictVal, this.dictVal)
			);
		})
	}
	
	function addOptions(obj) {
		var value;
		var text;
		$(obj).each(function(index) {
			document.getElementById("postName").options.add(
				new Option(this.dictVal, this.dictVal)
			);
		})
	}
</script>
</head>
<body>
	<div class="panel-body"
		style="padding-top:0px;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group "
			style="padding-top: 10px;padding-bottom:10px;">
			<button id="mt_btn_new" type="button" class="btn btn-default btn-sm">
				<span class="glyphicon glyphicon-plus" aria-hidden="true"></span>新增
			</button>
			<button id="mt_btn_edit" type="button" class="btn btn-default btn-sm">
				<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>修改
			</button>
			<button id="mt_btn_view" type="button" class="btn btn-default btn-sm">
				<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span>查看
			</button>
			<button id="mt_btn_delete" type="button"
				class="btn btn-default btn-sm">
				<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>删除
			</button>
			<button id="mt_btn_export" type="button"
				class="btn btn-default btn-sm">
				<span class="fa fa-mail-reply" aria-hidden="true"></span>导出
			</button>
		</div>
		<div
			style="width: 280px; float: right; padding-top: 10px;padding-bottom:10px;margin-right: 70px;">
			<div class="input-group">
				<input type="text" id="input-word" class="form-control input-sm"
					value="请输入人员名称" onFocus="if (value =='请输入人员名称'){value=''}"
					onBlur="if (value ==''){value='请输入人员名称'}"> <span
					class="input-group-btn">
					<button id="search" type="button" class="btn btn-primary btn-sm"
						onclick="searchUserInfo()">
						<i class="fa fa-search"></i> 查询
					</button>
					
				</span>
			</div>
			<button id="query" type="button" class="btn btn-primary btn-sm"
						style="width:70px;margin-right: 0px;position:absolute;top:10px;right:10px;" onclick="searchWindow()">高级查询</button>
		</div>
		<form id="fff" action="" method="post">
			<div class="row">
				<div id="userDutyTypForm" class="form-group col-sm-4"
					style="margin-left: 0; margin-right: 0">
					<label class="col-sm-4 control-label" for="userDutyTyp">&nbsp;&nbsp;人员类型</label>
					<div class="col-sm-8">
						<select id="userDutyTyp" name="userDutyTyp" class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
							<option value=""></option>
							<option value="0">正式-在职</option>
							<option value="2">正式-聘用</option>
							<option value="1">借调</option>
							<option value="5">实习</option>
						</select>
					</div>
				</div>
					<div id="userSexForm" class="form-group col-sm-4"
					style="margin-left: 0; margin-right: 0">
					<label class="col-sm-4 control-label" for="userSex">&nbsp;&nbsp;性别
					</label>
					<div class="col-sm-8">
						<select id="userSex" name="userSex" class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
							<option value=""></option>
							<option value="0">女</option>
							<option value="1">男</option>
							<option value="2">未知</option>
						</select>
					</div>
				</div>	
				<div id="userAgeForm" class="form-group has-feedback col-sm-4"
					style="margin-left: 0; margin-right: 0">
					<label class="col-sm-4 control-label" for="userAge">&nbsp;&nbsp;年龄</label>
					<div class="col-sm-8">
						<input type="text" id="userAge" name="userAge"
							class="validate[custom[notSpecial]] form-control  input-sm" placeholder=""
							maxlength=64>
					</div>
				</div>		
				
			</div>
			<div class="row">
			<div id="deptNameForm" class="form-group col-sm-4"
					style="margin-left: 0; margin-right: 0">
					<label class="col-sm-4 control-label" for="deptName">&nbsp;&nbsp;部门</label>
					<div class="col-sm-8">
					<select id="deptName" name="deptName" class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
						<option value=""></option>
						</select>
					</div>
				</div>
				<div id="userNameForm" class="form-group col-sm-4"
					style="margin-left: 0; margin-right: 0">
					<label class="col-sm-4 control-label" for="postName">&nbsp;&nbsp;职务</label>
					<div class="col-sm-8">
						<select id="postName" name="postName" class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
							<option value=""></option>
						</select>		
					</div>
				</div>
				<div id="entryTimeForm" class="form-group has-feedback col-sm-4"
					style="margin-left: 0; margin-right: 0">
					<label class="col-sm-4 control-label" for="entryTime">&nbsp;&nbsp;调入时间</label>
					<div class="col-sm-8	" >
						<input type="text" id="entryTime" name="entryTime"  style="width:100%;float:left;"
							class="form-control input-sm" placeholder="" maxlength=10>
							<span  class="laydate-icon" style="width:30px;height:30px;position:absolute;right:5px;float:right;padding-right:1%"  onclick="laydate({elem: '#entryTime'});"></span>
					</div>
				</div>
			</div>
			<div class="form-group" id="btnDiv" align="center">
				<button type="button" class="btn btn-primary btn-sm " onclick="submitForm()">查询</button>
				<button type="button" class="btn btn-primary btn-sm" onclick="clearForm()">重置</button>
			</div>
		</form>
		<form id="exportUserInfoToExcel" action="">
			<table id="dtlist" data-toggle="table" date-striped="true"
				data-click-to-select="true"></table>
		</form>
	</div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
		</div>
	</div>

	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel"></h4>
				</div>
				<div class="modal-body">
					<div id="userRadio" style="margin-top:0px;margin-left:30px;">
						<input id="userType-0" name="usertype" class="radioItem"
							type="radio" value="0" checked="checked" />正式人员 <input
							id="userType-1" name="usertype" class="radioItem" type="radio"
							value="1" />借调人员 <input id="userType-5" name="usertype"
							class="radioItem" type="radio" value="5" />实习生
					</div>
					<div style="margin-top: 10px">
						<iframe src="" id="mainBody_iframe" runat="server" width="100%"
							height="550px" frameborder="no" border="0" scrolling="no"></iframe>
					</div>
					<div class="form-group" id="btnDiv1" align="center">
						<button type="button" class="btn btn-primary" onclick="doSave()">保存</button>
						<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
					</div>
					<div class="form-group" id="btnDiv2" align="center">
						<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var mySwiper = new Swiper('.swiper-container', {
		loop : true,
		onSlidePrev : function(swiper) {
			$("#dtlist").bootstrapTable('prevPage');
		},
		onSlideNext : function(swiper) {
			$("#dtlist").bootstrapTable('nextPage');
		}
	});
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>