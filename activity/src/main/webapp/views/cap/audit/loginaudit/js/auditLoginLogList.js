/**
 * 初始化函数
 */
$(function() {
	// 初始化登录日志列表
	initAuditLoginLogList();
});

/**
 * 初始化登录日志列表
 * 
 * @param 无
 * @param 无
 */
function initAuditLoginLogList() {
	$('#auditLoginLogList').datagrid({
		url : 'auditLoginLogController/findByCondition',
		method : 'POST',
		idField : 'sessionId',
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
		   { field : 'sessionId',   title : '会话ID',hidden : true},
		   { field : 'acctLogin', 	title : '登陆账号',   width : 180, align : 'left' }, 
		   { field : 'userName', 	title : '用户姓名',   width : 180, align : 'left' },
		   { field : 'ipAddr', 		title : '登录IP',	    width : 100, align : 'left' },
		   { field : 'sysName',     title : '业务系统', 	width : 100, align : 'left' },
		   { field : 'loginTime',   title : '登录时间', 	width : 180, align : 'left' ,formatter : dateFormatter},
		   { field : 'logoutTime',  title : '登出时间', 	width : 180, align : 'left' ,formatter : dateFormatter},
		   { field : 'onlineTime', title : '在线时长（分）',   width : 100, align : 'left'}
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#auditLoginLogList').datagrid("clearChecked");
			//check the select row
			$('#auditLoginLogList').datagrid("selectRow", index);
		}
	});
}

/**
 * 查询
 * @author 王建坤
 * */
function submitForm() {
	var userName = $("#userName").textbox("getValue");
	var acctLogin = $("#acctLogin").textbox("getValue");
	var ipAddr = $("#ipAddr").textbox("getValue");
	var loginTimeStart = $("#loginTimeStart").textbox("getValue");
	var loginTimeEnd = $("#loginTimeEnd").textbox("getValue");
	$('#auditLoginLogList').datagrid({
		queryParams : {
			userName : userName,
			acctLogin : acctLogin,
			ipAddr : ipAddr,
			loginTimeStart : loginTimeStart,
			loginTimeEnd : loginTimeEnd
		}
	});
}

/**
 * 打开图表窗口
 * 
 * @author 王建坤
 * @Date 2016-09-29
 * */
function openEchartsDlg() {
	$('#echartsDialog').dialog('open');
	getEdata();
}

/**
 * 获取图表数据
 * 
 * @author 王建坤
 * @Date 2016-09-29
 * */
function getEdata() {
	var loginTime = $("#loginTime").textbox("getValue");
	$.ajax({
		type : 'post',
		url : 'auditLoginLogController/getEcharts',
		data : {
			loginTime : loginTime
		},
		dataType : 'json',
		success : function(data){
			createEcharts(data);
		}
	});
}

/**
 * 生成图表
 * 
 * @author 王建坤
 * @Date 2016-09-29
 * */
function createEcharts(data){
	var myChart = echarts.init(document.getElementById('echartsDiv'));

	option = {
		tooltip : {
			trigger : 'axis',
			formatter: "时间：{b}:00</br> 人数：{c}",
			position : function(pt) {
				return [ pt[0], '10%' ];
			}
		},
		title : {
			left : 'center',
			text : '登录日志统计图',
		},
		toolbox: {
	        feature: {
	            saveAsImage: {}
	        }
	    },
		xAxis : {
			name : '时间:(h)',
			type : 'category',
			boundaryGap : false,
			data : ['0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23']
		},
		yAxis : {
			name : '人数:',
			type : 'value',
			boundaryGap : [ 0, '100%' ]
		},
		series : [ {
			name : '人数',
			type : 'line',
			smooth : true,
			symbol : 'none',
			sampling : 'average',
			itemStyle : {
				normal : {
					color : 'rgb(255, 70, 131)'
				}
			},
			areaStyle : {
				normal : {
					color : new echarts.graphic.LinearGradient(0, 0, 0, 1,
							[ {
								offset : 0,
								color : 'rgb(255, 158, 68)'
							}, {
								offset : 1,
								color : 'rgb(255, 70, 131)'
							} ])
				}
			},
			data : data
		} ]
	};

	myChart.setOption(option);
}
/*************************** 格式化字段值 ***************************/
/**
 * 格式化是否封存节点
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function dateFormatter(val, row) {
	if (val != null && val !='') {
		return val.substr(0,val.length-2);
	}
}