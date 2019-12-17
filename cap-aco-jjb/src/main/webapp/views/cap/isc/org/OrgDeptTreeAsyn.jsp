<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>办公系统</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/org/js/OrgDeptTreeAsyn.js"></script>
</head>
<body>
		<div data-options="region:'center',split:true,collapsible:false" class="page_menu">
			<!-- 部门机构树 -->
			<div >
				<ul class="easyui-tree" id="org_dept_tree" />
			</div>
		</div>
</body>
</html>