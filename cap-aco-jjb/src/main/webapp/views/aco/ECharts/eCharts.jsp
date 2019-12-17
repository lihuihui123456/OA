<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>项目预算报表</title>
<style type="text/css">
.btn-div{
	padding: 5px 0px;
}
#search-div{
	width: 300px; 
	float: right;
}
</style>
<%@ include file="/views/aco/common/head.jsp"%>
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css">
<link href="${ctx}/views/aco/ECharts/css/<shiro:principal property="skinCode" />/eCharts.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<link rel="stylesheet" type="text/css"  href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>

<style> 
.divLeft{float:right;} 
</style> 

 <!-- 引入 ECharts 文件 -->
 <script src="${ctx}/views/aco/ECharts/js/echarts.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%> 
</head>
<body style="padding: 10px;">
	<div class="panel panel-other " style="background-color: white;margin-bottom:0px;border:1px #D9D9D9 solid;">
	<!-- 搜索框 -->
	<div style="margin-top:-1px;" class="btn-div" id="search-div">
		<div class="input-group" style="float: right;">
			<label class="lable">年度：</label>
			<div class="btn-group">
			  <button class="btn btn-default btn-xs dropdown-toggle" type="button" style="width: 150px;height: 30px" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			    <span id="dropdown-value"></span> <span style="position: absolute; right:2px;top:50%;" class="caret"></span>
			  </button>
			  <ul style="width: 150px;text-align: center;" class="dropdown-menu">
			    <li class="dropdown-li-e">2016</li>
			    <li class="dropdown-li-e">2017</li>
			  </ul>
			</div>
			<i onclick="refresh()" class="fa fa-refresh"></i>
			&nbsp;&nbsp;
		</div>
	</div>
	<div style="margin-top:-1px;float: right;" class="btn-div" id="search-div">
		<div class="input-group" style="float: right;">
			<label class="lable">单位名称：</label>
			<div class="btn-group">
			  <button class="btn btn-default btn-xs dropdown-toggle" type="button" style="width: 150px;height: 30px" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			    <span id="dropdown-values"></span> <span style="position: absolute; right:2px;top:50%;" class="caret"></span>
			  </button>
			  <ul style="width: 150px;text-align: center;" class="dropdown-menu">
			    <li class="dropdown-li-es">国家总署</li>
			    <li class="dropdown-li-es">西藏公安厅</li>
			  </ul>
			</div>
		</div>	
	</div>
	
	<!-- table工具栏 -->
	<div >
		<h5><font class="lab">&nbsp;&nbsp;&nbsp;项目预算执行分析</font></h5>
	</div>
	</div>
	
	<div style="background-color: white;border:1px #D9D9D9 solid;border-top:0px">
	<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
    <div id="main" style="width: 85%;height:300px; margin:0 auto;background: white;"></div>
    </div>
	<!-- 搜索框 -->
	<div style="margin-top:15px;" class="btn-div" id="search-div">
		<div class="input-group" style="float: right;">
			<label class="lable">月份：</label>
			<div class="btn-group">
			  <button class="btn btn-default btn-xs dropdown-toggle" type="button" style="width: 150px;height: 30px" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			     <span style="position: absolute; right:2px;top:50%;" class="caret"></span>
			  </button>
			  <ul style="width: 150px;text-align: center;" class="dropdown-menu">
			    <li>3月</li>
			    <li>2月</li>
			    <li>1月</li>
			  </ul>
			</div>
			<i class="fa fa-refresh"></i>
			&nbsp;&nbsp;
		</div>
	</div>
	
	
	<!-- table工具栏 -->
	<div class="panel panel-other " style="background-color: white;margin-bottom:0px;border:1px #D9D9D9 solid;border-bottom:0px;margin-top:10px;">
	<div class="btn-div">
		<h5><font class="lab">&nbsp;&nbsp;&nbsp;2016年6月项目预算执行分析表</font></h5>
	</div>
	</div>
	
	<!-- 数据列表 -->
	<table id="bizInfoList">
		<thead>
			<tr>
				<th data-align="center" data-valign="middle" data-field="index">项目代码</th>
				<th data-align="center" data-valign="middle" data-field="title">项目名称</th>
				<th data-align="center" data-valign="middle" data-field="month">月份</th>
				<th data-align="center" data-valign="middle" data-field="num">预算数</th>
				<th data-align="center" data-valign="middle" data-field="outNum">支出数</th>
				<th data-align="center" data-valign="middle" data-field="doNum">执行进度（%）</th>
			</tr>
		</thead>
			<tr>
				<td>201633829</td>
				<td>项目1</td>
				<td>6</td>
				<td>500</td>
				<td>300.60</td>
				<td class="cl1">84.84</td>
			</tr>
			<tr>
				<td>201633830</td>
				<td>项目2</td>
				<td>6</td>
				<td>400</td>
				<td>300.60</td>
				<td class="cl1">72.12</td>
			</tr>
			<tr>
				<td>201633831</td>
				<td>项目3</td>
				<td>6</td>
				<td>300</td>
				<td>300.60</td>
				<td class="cl2">69.23</td>
			</tr>
			<tr>
				<td>合计</td>
				<td></td>
				<td></td>
				<td>1200</td>
				<td>901.80</td>
				<td class="cl2">57.14</td>
			</tr>
	</table>
	
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var solId = "${solId}";//业务解决方案id
	
	var mySwiper = new Swiper('.swiper-container',{
	    loop:true,
		onSlidePrev: function(swiper){
		$("#bizInfoList").bootstrapTable('prevPage');
		  },
		onSlideNext: function(swiper){
		$("#bizInfoList").bootstrapTable('nextPage');
		}
	});
	$(document).ready(function(){
		$(".dropdown-li-e").click(function(){
			$("#dropdown-value").text($(this).text());
		});
		
		$(".dropdown-li-es").click(function(){
			$("#dropdown-values").text($(this).text());
		});
	});
	$(function(){
		$('#bizInfoList').bootstrapTable({
			//url : 'bpmRuBizInfoController/findBpmRuBizInfoBySolId', // 请求后台的URL（*）
			//method : 'get', // 请求方式（*）
			striped : true, // 是否显示行间隔色
			cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
			pagination : false, // 是否显示分页（*）
	        //sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
			clickToSelect : true, // 是否启用点击选中行
	        //idField : "id",  //指定主键列
		});
		
		$(".cl1").css('background-color','orange');
		$(".cl2").css('background-color','red');
	});
	
</script>
<script type="text/javascript">
        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));

        // 指定图表的配置项和数据
        var option = {
            tooltip: {},
            legend: {
                data:['']
            },
            xAxis: {
                name:'项目名称' ,
            	data: ["项目1","项目2","项目3","项目4","项目5","项目6","项目7","项目8","项目9","项目...","项目n"]
            },
            yAxis: [{
            	name:'百分比：%' ,
            	y: 'center'
            }],
            series: [{
                name: '销量',
                type: 'bar',
                itemStyle:{
                    normal:{
                        label:{position: "top",
                                show: true
                        }
                    }
                },
                barWidth : 30,
                data: [84.84, 72.12, 69.23, 68.40, 67.85, 60.84,60.12,58.23,38.40,30.85,29.91]
            }]
        };

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
        function refresh(){
        	if($("#dropdown-value").text()=="2016"){
        		option = {
                        series: [{
                            name: '销量',
                            type: 'bar',
                            itemStyle:{
                                normal:{
                                    label:{position: "top",
                                            show: true
                                    }
                                }
                            },
                            barWidth : 30,
                            data: [81.84, 80.12, 66.23, 66.40, 77.85, 64.84,64.12,56.23,40.40,32.85,30.91]
                        }]
                    };
        	}else{
        		option = {
                        series: [{
                            name: '销量',
                            type: 'bar',
                            itemStyle:{
                                normal:{
                                    label:{position: "top",
                                            show: true
                                    }
                                }
                            },
                            barWidth : 30,
                            data: [84.84, 72.12, 71.23, 68.40, 67.85, 60.84,60.12,58.23,38.40,30.85,29.91]
                        }]
                    };
        	}
        	
        myChart.setOption(option);
    	}
    </script>
<!-- 页面自己的 js -->
<%-- <script type="text/javascript" src="${ctx}/views/aco/bpm/list/js/biz_list_common.js"></script> --%>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>
