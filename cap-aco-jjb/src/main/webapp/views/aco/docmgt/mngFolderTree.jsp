<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>个人文件夹</title>
	<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
	<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/views/aco/docmgt/css/zTreeRightClick.css" />
	<%-- <script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery-1.4.4.min.js"></script> --%>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
	<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.min.js"></script>
	<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.min.js"></script>
	<script src="${ctx}/views/aco/docmgt/js/zTreeRightClick.js"></script>
	
	<script type="text/javascript">
	var chooseNode="";
	var setting = {
		data: {
			simpleData: {
				enable: true,
				idKey: "id",
				pIdKey: "pId",
				rootPId: 0
			}
		},
		callback:{
			onRightClick: OnRightClick,
			onClick:zTreeOnClick
		}
	
	};
	
	var zTree, rMenu;
	$(document).ready(function() {
		$.fn.zTree.init($("#folderTree"), setting,${treeList});
		zTree = $.fn.zTree.getZTreeObj("folderTree");
		rMenu = $("#rMenu");
	});
	
	function zTreeOnClick(event,treeId,treeNode){
		chooseNode=treeNode.id;
	}
	
	//增加节点
	function addTreeNode() {
		hideRMenu();
		$("#myModal").modal("show");
		$('#newnode').attr("src","${ctx}/docmgt/toNewNodeInfo");
	}
	
	//保存节点信息
	function saveFolderInfo(){
		document.getElementById("newnode").contentWindow.saveFolderInfo();
		var name=document.getElementById("newnode").contentWindow.name;
		var id=document.getElementById("newnode").contentWindow.id;
		if(name!=""&&name!=null){
			var newNode = {name:name,id:id};
			if (zTree.getSelectedNodes()[0]) {
				newNode.checked = zTree.getSelectedNodes()[0].checked;
				zTree.addNodes(zTree.getSelectedNodes()[0], newNode);
			} else {
				zTree.addNodes(null, newNode);
			}
		}
		$("#myModal").modal("hide");
	}
</script>
<style type="text/css">
table tr td {
	background-color: #f4f4f4;
	border: 1px solid #ececec;
}
.sendbtn{
	height:25px;
	width:50px;
	background-color: #CA2320;
	color:#fff;
	font-family:Microsoft YaHei;
	border: #d4d4d4 1px solid;
}
.ztree li a:hover {background:none;text-decoration:none}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="text-align: center;background-color: #f9f9f9;">
	<input type="hidden" id="folder_id" name="folder_id">
	<input type="hidden" id="folder_name" name="folder_name">
	<!-- <div class="container-fluid" style="padding:0;">
        <div class="folder_tree" id="folder_tree">
			<ul id="folderTree" class="ztree" style="height: 98%;"></ul>
		</div>
	</div> -->
	<table style="border: 0px;width:400px;">
		<tr style="background-color: #f4f4f4;border:1px solid #ececec;">
			<td style="vertical-align: middle;"  width="50%">
				<ul id="folderTree" class="ztree" style="height: 400px;"></ul>
			</td>
		</tr>
	</table>
	<div id="rMenu">
		<ul>
			<li id="m_add" onclick="addTreeNode();">增加节点</li>
		</ul>
	</div>
	<!-- 节点新增 -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">
					新增节点基本信息
					</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="newnode" runat="server" src="" width="100%" height="350" frameborder="no" border="0" marginwidth="0"
						 marginheight="0" scrolling="no" allowtransparency="yes"></iframe>
					</div>
					<div class="modal-footer" style="text-align: center;">
				        <button type="button" class="btn btn-primary" onclick="saveFolderInfo()">确定</button>
				    </div>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
</body>

</html>