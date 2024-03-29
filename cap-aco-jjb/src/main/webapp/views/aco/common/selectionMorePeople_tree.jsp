<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<script src="${ctx}/views/aco/dispatch/js/peopleMoreSelectData.js"></script>
<link rel="stylesheet" rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/css/keyTable.bootstrap.css">
<link href="${ctx}/static/cap/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/dataTables.bootstrap.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/dataTables.keyTable.js"></script>

<style>
.row {
	margin-left: 0;
	margin-right: 0;
}

.table {
	margin-bottom: 2px;
}

.dataTables_scrollHead {
	height: 0px;
}

.PeopleMoreList_username {
	font-weight: 800;
	/* font-size: xx-small; */
}

.PeopleMoreList_info {
	/* font-size: xx-small;  */
	float: right;
	margin-right: 20px;
}

.col-sm-7, .col-sm-5 {
	width: 80%;
}

.ztree li {
	margin-top: 10px;
}

.dataTables_length select.form-control {
	border: 1px #fff solid !important;
	-webkit-box-shadow: none;
	box-shadow: none;
	padding: 0;
}

.choosePeople {
	margin-left: 62%;
	margin-top: 5px;
	border: 1px solid #f2f4f8;
	width: 36%;
	height: 300px;
	word-wrap: break-word;
	word-break: break-all;
}

.choosePeople span.choosePeople_span {
	background-color: #f2f4f8;
	color: black;
	line-height: 2;
	white-space: pre-line;
	margin: 3px;
	float: left;
	padding:2px 10px;
}
.choosePeople span.label{
	width:auto;
	height:auto;
}
.footer-btn{
	text-align: center;
	clear:both;  
	position: absolute;
	bottom: 5px;
	border-top: 1px solid #DDD;
	width: 100%;
	padding-top: 5px;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
<body style="background-color: #f2f4f8;">
	<div id="selectionPeopleMore_div"
		style="overflow: hidden; display: none;">
		<div class="btn-div" id="search-div">
			<div class="input-group">
				<input type="text" id="inputPeopleMore-word"
					style="border: 1px #f2f4f8 solid;" class="form-control input-sm"
					value="请输入查询内容" onFocus="if (value =='请输入查询内容'){value=''}"
					onBlur="if (value ==''){value='请输入查询内容'}"
					onkeyup=" if(event.keyCode==13) {PeopleMore_search();}"> <span
					class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm"
						style="margin-right: 0px" onclick="PeopleMore_search()">
						<i class="fa fa-search"></i> 查询
					</button>
				</span> <span class="input-group-btn" id="buttonPeopleMore_reply"
					style="padding-left: 2px;display: none;">
					<button type="button" class="btn btn-primary btn-sm"
						style="margin-right: 0px;" onclick="PeopleMore_reply()">
						<i class="fa fa-mail-reply"></i> 返回选择树
					</button>
				</span>
			</div>
		</div>
		<div
			style="width: 60%; height:300px; float: left; border:1px solid #f2f4f8; margin-left: 5px; margin-top: 5px; overflow: auto;">
			<div id="selectPeopleMore_div">
				<ul id="selectPeopleMore_tree" class="ztree"
					style="margin-top: 5px;"></ul>
			</div>
			<div id="selectPeopleMore_table"
				style="display: none; margin: 10px;overflow: hidden; border: 1px; ">
				<table id="PeopleMoreInfoList"
					class="table table-striped table-bordered" cellspacing="0"
					width="100%">
					<thead>
						<tr>
							<th>隐藏人员ID</th>
							<th>隐藏人员姓名</th>
							<th>人员姓名岗位公司展示列</th>
						</tr>
					</thead>
				</table>
			</div>
		</div>
		<div class="choosePeople" id="choosePeople_div"></div>
		<div class="footer-btn">
			<button type="button" class="btn btn-primary btn-sm"
				style="margin-right: 0px" onclick="IndexLibrary_select()">
				确定
			</button>
			<button type="button" class="btn btn-primary btn-sm"
				style="margin-right: 0px" onclick="IndexLibrary_close()">
				取消
			</button>
		</div>
	</div>



</body>
</html>
