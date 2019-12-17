var divId = "bizform";
//加载tab中的iframe
function showPage(tabId, url){
	if ($('#' + tabId + '_iframe').attr("src") == "") {
		if (tabId == "mainBody") {
			$("#word").attr("checked", true);
		}
		$('#' + tabId + '_iframe').attr('src', url);
	}
}

function openImgDiv() {
	$('#viewFlowPicture').modal('show');
}	
$(function() {
	if(procInstId!=""&&procInstId!=null){
		$('#btn_viewFlow').show();
		$('#btn_export').show();
		$('#btn_print').show();
		$('#btn_circulation').show();
	}else{
		$('#btn_export').show();
		$('#btn_print').show();
	}
	//打印按钮事件
	$('#btn_print').click(function() {
		$.ajax({
	    url:"arcWordController/printWord?bizId="+bizId,
		type:"post",
		dataType:"json",
		success:function(data) {
			if(data.filename !=null){
				var url = "arcWordController/openWord?encryption=0&fileType=.doc&&mFileName="+data.filename;
				var options = {
					"text" : "打印",
					"id" : "printWord",
					"href" :url,
					"pid" : window,
					"isDelete" : true,
					"isReturn" : true,
					"isRefresh" : true
				};
				window.parent.createTab(options);
				}
			}
		}); 
		
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