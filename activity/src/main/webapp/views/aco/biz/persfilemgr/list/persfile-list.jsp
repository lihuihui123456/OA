<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>人事管理</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script
	src="${ctx}/views/aco/biz/persfilemgr/list/js/persfile-list.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
	var solId = '${solId}';
		$(function() {
			addOption(initDict('deptType'));
	        addOptions(initDict('postType'));
	        			//导出excel
	$('#export_excel_btn').click(function() {
		//判断是否有选中
		var obj = $('#persFileTable').bootstrapTable('getSelections');
		if (obj.length!=''||obj.length>=1) {
		   var selectid="";
		  $.each(obj, function(i,val){ 
		            if(i==0){
		            selectid=val.id
		            }else{
		            selectid=selectid+","+val.id;
		            }
		  });
		 $("#selectIds").val(selectid);
		}else{
			$("#selectIds").val("");
		}	
		if($("#input-word").val()!="请输入姓名查询"&&$("#input-word").val()!=""){
			var USER_NAME=$("#input-word").val();
			$("#ff")[0].reset();
			$("#USER_NAME").val(USER_NAME);
		}
/* 		var url = "persFileController/exportExcel?selectIds="+$('#selectIds').val()+"&queryParams="+$("#ff").serialize();
		var aLink = document.createElement('a');
	    aLink.href =url;
	    aLink.click();	 */
	    window.location.href = "${ctx}/persFileController/exportExcel?selectIds="+$('#selectIds').val()+"&queryParams="+$("#ff").serialize();
	    	
	    if($("#input-word").val()!="请输入姓名查询"&&$("#input-word").val()!=""){
			 $("#USER_NAME").val("");
		}

		});	
		});

	function addOption(obj) {
		var value;
		var text;
		$(obj).each(function(index) {
			document.getElementById("deptName").options.add(
				new Option(this.dictVal, this.dictVal)
			);
		})
	}
	
	function addOptions(obj) {
		var value;
		var text;
		$(obj).each(function(index) {
			document.getElementById("postName").options.add(
				new Option(this.dictVal, this.dictVal)
			);
		})
	}
		/** 查询字段信息 **/
	function initDict(dicttype) {
		var temp;
		$.ajax({
			url : "dictController/findDictByTypeCode",
			type : "post",
			async : false,
			dataType : "json",
			data : {
				"showAll" : "showAll",
				"dictTypeCode" : dicttype
			},
			success : function(data) {
				temp = data;
			}
		});
		
		return temp;
	}
</script>
</head>
<body style="padding-left: 6px;">
  <input type="hidden" id="selectIds" name="selectIds"/>

	<div id="search_div"
		style="width: 300px; float: right; padding-top: 10px;">
		<div class="input-group">
			<input type="text" id="input-word" class="form-control input-sm"
				value="请输入姓名查询" onFocus="if (value =='请输入姓名查询'){value=''}"
				onBlur="if (value ==''){value='请输入姓名查询'}"> <span
				class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm"
					style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
				<button type="button" class="btn btn-primary btn-sm"
					style="margin-left: 2px; margin-right: 0px;"
					onclick="showOrHide();">
					<i class="fa fa-search-plus"></i> 高级
				</button>
			</span>
		</div>
	</div>
	<div style="padding-top: 10px;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group">
			<shiro:hasPermission name="add:bizRunController:getBizRunList:aafd8bcd-1135-422f-b9b5-375655aef48c">
			<%@ include file="/views/aco/biz/earcmgr/biz_btn_list_do.jsp"%>
			</shiro:hasPermission>
			<shiro:hasPermission name="modify:bizRunController:getBizRunList:aafd8bcd-1135-422f-b9b5-375655aef48c">
			<button id="btn_update_pers" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"> 修改</span>
			</button>
			</shiro:hasPermission>
				<shiro:hasPermission name="delete:bizRunController:getBizRunList:aafd8bcd-1135-422f-b9b5-375655aef48c">
			<button id="btn_delete_pers" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"> 删除</span>
			</button>
			</shiro:hasPermission>
			 <button id="export_excel_btn" type="button" class="btn btn-default btn-sm" >
				   <span class="fa fa-download" aria-hidden="true"></span> 导出Excel
			     </button>	
			<!-- <button id="btn_export_pers" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"> 导出</span>
			</button> -->
		</div>
		<!-- 模态框（Modal） -->
		<div id="advSearchModal" class="search-high-grade"
			style="display: none; margin-top: 15px;">
			<form id="ff" enctype="multipart/form-data" class="form-horizontal "
				target="_top" method="post" action="">
				<div class="form-group" id="dialog-message">
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">姓名</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<input id="USER_NAME" name="USER_NAME" type="text"
							class="form-control">
					</div>
					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">性别</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<select id="USER_SEX" name="USER_SEX"
							class="form-control" size="1">
							<option value="">请选择</option>
							<option value="0">女</option>
							<option value="1">男</option>
							<option value="2">未知</option>
						</select>
					</div>
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">部门</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
					<select id="deptName" name="deptName" class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
						<option value=""></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="dialog-message">
							<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">人员类型</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
						<select id="user_duty_type" name="user_duty_type" class="form-control" size="1">
					<option value="">请选择</option>
					<option value="zsry">正式人员</option>
					<option value="jdry">借调人员</option>
					<option value="sxs">实习生</option>
						</select>
					</div>
						<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label">职务</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3">
							<select id="postName" name="postName" class="selectPiker select input-sm" style="width: 100%;padding: 5px;">
							<option value=""></option>
						</select>	
					</div>
					

					<label class="col-lg-1 col-md-1 col-sm-1 col-xs-1 control-label" >调入时间</label>
					<div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" >
						<input type="text" id="entryTime" name="entryTime"  style="width:100%;float:left;"
							class="form-control input-sm" placeholder="" onclick="laydate({istime: true, format: 'YYYY-MM-DD'})">
					</div>
			
				</div>
			</form>
			<div id="btnDiv" align="center"
				style="width:100%; margin-bottom: 10px">
				<button type="button" class="btn btn-primary btn-sm" id="advSearch">查询</button>
				<button type="button" class="btn btn-primary btn-sm"
					id="advSearchCalendar">重置</button>
				<button type="button" id="modal_close"
					class="btn btn-primary btn-sm" onclick="qxButton();">取消</button>
			</div>
		</div>
		<table id="persFileTable">
		</table>
	</div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
		</div>
	</div>
	<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>