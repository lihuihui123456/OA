/**
 * 初始化函数
 */
$(function() {
	initList();
});

/**
 * 初始化登录日志列表
 * 
 * @param 无
 * @param 无
 */
function initList() {
	$('#dtList').datagrid({
		url : 'timerController/findKeyWordListData',
		method : 'POST',
		idField : 'id',
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		fit: true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
//		   { field : 'ck',checkbox : true}, 
		   { field : 'id',   		title : 'ID',	   hidden : true},
		   { field : 'keyWord', 	title : '搜索关键词',   width : 180, align : 'center' }, 
		   { field : 'number', 		title : '搜索次数',   width : 180, align : 'center' }
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#dtList').datagrid("clearChecked");
			//check the select row
			$('#dtList').datagrid("selectRow", index);
		}
	});
}

/**
 * 打开图表窗口
 * */
function openEchartsDlg() {
	$("#echartsDiv").html("");
	$('#echartsDialog').dialog('open');
	getEdata();
}

/**
 * 获取图表数据
 * */
function getEdata() {
	$.ajax({
		type : 'post',
		url : 'timerController/getEcharts',
		data : {},
		dataType : 'json',
		success : function(data){
			createEcharts(data);
		}
	});
}

/**
 * 生成图表
 * */
function createEcharts(data){
	var myChart = echarts.init(document.getElementById('echartsDiv'));

	option = {
		title : {
	        text: '用户检索统计',
	        x:'center'
	    },
	    tooltip : {
	        trigger: 'item',
	        formatter: "{b} : {c}次 ({d}%)"
	    },
	    series : [
	        {
	            name:'检索关键词',
	            type:'pie',
	            radius : '70%',
	            center: ['50%', '60%'],
	            data:data
	        }
	    ]
	};

	myChart.setOption(option);
}