<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>系统logo配置</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/syslogo/js/logoConfig.js"></script>
	<style>
		.logo-set > .title{
  			width: 100%;
			height: 24px;
			background:#ceddea;
			padding-left: 4px;
			padding-top: 7px;
			color: #000;
		}
		.logo-set > .title > a.l-btn-plain{
		   float:right;
		   padding:0px;
		   margin-top:-5px;
		}
		.logo-set > ul{
			padding:10px;
		}
		.logo-set > ul > li{
			list-style:none;
			margin-bottom: 10px;
		}
		.logo-set > ul > li > span{
			display:inline-block;
			width:100px;
		}
		.logo-set > ul > li  img{
			background-color: #0E5FAA;
		}
		.logo-set > ul > li > .img {
			display:inline-block;
			width:500px;
			vertical-align: middle;
		}
		
	</style>
	<script type="text/javascript">
		var sysType = '${sysType}';
	</script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<div data-options="region:'center'" class="content">
		<div class="logo-set">
			<c:if test="${sysType == '0'}">
			<!-- 登录页logo配置 -->
			<div class="title">
				登录页LOGO <font color="red">(像素大小337*45)</font><a href="javascript:void(0)" onclick="addDlLogo('dl_logo')" class="easyui-linkbutton" iconCls="icon-add" plain="true"></a>
			</div>
			<ul>
				<li>
					<span>系统默认：</span>
					<div class="img">
						<img src="${ctx}/views/cap/login/images/login_logo.png" style="background-color: #fff;">
					</div>
					<a href="javascript:void(0)" onclick="setUsed('default','${dl_def}','dl_logo')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">使用</a>
					<c:if test="${dl_def == 'Y'}"><span style="color:red">已使用</span></c:if>
				</li>
				<c:forEach items="${dl_list }" var="list">
					<li>
						<span>${list.logoName }：</span>
						<div class="img">
							<img src="${ctx}/sysLogoController/doDownLoadPicFile?picPath=${list.filePath}" style="background-color: #fff;">
						</div>
						<a href="javascript:void(0)" onclick="setUsed('${list.logoName }','${list.isUsed}','dl_logo')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">使用</a>
						<a href="javascript:void(0)" onclick="removeLogo('${list.logoName }','${list.isUsed}','dl_logo')" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
						<c:if test="${list.isUsed == 'Y'}"><span style="color:red">已使用</span></c:if>
					</li>
				</c:forEach>
			</ul>

			<!-- 产品logo配置 -->
			<div class="title">
				产品主页LOGO <font color="red">(像素大小337*45)</font><a href="javascript:void(0)" onclick="addDlLogo('cp_logo')" class="easyui-linkbutton" iconCls="icon-add" plain="true"></a>
			</div>
			<ul>
				<li>
					<span>系统默认：</span>
					<div class="img">
						<img src="${ctx}/static/aco/images/logo1.png">
					</div>
					<a href="javascript:void(0)" onclick="setUsed('default','${cp_def}','cp_logo')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">使用</a>
					<c:if test="${cp_def == 'Y'}"><span style="color:red">已使用</span></c:if>
				</li>
				<c:forEach items="${cp_list }" var="list">
					<li>
						<span>${list.logoName }：</span>
						<div class="img">
							<img src="${ctx}/sysLogoController/doDownLoadPicFile?picPath=${list.filePath}">
						</div>
						<a href="javascript:void(0)" onclick="setUsed('${list.logoName }','${list.isUsed}','cp_logo')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">使用</a>
						<a href="javascript:void(0)" onclick="removeLogo('${list.logoName }','${list.isUsed}','cp_logo')" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
						<c:if test="${list.isUsed == 'Y'}"><span style="color:red">已使用</span></c:if>
					</li>
				</c:forEach>
			</ul>

			<!-- 关于主页logo配置 -->
			<div class="title">
				关于主页LOGO <font color="red">(像素大小157*31)</font><a href="javascript:void(0)" onclick="addDlLogo('gy_logo')" class="easyui-linkbutton" iconCls="icon-add" plain="true"></a>
			</div>
			<ul>
				<li>
					<span>系统默认：</span>
					<div class="img">
						<img src="${ctx}/views/cap/isc/theme/about/images/logo_1.png">
					</div>
					<a href="javascript:void(0)" onclick="setUsed('default','${gy_def}','gy_logo')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">使用</a>
					<c:if test="${gy_def == 'Y'}"><span style="color:red">已使用</span></c:if>
				</li>
				<c:forEach items="${gy_list }" var="list">
					<li>
						<span>${list.logoName }：</span>
						<div class="img">
							<img src="${ctx}/sysLogoController/doDownLoadPicFile?picPath=${list.filePath}">
						</div>
						<a href="javascript:void(0)" onclick="setUsed('${list.logoName }','${list.isUsed}','gy_logo')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">使用</a>
						<a href="javascript:void(0)" onclick="removeLogo('${list.logoName }','${list.isUsed}','gy_logo')" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
						<c:if test="${list.isUsed == 'Y'}"><span style="color:red">已使用</span></c:if>
					</li>
				</c:forEach>
			</ul>
			</c:if>
			
			<c:if test="${sysType == '2'}">
			<!-- 平台主页logo配置 -->
			<div class="title">
				平台主页LOGO <font color="red">(像素大小312*45)</font><a href="javascript:void(0)" onclick="addDlLogo('pt_logo')" class="easyui-linkbutton" iconCls="icon-add" plain="true"></a>
			</div>
			<ul>
				<li>
					<span>系统默认：</span>
					<div class="img">
						<img src="${ctx}/static/cap/images/logo2.png">
					</div>
					<a href="javascript:void(0)" onclick="setUsed('default','${pt_def}','pt_logo')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">使用</a>
					<c:if test="${pt_def == 'Y'}"><span style="color:red">已使用</span></c:if>
				</li>
				<c:forEach items="${pt_list }" var="list">
					<li>
						<span>${list.logoName }：</span>
						<div class="img">
							<img src="${ctx}/sysLogoController/doDownLoadPicFile?picPath=${list.filePath}">
						</div>
						<a href="javascript:void(0)" onclick="setUsed('${list.logoName }','${list.isUsed}','pt_logo')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">使用</a>
						<a href="javascript:void(0)" onclick="removeLogo('${list.logoName }','${list.isUsed}','pt_logo')" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
						<c:if test="${list.isUsed == 'Y'}"><span style="color:red">已使用</span></c:if>
					</li>
				</c:forEach>
			</ul>
			</c:if>
			
		</div>
	</div>

	<!-- Form表单 -->
	<div id="logoDialog" class="easyui-dialog"  closed="true" data-options="modal:true" title="新增登录logo" style="width:470px;height:335px;" buttons="#dlg-buttons">
		<div class="easyui-panel window-body" style="height: 100%;">
			<form id="logoForm" method="post" class="window-form" enctype="multipart/form-data">
				<input type="hidden" id="id" name="id" />
				<table cellpadding="3" class="form-table">
		    		<tr>
		    			<td>名称<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,64]']" required="true" missingMessage="不能为空" id="logoName" name="logoName" style="width:350px;" />
		    			</td>
		    		</tr>
		    		<tr id="path">
		    			<td >路径<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input id="filePath" name="filePath" class="easyui-filebox" style="width:95%" data-options="prompt:'请选择图片路径...'" />
		    			</td>
		    		</tr>
		    	</table>
			</form>
		</div>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doUpfileImg()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#logoDialog').dialog('close')" plain="true">取消</a>
	</div>
</body>
</html>