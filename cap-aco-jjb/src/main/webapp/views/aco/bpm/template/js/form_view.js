var divId = "bizform";
//加载tab中的iframe
function showPage(tabId, url){
	if ($('#' + tabId + '_iframe').attr("src") == "") {
		if (tabId != "mainBody") {
			$('#' + tabId + '_iframe').attr('src', url);
		}else {
			if( !$("#word").hasClass("open-page") && !$("#pdf").hasClass("open-page")){
				$("#word").addClass("close-page").addClass("open-page");
				$("#pdf").addClass("close-page");
				$("#mainBody_iframe").addClass("iframe_show").attr('src', url);
			}
		}
	}
}

function openImgDiv() {
	$('#viewFlowPicture').modal('show');
}	

//传阅选人确定按钮
function circulation() {
	var users = document.getElementById("circulation_iframe").contentWindow.doSaveSelectUser();
	var viewUserIds = users[0];
	$.ajax({
		type: 'post',  
        url: 'bpmRuBizInfoController/doSaveBizGwCircularsEntitys',
        dataType: 'json',
        data: {
        	'bizId' : bizId,
        	'viewUserIds' : viewUserIds
        },
        success: function(data) {
        	if(data){
	        	layerAlert("传阅成功！");
	        	$('#circulationDiv').modal('hide');
        	}else {
	        	layerAlert("传阅失败！");
        	}
        }
	});
}

$(function() {
	if(window.parent.$('#framehome')[0]){
		var todoFrame=window.parent.$('#framehome')[0].contentWindow.$('#todo_iframe');
		if(todoFrame!=null){
			todoFrame[0].contentWindow.init();
		}
	}
	if(procInstId!=""&&procInstId!=null){
		$('#btn_viewFlow').show();
		$('#fordetails').show();
		$('#btn_export').show();
		$('#btn_print').show();
		$('#btn_circulation').show();
	}else{
		$('#btn_export').show();
		$('#btn_print').show();
	}
	//传阅按钮事件
	$('#btn_circulation').click(function() {
		changeIndex();
		$("#circulation_iframe").attr("src",'treeController/zMultiPurposeContacts?state=1');
		$('#circulationDiv').modal('show');
	});
	
	//返回按钮事件
	$('#btn_close').click(function() {
		if(isRefresh !=null && isRefresh == "false"){
			window.parent.parent.closePage(window,true,true,false);
		}else{
			window.parent.parent.closePage(window,true,true,true);
		}
	});
	
	$('#myTabs a').click(function (e) {
		  e.preventDefault()
		  divId = $(this).attr('href').replace("#","");
	});
	
});

//通过判断是否存在在DB中存在bizId,没有插入并更新标记dbbizId
function changeIseb() {
	return;
}