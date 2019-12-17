<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>测试接口</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<script type="text/javascript" src="${ctx}/views/cap/sys/intfc/js/intfcList.js"></script>
	
<script type="text/javascript">
	$(function() {
		var obj = ${arr};   
		
		$('#tb1').datagrid('loadData',obj);
	});
	
	function run(){
		var AjaxURL = "intfcController/run";
		$.ajax({
			type: "POST",
			url: AjaxURL,
			async: false,
			data: $('#ff').serialize(),
			success: function (data) {
				$("#content").html(data);
				$('#dlg').dialog('open');
			},
			error: function(data) {
				alert("执行失败！");
			}
		});
	}
</script>

</head>
<body>
	<form form id="ff" name="ff" method="post" novalidate class="window-form">
		<input type="hidden" id="id" name="intfc_id" value="${intfcInfo.id }">
		<div class="easyui-panel window-panel-header" style="width:100%;padding-left:10px;" title="接口基本信息">
			<table class="form-table">
				<tr>
					<td>接口名称:</td>
					<td><input class="easyui-textbox" value="${intfcInfo.intfcName }" readonly style="width:200px"></td>
					<td>请求方式:</td>
					<td><input class="easyui-textbox" value="${intfcInfo.reqMode }" readonly style="width:200px"></td>
				</tr>
				<tr>
					<td>接口类型:</td>
					<td><input class="easyui-textbox" value="${intfcInfo.intfcType }" readonly style="width:200px"></td>
					<td>实现方式:</td>
					<td><input class="easyui-textbox" value="${intfcInfo.impMode }" readonly style="width:200px"></td>
				</tr>
				<tr>
					<td>接口地址:</td>
	    			<td colspan="4"><input class="easyui-textbox" value=${intfcInfo.url } readonly style="height:32px;width:548px"></td>
				</tr>
				<tr>
					<td>方法名称:</td>
					<td><input class="easyui-textbox" value="${intfcInfo.method }" readonly style="height:32px;width:200px"></td>
					<td>系统名称:</td>
					<td><input class="easyui-textbox" value="${intfcInfo.sysName }" readonly style="height:32px;width:200px"></td>
				</tr>
				<tr>
					<td>备注:</td>
					<td colspan="4">
						<textarea  readonly rows="2" style="width:548px" >${intfcInfo.remark }</textarea>
					</td>
				</tr>
			</table>
		</div>
		<div class="easyui-panel" style="width:100%;padding-left:10px;" title="接口参数信息">
			<div style="height:auto;">
                  <table id="tb1" class="easyui-datagrid" style="width: 650px; height: 150px;"
					border="0"
					data-options="
			           rownumbers:false,
			           animate: true,
			           collapsible: true,
			           fitColumns: true,
			           method:'post',
					   ">
					<thead>
						<tr>
							<th data-options="field:'infoId',hidden:true">infoId</th>
							<th data-options="field:'sort',width:80,align:'center'">参数序号</th>
							<th data-options="field:'parmName',width:140,align:'center'">参数名称</th>
							<th data-options="field:'defValue',width:140,align:'center'">默认值</th>
							<th data-options="field:'remark',width:160,align:'center'">描述</th>
						</tr>
					</thead>
				</table>
			</div>
		</div>
		
		<table class="" id="">
				
			<c:forEach items="${list}" var="list">
                     <tr>
                         <td>${list.parmName}</td>
                         <td colspan="4"><input class="easyui-textbox" name="${list.parmName}"
					style="height:32px;width:350px" value=${list.defValue }></td>
                     </tr>
                  </c:forEach>
		</table>
		
		<!-- <div style="margin-top:20px" class="window-tool">
			<a onclick="run()" class="easyui-linkbutton"
				href="javascript:void(0)" plain="true">测试请求</a>&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:void(0)" plain="true" onclick="cancel()" class="easyui-linkbutton"
				>取消</a>&nbsp;&nbsp;&nbsp;&nbsp;
		</div> -->
	</form>
	
	<div id="dlg" class="easyui-dialog" title="测试结果" closed="true" data-options="modal:true"
		style="width: 430px; height: 350px; padding: 10px">
		<span style="margin-bottom: 5px;" id="content">
		</span> 
	</div>
</body>
</html>