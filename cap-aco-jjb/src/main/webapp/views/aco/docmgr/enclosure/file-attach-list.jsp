<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<%@ include file="/views/aco/common/head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<style type="text/css">
.btn-div{
	padding: 5px 0px;
}
#search-div{
	width: 300px; 
	float: right;
}
</style>
<script type="text/javascript">
var content='';
var taskid;
var attachbizid='';
var attach_title='';

function search() {
	var title = $("#input-word").val();
	if (title == '请输入标题查询') {
		title = "";
	}else{
		title = window.encodeURI(window.encodeURI(title));
	}
	$("#tb_departments").bootstrapTable('refresh',{
		url : "${ctx}/media/listAllBiz",
		query:{
			title : title
		}
	});
}

$(function(){
	$('#tb_departments').bootstrapTable({
		url : "${ctx}/media/listAllBiz", 
		method : 'get', 
		toolbar : '#toolbar', 
		striped : true, 
		cache : false,
		pagination : true,
		sortable : false, 
		sortOrder : "asc", 
		queryParams :function(params) {
			var temp = {
					rows : params.limit, 
					page : params.offset,
					bizId: '${bizid}',
					title : $("#input-word").val()=="请输入标题查询"?"":window.encodeURI(window.encodeURI($("#input-word").val()))
				};
				return temp;
			}, 
		sidePagination : "server", 
		pageNumber : 1, 
		pageSize : 10, 
		pageList :[10,15,25] ,
		search : false, 
		strictSearch : false,
		showColumns : false, 
		showRefresh : false, 
		minimumCountColumns : 2, 
		clickToSelect : true, 
/* 		height : 300,  */
		uniqueId : "ID", 
		showToggle : false,
		cardView : false, 
		detailView : false, 
		columns : [ {
			checkbox : true,
			width : '5%'
		}, {
			field : 'index',
			title : '序号',
			width : '7%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		},{
			field : 'bizTitle_',
			width : '23%',
			title : '标题'
		},{
			field : 'serialNumber_',
			title : '发文流水号',
			visible:false
		},{
			field : 'createUserId_',
			width : '15%',
			title : '送交人'
		},{
			field : 'createtime',
			title : '办理日期',
			width : '15%',
			formatter:function(value,row){
				if (value == ""){
					return '';
				}
				var now = new Date();
				now.setTime(value);
                var year = now.getFullYear();
                var month =(now.getMonth() + 1).toString();
                var day = (now.getDate()).toString();
                if (month.length == 1) {
                    month = "0" + month;
                }
                if (day.length == 1) {
                    day = "0" + day;
                }
                var dateTime = year + "-" + month + "-" + day;
				return dateTime;
			}
		},{
			field : 'state_',
			title : '办理状态',
			valign: 'middle',
			halign: 'center',
			align:'center',
			width : '15%',
			formatter:function(value,row){
				if (value == "0")
					return '<span class="label label-danger">未办</span>';
				if (value == "2")
					return '<span class="label label-success">办结</span>';
				if (value == "1")
					return '<span class="label label-warning">在办</span>';
				if	(value == "4")
					return '<span class="label label-default">挂起</span>';
			}
		},{
			field : 'taskId',
			title : '任务id',
			visible:false
		},{
			field : 'bizId',
			title : '业务id',
			visible:false
		},{
			field : 'solId_',
			title : '业务解决方案id',
			visible:false
		},{
			field : 'procInstId_',
			title : '流程实例id',
			visible:false
		}]
	});
});

function checknum(){
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
		layerAlert("请选择一条数据");
		return false;
	}else{
		taskid=obj[0].taskId;
		bizid=obj[0].bizId;
		return true;
	}
}

function connect(){
	if(checknum()){
		/*$('#myModalcontent').modal('show').css({
            width: 'auto',
            'margin-left':'-300px'
        });
		$('.modal-content').css('width', '1000px');
		$('.modal-body').css('width', '1000px');*/
		
		var obj =$('#tb_departments').bootstrapTable('getSelections');
		//$('#connect').attr("src","bpmRuBizInfoController/view?bizId="+ obj[0].bizId+"&&procInstId="+ obj[0].procInstId_ +"&&taskId="+obj[0].taskId +"&&solId="+obj[0].solId_);
/* 		var options = {
			"text" : "查看",
			"id" : "view"+obj[0].bizId,
			"href" : "bpmRunController/view?isRefresh=false&bizId="+ obj[0].bizId+"&&taskId="+obj[0].taskId,
			"pid" : window.parent.parent
		};
		window.parent.parent.parent.createTab(options); */
		var bizid=obj[0].bizId;
		var solId=obj[0].solId_;
		var operateUrl = "bizRunController/getBizOperate?status=4&solId="+ solId + "&bizId=" + bizid;
		var options={
				"text":"查看",
				"id":"view"+bizid,
				"href":operateUrl,
				"pid":window.parent.parent,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":false,
				"createFirst":true
		};
		window.parent.parent.parent.createTab(options);
	}
	
}

function fordetails(){
	if(checknum()){
		/*$('#myModaldetail').modal('show').css({
	            width: 'auto',
	            'margin-left':'-300px'
	     });
		$('.modal-content').css('width', '1000px');
		$('.modal-body').css('width', '1000px');*/
		//myModeliframe
		var obj =$('#tb_departments').bootstrapTable('getSelections');
		//$('#myModeliframe').attr("src","${ctx}/bpmRuBizInfoController/toDealDetialPage?procInstId="+obj[0].procInstId_);
		var options = {
			"text" : "办理详情",
			"id" : "bizinfoview"+obj[0].bizId,
			"href" : "${ctx}/bpmRuBizInfoController/toDealDetialPage?bizId="+obj[0].bizId+"&procInstId="+obj[0].procInstId_,
			"pid" : window.parent.parent
		};
		window.parent.parent.parent.createTab(options);
	}
}

//保存关联信息
function saveAttach(){
	//判断是业务Id是否已经在数据库中存在
	/* window.parent.parent.parent.changeIseb(); */
	//获取当前选取的数据
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	for(var i=0;i<obj.length;i++){
		attachbizid+= obj[i].bizId+',';
		attach_title+=obj[i].bizTitle_+',';
	}
	attachbizid=attachbizid.substr(0, attachbizid.length-1);
	attach_title=attach_title.substr(0, attach_title.length-1)
	//进行数据的保存
	$.ajax({
		type: "post",  
        url: "${ctx}/media/savefileattach",
        dataType: 'json',
        data: {
        	bizid:'${bizid}',
        	attachbizid:attachbizid,
        	attach_title:attach_title
        },
        success: function(data) {  
			window.parent.findattachFile();
        }
	});
	
}

</script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
<div class="panel-body" style="padding-bottom:0px;border:0;'">
	<div class="btn-div btn-group">
		<button id="" type="button" class="btn btn-default" onclick="connect()">
			<span class="fa fa-eye" aria-hidden="true"></span>查看
		</button>
		<button id="fordetails" type="button" class="btn btn-default" onclick="fordetails()">
			<span class="fa fa-list" aria-hidden="true"></span>办理详情
		</button>
	</div>
	<!-- 搜索框 -->
	<div class="btn-div" id="search-div">
		<div class="input-group">
			<input type="text" id="input-word" class="validate[required] form-control input-sm" value="请输入标题查询" 
				onFocus="if (value =='请输入标题查询'){value=''}" onBlur="if (value ==''){value='请输入标题查询'}"> 
			<span class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
			</span>
		</div>
	</div>
	<table  id="tb_departments" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
</div>
	<!-- 查看关联业务数据 -->
	<div class="modal fade" id="myModalcontent" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">
						相关联业务数据
					</h4>
				</div>
				<div class="modal-body">
					<div>
						<iframe id="connect" runatmymodel="server" src="" width="980px" height="700px" frameborder="no" border="0" marginwidth="0"
						 marginheight="0" scrolling="no" allowtransparency="yes"></iframe>
					</div>
					<div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 查看办理详情 -->
	<div class="modal fade" id="myModaldetail" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModaldetailLabel">
						相关联业务数据
					</h4>
				</div>
				<div class="modal-body">
					<div>
						<iframe id="myModeliframe" runatmymodel="server" src="" width="980px" height="700px" frameborder="no" border="0" marginwidth="0"
						 marginheight="0" scrolling="no" allowtransparency="yes"></iframe>
					</div>
					<div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>