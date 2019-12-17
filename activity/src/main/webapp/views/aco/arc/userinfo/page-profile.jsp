<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/arc/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>办公系统</title>	
<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />	
<%@ include file="/views/arc/common/head.jsp"%>
<link rel="stylesheet" href="${ctx}/static/cap/plugins/plupload/queue/css/jquery.plupload.queue.css" type="text/css"></link>
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/plupload/plupload.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/plupload/zh_CN.js"></script>
<script src="${ctx}/views/arc/userinfo/js/profile.js"></script>
<script type="text/javascript">

 //修改头像按钮
 function makerUpload(chunk, flag){
	url='${ctx}/arcUserController/upfileImg';
	window.open('<%=basePath%>arcUserController/index?chunk='+chunk+'&url='+url, 'window', 'height=316, width=400, top=2, left=2, toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
 } 

</script>

<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="overflow: auto;">
<form id="profile" action="${ctx}/arcUserController/findPerInfoById" target="_self" method="post">

	
	<div class="container-fluid content" style="overflow:hidden;">
		<div class="row">
		
			<div class="col-sm-4" style="height:515px;border:solid 1px #e4e4e4;text-align: center;">
			
				<div style="margin-top:25px;">
					<img style="border-radius:100px;height:150px;width:150px;" id="userpic" src="${ctx}/arcUserController/uploadfile?pic=${data.picUrl}">
				</div>
				<!-- 修改头像 -->
				<div style="margin-top:15px;">
					<a href="javascript:makerUpload(false)"><span class="fa fa-pencil" aria-hidden="true"></span>修改头像</a>
				</div>
				
		
				<!-- 二维码功能 
				<div id="erweima" style="max-width:210px;margin:12% auto;">
					<img width="70%" style=" margin-bottom: 10px;" src="${ctx}/arcUserController/getQRCode?url=<%=basePath%>views/arc/userinfo/index.jsp">
					<img width="70%" src="${ctx}/views/arc/userinfo/images/font.png">
					<img width="70%" src="${ctx}/views/arc/userinfo/images/btn2.png">
				</div>
				-->	
			</div>
		
		
			<div class="col-sm-8" style="height:515px;border:solid 1px #e4e4e4;">
				<div style="margin-top:35px;margin-left:15%;">
					  <div>
					  
						<div class="row" style="margin-bottom:20px;width: 300px;">
							<label class="col-sm-2" style="width:80px; text-align:left;color:#808080;font-family:Microsoft YaHei;">姓&nbsp&nbsp&nbsp&nbsp名:</label>
							<div class="col-sm-2" id="name" style="width:220px; float:right;text-align:left;font-weight:bold;font-family:Microsoft YaHei;">${data.userName}&nbsp&nbsp
								<span data-toggle="modal" data-target="#myModal" id="mt_btn_edit" class="fa fa-pencil" style="cursor:pointer;color: #167495;" aria-hidden="true"></span><font style="color:#167495;font-family:Microsoft YaHei;cursor:pointer;" data-toggle="modal" data-target="#myModal" id="mt_btn_edit" color="#167495" >修改</font>
								&nbsp;|&nbsp;<span data-toggle="modal" id="mm_btn_edit" class="fa fa-lock" style="cursor:pointer;color: #167495;" aria-hidden="true" onclick="openPwd()"></span><font style="color:#167495;font-family:Microsoft YaHei;cursor:pointer;" data-toggle="modal" id="mm_btn_edit" color="#167495" onclick="openPwd()">修改密码</font>
							</div>
								
						</div>
						
						<div class="row" style="margin-bottom:20px;width: 300px;">
							<label class="col-sm-2" style="width:80px; text-align:left;color:#808080;font-family:Microsoft YaHei;">性&nbsp&nbsp&nbsp&nbsp别:</label>
							<div class="col-sm-4" id="sex" style="width:220px;float:right;text-align:left;font-weight:bold;font-family:Microsoft YaHei;"><c:if test="${data.userSex==1}">男</c:if><c:if test="${data.userSex==0}">女</c:if></div>
						</div>
								<%-- <div class="row" style="margin-bottom:20px;">
								<label class="col-sm-2" style="text-align:right;color:#808080;font-family:Microsoft YaHei;">人员编号：</label>
								<div class="col-sm-2" id="id" style="text-align:left;font-weight:bold;font-family:Microsoft YaHei;"></div>
								</div> --%>
								<%-- <div class="row" style="margin-bottom:20px;">
								<label class="col-sm-2" style="text-align:right;color:#808080;font-family:Microsoft YaHei;">所属机构:</label>
								<div class="col-sm-10" id="ssjg" style="text-align:left;font-weight:bold;font-family:Microsoft YaHei;"></div>
								</div> --%>
								<%-- <div class="row" style="margin-bottom:20px;">
								<label class="col-sm-2" style="text-align:right;color:#808080;font-family:Microsoft YaHei;">办公电话:</label>
								<div class="col-sm-10" id="bgdh" style="text-align:left;font-weight:bold;font-family:Microsoft YaHei;"></div>
								</div> --%>
						<div class="row" style="margin-bottom:20px;width: 300px;">
							<label class="col-sm-2" style="width:80px; text-align:left;color:#808080;font-family:Microsoft YaHei;">电子邮件:</label>
							<div class="col-sm-4" id="mail" style="width:220px;float:right;text-align:left;font-weight:bold;font-family:Microsoft YaHei;">${data.userEmail}</div>
						</div>
								<%-- <div class="row" style="margin-bottom:20px;">
								<label class="col-sm-2" style="text-align:right;color:#808080;font-family:Microsoft YaHei;">职务:</label>
								<div class="col-sm-10" id="job" style="text-align:left;font-weight:bold;font-family:Microsoft YaHei;"></div>
								</div> --%>
						<div class="row" style="margin-bottom:20px;width: 300px;">
							<label class="col-sm-2" style="width:80px; text-align:left;color:#808080;font-family:Microsoft YaHei;">手&nbsp机&nbsp号:</label>
							<div class="col-sm-4" id="phoneNum" style="width:220px;float:right;text-align:left;font-weight:bold;font-family:Microsoft YaHei;">${data.userMobile}</div>
						</div>
						
				    </div>
						
					<div class="divider" style="width: 96%;position:absolute;z-index:-1;margin:0 auto;left:2%;top:46%;"></div>
					<div class="row" style="margin-bottom:20px;width: 300px;margin-top:80px ">
						<label class="col-sm-2" style="width:80px; text-align:left;color:#808080;font-family:Microsoft YaHei;">所属部门:</label>
						<div class="col-sm-10" id="ssbm" style="width:220px;float:right;text-align:left;font-weight:bold;font-family:Microsoft YaHei;">${data.deptName}</div>
					</div>
					<div class="row" style="margin-bottom:20px;width: 300px;">
						<label class="col-sm-2" style="width:80px; text-align:left;color:#808080;font-family:Microsoft YaHei;">部门编号:</label>
						<div class="col-sm-10" id="phoneNum" style="width:220px;float:right;text-align:left;font-weight:bold;font-family:Microsoft YaHei;">${data.deptCode}</div>
					</div>
					<div class="row" style="margin-bottom:20px;width: 300px;">
						<label class="col-sm-2" style="width:80px; text-align:left;color:#808080;font-family:Microsoft YaHei;">负责业务:</label>
						<div class="col-sm-10" id="duty" style="width:220px;float:right;text-align:left;font-weight:bold;font-family:Microsoft YaHei;">项目开发</div>
					</div>
				</div>
			</div>
			
		</div>
	
	</div><!--/container-->
	
</form>
		
	
	<div class="modal fade" id="myModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title">个人信息修改</h4>
				</div>
				<div class="modal-body">
		<form id="ff" action="" method="post" enctype="multipart/form-data"
			class="form-horizontal " target="_top">
			<input type="hidden" name="id" value=${data.userId}>
			
			<div id="roomNameForm" class="form-group has-feedback" style="margin-left:0;margin-right:0">
				<label class="col-sm-2 col-xs-2 control-label" for="roomname" style="text-align:right;">姓名&nbsp;<span style="color:red">*</span></label>
				<div class="col-sm-4 col-xs-4">
					<input type="text" id="roomname" name="userName"
						class="form-control" placeholder="" maxlength=10 onblur="IsChinese()" value=${data.userName} readonly="readonly">
						<span id="checkRoomName" class="form-control-feedback"></span>
						<%--<span id="checkRoomName" class="glyphicon form-control-feedback"></span>--%>						
				</div>
				<label class="col-sm-2  col-xs-2 control-label" for="roomnum" style="text-align:center;">性别&nbsp;<span style="color:red">*</span></label>
				<div class="col-sm-4  col-xs-4">
					<select id="sexChange" name="userSex" class="form-control">
						<option value="1" <c:if test="${data.userSex==1}">selected = selected"</c:if>>男</option>
						<option value="0" <c:if test="${data.userSex==0}">selected = selected"</c:if>>女</option>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 col-xs-2  control-label" for="floor" style="text-align:center;">电子邮件</label>
				<div class="col-sm-10 col-xs-10">
					<input type="text" id="roomnum" name="userEmail" class="form-control" placeholder="" value=${data.userEmail}>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 col-xs-2  control-label" for="area" style="text-align:center;">手机号</label>
				<div class="col-sm-10 col-xs-10">
					<input type="text" id="area" name="userMobile"
						class="form-control" placeholder="" value=${data.userMobile}>
				</div>
			</div>
		</form>
		</div>
		<div align="center" style="margin-bottom:20px;">
		<button class="btn btn-primary" id="changeSave" onclick="changeSave()">保存</button>
		</div>
		
		
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	<!-- 修改密码modal -->
	<div class="modal fade" id="mm">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title">修改密码</h4>
				</div>
				<div class="modal-body" style="margin-left: 130px">
					<form id="ff_mm" action="profile/updatePwd" method="post"
						class="form-horizontal " target="_top">
						<div class="row">
							<label class="col-sm-2 control-label" for="password"
								style="text-align: right;">原密码</label>
							<div class="col-sm-5">
								<input type="password" id="password" name="password"
									class="form-control" placeholder="" onchange="validPWd()">
							</div>
						</div>
						<br />
						<div class="row">
							<label class="col-sm-2 control-label" for="newPassword"
								style="text-align: right;">新密码</label>
							<div class="col-sm-5">
								<input type="password" id="newPassword" name="newPassword"
									class="form-control" placeholder="" onchange="validNewPWd()">
							</div>
						</div>
						<br />
						<div class="row">
							<label class="col-sm-2 control-label" for="conPassword"
								style="text-align: right;">确认密码</label>
							<div class="col-sm-5">
								<input type="password" id="conPassword" name="conPassword"
									class="form-control" placeholder="">
							</div>
						</div>
					</form>
				</div>
				<div align="center" style="margin-bottom: 20px;">
					<button class="btn btn-primary" onclick="submitForm()">保存</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- 修改密码/.modal -->
</body>
</html>