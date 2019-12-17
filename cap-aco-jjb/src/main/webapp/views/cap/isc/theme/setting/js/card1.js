
$(function(){
	 list = eval("("+list+")");
	 jQuery.each(list, function(i,item){  
		 $("#"+item.pageId).css("width","260px");
     	 $("#"+item.pageId).css("height","140px");
		 $("#"+item.pageId).attr("src",path+item.modImg);
		 $("#"+item.pageId).attr("title",item.modName);
     });  
})
//主题设置
var pageId = '';
function setModule(id){
	
	pageId = id;
	InitMenuTreeData();
	$('#moduleDialog').dialog('open');
}

/**
 * 初始化系统菜单树
 */
function InitMenuTreeData() {
	$('#menu_tree').tree({
		url : 'roleMenuController/findSysModuleTree',
		animate : true,
		checkbox : false,
		queryParams:{
			roleId : ''
		},
		onlyLeafCheck : true,
		cascadeCheck : false,
		onBeforeLoad: function (node, param) {//onBeforeLoad,在请求载入数据之前触发，返回false将取消载入。
            $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%" }).appendTo("#menu_tree");
            $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍待。。。").appendTo("#menu_tree").css({ display: "block" });
        },
        onDblClick : function(node) {
        	
        	if (node.attributes.isVrtlNode != "N") {
        		return;
        	}
        	var modImg = node.attributes.modImg;
        	var modName = node.text;
        	var themeId = $("#themeId",parent.document).val();
        	$.ajax({
				url : "themeController/doSaveThemeInfo",
				type : "post",
				async : false,
				data : {themeId:themeId,pageId:pageId,modId:node.id,modUrl:node.attributes.modUrl,modImg:modImg,modName:modName},
				success : function(data) {
					
					$("#"+pageId).css("width","260px");
		        	$("#"+pageId).css("height","140px");
		        	$("#"+pageId).attr("src",path+modImg);
		        	$("#"+pageId).attr("title",modName);
		        	
		        	$('#moduleDialog').dialog('close');
				}
			});
		},
		onLoadSuccess: function (row,data) {
			//$(".datagrid-mask").css({ display: "none"});
            //$(".datagrid-mask-msg").css({ display: "none" });
			$('#menu_tree').tree('collapseAll');
		},
		onClick : function(node) {
			// 点击展开
			$('#menu_tree').tree('expand', node.target);
		}
	});
}

function closeDialog(){
	$('#moduleDialog').dialog('close');
}