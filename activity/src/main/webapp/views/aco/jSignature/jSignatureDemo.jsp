<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<head>
	<title>手写签批</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="shortcut icon" href="${ctx}/static/cap/plugins/bootstrap/ico/tl-favicon.ico" type="image/x-icon" />
	<script src="${ctx}/static/cap/plugins/bootstrap/js/jquery-1.11.1.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<script src="${ctx}/views/aco/jSignature/js/jSignature.js"></script>
	<!--[if lt IE 9]>
		<script type="text/javascript" src="${ctx}/views/aco/jSignature/js/flashcanvas.js"></script>
	<![endif]-->
	<style type="text/css">
	canvas {
		border: 1px dotted #000;
		margin: 0px;
		cursor: pointer;
	}
	/*.imported {
		border: 1px dotted #f00;
		margin: 10px 0;
	}*/
	body {
		text-align: center;
	}
	.btn{
		padding:5px 10px;
		border-radius:4px;
	}
	</style>
	<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<center>
		<div class="jSignatureBody">
			<div id="signature" class="signatureCon"></div>
		</div>

		<div style="padding-top: 10px; text-align: center;vertical-align: middle;">
			<button type="button" id="yes" class="btn btn-primary">保存</button>
			<button type="button" id="reset" class="btn btn-primary">重写</button>
		</div>
	</center>
</body>
<script>
	var bizId = "${bizId}";
	var filedName = "${filedName}";
	var taskId = "${taskId}";
	var procInstId = "${procInstId}";
	var $sigdiv = $("#signature");
	var id = "";
	
	//画布初始化时的数据，用作校验是否操作了手写签批
	var imgData;
	//初始化画布
	function initSignature() {
		$("#signature").width(${width}).height(${height});
		$sigdiv.jSignature({width:"100%",height:"100%"});
		imgData = $sigdiv.jSignature("getData", "image").toString();
	}
	
	//加载手写签批数据
	function loadSignature() {
		$.ajax({
			url : "${ctx}/signatureController/findSignature",
			type : "post",
			dataType : "json",
			data : {
				taskId : taskId,
				filedName : filedName,
			},
			success : function(data) {
				var datapair = data.fieldHeader_ + "," + data.fieldValue;
				$sigdiv.jSignature("setData", "data:" + datapair);
				id = data.id;
			}
		})
	}
	
	//绑定按钮事件
	function initButtons() {
		//保存按钮
		$("#yes").click(function() {
			//将画布内容转换为图片
			var datapair = $sigdiv.jSignature("getData", "image");
			saveSignature(datapair);
		});

		//重置按钮
		$("#reset").click(function() {
			//重置画布，可以进行重新作画.
			$sigdiv.jSignature("reset");
		});
	}

	//保存手写签批
	function saveSignature(datapair) {
		if(datapair == null) {
			return;
		}
		var filedHeader = datapair[0];
		var filedValue = datapair[1];
		if(datapair.toString() == imgData){
			filedValue = "";
			datapair[1] = filedValue;
		}
		$.ajax({
			url : "${ctx}/signatureController/doSaveSignature",
			type : "post",
			dataType : "text",
			data : {
				id : id,
				bizId : bizId,
				filedName : filedName,
				taskId : taskId,
				procInstId : procInstId,
				filedHeader : filedHeader,
				filedValue : filedValue
			},
			success : function(data) {
				//为表单页面签批框赋值
				window.opener.setParentWindowPic(filedName, datapair);
				window.close();
			}
		})
	}
	
	$(function() {
		initSignature();

		loadSignature();

		initButtons();
		
		window.onresize = function(){
			var data = $sigdiv.jSignature("getData", "image");
            setTimeout(function(){
                $('a').innerHTML = Math.floor(Math.random() * 100);
				$sigdiv.jSignature("setData", "data:" + data);
            }, 1000)
		}
	});
</script>
</html>