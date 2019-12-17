$(function() {
	$("#createTime").val(formatDateTime(new Date()));
	$("#btn_close").click(function(){
		window.parent.closePage(window,true,true,false);
	});
});

function doSaveIndexLibraryInfo(){
	$.ajax({
		type : "POST",
		url : "indexLibraryController/doSaveIndexLibraryInfo",
		data : $('#myFm').serialize(),
		success : function(data) {
			if(data=="1"){
				layerAlert("保存成功");
				window.parent.parent.closePage(window,true,true,true);
			}else{
				layerAlert("保存失败");
			}
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});
}

function doDelIndexLiarbryById(Id){
	$.ajax({
		type : "POST",
		url : "indexLibraryController/doDelIndexLiarbryById",
		data : {id:Id},
		success : function(data) {
			if(data=="1"){
				layerAlert("删除成功");
			}else{
				layerAlert("删除失败");
			}
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});
	
}


function formatDateTime(dateTime) {  
    var y = dateTime.getFullYear();  
    var m = dateTime.getMonth() + 1;  
    m = m < 10 ? ('0' + m) : m;  
    var d = dateTime.getDate();  
    d = d < 10 ? ('0' + d) : d;  
    var h = dateTime.getHours();
    h = h < 10 ? ('0' + h) : h; 
    var minute = dateTime.getMinutes();  
    minute = minute < 10 ? ('0' + minute) : minute;  
    var s = dateTime.getSeconds();
    s = s < 10 ? ('0' + s) : s;  

    return y + '-' + m + '-' + d+' '+h+':'+minute+':'+s;  
}
