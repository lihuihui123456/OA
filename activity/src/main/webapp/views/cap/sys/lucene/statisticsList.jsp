<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>用户检索统计分析</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/statisticsList.js"></script>
	<script type="text/javascript" src="${ctx }/static/cap/plugins/echarts/echarts.min.js"></script>
	<style type="text/css">
       * {
        	font-size:14px;
       } 
	</style>
</head>

<body class="easyui-layout" style="width: 100%; height: 98%;">
	<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolBar" class="clearfix">
				<table >
					<tr>
						<td>
							<shiro:hasPermission name="chart:timerController:statisticsList">
								<a href="javascript:openEchartsDlg();" class="easyui-linkbutton" style="width:80px">统计图表</a>				
							</shiro:hasPermission>
						</td>
					</tr>
					<tr></tr>
				</table>
		</div>
		<!-- 列表 -->
		<table class="easyui-datagrid" id="dtList" data-options="view : dataGridExtendView,emptyMsg : '没有相关记录！',
			idField:'id', method:'post', toolbar:'#toolBar',striped:true,fitColumns:true,fit:true,rownumbers:true,pagination:true,showFooter:true,nowrap:false">
			<thead>
				<tr>
					<!-- <th data-options="field:'ck', checkbox:true"></th> -->
					<th data-options="field:'keyWord', width:180, align:'center'">搜索关键词</th>
					<th data-options="field:'number', width:180, align:'center'">搜索次数</th>
				</tr>
			</thead>
		</table>
	</div>
	<!-- 图表弹出框 -->
	<div id="echartsDialog" class="easyui-dialog"  closed="true" data-options="modal:true" title="检索统计图" style="width:600px;height:400px;" buttons="#dlg-buttons">
		<div id="echartsDiv" style="width: 100%;height:90%;margin-top:20px"></div>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#echartsDialog').dialog('close')" plain="true">取消</a>
	</div>
</body>
</html>