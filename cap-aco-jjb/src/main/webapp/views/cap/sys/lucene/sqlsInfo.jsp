<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>添加sql语句</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/sqlsInfo.js"></script>

	<script type="text/javascript">
		var dbsid = ${dbsid}
	</script>
	<style type="text/css">
       * {
        	font-size:12px;
       } 
	</style>
	


</head>
<body>
		<div class="easyui-panel" style="padding-left:10px;">
			<form id="ff" name="ff" method="post" novalidate>
				<input type="hidden" id="rows" name="rows">
				<input type="hidden" id="typeId" name="typeId">
				<table class="">
					<tr>
						<td>数据库ID:</td>
						<td colspan="4"><input class="easyui-textbox" id="dbsid" name="dbsid" value = ${dbsid}
							style="height:32px;width:100%"></td>
					</tr>
						<td>sql语句:</td>
						<td><input class="easyui-textbox" id="sql" name="sql"
							style="height:32px;width:100%"></td>
					</tr>
				</table>
				
				<a onclick="doSaveSqlInfo()" class="easyui-linkbutton" iconCls="icon-ok"
					style="width:150px;height:32px">保存</a>
			</form>
		</div>
		</div>
	</div>
</body>
</html>