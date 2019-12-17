var divId;
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
function showPage(url,type){
	$('#attachment_iframe').attr("src",'');
	if ($('#attachment_iframe').attr("src") == "") {
		if(type=="add"){
			url = url + arcId;
		}
		$('#attachment_iframe').attr('src', url);
	}
}
$(function() {
	arcId = generateUUID();
	//暂存按钮事件
	$("#btn_save").click(function() {
		changeIndex();
		data = $("#form_iframe")[0].contentWindow.doSaveForm(arcId);
		if(data=="Y"||data==undefined){
		}else{
			window.parent.closePage(window,true,true,false,"#main_iframe");
		}
	});
	$("#btn_update").click(function() {
		changeIndex();
		data = $("#form_iframe")[0].contentWindow.doUpdateSaveForm(arcId);
		if(data=="Y"||data==undefined){
		}else{
			window.parent.closePage(window,true,true,false,"#main_iframe");
		}
	});
	//表单、正文、附件页签切换事件
	$("#myTabs a").click(function (e) {
		  e.preventDefault();
		  divId = $(this).attr('href').replace("#","");
	});
});

function changeIndex() {
	if(divId == "attachment") {
		$('#myTabs li:eq(0)').addClass("active");
		$('#myTabs li:eq(1)').removeClass("active");
		$('#attachment').removeClass("active");
		$('#bizform').addClass("active");
		divId = "";
	}
}


//返回按钮事件````
$("#btn_close").click(function() {
	window.parent.closePage(window,true,true,false,"#main_iframe");
});
//返回按钮事件````
$("#btn_reset").click(function() {
	clearCUserForm();
});
/**
 * 重置表单
 */
function clearCUserForm(){
	$("#form_iframe")[0].contentWindow.clearCUserForm();
}
