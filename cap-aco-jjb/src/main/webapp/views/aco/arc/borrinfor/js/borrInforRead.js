$(function() {
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
	
	//set radio disable
	if(showBorrisSet=='Y'){
		$("#isSetY").attr("checked","checked");
		$('#isSetTimeDiv').show();
	}else{
		$("#idSetN").attr("checked","checked");
		$('#isSetTimeDiv').hide();
		
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

	//set all input readonly
	$('#borrInforForm').find('input[type=radio]').attr('disabled','disabled');
	$('#borrInforForm').find('input[type=text] ').attr('readonly','readonly');
	//set select disabled
	$('#borrInforForm').find('select').attr('disabled','disabled');
	
	//setAttSelected($('#arcId').val(),$('#attId').val());
});

function disableFileLoadButton(){
	//disable the button of file upload
    var buttons=$(window.frames["attachment_iframe"].document).find("button");
    for(var i=0;i<buttons.length;i++){
/*    	if(buttons[i].getAttribute("id")!="open" && buttons[i].getAttribute("id")!="resave"){
	    	buttons[i].setAttribute("disabled","disabled");
    	}*/
    	buttons[i].setAttribute("disabled","disabled");
    }
}

function setAttSelected(arcId,showBorrAttid){
	$("#borrInforAttList").empty();
	$('<iframe id="attachment_iframe" runat="server" src="'+globalCTX+'/media/bpmaccessory?docTyoe=2&showType=form&tableId='+arcId+'" width="100%"height="100%" frameborder="no" border="0" scrolling="yes"></iframe>').prependTo('#borrInforAttList');
	var iframe = document.getElementById('attachment_iframe');
	if (iframe.attachEvent){
		iframe.attachEvent("onload", function(){
			$(window.frames["attachment_iframe"].document).find('.btn-group').hide();
			var tds = $(window.frames["attachment_iframe"].document).find('td input[type="checkbox"]');
			if(tds!=null){
				for(var i=0; i<tds.length; i++){
					if($(tds[i]).attr('value')==showBorrAttid){
						$(tds[i]).attr('checked',true);
						$(tds[i]).attr('disabled',true);
					}
				}
			}
		});
	} else {
		iframe.onload = function(){
			$(window.frames["attachment_iframe"].document).find('.btn-group').hide();
			var tds = $(window.frames["attachment_iframe"].document).find('td input[type="checkbox"]');
			if(tds!=null){
				for(var i=0; i<tds.length; i++){
					if($(tds[i]).attr('value')==showBorrAttid){
						$(tds[i]).attr('checked',true);
						$(tds[i]).attr('disabled',true);
					}
				}
			}
		};
	}
}
