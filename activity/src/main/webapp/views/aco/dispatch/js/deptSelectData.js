var treetype;
var style;
var callbackfunc;
var jjbtype;
function deptTree(type, treeType,jjbtype,event,callback) {
	jjbtype = jjbtype;
	treetype = treeType;
	callbackfunc=callback;
	style = type;
	if (type == "2") {//拟稿部门
		url = "deptController/getDeptTree";
	}
	if (type == "4") {//拟稿单位
		url = "systree/getDeptData?type="+treetype;
	}
	var setting = {
			async : {
				enable : true,
				dataType : "json",
				type : "post",
				url : url,
				autoParam : [ "id" ],
				idKey : "id",
				pIdKey : "pId",
				rootPId : 0
			},
			callback : {
				onDblClick : deptOnDblclick,
				onAsyncSuccess: deptgetOrgExpand,
				onClick: zTreeDetpOnClick
			}
	};
	$.fn.zTree.init($("#selectDept_tree"), setting);
	dept_reply();
	openDeptSelectTree("selection_div");
}
function openDeptSelectTree(treeDivId){
	layer.open({
		type: 1,
		shade: 0.3,
		area:  ['500px', '400px'], //宽高
		title: '请选择', 
		offset: '30px',
		content: $("#"+treeDivId), //捕获的元素，注意：最好该指定的元素要存放在body最外层，否则可能被其它的相对元素所影响
		cancel: function(){

		}
	});
}
function zTreeDetpOnClick(event, treeId, treeNode, clickFlag){
	if(treeNode.isParent != null) {
			
			$("#"+treetype.replace("_","Name_")).val(treeNode.name);
			$("#" + treetype).val(treeNode.id);
			if(typeof callbackfunc == "function") {
				callbackfunc(treeNode.id,treeNode.name);
			} 
			/**
			 * 基金办签报部门负责人连动
			 */
			if(jjbtype!=""){
				initSelectUserByDeptId("qbbmfzr");
			}	
			layer.closeAll();
			dept_reply();
	}
}
function peopleOnDblclick(event, treeId, treeNode, clickFlag) {
	
	
	
	if(treeNode.isParent != null) {
		if(!treeNode.isParent) {
			$("#"+treetype.replace("_","Name_")).val(treeNode.name);
			$("#" + treetype).val(treeNode.id);
			
			/**
			 * 基金办签报部门负责人连动
			 */
			if(jjbtype!=""){
				initSelectUserByDeptId("qbbmfzr");
			}	
			layer.closeAll();
		}
	}
}
function deptOnDblclick(event, treeId, treeNode, clickFlag) {
	$("#"+treetype.replace("_","Name_")).val(treeNode.name);
	$("#" + treetype).val(treeNode.id);
	layer.closeAll();
}

//异步加载成功回调函数  
function deptgetOrgExpand(event, treeId, treeNode, msg) {
	var treeObj = $.fn.zTree.getZTreeObj("selectDept_tree");
	var nodes = treeObj.getNodes();
	for (var i = 0; i < nodes.length; i++) { //设置节点展开
		treeObj.expandNode(nodes[i], true, false, false);
	}
};
/*function dept_search(){
	$.ajax({
		url : "${ctx}/signatureController/findSignature",
		type : "post",
		dataType : "json",
		data : {
			bizId : bizId,
			filedName : filedName,
		},
		success : function(data) {
			var datapair = data.fieldHeader_ + "," + data.fieldValue;
			$sigdiv.jSignature("setData", "data:" + datapair);
			id = data.id;
		}
	})
}*/
/*$(function(){
	$("#inputdept-word").bind("input propertychange", function() { 
		var searchValue = $("#inputdept-word").val();
		if (searchValue != "请输入标题查询") {
			dept_search();
		}	
	});
})*/


function initDataDeptTable() {
	
	var datetable = $('#deptInfoList').DataTable();
	datetable.clear().draw();

}

$(function (){
	var datatable = $('#deptInfoList').DataTable({
		language: {
			"sProcessing": "处理中...",
			"sLengthMenu": "每页显示 _MENU_条记录",
			"sZeroRecords": "没有匹配结果",
			"sInfo": "共 _TOTAL_ 项",
			"sInfoEmpty": "显示第 0 至 0 条记录，共 0 条",
			"sInfoFiltered": "(由 _MAX_ 项结果过滤)",
			"sInfoPostFix": "",
			"sSearch": "搜索:",
			"sUrl": "",
			"sEmptyTable": "未检索出数据，请重新输入",
			"sLoadingRecords": "载入中...",
			"sInfoThousands": ",",
			"oPaginate": {
				"sFirst": "首页",
				"sPrevious": "上页",
				"sNext": "下页",
				"sLast": "末页"
			},
			"oAria": {
				"sSortAscending": ": 以升序排列此列",
				"sSortDescending": ": 以降序排列此列"
			}
		},//国际化
		columnDefs:[{ targets: [0], visible: false},{ targets: [1], visible: false}],//设置第一列与第二列为隐藏列
		keys:{focus:':eq(0)'},//设置初始化第一列获取焦点。（因为有两列为隐藏列故此处从0开始记2）
		searching:false,	//隐藏搜索插件
		deferRender:true,   //大数据延迟渲染选项，可优化速度
		scrollY: "172px",	//列表出现滚动条的高度
		scrollCollapse:true,	//允许表减少在高度有限数量的行所示。
		ordering: false,	//是否启用表格自带列排序
		scroller:true, 	//启动照片卷轴功能，提高性能
		serverSide: true,  //启用服务器端分页
		ajax: function (data, callback, settings) {
			//封装请求参数
			var param = {};
			param.rows = data.length;//页面显示记录条数，在页面显示每页显示多少项的时候
			//param.start = data.start;//开始的记录序号
			param.page = (data.start / data.length)+1;//当前页码
			param.searchValue = $("#inputdept-word").val()=="请输入查询内容"?"":$("#inputdept-word").val();
			//console.log(param);
			//ajax请求数据
			$.ajax({
				type: "POST",
				url: "fromsComponentsController/findDeptByName",
				cache: false,  //禁用缓存
				data: param,  //传入组装的参数
				dataType: "json",
				success: function (result) {
					//console.log(result);
						//封装返回数据
						var returnData = {};
						returnData.draw = data.draw;//这里直接自行返回了draw计数器,应该由后台返回
						returnData.recordsTotal = result.total;//返回数据全部记录
						returnData.recordsFiltered = result.total;//后台不实现过滤功能，每次查询均视作全部结果
						returnData.data = result.rows;//返回的数据列表
						//调用DataTables提供的callback方法，代表数据已封装完成并传回DataTables进行渲染
						//此时的数据需确保正确无误，异常判断应在执行此回调前自行处理完毕
						callback(returnData);
				}
			});
		},columns: [
	                { "data": "deptId" },
	                { "data": "deptName" },
	                { "data": "parentDeptName"}
	            ]
	});
	var browser=navigator.appName 
	var b_version=navigator.appVersion 
	var version=b_version.split(";"); 
	var trim_Version=version[1].replace(/[ ]/g,""); 
	if(browser!="Microsoft Internet Explorer" && trim_Version!="MSIE8.0") {
	//设置监听
	$("#inputdept-word").bind("input propertychange", function() {
		var searchValue = $("#inputdept-word").val();
		if (searchValue != "请输入查询内容") {
			dept_search();
		}	
	});
	}
	$('#deptInfoList tbody').on('click', 'tr', function () {
		
		var data = datatable.row( this ).data();
		$("#"+treetype.replace("_","Name_")).val(data.deptName);
		$("#" + treetype).val(data.deptId);
		if(typeof callbackfunc == "function") {
			callbackfunc(treeNode.id,treeNode.name);
		} 
		/**
		 * 基金办签报部门负责人连动
		 */
		if(jjbtype!=""){
			initSelectUserByDeptId("qbbmfzr");
		}	
		layer.closeAll();
		dept_reply();
	} );
	
	datatable.on( 'key', function ( e, datatable, key, cell, originalEvent ) {
	    if ( key === 13 ) { // return
	    	
	    	var data = datatable.row(cell.index().row).data();
	    	$("#"+treetype.replace("_","Name_")).val(data.deptName);
			$("#" + treetype).val(data.deptId);
			if(typeof callbackfunc == "function") {
				callbackfunc(treeNode.id,treeNode.name);
			}
			/**
			 * 基金办签报部门负责人连动
			 */
			if(jjbtype!=""){
				initSelectUserByDeptId("qbbmfzr");
			}	
			layer.closeAll();
			dept_reply();
	    }
	});
	 
});
function dept_search() {
	$("#selectdept_table").css("display",""); 
	$("#selectDept_div").css("display","none"); 
	$("#button_reply").css("display",""); 
	initDataDeptTable();
	$("#inputdept-word").focus();
}

function dept_reply(){
	$("#selectdept_table").css("display","none"); 
	$("#selectDept_div").css("display",""); 
	$("#button_reply").css("display","none"); 
	$("#inputdept-word").val("");
	$("#inputdept-word").focus();
	$("#"+treetype.replace("_","Name_")).focus();

}
