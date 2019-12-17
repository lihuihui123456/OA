<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>选择部门岗位人员</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/org/js/selectDeptPostTree.js"></script>
	
</head>

<body> 
	
	<div data-options="region:'center',split:true,collapsible:false" class="page_menu">
		<!-- 部门机构岗位树 -->
		<div >
			<ul class="easyui-tree" id="dept_post_tree" ></ul>
		</div>
	</div>
</body>
</html>