var globalTable;
var saveResult=null;
var tempNbrtime =  '';
var tempBorrtime =  '';
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
		//set the isSety checked
		$('#isSetY').attr('checked','checked');
		$('#isSetY').attr('value','Y');
		$('#isSetN').attr('value','N');
		$('#isSetN').removeAttr('checked');
		//show the plantime and actltime div
		$('#isSetTimeDiv').show();
		$('#planTimeTh')[0].innerHTML='计划归还时间<span class="star">*</span>';
		$('#planTime').addClass('validate[required]');
	});
	$('#isSetN').click(function(){
		$('#isSetN').attr('checked','checked');
		$('#isSetY').attr('value','Y');
		$('#isSetN').attr('value','N');
		$('#isSetY').removeAttr('checked');
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
	
	//initial the "单号时间"
	if($('#nbrTime').val()==null||$('#nbrTime').val()==''){
		$('#nbrTime').val(new Date().format("yyyy-MM-dd hh:mm:ss"));
		tempNbrtime =  $('#nbrTime').val();
	}
	//initial the "借阅时间"
	if($('#borrTime').val()==null||$('#borrTime').val()==''){
		$('#borrTime').val(new Date().format("yyyy-MM-dd hh:mm:ss"));
		tempBorrtime =  $('#borrTime').val();
	}
	//initial the regTime
	if($('#creTime').val()==null||$('#creTime').val()==''){
		$('#creTime').val(new Date().format("yyyy-MM-dd hh:mm:ss"));
	}
	//initial the radio
	$('#isSetY').attr('checked',true);
	//set the user and time readonly
	$('#creUserName').attr('readonly','readonly');
	$('#creUser').attr('readonly','readonly');
	$('#creUserID').attr('readonly','readonly');
	$('#creTime').attr('readonly','readonly');
});

function doClearForm(){
	//reset the form
	var inputs = $('#borrInforForm').find('input');
	for(var i=0; i<inputs.length; i++){
		if($(inputs[i]).attr('readonly')!='readonly'){
			$(inputs[i]).val('');
		}
	}
	$('#nbrTime').val(tempNbrtime);
	$('#borrTime').val(tempBorrtime);
	setDefaultSelect('borrType','1');
	setDefaultSelect('borrSHR','1');
	//initial the radio
	$('#isSetY').click();
	//remove the attframe
	$('#arcPubTable').empty();
	$('#borrInforAttList').empty();
}

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
	var temp = saveAttach();
	if(temp==null){
		layerAlert("您还没有选取借阅档案！");
		return;
	}
	var checkedInput = $('#borrInforAttList').find("input:checked");
	
	if(checkedInput.length==1){

		$('#borrInforForm').find('#arcId').val(temp[0]);
		var url = "borrInforController/doSaveBorrInfor";
		if ($('#borrInforForm').validationEngine('validate')){
			var obj = $('#borrInforForm').serialize() + '&attId='+temp[2];
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

