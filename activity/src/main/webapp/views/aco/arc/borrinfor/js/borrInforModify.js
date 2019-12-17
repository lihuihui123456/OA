var globalTable;
var saveResult=null;
/**
 * 由父iframe调用保存方法
 * */
function doSaveForm(arcId){
	saveBorrInforForm();
	return saveResult;
}
$(function() {
	laydate.skin('dahong');
	//iniTable(null);
	Date.prototype.format = function(format){
		var o = {
			"M+" : this.getMonth()+1, //month
			"d+" : this.getDate(), //day
			"h+" : this.getHours(), //hour
			"m+" : this.getMinutes(), //minute
			"s+" : this.getSeconds(), //second
			"q+" : Math.floor((this.getMonth()+3)/3), //quarter
			"S" : this.getMilliseconds() //millisecond
		}

		if(/(y+)/.test(format)) {
			format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
		}

		for(var k in o) {
			if(new RegExp("("+ k +")").test(format)) {
				format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
			}
		}
		return format;
	} 
	
	$('#isSetY').click(function(){
		//show the plantime and actltime div
		$('#isSetTimeDiv').show();
		$('#planTimeTh')[0].innerHTML='计划归还时间<span class="star">*</span>';
		$('#planTime').addClass('validate[required]');
	});
	$('#isSetN').click(function(){
		//clean the value
		var inputs = $('#isSetTimeDiv').find('input');
		for(var i=0; i<inputs.length; i++){
			$(inputs[i]).val('');
		}
		$('#planTimeTh')[0].innerHTML='计划归还时间';
		$('#planTime').removeClass('validate[required]');
		//hide the plantime and actltime div
		$('#isSetTimeDiv').hide();
	});

	//set radio disable
	if(showBorrisSet=='Y'){
		$("#isSetY").click();
	}else{
		$("#isSetN").click();
	}
	//如果需要要归还，但未归还，清空实际归还时间
	if(showBorrisSet=='Y'&&showBorrisBack=='N'){
		$('#actlTime').val('');
	}
	
	//set select value
	var selects = $('#borrInforForm').find('select');
	for(var i=0;i<selects.length;i++){
		var selectValue = $(selects[i]).attr('myvalue');
		$(selects[i]).find('option[selected="selected"]').removeAttr('selected');
		var option = $(selects[i]).find('option[value="'+selectValue+'"]');
		if(option!=null&&option.length==1){
			$(option[0]).attr('selected','selected');
		}
	}
	
	//set the input readonly
	$('#creUserDiv').find('input').attr('readonly',true);
	$('#creTimeDiv').find('input').attr('readonly',true);
});

function setDefaultSelect( selectId,value){
//	$('#'+selectId).find('option[selected="selected"]').removeAttr('selected');
//	var option = $('#'+selectId).find('option[value="'+value+'"]');
//	if(option!=null&&option.length==1){
//		$(option[0]).attr('selected','selected');
//	}
	$('#'+selectId).selectpicker('val', value);
}

/**
 * 加载选中的档案所包含的附件记录
 * 由档案列表选择动作触发
 * */
function loadAttList(arcId){
	$("#borrInforAttList").empty();
	$('<iframe id="attachment_iframe" runat="server" src="'+globalCTX+'/media/bpmaccessory?docTyoe=2&showType=form&tableId='+arcId+'" width="100%"height="100%" frameborder="no" border="0" scrolling="yes"></iframe>').prependTo('#borrInforAttList');
	
	//btn-group
	var iframe = document.getElementById('attachment_iframe');
	if (iframe.attachEvent){
		iframe.attachEvent("onload", function(){
			$(window.frames["attachment_iframe"].document).find('.btn-group').hide();
		});
	} else {
		iframe.onload = function(){
			$(window.frames["attachment_iframe"].document).find('.btn-group').hide();
		};
	}
	
}
/**
 * 保存借阅档案记录,
 * 只支持选择一个附件
 * */
function saveBorrInforForm(){
	
	var checkedInput = $('#borrInforAttList').find("input:checked");
	if(checkedInput.length==1){
		//get the select input value
		//var attId = $(checkedInput[0]).attr('value');
		var url = "borrInforController/doUpdateBorrInforById";
		if ($('#borrInforForm').validationEngine('validate')){
			var obj = $('#borrInforForm').serialize();
			$.ajax({
				type : "POST",
				url : url,
				async : false,
				data : obj,
				success : function(data) {
					if(data.result){
						//$(window.parent.document).find("#btn_close")[0].click();
						saveResult = true;
					}else{
						layerAlert("保存失败! 请关闭页签，重新打开页签输入！");
						saveResult = false;
					}
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
					saveResult = false;
				}
			});
		}
	}else{
		layerAlert("您还没有选取借阅档案！");
		return;
	}
	
}
/**
 * 根据输入的档案名字搜索档案
 * */
function search(){
	var searchKey = $('#arcName').val();
	if(searchKey==null||searchKey==''){
		layerAlert('输入内容为空');
		return;
	}
	iniTable(searchKey);
}
/**
 * 初始化搜索到的档案table
 * */
function iniTable(searchKey){
	//arcPubTable
	$("#arcPubTable").empty();
	$('<iframe id="arcPubTable_iframe" runat="server" src="'+globalCTX+'/borrInforController/toArcPubInforTable?searchKey='+searchKey+'" width="100%"height="100%" frameborder="no" border="0" scrolling="yes"></iframe>').prependTo('#arcPubTable');
}

