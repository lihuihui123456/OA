<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<%@ include file="/views/aco/common/head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>	
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.js"></script>
<script type="text/javascript">
var ids='';
var setting = {
       check: {
			 enable: true,
			 chkStyle: "checkbox",               //多选  
	         chkboxType: { "Y" : "", "N" : "" }  //不级联父节点选择 ,
			},
		data : {
			simpleData : {
				enable : true,
				idKey : "id",
				pIdKey : "pId",
				rootPId : 0,
			}
		},
		callback: {
			onClick: zTreeOnClick
		}
	};
	$(document).ready(function() {
		//ztree初始化
		 $.fn.zTree.init($("#folderTree"), setting,${treeList});
		 zTree = $.fn.zTree.getZTreeObj("folderTree");
                     var nodes = zTree.getNodes();
                     for (var i = 0; i < nodes.length; i++) { //设置节点展开
                          zTree.expandNode(nodes[i], true, false, false);
    }
});

function zTreeOnClick(event, treeId, treeNode){
	if(treeNode.checked){
		//选中取消
		zTree.checkNode(treeNode, false);
	}else{
		//选中
		zTree.checkNode(treeNode, true);
	}
}
//保存关联信息
function saveAttach(){
var treeObj=$.fn.zTree.getZTreeObj("folderTree");
            nodes=treeObj.getCheckedNodes(true);
            for(var i=0;i<nodes.length;i++){
            ids+=nodes[i].id + ",";
            }
	return ids;
}

</script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
</head>
<body>
 <div class="panel-body" style="padding-bottom:0px;border:0;'">
 <div style="width: 300px; float: left;">
 <ul id="folderTree" class="ztree"></ul>
 </div>
  </body>
</html>