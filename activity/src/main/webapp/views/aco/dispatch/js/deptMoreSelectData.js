var treetype;
var style;
var map={};
function deptMoreTree(type, treeType,event) {
	treetype = treeType;
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
				onDblClick : deptMoreOnDblclick,
				onAsyncSuccess: deptMoregetOrgExpand,
				onClick: zTreeDetpMoreOnClick
			}
	};
	$.fn.zTree.init($("#selectDeptMore_tree"), setting);
	deptMore_reply();
	opendeptMoreSelectTree("selectionDeptMore_div");
}
function opendeptMoreSelectTree(treeDivId){
	layer.open({
		type: 1,
		shade: 0.3,
		area: ['800px', '425px'],
		title: '请选择', 
		offset: 'auto',
		content: $("#"+treeDivId), //捕获的元素，注意：最好该指定的元素要存放在body最外层，否则可能被其它的相对元素所影响
		cancel: function(){

		}
	});
}
function zTreeDetpMoreOnClick(event, treeId, treeNode, clickFlag){
	if(treeNode.isParent != null) {
		if (map[treeNode.id] == undefined) {
			$("#chooseDept_div").append("<span class='label chooseDept_span' id='"+treeNode.id+"' >"+treeNode.name+"<i class='fa fa-close' onclick='removeDept(\""+treeNode.id+"\");'></i></span>");
			  map[treeNode.id] = treeNode.name;
		} else {
			
		}
	}
}
function DeptOnDblclick(event, treeId, treeNode, clickFlag) {
	if(treeNode.isParent != null) {
		if(!treeNode.isParent) {
			if (map[treeNode.id] == undefined) {
				$("#chooseDept_div").append("<span class='label chooseDept_span' id='"+treeNode.id+"' >"+treeNode.name+"<i class='fa fa-close' onclick='removeDept(\""+treeNode.id+"\");'></i></span>");
				  map[treeNode.id] = treeNode.name;
			} else {
				
			}
		}
	}
}
function deptMoreOnDblclick(event, treeId, treeNode, clickFlag) {
	$("#"+treetype.replace("_","Name_")).val(treeNode.name);
	$("#" + treetype).val(treeNode.id);
	layer.closeAll();
}

//异步加载成功回调函数  
function deptMoregetOrgExpand(event, treeId, treeNode, msg) {
	var treeObj = $.fn.zTree.getZTreeObj("selectDeptMore_tree");
	var nodes = treeObj.getNodes();
	for (var i = 0; i < nodes.length; i++) { //设置节点展开
		treeObj.expandNode(nodes[i], true, false, false);
	}
};


function initDatadeptMoreTable() {
	
	var datetable = $('#deptMoreInfoList').DataTable();
	datetable.clear().draw();

}

$(function (){
	var datatable = $('#deptMoreInfoList').DataTable({
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
			param.searchValue = $("#inputDeptMore-word").val()=="请输入查询内容"?"":$("#inputDeptMore-word").val();
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
	$("#inputDeptMore-word").bind("input propertychange", function() {
		var searchValue = $("#inputDeptMore-word").val();
		if (searchValue != "请输入查询内容") {
			deptMore_search();
		}	
	});
	}
	$('#deptMoreInfoList tbody').on('click', 'tr', function () {
		var data = datatable.row( this ).data();
		if (map[data.deptId] == undefined) {
			$("#chooseDept_div").append("<span class='label label-success chooseDept_span' id='"+data.deptId+"' >"+data.deptName+"<i class='fa fa-close' onclick='removeDept(\""+data.deptId+"\");'></i></span>");
			  map[data.deptId] = data.deptName;
		} else {
			
		}
	} );
	
	datatable.on( 'key', function ( e, datatable, key, cell, originalEvent ) {
	    if ( key === 13 ) { // return
	    	var data = datatable.row(cell.index().row).data();
	    	if (map[data.deptId] == undefined) {
				$("#chooseDept_div").append("<span class='label label-success chooseDept_span' id='"+data.deptId+"' >"+data.deptName+"<i class='fa fa-close' onclick='removeDept(\""+data.deptId+"\");'></i></span>");
				  map[data.deptId] = data.deptName;
			} else {
				
			}
	    }
	});
	 
});



function removeDept(id){1
	// 删除  
	delete map[id];  
	$("#"+id).remove();
}

function IndexLibraryDept_close(){
	map = {};
	//选择div内的span标签
	var objects=$("#chooseDept_div").children("span");
	for(var i=0;i<objects.length;i++){
	    objects[i].remove();
	}
	layer.closeAll();
	deptMore_reply();
}

function IndexLibraryDept_select(){

	var username =[];
	var userid =[];
	// 遍历 
	var i = 0;
	for(key in map){  
		username[i] =  map[key];
		userid[i]= key;
		i++;
	}
	$("#"+treetype.replace("_","Name_")).val(username);
	$("#" + treetype).val(userid);layer.closeAll();
	IndexLibraryDept_close();
}

function deptMore_search() {
	$("#selectDeptMore_table").css("display",""); 
	$("#selectDeptMore_div").css("display","none"); 
	$("#deptMore_reply").css("display",""); 
	initDatadeptMoreTable();
	$("#inputDeptMore-word").focus();
	$("#"+treetype.replace("_","Name_")).focus();

}

function deptMore_reply(){
	$("#selectDeptMore_table").css("display","none"); 
	$("#selectDeptMore_div").css("display",""); 
	$("#deptMore_reply").css("display","none"); 
	$("#inputDeptMore-word").val("");
	$("#inputDeptMore-word").focus();
	
	
}
