var arcId;
//拟稿生成uuid
function generateUUID() {
	var temp;
	if(arcId == null || arcId == ""){
		var d = new Date().getTime(); 
		var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, 
		function(c) {   
			var r = (d + Math.random()*16)%16 | 0;   d = Math.floor(d/16);   
			return (c=='x' ? r : (r&0x3|0x8)).toString(16); 
		});
		temp = uuid;
		arcId = temp;
	}else{
		temp = arcId;
	}
	return temp;
}

//页签时切换加载对应的iframe
function showPage(tabId, url){
	if ($('#' + tabId + '_iframe').attr("src") == "") {
		url = url + '&bizId=' + arcId;
		if (tabId == "mainBody") {
			$("#word").attr("checked", true);
		}
		$('#' + tabId + '_iframe').attr('src', url);
	}
}
$(function() {
	
   if($("#addFuJian").val()=='addFuJian'){
	   var inputHtml=$(window.frames["form_iframe"].document).find("input");
    for(var i=0;i<inputHtml.length;i++){
	    	inputHtml[i].setAttribute("disabled","disabled");
    }
      var selectHtml=$(window.frames["form_iframe"].document).find("select");
          for(var i=0;i<selectHtml.length;i++){
	    	selectHtml[i].setAttribute("disabled","disabled");
    }
    var textareaHtml=$(window.frames["form_iframe"].document).find("textarea");
            for(var i=0;i<textareaHtml.length;i++){
	    	textareaHtml[i].setAttribute("disabled","disabled");
    }
	}
	//暂存按钮事件
	$("#btn_save_update").click(function() {
		$("#dengji_update").click();
		/*clearCUserForm();*/
		data = $("#form_iframe")[0].contentWindow.doSaveFormUpdate();
		if(data=="Y"){
		}else{
			window.parent.closePage(window,true,true,false,"#main_iframe");
		}
	});
				//重置按钮事件
	$("#btn_reset").click(function() {
		data = $("#form_iframe")[0].contentWindow.doReset();
	});
	//返回按钮事件
	$("#btn_close").click(function() {
		window.parent.closePage(window,true,true,false,"#main_iframe");
/*		window.parent.parent.closePage(window,true,true,true);
*/	});
	
	//表单、正文、附件页签切换事件
	$("#myTabs a").click(function (e) {
		  e.preventDefault();
		  divId = $(this).attr('href').replace("#","");
	});
});

/**
 * 重置表单
 */
function clearCUserForm(){
	document.getElementById("pubInfoFormUpdate").reset();
}
	function disableFileLoadButton(){
	//disable the button of file upload
    var buttons=$(window.frames["attachment_iframe"].document).find("button");
    for(var i=0;i<buttons.length;i++){
  	if(buttons[i].getAttribute("id")!="open" && buttons[i].getAttribute("id")!="resave"){
	    	buttons[i].setAttribute("disabled","disabled");
    	}
    }
}