var arcId;
var modifyarcid;
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
	if(globalAction=="add"){
		$('#btn_save').show();
		//set the generate arcId
		arcId = generateUUID();
		var src =$("#attachment_iframe")[0].src;
		src = src+arcId
		$("#attachment_iframe")[0].src=src;
	}
	if(globalAction=="read"||globalAction=="selectView"){
		$('#btn_save').hide();
		var iframe = document.getElementById('form_iframe');
		checkloadFrame(iframe);
		iframe.onload = function(){
			afterload();
			disableFileLoadButton();
		}
	}
	if(globalAction=="modify"){
		var iframe = document.getElementById('form_iframe');
		if (iframe.attachEvent){
			iframe.attachEvent("onload", function(){
			//alert("Local iframe is now loaded.");
				afterload();
			});
		} else {
			iframe.onload = function(){
				afterload();
			};
		} 
	}
	if(globalAction=="zhuijiadangan"){
		//暂存按钮事件
/*		$("#btn_save").click(function() {
			data = $("#form_iframe")[0].contentWindow.doSaveForm(arcId);
		});*/
		//$('#btn_save').hide();
		var iframe = document.getElementById('form_iframe');
		if (iframe.attachEvent){
			iframe.attachEvent("onload", function(){
			//alert("Local iframe is now loaded.");
				afterload();
			});
		} else {
			iframe.onload = function(){
				afterload();
			};
		}
/*		var attFrame = document.getElementById('attachment_iframe');
		if (attFrame.attachEvent){
			attFrame.attachEvent("onload", function(){
			});
		} else {
			attFrame.onload = function(){
			};
		}*/
	}
	
	//暂存按钮事件
	$("#btn_save").click(function() {
		data = $("#form_iframe")[0].contentWindow.doSaveForm(arcId);
		if(data){
			window.parent.closePage(window,true,true,false,"#main_iframe");
		}
	});
	
	//重置按钮事件
	$('#btn_reset').click(function(){
		$("#form_iframe")[0].contentWindow.doclearForm();
	});
	
	//返回按钮事件
	$("#btn_close").click(function() {
		window.parent.parent.closePage1(window,true,true,false,1);
		
	});
	
	//表单、正文、附件页签切换事件
	$("#myTabs a").click(function (e) {
		  e.preventDefault();
		  divId = $(this).attr('href').replace("#","");
	});
});


function checkloadFrame(iframe){
	if (iframe.attachEvent){
		iframe.attachEvent("onload", function(){
			afterload();
			disableFileLoadButton();
			//setReadOnly($(window.frames["form_iframe"].document).find("#docInforForm"));
		});
	} else {
		iframe.onload = function(){
			afterload();
			disableFileLoadButton();
			//setReadOnly($(window.frames["form_iframe"].document).find("#docInforForm"));
		};
	} 
}

/**
 * 设置默认arcType
 * */
function setArcTypeId(){
	var form = $(window.frames["form_iframe"].document).find("#docInforForm");
	//set read only
	$(form).find('#regTime').attr("readonly","readonly");
	$(form).find('#regDept').attr("readonly","readonly");
	$(form).find('#regDeptId').attr("readonly","readonly");
	$(form).find('#regUser').attr("readonly","readonly");
	$(form).find('#regUserId').attr("readonly","readonly");
}

/**
 * 加载完执行的任务
 * */
function afterload(){
	$(window.frames["form_iframe"].document).find('#docInforId').val(globalArcId);
	var fileuser =	$(window.frames["form_iframe"].document).find('#fileUserID').val();
	if(fileuser!=null&&fileuser!=''){
		$(window.frames["form_iframe"].document).find('#guidangDiv').show();
	}

}
function disableFileLoadButton(){
	//disable the button of file upload
	var buttons;
     var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
	    if (isChrome) {
	         buttons=$(window.frames["attachment_iframe"].contentDocument).find("button");	
	    }else{
	         buttons=$(window.frames["attachment_iframe"].document).find("button");
	    }
    for(var i=0;i<buttons.length;i++){
    	if(buttons[i].getAttribute("id")!="open" && buttons[i].getAttribute("id")!="resave"){
	    	buttons[i].setAttribute("disabled","disabled");
    	}
    	//buttons[i].setAttribute("disabled","disabled");
    }
}


/**
 * set the input read only
 * */
function setReadOnly(formObj){
	var inputs = formObj.find('input:visible');
	for(var i=0; i<inputs.length; i++){
		$(inputs[i]).attr("readonly","readonly");
	}
	var selects = formObj.find('select');
	for(var i=0;i<selects.length;i++){
		$(selects[i]).attr("disabled",'disabled');
	}
}
/**
 * 重置表单
 */
function clearCUserForm(){
	document.getElementById("arcMtgForm").reset();
}