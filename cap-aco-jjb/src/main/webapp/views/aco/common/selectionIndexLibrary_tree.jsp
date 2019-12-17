<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<script src="${ctx}/views/aco/dispatch/js/IndexLibrarySelectData.js"></script>

<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>

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
.IndexLibraryList_username{
	font-weight: 800; 
	/* font-size: xx-small; */
}
.IndexLibraryList_info{
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
.dataTables_length select.form-control{
	border: 1px #fff solid!important;
	-webkit-box-shadow: none;
    box-shadow: none;
    padding:0;
}
</style>
<body style="background-color: #f2f4f8;">
	<div id="selectionIndexLibrary_div" style="overflow: hidden; display: none;">
		<div class="btn-div" id="search-div">
			<div class="input-group">
				<input type="text" id="inputIndexLibrary-word" style="border: 1px #f2f4f8 solid;"
					class="form-control input-sm" value="请输入查询内容"
					onFocus="if (value =='请输入查询内容'){value=''}"
					onBlur="if (value ==''){value='请输入查询内容'}" 
					onkeyup=" if(event.keyCode==13) {IndexLibrary_search();}"> 
					<span class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="IndexLibrary_search()">
						<i class="fa fa-search"></i> 查询
					</button> 
					</span>
			</div>
		</div>
		<div id="selectIndexLibrary_table" style="margin: 10px;overflow: hidden;">
			<table id="IndexLibraryInfoList"  >
			</table>
		</div>
		
		<div style="text-align: center;">
		<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="IndexLibrary_select()">
						<i class="fa fa-search"></i>确定
		</button> 
		<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="IndexLibrary_close()">
						<i class="fa fa-search"></i>取消
		</button> 
		</div>
		
		
	</div>
	
	
</body>
</html>
