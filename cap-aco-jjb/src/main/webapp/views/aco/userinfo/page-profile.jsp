<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>办公系统</title>	
<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />	
<%@ include file="/views/aco/common/head.jsp"%>
<link rel="stylesheet" href="${ctx}/static/cap/plugins/plupload/queue/css/jquery.plupload.queue.css" type="text/css"></link>
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/plupload/plupload.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/plupload/zh_CN.js"></script>
<script src="${ctx}/views/aco/userinfo/js/profile.js"></script>
<script type="text/javascript">

  //修改头像按钮
 function makerUpload(chunk, flag){
 	/* var iTop = (window.screen.height-30-316)/2;  
	var iLeft = (window.screen.width-10-400)/2; */
	var iWidth=500; //弹出窗口的宽度; 
    var iHeight=315;//弹出窗口的高度; 
    //获得窗口的垂直位置 
    var iTop = (window.screen.availHeight - 30 - iHeight) / 2; 
    //获得窗口的水平位置 
    var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; 
	url='${ctx}/uploader/upfileImg';
	window.open('<%=basePath%>uploader/index?chunk='+chunk+'&url='+url, 'window', 'height='+iHeight+', width='+iWidth+', top=' + iTop + ', left=' + iLeft + ', toolbar=no, menubar=no, scrollbars=no, resizable=no, location=no, status=no');
 } 
/**
 * 创建上传窗口 公共方法
 * @param chunk 是否分割大文件
 * @param callBack 上传成功之后的回调
 */
 /** 
 function Uploader(chunk,callBack){
	var addWin = $('<div style="overflow: hidden;"/>');
	var upladoer = $('<iframe/>');
	var url = '${ctx}/uploader/upfileImg';
	upladoer.attr({'src':'${ctx}/uploader/index?chunk='+ chunk+'&url='+url,width : '100%',height : '100%',frameborder : '0',scrolling : 'no'});
		addWin.window({
			title : "上传文件",
			height : 350,
			width : 550,
			minimizable : false,
			modal : true,
			collapsible : false,
			maximizable : false,
			resizable : false,
			content : upladoer,
			onClose : function() {
				var fw = GetFrameWindow(upladoer[0]);
				var files = fw.files;
				$(this).window('destroy');
				callBack.call(this, files);
			},
			onOpen : function() {
				var target = $(this);
				setTimeout(function() {
					var fw = GetFrameWindow(upladoer[0]);
					fw.target = target;
				}, 100);
			}
	});
}
**/
/**
 * 根据iframe对象获取iframe的window对象
 * @param frame
 * @returns {Boolean}
 */
/** 
function GetFrameWindow(frame){
	return frame && typeof(frame)=='object' && frame.tagName == 'IFRAME' && frame.contentWindow;
}

 //修改头像按钮
 function makerUpload2(chunk, flag) {
	Uploader(chunk, function(files) {
		if (files && files.length > 0) {
			doSavePicture(files[0]);
		}
	});
} 
 
function makerUpload(chunk, flag){
	url='${ctx}/uploader/upfileImg';
	var resultStr = window
.showModalDialog("${ctx}/uploader/index?chunk="+chunk+"&url="+url,
			window,"dialogWidth:500px; dialogHeight: 310px; help: no; scroll: no; status: no");
	doSavePicture(resultStr);
} 
 
function doSavePicture(fileName){
	fileName='<shiro:principal property="id"/>'+fileName.substring(fileName.lastIndexOf("."));
	var AjaxURL = '${ctx}/uploader/changePicture?picture='+fileName;
	$.ajax({
		type: "POST",
		url: AjaxURL,
		data: "JSON",
		success: function (data) {
			refreshPicture(fileName);
		},
		error: function(data) {
			alert("网络异常！");
		}
	});
}
**/
/**
*a加入的原因
*照片二次上传时因url相同，故加入变量防止调用缓存信息
**/
/** 
var a=1;
function refreshPicture(fileName){
	var browser = myBrowser();	
	$("#userpic").attr('src','${ctx}/uploader/uploadfile?pic='+fileName+'&bro='+browser+'&a='+a);
	$(parent.document).find("#nav_tx").attr('src','${ctx}/uploader/uploadfile?pic='+fileName+'&bro='+browser+'&a='+a);
	a++;
}

function myBrowser(){
    var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
    var isOpera = userAgent.indexOf("Opera") > -1;
    if (isOpera) {
        return "Opera";
    }; //判断是否Opera浏览器
    if (userAgent.indexOf("Firefox") > -1) {
        return "FF";
    } //判断是否Firefox浏览器
    if (userAgent.indexOf("Chrome") > -1){
		return "Chrome";
	}
    if (userAgent.indexOf("Safari") > -1) {
        return "Safari";
    } //判断是否Safari浏览器
    if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera) {
        return "IE";
    }; //判断是否IE浏览器
}
**/

/** 
$(function(){
	//var sex = ${data.userSex};
	//$('#sexChange').val(sex);
})

function changeFrameHeight(){
    var ifm= document.getElementById("profile"); 
    ifm.height=document.documentElement.clientHeight;
}
window.onresize=function(){  
     changeFrameHeight();  
} 
**/
</script>

<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="overflow: auto;">
<form id="profile" action="${ctx}/userController/findPerInfoById" target="_self" method="post">

	
	<div class="container-fluid content" style="overflow:hidden;">
		<div class="row">
		
			<div class="col-sm-4" style="height:540px;border:solid 1px #e4e4e4;text-align: center;">
			
				<div style="margin-top:25px;">
					<img style="border-radius:100px;height:150px;width:150px;" id="userpic" src="${ctx}/uploader/uploadfile?pic=${data.picUrl}">
				</div>
				<div style="margin-top:15px;">
					<a href="javascript:makerUpload(false)"><span class="fa fa-pencil" aria-hidden="true"></span>修改头像</a>
				</div>
				
		
				<!-- 二维码功能 -->	
				<div id="erweima" style="max-width:210px;margin:8% auto;">
					<img width="85%" style=" margin-bottom: 10px;" src="${ctx}/QRCodeController/getQRCode?url=<%=basePath%>views/aco/userinfo/index.jsp">
					<img width="85%" src="${ctx}/views/aco/userinfo/images/font.png">
					<img width="85%" src="${ctx}/views/aco/userinfo/images/btn2.png">
				</div>
				
			</div>
		
		
			<div class="col-sm-8" style="height:540px;border:solid 1px #e4e4e4;">
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
					<%-- <div class="row" style="margin-bottom:20px;width: 300px;">
						<label class="col-sm-2" style="width:80px; text-align:left;color:#808080;font-family:Microsoft YaHei;">部门编号:</label>
						<div class="col-sm-10" id="phoneNum" style="width:220px;float:right;text-align:left;font-weight:bold;font-family:Microsoft YaHei;">${data.deptCode}</div>
					</div>
					<div class="row" style="margin-bottom:20px;width: 300px;">
						<label class="col-sm-2" style="width:80px; text-align:left;color:#808080;font-family:Microsoft YaHei;">负责业务:</label>
						<div class="col-sm-10" id="duty" style="width:220px;float:right;text-align:left;font-weight:bold;font-family:Microsoft YaHei;">项目开发</div>
					</div> --%>
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
				<label class="col-sm-2 col-xs-2 control-label" for="roomname" style="text-align:left;">姓名&nbsp;<span style="color:red">*</span></label>
				<div class="col-sm-4 col-xs-4">
					<input type="text" id="roomname" name="userName"
						class="form-control" placeholder="" maxlength=10 onblur="IsChinese()" value=${data.userName} readonly="readonly">
						<span id="checkRoomName" class="form-control-feedback"></span>
						
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
				<label class="col-sm-2 col-xs-2  control-label" for="floor" style="text-align:left;">电子邮件</label>
				<div class="col-sm-10 col-xs-10">
					<input type="text" id="roomnum" name="userEmail" class="form-control" placeholder="" value=${data.userEmail}>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 col-xs-2  control-label" for="area" style="text-align:left;">手机号</label>
				<div class="col-sm-10 col-xs-10">
					<input type="text" id="area" name="userMobile"
						class="form-control" placeholder="" value=${data.userMobile}>
				</div>
			</div>
		</form>
		</div>
		<div align="center" style="margin-bottom:20px;">
		<button class="btn btn-primary" id="changeSave" onclick="changeSave()">保存</button>
		<button type="button" class="btn btn-primary"" data-dismiss="modal">关闭 </button>
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
					<button type="button" class="btn btn-primary"" data-dismiss="modal">关闭 </button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- 修改密码/.modal -->
</body>
</html>