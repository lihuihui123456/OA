<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>个人文件夹</title>
	<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
	<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
	<%-- <script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery-1.4.4.min.js"></script> --%>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
	<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.min.js"></script>
	<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.min.js"></script>
	
	<script type="text/javascript">
	
	var setting = {
		check: {
			enable: true,
			chkboxType : { "Y" : "", "N" : ""}
		},
		data: {
			simpleData: {
				enable: true,
				idKey: "id",
				pIdKey: "pId",
				rootPId: 0
			}
		},
		callback:{
			//onClick:zTreeOnClick,
			onCheck: zTreeOnCheck
		}
	
	};
	
	$(document).ready(function() {
		$.fn.zTree.init($("#folderTree"), setting,${treeList});
	});
	
	/* function zTreeOnClick(events,treeId,treeNode){
		org[0]=treeNode.id;
		org[1]=treeNode.name;
	} */
	

	var org = new Array();
	function zTreeOnCheck(e, treeId, treeNode) {
		var treeObj=$.fn.zTree.getZTreeObj("folderTree");
        var nodes=treeObj.getCheckedNodes(true);
        var name="";
        var id="";
        for(var i=0;i<nodes.length;i++){
        	id+=nodes[i].id+",";
        	name+=nodes[i].name + ",";
        }
		org[0]=id.substring(0,id.length-1);
		org[1]=name.substring(0,name.length-1);
	}
	
	function chooseOrg(){
		return org;
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
</head>
<body style="text-align: center;background-color: #f9f9f9;">
	<table style="border: 0px;width:400px;">
		<tr style="background-color: #f4f4f4;border:1px solid #ececec;">
			<td style="vertical-align: middle;"  width="50%">
				<ul id="folderTree" class="ztree" style="height: 300px;"></ul>
			</td>
		</tr>
	</table>
</body>

</html>