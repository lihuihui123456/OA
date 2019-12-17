<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务拟稿公共页面-附件</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/jquery-ui/css/jquery-ui-1.10.4.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/add-ons.min.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/jquery-ui/js/jquery-ui-1.10.4.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/SmoothScroll.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/createtab.js"></script>
<script src="${ctx}/views/aco/upload/js/plupload.full.min.js"></script>
<script src="${ctx}/views/aco/upload/js/customized-upload.js"></script>

<script type="text/javascript">
var bizid_attach='';

//文件传阅
function attachFile(){
	$('#myModal').modal('show');
	$('#group').attr("src","${ctx}/media/enclosureFile?bizid=${bizid}&&bizid_attach='"+bizid_attach+"'");
	//清除数据
	bizid_attach='';
}

//保存关联信息
function saveAttach(){
	//group
	document.getElementById("group").contentWindow.saveAttach();
	$('#myModal').modal('hide');
	//findattachFile();
}

//查询平台内的关联文件
function findattachFile(){
	$.ajax({
		type: "post",  
        url: "${ctx}/media/findattachFile",
        dataType: 'json',
        data: {
        	bizid:'${bizid}'
        },
        success: function(data) {
	        var htm='';
	        if(data != null) {
	        	for(var i=0;i<data.length;i++){
		        	htm+='<div class="yinyong" onclick="connect(\''+data[i].bizid_attach+'\',\''+ data[i].solId +'\',\''+data[i].procInstId+'\')">'+ data[i].attach_title+' </div>'
		        	bizid_attach+=data[i].bizid_attach+",";
		        }
		        $('#findattachFile').html(htm);
		        bizid_attach=bizid_attach.substr(0,bizid_attach.length-1);
		        window.parent.changeTitle(data.length);
	        }
        }
	});
	
}
$(function(){
	findattachFile();
	var bizCode=$("#bizCode",window.parent.document).val();
	var operateState=$("#operateState",window.parent.document).val();
	upload({// 引用customized-upload.js中方法
		multipart_params : {
			refId : "${bizid}",
			refType : bizCode
		}
	}, "attachFile", true,operateState);
});

function connect(bizid,solId,proceInstId){
	var operateUrl = "bizRunController/getBizOperate?solId="+ solId  + "&bizId=" + bizid + "&status=4";
	var options = {
		"text" : "查看",
		"id" : "bizinfoeditold"+bizid,
		"href" : operateUrl,
		"pid" : window.parent,
		"isDelete" : true,
		"isReturn" : true,
		"isRefresh" : false
	};
	window.parent.parent.createTab(options);
}
</script>
<style>
.form-control {
	border: 1px #fff solid;
}
.form-group{
	margin-bottom:0;
}
.treeDiv {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	margin-top: 20px;
	display: none;
	position: absolute;
	margin-top: -160px;
	background-image: url('${ctx}/static/cap/images/treeImg.png');
	background-color: black;
}
.paper-outer{
	background-color: #F2F4F8; 
	padding:3% 5% 3% 5%;
}
.paper-inner{
	background-color: white;
	padding:3% 5% 3% 5%;
	-webkit-box-shadow:0 0 10px 2px #666;  
    -moz-box-shadow:0 0 10px 2px #666;  
    box-shadow:0 0 10px 2px #666;
}
.tablestyle th{
	text-align:center;
	vertical-align:middle;
}
.tablestyle .yinyong{
	font-size:14px;
	padding:3px 0;
	text-decoration:none;
	cursor:pointer;
}
.btn-group .btn+.btn, .btn-group .btn+.btn-group, .btn-group .btn-group+.btn, .btn-group .btn-group+.btn-group{
	margin-left: 0;
}
</style>
<script type="text/javascript">
$(function(){
	var view='${view}';
	if(view=='1'){
		onlyRead();
	}
});
//查看页面
function onlyRead(){
    var buttons=document.getElementsByTagName("button");
    for(var i=0;i<buttons.length;i++){
    	if(buttons[i].getAttribute("id")!="open" && buttons[i].getAttribute("id")!="resave"){
	    	buttons[i].setAttribute("disabled","disabled");
    	}
    }
}
</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>

<body class="paper-outer" style="margin-top:-15px\9">
	<div class="paper-inner">
	<table class="tablestyle" width="100%" border="0" cellspacing="0">
		<tr>
			<th height="390">关联平台内文件</th>
			<td height="390" style="word-break:break-all;overflow:auto;padding-top:10px;vertical-align:top;padding-left:20px">
				<span id="findattachFile" style="float:left;"></span>
				<div class="btn-group" role="group" aria-label="..." style="float:right;margin-top:150px;">
						<button type="button" class="btn btn-default" onclick="attachFile()">
							<i class="fa  fa-link"></i>&nbsp;引用
						</button>
				</div>
			</td>
		</tr>
		<tr>
			<th height="490">附 件</th>
			<td valign="top">
				<div style="width: 100%;height: 490px;">
					<div class="form_annex_new " id="attachFile" style="width: 100%;height: 490px;overflow:auto;"></div>
				</div> 
			</td>
		</tr>
	</table>

	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h3 class="modal-title" id="myModalLabel">关联平台内文件</h3>
				</div>
				<div class="modal-body" >
					<iframe id="group" runat="server" width="100%" height="350" frameborder="no" border="0" marginwidth="0"
						 marginheight="0" scrolling="yes" allowtransparency="yes"></iframe>
				</div>
				<div class="modal-footer" style="text-align:center">
					<button type="button" class="btn btn-primary btn-contact" onclick="saveAttach()">确定</button>
  					<button type="button" class="btn btn-primary btn-contact" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
	</div>
</body>
</html>