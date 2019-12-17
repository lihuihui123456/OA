<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>新增流程模块绑定</title>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/bpm/procdefmgr/js/procdefmgr.js"></script>
</head>
<body>

	<div style="overflow: auto;height: 300px">
		<form id="procdsgnInfo" class="window-form">
			<table class="table-style">
				<tr>
					<th colspan="4">流程模块绑定</th>
				</tr>
				<tr>
					<td style="width:18%">模块名称：<span class="input-must">*</span></td>
					<td>
						<input class="easyui-textbox" id="modelName" name="modelName" value="">
					</td>
					<td style="width:18%">模块链接：<span class="input-must">*</span></td>
					<td>
						<input class="easyui-textbox" id="modelUrl" name="modelUrl" value="">
					</td>
				</tr>
				<tr>
					<td style="width:18%">流程解决方案：<span class="input-must">*</span></td>
					<td colspan="3">
						<input id="solCtlgTree" name="solCtlgTree" value="">
					</td>
				</tr>
			</table>
		</form>
		<div class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" onclick="formSubmit()"  plain="true">保存</a>
		</div>
	</div>
	<script type="text/javascript">
	$(function(){
		$('#solCtlgTree').combotree({
		    url: '../solutionCfgController/findSolCtlgTree',
		    required: true
		});
	});
	</script>
</body>
</html>