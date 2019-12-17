<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>zTree部门人员树</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
	<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery-1.4.4.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
	<script type="text/javascript">
		var setting = {
			async:{
				enable:true,
				dataType:"json",
				type:"post",
				url:"${ctx}/treeController/getDeptUser",
				autoParam:["id","pId"],
				idKey:"id",
				pIdKey:"pId",
				rootPId:0
			},
			callback:{
				onClick:zTreeOnClick
			}
		};
		$(document).ready(function() {
			$.fn.zTree.init($("#tree"),setting);
		});
		function zTreeOnClick(event,treeId,treeNode) {
			if (!treeNode.isParent) {
				alert(treeNode.id+":"+treeNode.name);
			}
		};
	</script>
</head>
	<body style="text-align: center;background-color: #f9f9f9;">
		<table style="border: 0px;width:400px;">
			<tr style="background-color: #f4f4f4;border:1px solid #ececec;">
				<td style="vertical-align: middle;"  width="50%">
					<ul id="tree" class="ztree" style="height: 300px;"></ul>
				</td>
			</tr>
		</table>
	</body>
</html>