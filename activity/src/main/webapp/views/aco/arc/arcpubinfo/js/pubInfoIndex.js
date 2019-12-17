$(function() {
	/**
	 * 列表回车触发搜索
	 */
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	searchCommon();
	       return false ;   
	    } 
	});
	laydate.skin('dahong');

		
	 $('#view_btn').click(function() {
	 var obj = $('#folderContent').bootstrapTable('getSelections');
	 if (obj.length > 1 || obj.length == '') {
	 layerAlert("请选择一条数据");
	 return false;
	 }
	 arcTypeView(obj[0]);	
	 });

	});

function setDefaultSelect( selectId,value){
	$('#'+selectId).find('option[selected="selected"]').removeAttr('selected');
	var option = $('#'+selectId).find('option[value="'+value+'"]');
	if(option!=null&&option.length==1){
		$(option[0]).attr('selected','selected');
	}
}

/**
 * 销毁状态格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
/*function formatterFileStart(value, row, index) {
	if(row.isInvalid=="1"){
		return '<span class="label label-success">已作废</span>';
	}
	else if(value == "0"){
		return '<span class="label label-danger">&nbsp;未归档&nbsp;&nbsp;</span>';
	}else if (value == "1"){
		return '<span class="label label-warning">&nbsp;已归档&nbsp;&nbsp;</span>';
	}else{
		return "--";
	}
}*/
function arcTypeView(obj) {
	date = new Date().getTime();
	var arcType = obj.arc_type;
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
						var hrefPath=getRootPath()+data+"arcId="+obj.arc_id+"&type=selectView&fileStart=1";
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



function getRootPath(){  
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
/**
 * 高级搜索模态框
 */
function advSearchModal(){
	$('#advSearchModal').modal('show');
}
/**
 * 标题格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function onTdClickTabFormatter(value, row, index){
	/**
	 * 格式化标题
	 */
	if(value==null){
		return "<span class='tdClick'>-</span>"
	}
	else if(value.length>30){
		return "<span class='tdClick' title='"+value+"'>"+value.substring(0,29)+"...</span>"
	}else{
		return "<span class='tdClick'>"+value+"</span>"
	}
}
/*
 * table 点击标题弹出查看/办理页面
 */
window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
		 arcTypeView(row);	
	 }
}
function searchCommon() {
	//普通查询清空高级查询条件
	$("#search_form")[0].reset();
	var arcName = $("#input-word").val();
	if (arcName == '请输入文件标题查询') {
		arcName = "";
	}else{
		arcName = arcName
	}
	$("#folderContent").bootstrapTable('refresh',{
		url : "arcPubInfo/arcPubInfoListPage",
		query:{
			arcName :$.trim(arcName) 
		}
	});
}