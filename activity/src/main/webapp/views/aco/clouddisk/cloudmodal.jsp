<%@ page contentType="text/html;charset=UTF-8"%>
<!-- 新增文件夹-->
<div class="modal fade" id="modal_add" tabindex="-1" role="dialog"
	aria-labelledby="modal_add" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			 <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<h4 class="modal-title" id="modal_add_title">新增文件夹</h4>
			</div> 
			<div class="modal-body cloud-add-body" style="text-align: center;">
				<div class="input-group cloud-addfolder">
					<span class="input-group-addon" >文件夹名称&nbsp;&nbsp;&nbsp;</span>
		 			<input type="text" id="input_add" name="input_add" class="form-control" placeholder="请输入文件夹的名称" >
				</div>
			</div>
			<div class="modal-footer" style="text-align: center;">
				<button type="button" class="btn btn-primary" id="onAdd">保存</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal">取消</button>
			</div>
		</div>
	</div>
</div>


<!-- 选择人员 -->
	<div class="modal fade" id="chooseUserDiv" tabindex="-1" role="dialog"
		aria-labelledby="chooseUserDiv" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="c">人员选择</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="chooseUser_iframe" runat="server" src="" width="100%"
							height="450" frameborder="no" border="0" marginwidth="0"
							marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
					</div>
					<div class="modal-footer" style="text-align: center;">
						<button type="button" class="btn btn-primary" onclick="makesure()">确认</button>
						<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
	</div>

<div class="modal fade" id="modal_log" tabindex="-1" role="dialog"
	aria-labelledby="modal_log" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content log-content">
			 <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<h4 class="modal-title" id="modal_look_title">文件详情</h4>
				
			</div> 
			<div class="modal-body">
			<div class="log-detail">
				<p><span style="font-weight: bold;">文件名称</span></span><span style="margin-left:10px;"id="log-fileName"></span></p>
				<p><span style="font-weight: bold;">文件大小</span><span style="margin-left:10px;"id="log-fileSize"></span></p>
		   		<p><span style="font-weight: bold;">上传用户</span><span style="margin-left:10px;"id="log-fileOwnerName"></span></p>
		    	<p><span style="font-weight: bold;">上传时间</span><span style="margin-left:10px;"id="log-fileDate"></span></p>
				<p><span style="font-weight: bold;">下载次数</span><span style="margin-left:10px;"id="log-fileCount"></span></p>
				<p><span style="font-weight: bold;">文件权限</span><span style="margin-left:10px;" id="log-fileAuth"></span></p>
			</div>
				<table id="logList"></table>
			</div>
			<div class="modal-footer" style="text-align: center;">
					<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="modal_rename" tabindex="-1" role="dialog"
	aria-labelledby="modal_rename" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			 <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<h4 class="modal-title" id="modal_look_title">重命名</h4>
				
			</div> 
			<div class="modal-body">
				<div class="input-group">
					<span class="input-group-addon" >文件夹名称</span>
		 			<input type="text" id="input_rename" name="input_rename" class="form-control" placeholder="请输入文件夹的名称" >
				</div>
			</div>
			<div class="modal-footer" style="text-align: center;">
				<button type="button" class="btn btn-primary" id="onRename">保存</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="modal_detail" tabindex="-1" role="dialog"
	aria-labelledby="modal_detail" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			 <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<h4 class="modal-title" id="modal_detail_title">文件详情</h4>
				
			</div> 
			<div class="modal-body">
				<div class="detail-row">
					<span class="detail-title">文件名</span><span class="detail-text"><span id="fileName"></span></span>
				</div>
				<div class="detail-row">
					<span class="detail-title">文件大小</span><span class="detail-text"><span id="fileSize"></span></span>
				</div>
				<div class="detail-row">
					<span class="detail-title">上传用户</span><span class="detail-text"><span id="fileOwnerName"></span></span>
				</div>
				<div class="detail-row">
					<span class="detail-title">上传时间</span><span class="detail-text"><span id="fileDate"></span></span>
				</div>
				<div class="detail-row">
					<span class="detail-title">下载次数</span><span class="detail-text"><span id="fileCount"></span></span>
				</div>
			</div>
			<div class="modal-footer" style="text-align: center;">
				<!-- <button type="button" class="btn btn-primary" id="onRename">保存</button> -->
				<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div>
</div>

<!-- <div class="modal fade" id="modal_upload" tabindex="-1" role="dialog"
	aria-labelledby="modal_upload" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog">
		<div class="modal-content">
			 <div class="modal-header" style="overflow: hidden;">
				<button type="button" class="close" id="closeUploadIcon"
					aria-hidden="true">×</button>
				<h4 class="modal-title" id="modal_detail_title" >文件上传</h4>
			</div> 
			<div class="modal-body">
				<div class="detail-row">
					<span class="detail-title">文件夹名称</span><span class="detail-text"><span id="upLoadFileName"></span></span>
				</div>
				<div>
				<div id="uploading-console"><span id="uploading-console-filename"></span><span id="uploading-console-status"></span></div>
				<div><span id="uploading-size"></span><span id="uploading-time"></span><span id="uploading-speed"></span></div>
				<div class="progress">
				  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="min-width: 2em;">
				    0%
				  </div>
				</div>
				</div>
			</div>
			<div class="modal-footer" style="text-align: center;" id="container">
				<div class="btn btn-primary" id="pickFiles"><i class="fa fa-cloud-upload"></i>上传</div>
			 	<button type="button" class="btn btn-primary" id="onUpload"><i class="fa fa-arrow-circle-up "></i>上传</button>
				<button type="button" class="btn btn-primary" id="closeUploadBtn" >关闭</button>
			</div>
		</div>
	</div>
</div> -->
<div class="modal fade" id="file_share_detail" tabindex="-1" role="dialog" 
	aria-labelledby="file_share_detail" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog" style="width:800px">
		<div class="modal-content">
			 <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<h4 class="modal-title" id="modal_detail_title">分享详情</h4>
				
			</div> 
			<div class="modal-body">
				<table id="tableShareList">
				</table>
				<input type="hidden" id="hideValShare"/>
			</div>
			<div class="modal-footer" style="text-align: center;" id="containerShare">
				<button type="button" id="onCancelShare"class="btn btn-primary" ><i class="fa fa-ban"></i>取消共享</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="file_share_auth" tabindex="-1" role="dialog" 
	aria-labelledby="file_share_auth" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog">
		<div class="modal-content">
			 <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<h4 class="modal-title" id="modal_detail_title">文件权限</h4>
				
			</div> 
			<div class="modal-body">
				 <div class="cloud-setAuth">
				<div class="cloud-share">
				<div class="cloud-test">
					<div class="cloud-test-left">
						<div id="cloud-auth-console">
						</div>
					</div>
					<div class="cloud-test-right">
						<ul>
							<button id="btnAddAll" type="button" class="btn btn-primary btn-sm">
							<span class="fa fa-users" aria-hidden="true"></span>添加所有人
							</button>
							<button id="btnAddDept" type="button" class="btn btn-primary btn-sm">
							<span class="fa fa-university" aria-hidden="true"></span>添加部门
							</button>
							<button id="btnAddUsers" type="button" class="btn btn-primary btn-sm">
							<span class="fa fa-user-plus" aria-hidden="true"></span>添加用户
							</button>
							 <button id="btnRemove" type="button" class="btn btn-primary btn-sm">
							<span class="fa fa-user-times" aria-hidden="true"></span>移除选定
							</button>
							<button id="btnRemoveAll" type="button" class="btn btn-primary btn-sm">
							<span class="fa fa-times" aria-hidden="true"></span>清空所有
							</button> 
							<input id="selectUserId_" class="form-control select" name="selectUserId_"
											type="hidden" style="width: 100%; height: 29; border: 0;" />
							<input id="selectUserIdName_" class="form-control select" name="selectUserIdName_"
							type="hidden" style="width: 100%; height: 29; border: 0;" />
							<input id="selectDeptId_" class="form-control select" name="selectDeptId_"
											type="hidden" style="width: 100%; height: 29; border: 0;" />
							<input id="selectDeptIdName_" class="form-control select" name="selectDeptIdName_"
							type="hidden" style="width: 100%; height: 29; border: 0;" />
						</ul>
					</div>
				</div>
				<div class="cloud-auth">
				 	<fieldset>
				 		<legend>对此文档拥有的权限</legend>
				 		<ul>
				 			<li>
				 				<span><i class="fa fa-eye"></i>是否可见</span>
				 				<label><input class="radio-auth" type="radio" value="ban" name="onSee" />禁止</label>
				 				<label><input class="radio-auth" type="radio" value="allow" name="onSee" />允许</label>
				 			</li>
				 			<li>
				 				<span><i class="fa fa-plus-square"></i>新建文件夹</span>
				 				<label><input class="radio-auth" type="radio" value="ban" name="beforeAdd" />禁止</label>
				 				<label><input class="radio-auth" type="radio" value="allow" name="beforeAdd" />允许</label>
				 			</li>
				 			<li>
				 				<span><i class="fa fa-pencil-square"></i>重命名文件</span>
				 				<label><input class="radio-auth" type="radio" value="ban" name="beforeRename" />禁止</label>
				 				<label><input class="radio-auth" type="radio" value="allow" name="beforeRename" />允许</label>
				 			</li>
				 			<li>
				 				<span><i class="fa fa-list"></i>查看详情列表</span>
				 				<label><input class="radio-auth" type="radio" value="ban" name="onShowLog" />禁止</label>
				 				<label><input class="radio-auth" type="radio" value="allow" name="onShowLog" />允许</label>
				 			</li>
				 			<li>
				 				<span><i class="fa fa-upload"></i>上传文件</span>
				 				<label><input class="radio-auth" type="radio" value="ban" name="buttonUpload" />禁止</label>
				 				<label><input class="radio-auth" type="radio" value="allow" name="buttonUpload" />允许</label>
				 			</li>
				 			<li>
				 				<span><i class="fa fa-download "></i>下载文件</span>
				 				<label><input class="radio-auth" type="radio" value="ban" name="buttonDownload" />禁止</label>
				 				<label><input class="radio-auth" type="radio" value="allow" name="buttonDownload" />允许</label>
				 			</li>
				 			<li>
				 				<span><i class="fa fa-trash"></i>删除文件</span>
				 				<label><input class="radio-auth" type="radio" value="ban" name="btnDelete" />禁止</label>
				 				<label><input class="radio-auth" type="radio" value="allow" name="btnDelete" />允许</label>
				 			</li>
				 			<li>
				 				<span><i class="fa fa-cogs"></i>修改文件权限</span>
				 				<label><input class="radio-auth" type="radio" value="ban" name="btnShareAuth" />禁止</label>
				 				<label><input class="radio-auth" type="radio" value="allow" name="btnShareAuth" />允许</label>
				 			</li>
				 		</ul>
				 	</fieldset>
				 </div>
			</div>
			</div>
			</div>
			
			<div class="modal-footer" style="text-align: center;">
				<button type="button" id="onSaveAuth"class="btn btn-primary" ><i class="fa fa-ban"></i>保存</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div>
</div>
 <div class="modal fade" id="modal_images" tabindex="-1" role="dialog" 
	aria-labelledby="modal_images" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog" style="width:1100px">
		<div class="modal-content">
			 <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<h4 class="modal-title" id="modal_detail_title">图片预览</h4>
				
			</div> 
			<div class="modal-body">
				<iframe width="100%" height="100%"src="${ctx}/views/aco/clouddisk/cloudswiper.jsp" id="cloud-swiper" frameborder="0" scrolling="no"></iframe>
			</div>
		</div>
	</div>
</div> 