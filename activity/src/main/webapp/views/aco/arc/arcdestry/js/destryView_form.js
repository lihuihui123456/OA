$(function() {
	$('input,select,textarea',$('form[name="destryFormView"]')).prop('disabled',true);
	$("#arcName").prop('disabled',false);
	var expiryDate = $("#expiryDate").val();
	if(expiryDate=="0"){
		expiryDate="永久有效"
	}else if(expiryDate=="10"){
		expiryDate="10年"
	}else if(expiryDate=="30"){
		expiryDate="30年"
	}
	$("#expiryDate").val(expiryDate);
});

//查看档案
function viewArc() {
	var arcName = $('#arcName').val();
	var arcId = $('#arcId').val();
	var arcType = $('#arcType').val();
	date = new Date().getTime();
	if(arcId==""||arcType=="") {
		layerAlert("请选择销毁档案！");
	}else {
		$.ajax({
			type : "POST",
			url : "arcPubInfo/getArcTypeUrl",
			async : false,
			dataType : 'text',
			data : {
				"id" : arcType
			},
			success : function(data) {	
				if (data != "") {
					var hrefPath=getRootPath()+data+"arcId="+arcId+"&type=selectView&fileStart=1";
					var options = {
							"text" : "档案管理-查看",
							"id" : date,
							"href" :hrefPath,
							"pid" : window.parent
					};
					window.parent.parent.createTab(options);
				}
			},
			error : function(data) {
			}
		});
	}
}

function getRootPath() {  
    //获取当前网址，如： http://localhost:8083/uimcardprj/share/meun.jsp  
    var curWwwPath=window.document.location.href;  
    //获取主机地址之后的目录，如： uimcardprj/share/meun.jsp  
    var pathName=window.document.location.pathname;  
    var pos=curWwwPath.indexOf(pathName);  
    //获取主机地址，如： http://localhost:8083  
    var localhostPaht=curWwwPath.substring(0,pos);  
    //获取带"/"的项目名，如：/uimcardprj  
    var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+1);  
    return(localhostPaht+projectName);  
} 