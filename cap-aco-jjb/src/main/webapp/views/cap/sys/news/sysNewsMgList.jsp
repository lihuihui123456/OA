<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<title>新闻图片管理</title>
		<%@ include file="/views/cap/common/easyui-head.jsp"%>

		<script type="text/javascript">
			var orgIdGlobal = "${orgId}";
			var orgNameGlobal = "${orgName}";
			var ctxGlobal="${ctx}";
			var modeladdres="/views/cap/sys/news";
		</script>
		<style>
			.selectedPic {border:5px solid red;} 
		</style>
</head>
<body class="easyui-layout" style="width:100%;height:98%;">
	<div data-options="region:'center'" class="content">
		<!-- 部门类型列表 -->
		<table class="easyui-datagrid" id="sysNewsMgDataGrid" data-options="toolbar:'#toolBar'"></table>
		<!-- 部门类型列表 -->
		<div id="toolBar" class="clearfix" style="display:none">
			<!-- 条件查询 -->
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入轮播主题'"/>
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<!-- 工具栏 -->
			<div id="operateBtn" class="tool_btn">
				<shiro:hasPermission name="add:sysNewsMgController:sysNewsMgList">
					<a href="javascript:void(0)" onclick="doAddSysNewsMgTypeBefore();" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="modify:sysNewsMgController:sysNewsMgList">
					<a href="javascript:void(0)" onclick="doUpdateSysNewsMgBefore();" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="delete:sysNewsMgController:sysNewsMgList">
					<a href="javascript:void(0)" onclick="doDeleteSysNewsMg();" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="addPic:sysNewsMgController:sysNewsMgList">
					<a href="javascript:void(0)" onclick="doManagePics();" class="easyui-linkbutton" iconCls="icon-isc-tpgl" plain="true">图片管理</a>
				</shiro:hasPermission>
			<!-- 	<shiro:hasPermission name="depSysNews:sysNewsMgController:sysNewsMgList">
					<a href="javascript:void(0)" onclick="doDeploySysNews();" class="easyui-linkbutton" iconCls="icon-isc-fb" plain="true">发布</a>
				</shiro:hasPermission>  -->
				<a href="javascript:void(0)" onclick="showpics();" class="easyui-linkbutton" iconCls="icon-isc-fb" plain="true">轮播预览</a>
			</div>
		</div>
		

	</div>
	
	
	<!-- 新闻图片管理信息新增修改对话框 -->
	<div id="sysNewsMgDialog" class="easyui-dialog" closed="true" data-options="modal:true" style="width:530px;height:300px;padding: 10px;display:none;" buttons="#dlg-buttons">
		<form id="sysNewsMgForm" method="post">
			<input type="hidden" id="newsId" name="newsId" />
			<table cellpadding="3">
				<tr>
					<td>新闻图片名称<span style="color:red;vertical-align:middle;">*</span>:</td>
					<td>
						<input class="easyui-textbox" id="newsTittle" name="newsTittle" validType="" data-options="required:true" style="width:380px;vertical-align: middle;" missingMessage="不能为空">
					</td>
				</tr>

				<tr>
					<td>所属单位名称:</td>
					<td>
						<input type="hidden" id="orgId" name="orgId" />
						<input type="hidden" id="orgNameInput" name="orgName" />
						<input class="easyui-textbox" id="orgName" name="orgName" disabled="disabled" style="width:380px;" >
					</td>
				</tr>
				<tr>
					<td>所属主部门：</td>
	    			<td>
	    				<input type="hidden" id="deptName" name="deptName" />
	    				<select class="easyui-combotree select_txt" style="width:380px;"  id="deptId" name="deptId" >
						</select>
					</td>
				</tr>
	    		<tr>
	    			<td><span>&nbsp;</span>是否发布：</td>
	    			<td>
	    				<input id="isDeploy" class="easyui-switchbutton" onText="是" offText="否" >
					</td>
	    		</tr>				
			</table>
		</form>
	</div>
	<div id="dlg-buttons" class="window-tool" style="display:none;">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveOrUpdateSysNewsMg()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#sysNewsMgDialog').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 图片新增修改对话框 -->
	<div id="newsPicUpMgDialog" class="easyui-dialog" closed="true" data-options="modal:true" style="width:90%;height:90%;overflow-x:hidden;display:none;" buttons="#dlg-picUpMg" >
		<div class="">
			<div class="easyui-panel window-panel-header" style="width:100%;padding-left:10px;" title="选择图片 ">
				<!-- 工具栏 -->
				<div id="uploadBtn" class="tool_btn" style="padding-top:3px;">
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doUploadPic('1');" plain="true">添加本地图片</a>
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doUploadPic('2');" plain="true">添加外部图片</a>
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="previewSysNewsPicCarousel();" plain="true" iconCls="icon-isc-yl">轮播预览</a>			
				</div>			
			</div>
			<div class="easyui-panel" style="width:100%;padding-left:10px;" >		
				<!-- the pictures queue -->
				<div id="picsQueue" style="">
					<div id="picBlock" style="width:100px;height:110px;padding: 10px;float:left;display:none">
						<div >
							<a>
								<img class="picInQueue" alt="图片" style="width:80px;height:60px;">
							</a>
						</div>
						<!-- photo button -->
						<div>
							<a href="javascript:void(0)" class="showSysNewsPicBtn"  ><img class="selectBefore" style="border:0px;" >选择</a>
							<a href="javascript:void(0)" class="unshowSysNewsPicBtn"  ><img class="selectAfter" style="border:0px;">已选</a>
							<a href="javascript:void(0)" class="delSysNewsPicBtn" ><img class="delPic" style="border:0px;">删除</a>
						</div>
					</div>
				</div>
			</div>
			<div id="sysNewsPicInforList" class="easyui-panel window-panel-header" style="width:100%;padding-left:10px;" title="图片具体信息">
				<!-- the information of each photo -->
				<div id="sysNewsPicInforBlock" style="display:none;" >
					<form id="sysNewsPicInforBlockForm" method="post">
						<input id="sysNewsPicInforId" type="hidden" name="picId" >
						<table cellpadding="3">
				    		<tr>
				    			<td >图片标题<span style="color:red;vertical-align:middle;">*</span>：</td>
				    			<td ><input class="easyui-textbox" id="picTitle" required="true" type="text" name="picTitle" style="width:700px;"></input></td>
				    		</tr>
				    		<tr>
				    			<td>图片描述：</td>
				    			<td><input class="easyui-textbox" id="picDes" type="text" name="picDes"  style="width:700px;"></input></td>
				    		</tr>
				    		<tr id="sysPicLinkColumn">
				    			<td>图片链接：</td>
				    			<td><input class="easyui-textbox" id="picUrl" type="text" name="picUrl" style="width:700px;"></input></td>
				    		</tr>
				    		<tr>
				    			<td>图片内容：</td>
				    			<td>
				    				<!-- <input class="easyui-textbox" id="picContent" type="text" name="picContent" data-options="multiline:true" style="width:380px;"></input>  -->
				    				<div style="">
										<script id="sysNewsPicInforContent" name="picContent"  style="width:700px; height:500px">
										</script>
				    				</div>
				    			</td>
				    		</tr>
				    	</table>
					</form>
				</div>
			</div>
		</div>
	</div>
	<div id="dlg-picUpMg" class="window-tool" style="display:none;">
		<a href="javascript:void(0)" class="easyui-linkbutton picInforSaveBtn" onclick="previewSysNewsPicCarousel();" plain="true">预览</a>
		<a href="javascript:void(0)" id="picInforBlockSaveBtn" class="easyui-linkbutton picInforSaveBtn" onclick="doSavePicInfor();" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#newsPicUpMgDialog').dialog('close')" plain="true">关闭</a>
	</div>
	
	<!-- 上传图片Form表单 -->
	<div id="upLoadNewsPic" class="easyui-dialog"  closed="true" data-options="modal:true" style="width:920px;height:95%;display:none;"  buttons="#sysNewsPic-buttons">
		<div class="easyui-panel window-body" style="height: 100%;">
			<form id="upLoadNewsPicForm" method="post" class="window-form" enctype="multipart/form-data">
			<table>
				<tr>
					<table>
						<tr>
							<td>
								<table cellpadding="3" class="form-table">
						    		<tr>
						    			<td>图片标题<span style="color:red;vertical-align:middle;">*</span>：</td>
						    			<td>
						    				<input class="easyui-textbox" type="text" missingMessage="不能为空" id="picTitle" name="picTitle" style="width:400px;" />
						    			</td>
						    		</tr>
						    		<tr>
						    			<td >图片描述：</td>
						    			<td >
						    				<input class="easyui-textbox"  missingMessage="不能为空" type="text" id="picDes" name="picDes" data-options="validType:['length[0,50]']"  style="width:400px;" />
						    			</td>
						    		</tr> 
						    		<tr id="picLocalSelectInput">
						    			<td ></td>
						    			<td colspan="3">
											<input id="file" name="file" class="easyui-filebox" style="width:98%" onclick="alert(22);" data-options="prompt:'请选择一张图片...',onChange:fileOnchange" />
						    			</td>
						    		</tr>						    		
						    	</table>							
							</td>
							<td>
								<table cellpadding="3" class="form-table">
						    		<tr>
						    			<td id="uploadPicPreview" colspan="3">
											<img id="picResImg" alt="图片" width="350px" height="150px">
						    			</td>
						    		</tr>
						    	</table>							
							</td>
						</tr>
					</table>
				</tr>
				<tr >图片内容<span style="color:red;vertical-align:middle;">*</span>：</tr>
				<tr id="UEplugin">	
					<td>
						<div style="">
							<script id="localPicContentUE"  style="width:870px;height:500px">
							</script>
	  					</div>
  					</td>
				</tr>
			</table>	
			</form>
		</div>
	</div>
	<div id="sysNewsPic-buttons" class="window-tool" style="display:none;">
		<a id="saveSysNewsPicBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveSysNewsPic()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#upLoadNewsPic').dialog('close')" plain="true">取消</a>
	</div>
	
	<!-- 上传外部图片Form表单 -->
	<div id="upOutsideNewsPic" class="easyui-dialog"  closed="true" data-options="modal:true" style="width:920px;height:100%;display:none;"  buttons="#sysNewsPicoutside-buttons">
		<div class="easyui-panel window-body" style="height: 100%;">
			<form id="upLoadOutSideNewsPicForm" method="post" class="window-form" enctype="multipart/form-data">
				<table>
					<tr>
						<table>
							<tr>
								<td>
									<table cellpadding="3" class="form-table">
							    		<tr>
							    			<td>图片标题<span style="color:red;vertical-align:middle;">*</span>：</td>
							    			<td>
							    				<input class="easyui-textbox" type="text" required="true" missingMessage="不能为空" id="picTitle" name="picTitle" style="width:400px;" />
							    			</td>
							    		</tr>
							    		<tr>
							    			<td >图片描述：</td>
							    			<td >
							    				<input class="easyui-textbox" missingMessage="不能为空" type="text" id="picDes" name="picDes" data-options="validType:['length[0,50]']"  style="width:400px;" />
							    			</td>
							    		</tr> 
							    		<tr >
							    			<td >
							    				图片地址<span style="color:red;vertical-align:middle;">*</span>：
							    			</td>
							    			<td >
												<input id="picOutsideSelectInput" name="picPath" type="text" style="width:400px;" />
							    			</td>
							    		</tr>
							    	</table>							
								</td>
								<td>
									<table cellpadding="3" class="form-table">
							    		<tr>
							    			<td id="uploadPicPreview" colspan="3">
												<img id="picResImg" alt="图片" width="350px" height="160px">
							    			</td>
							    		</tr>
							    	</table>							
								</td>
							</tr>
						</table>					
					</tr>
		    		<tr>图片内容<span style="color:red;vertical-align:middle;">*</span>：</tr>					
		    		<tr>
		    			<td >
	    					<div style="">
								<script id="outsidePicContentUE"  style="width:870px;height:500px">
								</script>
    						</div>
		    			</td>
		    		</tr>
				</table>

			</form>
		</div>
	</div>
	<div id="sysNewsPicoutside-buttons" class="window-tool" style="display:none;">
		<a id="saveOutSysNewsPicBtn" href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveOutSysNewsPic()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#upOutsideNewsPic').dialog('close')" plain="true">取消</a>
	</div>	
</body>
	<script type="text/javascript" charset="utf-8" src="${ctx}/static/cap/plugins/UEditor1.4.4.3/ueditor.config.js"></script>
    <script type="text/javascript" charset="utf-8" src="${ctx}/static/cap/plugins/UEditor1.4.4.3/ueditor.all.js"> </script>
	<script type="text/javascript" charset="utf-8" src="${ctx}/static/cap/plugins/UEditor1.4.4.3/lang/zh-cn/zh-cn.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/sys/news/js/sysNewsMgList.js"></script>
</html>