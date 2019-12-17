var treetype;
var style;
var callbackfunc;
var map = {};
function peopleMoreTree(type, treeType,event,callback) {
	callbackfunc=callback;
	treetype = treeType;
	style = type;
	var url;
	if (type == "1") {//拟稿人
		url = "orgController/getDeptUserTree";
	}
	if (type == "3") {//校对人
		url = "systree/getOrgPersonData?type="+treetype;	
	}
	var	setting = {
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
				onAsyncSuccess: PeopleMoregetOrgExpand,
				onClick: zTreePeopleMoreOnClick
			}
	};
	$.fn.zTree.init($("#selectPeopleMore_tree"), setting);
	PeopleMore_reply();
	openPeopleMoreSelectTree("selectionPeopleMore_div");
}
function openPeopleMoreSelectTree(treeDivId){
	layer.open({
		type: 1,
		shade: 0.3,
		area: ['800px', '425px'],
		title: '请选择', 
		offset: 'auto',
		scrollbar: false,
		content: $("#"+treeDivId), //捕获的元素，注意：最好该指定的元素要存放在body最外层，否则可能被其它的相对元素所影响
		cancel: function(){
		}
	});
}
function zTreePeopleMoreOnClick(event, treeId, treeNode, clickFlag){
	if(treeNode.isParent != null) {
		if(!treeNode.isParent) {
			
			if (map[treeNode.id] == undefined) {
				$("#choosePeople_div").append("<span class='label label-success choosePeople_span' id='"+treeNode.id+"' >"+treeNode.name+"<i class='fa fa-close' onclick='removePeople(\""+treeNode.id+"\");'></i></span>");
				  map[treeNode.id] = treeNode.name;
			} else {
				
			}
			
			/*$("#"+treetype.replace("_","Name_")).val(treeNode.name);
			$("#" + treetype).val(treeNode.id);*/
			if(typeof callbackfunc == "function") {
				callbackfunc(treeNode.id,treeNode.name);
			} 
			/*layer.closeAll();
			PeopleMore_reply();*/
		}else{
			var treeObj = $.fn.zTree.getZTreeObj("selectPeopleMore_tree");
			if (treeNode.open) {
				treeObj.expandNode(treeNode, false, false, false);
			}else{
				treeObj.expandNode(treeNode, true, false, false);
			}
		}
	}
}
//异步加载成功回调函数  
function PeopleMoregetOrgExpand(event, treeId, treeNode, msg) {
	var treeObj = $.fn.zTree.getZTreeObj("selectPeopleMore_tree");
	var nodes = treeObj.getNodes();
	for (var i = 0; i < nodes.length; i++) { //设置节点展开
		treeObj.expandNode(nodes[i], true, false, false);
	}
};
/*function PeopleMore_search(){
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
	$("#inputPeopleMore-word").bind("input propertychange", function() { 
		var searchValue = $("#inputPeopleMore-word").val();
		if (searchValue != "请输入标题查询") {
			PeopleMore_search();
		}	
	});
})*/
function initDataPeopleMoreTable() {
	var datetable = $('#PeopleMoreInfoList').DataTable();
//	datetable.cell(':eq(2)').focus();
	datetable.clear().draw();
}



$(function (){
	var datatable = $('#PeopleMoreInfoList').DataTable({
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
		scrollY: "227px",	//列表出现滚动条的高度
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
			param.searchValue = $("#inputPeopleMore-word").val()=="请输入查询内容"?"":$("#inputPeopleMore-word").val();
			//console.log(param);
			//ajax请求数据
			$.ajax({
				type: "POST",
				url: "fromsComponentsController/findUserByName",
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
	                { "data": "userId" },
	                { "data": "userName" },
	                { "data": "postName"}
	            ]
	});
	var browser=navigator.appName 
	var b_version=navigator.appVersion 
	var version=b_version.split(";"); 
	var trim_Version=version[1].replace(/[ ]/g,""); 
	if(browser!="Microsoft Internet Explorer" && trim_Version!="MSIE8.0") {
		//设置监听
		$("#inputPeopleMore-word").bind("input propertychange", function() { 
			var searchValue = $("#inputPeopleMore-word").val();
			if (searchValue != "请输入查询内容") {
				PeopleMore_search();
			}	
		});
	}
	$('#PeopleMoreInfoList tbody').on('click', 'tr', function () {
		var data = datatable.row( this ).data();
		
		/*<span class="label label-success choosePeople_span" >王贱坤    <i class="fa fa-close" onclick="addPeople();"></i></span>*/
		if (map[data.userId] == undefined) {
			$("#choosePeople_div").append("<span class='label label-success choosePeople_span' id='"+data.userId+"' >"+data.userName+"<i class='fa fa-close' onclick='removePeople(\""+data.userId+"\");'></i></span>");
			  map[data.userId] = data.userName;
		} else {
			
		}
		  
/*		  var map = {};  
		  
		// put  
		var key = "key1";  
		var value = "value1";  
		map[key] = value;  
		  
		// get  
		alert(map[key]);  
		  
		if("key1" in map) { //判断是否存在  
		  alert("OK");  
		}  
		  
		// 删除  
		delete map["key1"];   
		  
		// 遍历  
		for(key in map){  
		    alert(key + map[key]);  
		}  */
		  
		  
		  /*$("#"+treetype.replace("_","Name_")).val(data.userName);
		$("#" + treetype).val(data.userId);
		if(typeof callbackfunc == "function") {
			callbackfunc(data.userId,data.userName);
		} 
		layer.closeAll();
		PeopleMore_reply();*/
	} );
	
	datatable.on( 'key', function ( e, datatable, key, cell, originalEvent ) {
	    if ( key === 13 ) { // return
	    	var data = datatable.row(cell.index().row).data();
	    	
	    	if (map[data.userId] == undefined) {
				$("#choosePeople_div").append("<span class='label label-success choosePeople_span' id='"+data.userId+"' >"+data.userName+"<i class='fa fa-close' onclick='removePeople(\""+data.userId+"\");'></i></span>");
				  map[data.userId] = data.userName;
			} else {
				
			}
	    	/*$("#"+treetype.replace("_","Name_")).val(data.userName);
			$("#" + treetype).val(data.userId);
			if(typeof callbackfunc == "function") {
				callbackfunc(data.userId,data.userName);
			} 
			layer.closeAll();
			PeopleMore_reply();*/
	    }
	});
	 
});

function removePeople(id){1
	// 删除  
	delete map[id];  
	$("#"+id).remove();
}

function IndexLibrary_close(){
	map = {};
	//选择div内的span标签
	var objects=$("#choosePeople_div").children("span");
	for(var i=0;i<objects.length;i++){
	    objects[i].remove();
	}
	layer.closeAll();
	PeopleMore_reply();
}

function IndexLibrary_select(){

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
	IndexLibrary_close();
}

function PeopleMore_search() {
	$("#selectPeopleMore_table").css("display",""); 
	$("#selectPeopleMore_div").css("display","none"); 
	$("#buttonPeopleMore_reply").css("display",""); 
	initDataPeopleMoreTable();
	$("#inputPeopleMore-word").focus();
}

function PeopleMore_reply(){
	$("#selectPeopleMore_table").css("display","none"); 
	$("#selectPeopleMore_div").css("display",""); 
	$("#buttonPeopleMore_reply").css("display","none"); 
	$("#inputPeopleMore-word").val("");
	$("#inputPeopleMore-word").focus();
	$("#"+treetype.replace("_","Name_")).focus();

}
