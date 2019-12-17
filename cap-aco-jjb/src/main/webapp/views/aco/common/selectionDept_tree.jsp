<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<script src="${ctx}/views/aco/dispatch/js/deptSelectData.js"></script>
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/css/keyTable.bootstrap.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/dataTables.bootstrap.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/dataTables.keyTable.js"></script>
<style>
.row {
	margin-left: 0;
	margin-right: 0;
}
.table {
    width: 100%;
    margin-bottom: 2px;
}
.dataTables_scrollHead{
	height: 0px;
}
.deptList_deptname{
	font-weight: 800; 
	/* font-size: xx-small; */
}
.deptList_info{
	/* font-size: xx-small;  */
	float: right; 
	margin-right: 20px;
}
.col-sm-7,.col-sm-5{
	width: 80%;
}
.ztree li{
	margin-top: 10px;
}
</style>
<body style="background-color: #f2f4f8;">
	<div id="selection_div" style="overflow: hidden; display: none;">
		<div class="btn-div">
			<div class="input-group">
				<input type="text" id="inputdept-word" style="border: 1px #f2f4f8 solid;"
					class="form-control input-sm" value="请输入查询内容"
					onFocus="if (value =='请输入查询内容'){value=''}"
					onBlur="if (value ==''){value='请输入查询内容'}"
					onkeyup=" if(event.keyCode==13) {dept_search();}"> 
					<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="dept_search()">
						<i class="fa fa-search"></i> 查询
					</button> 
					</span>
					<span class="input-group-btn"  id="button_reply"  style="padding-left: 2px;display: none;"  >
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px;" onclick="dept_reply()">
						<i class="fa fa-mail-reply"></i> 返回选择树
					</button> 
					</span>
			</div>
		</div>
	<div id="selectDept_div">
	<ul id="selectDept_tree" class="ztree" style="margin-top: 5px;overflow:hidden;"></ul>
	</div>
		<div id="selectdept_table"  style="display: none; margin: 10px;overflow: hidden;">
			<table id="deptInfoList"  class="table table-striped table-bordered" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th>隐藏部门ID</th>
						<th>隐藏部门名称</th>
						<th>部门上级部门展示列</th>
					</tr>
				</thead>
			</table>
		</div>
	</div>
	
	
	
</body>
</html>
