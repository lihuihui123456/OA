<%@ page contentType="text/html;charset=UTF-8"%>
	
	<shiro:hasPermission name="on:msgpushController:msgpush">
		<shiro:hasPermission name="im:msgpushController:msgpush">
		<!-- 即时通讯好友重命名modal -->
		<div class="modal fade" id="im_freind_rename" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">×</button>
						<h4 class="modal-title" id="myModalLabel">
							联系人重命名
						</h4>
					</div>
					<div class="modal-body" style="text-align: center;">
						<form id="im_rename_form">
							<input type="text" id="im_rename_group" style="display:none;"> 
							<div class="form-group">
								<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">原名:</label>
								<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
									<input type="text" id="orignal_name" disabled="true ">
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">昵称:</label>
								<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
									<input type="text" id="new_name" class="validate[required]">
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
							<button class="btn btn-primary btn-sm" onClick="IMRenameFreind();">保存</button>
							<!-- <button class="btn btn-primary btn-sm" onClick="closeThemeDialog();">关闭</button> -->
					</div>
					
				</div>
			</div>
		</div>
		<!-- 即时通讯好友重命名modal -->
		<div class="modal fade" id="im_group_rename" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">×</button>
						<h4 class="modal-title" id="myModalLabel">
							联系人分组重命名
						</h4>
					</div>
					<div class="modal-body" style="text-align: center;">
						<form id="im_rename_form">
							<input type="text" id="im_rename_group" style="display:none;"> 
							<div class="form-group">
								<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">原组名:</label>
								<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
									<input type="text" id="orignal_name" disabled="true ">
								</div>
							</div>
							<div class="form-group">
								<label class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">新组名:</label>
								<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
									<input type="text" id="new_name" class="validate[required]">
								</div>
							</div>
						</form>
					</div>
					<div class="modal-footer">
							<button class="btn btn-primary btn-sm" onClick="IMRenameGroup();">保存</button>
					</div>
					
				</div>
			</div>
		</div>
		
		<!-- 即时通讯添加好友请求modal -->
		<div class="modal fade" id="im_add_freind_request" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">×</button>
						<h4 class="modal-title" id="myModalLabel">
							添加好友请求
						</h4>
					</div>
					<div class="modal-body" style="text-align: center;">
						<table id="req_list_table">
						</table>
					</div>
					<div class="modal-footer">
							<!-- <button class="btn btn-primary btn-sm" onClick="IMAddFreindRequ();">保存</button> -->
					</div>
				</div>
			</div>
		</div>
		</shiro:hasPermission>
	</shiro:hasPermission>
	
	<!-- 引入即时通讯JS和CSS文件  update by 张多一 2017.04.17-->
	<!-- 放在消息提醒加载js的后面，确保后于消息提醒js执行 -->
	<!-- 放在body的后面，确保js后渲染 -->
	<shiro:hasPermission name="on:msgpushController:msgpush">
		<shiro:hasPermission name="im:msgpushController:msgpush">
			<link href="${ctx}/static/cap/plugins/layim/layim.css" rel="stylesheet">
			<%-- <script src="${ctx}/static/cap/plugins/layim/layer-v1.8.5/layer-v1.8.5.js"></script> --%>
			<script type="text/javascript" src="${ctx}/static/cap/plugins/layim/connector.js"></script>
			<script type="text/javascript" src="${ctx}/static/cap/plugins/layim/layim.js"></script>
			<%-- 如果单独部署及时通讯需要打开以下内容 -->
	<%-- 		<script type="text/javascript" src="${ctx}/static/cap/plugins/msgpush/pushAPI.js"></script>
			<script type="text/javascript" src="${ctx}/static/cap/plugins/msgpush/strophe.js"></script> --%>
			<!-- 即时通讯参数配置 -->
		</shiro:hasPermission>
	</shiro:hasPermission>