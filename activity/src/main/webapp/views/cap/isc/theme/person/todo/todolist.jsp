<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
		<title>个人桌面待办事项</title>		
		<%@ include file="/views/aco/common/head.jsp"%>
		<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
		<link href="${ctx}/views/cap/isc/theme/common/css/pages.css" rel="stylesheet">
		<link href="${ctx}/views/cap/isc/theme/common/css/skin-red.css" rel="stylesheet">
		<style type="text/css">
			body{
				 background-color:#FFF;
			}
			.panel-other{
				border:1px solid transparent;
			}
			.refresh{
				position:absolute;
				top:2px;
				right:80px;
             }
             .todolist{
				left:30px;
             }
             .panel .panel-heading > h2 > i {
             	top:5px;
             }
		</style>
	<%@ include file="/views/cap/common/theme.jsp"%>
	</head>
<body>
<div class="panel panel-other" id="todoPanel">
	<div class="panel-heading">
	<h2>
			<!--<img src="${ctx}/static/aco/images/title_1.png">-->
			<i class="iconfont icon-daibanshixiang"></i>
			<!-- <strong>待办事项(<span id="totalcount"></span>)</strong> -->
		</h2>
		<div class="refresh">
			<a href="javascript:;" class="fa fa-refresh" onclick="init()"></a>
		</div>
		<div class="more">
			<a href="javascript:;" class="more" onclick="opentabs('待办事项','8a816d115691473c0156920bfaf90001','/bpmQuery/toTaskTodoList');">MORE</a>
		</div>
	</div>
	<div class="panel-body" style="padding:0;">
		<ul class="nav nav-tabs small_tabs todo_tabs todolist" role="tablist">
		<li id="tasks" role="presentation" class="active">
           		&nbsp;&nbsp;&nbsp;&nbsp;<a href="#total" aria-controls="total" role="tab" data-toggle="tab" 
           			onclick="getToDoTasks('total')"><strong>待办事项(<span id="totalcount"></span>条)</strong></a>
           	</li>
         	<li id="tasks2" role="presentation">
           		&nbsp;&nbsp;<a href="urgent" aria-controls="urgent" role="tab" data-toggle="tab" 
           			onclick="getToDoTasks('urgent')">急件(<span id="urgentcount"></span>)</a>
           	</li>
           	 <li id="tasks1" role="presentation">
           		<a href="#flat" aria-controls="flat" role="tab" data-toggle="tab" 
           			onclick="getToDoTasks('flat')">平件(<span id="flatcount"></span>)</a>
           	</li>
          	<li id="tasks3" role="presentation">
          		<a href="#read" aria-controls="read" role="tab" data-toggle="tab" 
          			onclick="getToDoTasks('read')">阅件(<span id="readcount"></span>)</a></li>
           	<li role="presentation">
		</ul>
        <div class="tab-content">
              	<div class="tab-pane active">
               	<table class="table table-hover table_td" id="todoArea">
	        	</table>
        	</div>
    	</div>
	</div>
</div>
</body>  
<script type="text/javascript">
	$(document).ready(function(){
		init();//首次加载
		<shiro:lacksPermission  name="on:msgpushController:msgpush">
			setInterval(init,600000);//定时加载
		</shiro:lacksPermission>
	});
	function init(){
		if (parent.parent.IS_SYS_ON_LINE){
			//打开个人桌面时初始化数据展示
			getToDoTasks("total");
			//查询待办数量
			getToDoTasksNums();
			var $li = $('#tasks');
			if( !$li.hasClass("active")) {
				$li.addClass('active').siblings().removeClass("active");
			}
		}
	}
	function getToDoTasksNums(){
		var rd = "?random=" + Math.random();  
		$.ajax({
		    url:'${ctx}/personHomeQueryController/getToDoTasksNums'+rd,
			type:'post',
			dataType:'json',
			success:function(data) {
				if(data.flag=='1') {
					var json = data.result;
					var dbsl = "0";//待办数量
					var jjsl = "0";//急件数量
					var qtsl = "0";//其他
					var yjsl = "0";//阅件数量
					$.each(json, function(idx, obj) {
						if(obj.tasktype=='2' || obj.tasktype=='3') {//急件数量
							jjsl = parseInt(jjsl) + parseInt(obj.nums);
							dbsl = parseInt(dbsl) + parseInt(obj.nums);
						}else if(obj.tasktype=='read'){//阅件数量
							yjsl = parseInt(yjsl) + parseInt(obj.nums);
							dbsl = parseInt(dbsl) + parseInt(obj.nums);
						}else{//其他
							qtsl = parseInt(qtsl) + parseInt(obj.nums);
							dbsl = parseInt(dbsl) + parseInt(obj.nums);
						}
					});
					$("#readcount").html(yjsl);
					$("#flatcount").html(qtsl);
					$("#urgentcount").html(jjsl);//设置公文数量
					$("#totalcount").html(dbsl);//设置待办总数量
				}
			}
		});
	}
	function getToDoTasks(taskType){
		var rd = "?random=" + Math.random();  
		$("#todoArea").html("");
		var taskValue = "";//数据结果
		$.ajax({
		    url:'${ctx}/personHomeQueryController/getToDoTasks'+rd,
			type:'post',
			dataType:'json',
			data: {taskType:taskType},
			success:function(data) {
				if(data.flag=='1') {
					var json = data.result;
					$.each(json, function(idx, obj) {
					  	if(null != obj.title && obj.title.length > 40){
					  		obj.title=obj.title.substr(0, 39)+"...";
				    	}
						if(taskType=='total'){
							if(idx==0) {
								taskValue = taskValue+"<tr><td style='width:100%;' title='"+obj.title+"' onclick='opentab(\""+obj.title+"\",\""+obj.bizid+"\",\""+obj.taskid+"\",\""+obj.type+"\",\""+obj.solId+"\")'>"
									+"<span></span><span class='count red'>"+(idx+1) + "</span>"+obj.title+"</td><td style='text-align: center;width:90px;'>"+obj.creator+"</td><td class='time' style='text-align: left;width:95px;'>"+formatTime(obj.endtime)+"</td></tr>";
							}else if(idx==1) {
								taskValue = taskValue+"<tr><td style='width:100%;' title='"+obj.title+"' onclick='opentab(\""+obj.title+"\",\""+obj.bizid+"\",\""+obj.taskid+"\",\""+obj.type+"\",\""+obj.solId+"\")'>"
									+"<span></span><span class='count green'>"+(idx+1) + "</span>"+obj.title+"</td><td style='text-align: center;width:90px;'>"+obj.creator+"</td><td class='time' style='text-align: left;width:95px;'>"+formatTime(obj.endtime)+"</td></tr>";
							}else if(idx==2) {
								taskValue = taskValue+"<tr><td style='width:100%;' title='"+obj.title+"' onclick='opentab(\""+obj.title+"\",\""+obj.bizid+"\",\""+obj.taskid+"\",\""+obj.type+"\",\""+obj.solId+"\")'>"
									+"<span></span><span class='count blue'>"+(idx+1) + "</span>"+obj.title+"</td><td style='text-align: center;width:90px;'>"+obj.creator+"</td><td class='time' style='text-align: left;width:95px;'>"+formatTime(obj.endtime)+"</td></tr>";
							}else {
								taskValue = taskValue+"<tr><td style='width:100%;' title='"+obj.title+"' onclick='opentab(\""+obj.title+"\",\""+obj.bizid+"\",\""+obj.taskid+"\",\""+obj.type+"\",\""+obj.solId+"\")'>"
								+"<span></span><span class='count'>"+(idx+1) + "</span>"+obj.title+"</td><td style='text-align: center;width:90px;'>"+obj.creator+"</td><td class='time' style='text-align: left;width:95px'>"+formatTime(obj.endtime)+"</td></tr>";
							}
						}else{
							if(idx==0) {
									taskValue = taskValue+"<tr><td style='width:100%;' title='"+obj.title+"' onclick='opentab(\""+obj.title+"\",\""+obj.bizid+"\",\""+obj.taskid+"\",\""+taskType+"\",\""+obj.solId+"\")'>"
										+"<span></span><span class='count red'>"+(idx+1) + "</span>"+obj.title+"</td><td style='text-align: center;width:90px;'>"+obj.creator+"</td><td class='time' style='text-align: left;width:95px;'>"+formatTime(obj.endtime)+"</td></tr>";
								}else if(idx==1) {
									taskValue = taskValue+"<tr><td style='width:100%;' title='"+obj.title+"' onclick='opentab(\""+obj.title+"\",\""+obj.bizid+"\",\""+obj.taskid+"\",\""+taskType+"\",\""+obj.solId+"\")'>"
										+"<span></span><span class='count green'>"+(idx+1) + "</span>"+obj.title+"</td><td style='text-align: center;width:90px;'>"+obj.creator+"</td><td class='time' style='text-align: left;width:95px;'>"+formatTime(obj.endtime)+"</td></tr>";
								}else if(idx==2) {
									taskValue = taskValue+"<tr><td style='width:100%;' title='"+obj.title+"' onclick='opentab(\""+obj.title+"\",\""+obj.bizid+"\",\""+obj.taskid+"\",\""+taskType+"\",\""+obj.solId+"\")'>"
										+"<span></span><span class='count blue'>"+(idx+1) + "</span>"+obj.title+"</td><td style='text-align: center;width:90px;'>"+obj.creator+"</td><td class='time' style='text-align: left;width:95px;'>"+formatTime(obj.endtime)+"</td></tr>";
								}else {
									taskValue = taskValue+"<tr><td style='width:100%;' title='"+obj.title+"' onclick='opentab(\""+obj.title+"\",\""+obj.bizid+"\",\""+obj.taskid+"\",\""+taskType+"\",\""+obj.solId+"\")'>"
									+"<span></span><span class='count'>"+(idx+1) + "</span>"+obj.title+"</td><td style='text-align: center;width:90px;'>"+obj.creator+"</td><td class='time' style='text-align: left;width:95px;'>"+formatTime(obj.endtime)+"</td></tr>";
								}
						}
					});
				}else {
					taskValue = taskValue + "" ;
				}
			   var thead="<tr><td style='width:100%;'><span></span><span class='count' style='visibility: hidden;'></span><strong>标题</strong></td><td style='text-align: center;width:90px;'><strong>拟稿人</strong></td><td class='count' style='text-align: left;width:95px;'><strong>拟稿时间</strong></td></tr>";
				$("#todoArea").html(thead+taskValue);
				parent.parent.todoiFrameReady=true;
			}
		});
	}
	 function opentabs(title,id,url) {
		var options={
				"text":title,
				"id":id,
				"href":'${ctx}'+url,
				"pid":window.parent.parent,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":false
		};
		window.parent.parent.createTab(options);
	} 
	 function opentab(title,bizid,taskid,type,solId) {
		 var id='';
		 var url = "";//url地址
		 if(type=='read'){
			 id=taskid;
			 url="/bpmCirculate/findCirculate?bizid="+bizid+"&id="+taskid+"&solId="+ solId;
		 }else{
			id= bizid;
			url = "/bizRunController/getBizOperate?status=3&solId="+ solId + "&taskId=" + taskid + "&bizId=" + bizid;
		 }
		var options={
				"text":title,
				"id":id,
				"href":'${ctx}'+url,
				//"pid":window.parent.parent,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":false
		};
		window.parent.parent.createTab(options);
		if(window.parent.parent.setReadNotice){
			window.parent.parent.setReadNotice("cap-aco",id);
		}
			} 
 function formatTime(time){	
	 if(time!=null&&time!=''){
		 var oldTime = (new Date(time.replace(/-/g, "/"))).getTime();
	     var curTime = new Date(oldTime).format("yyyy-MM-dd");
		 return curTime;
	 }else{
		 return time;
	 }	 
}
 	 Date.prototype.format = function(fmt) { 
	     var o = { 
	        "M+" : this.getMonth()+1,                 //月份 
	        "d+" : this.getDate(),                    //日 
	        "h+" : this.getHours(),                   //小时 
	        "m+" : this.getMinutes(),                 //分 
	        "s+" : this.getSeconds(),                 //秒 
	        "q+" : Math.floor((this.getMonth()+3)/3), //季度 
	        "S"  : this.getMilliseconds()             //毫秒 
	    }; 
	    if(/(y+)/.test(fmt)) {
	            fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	    }
	     for(var k in o) {
	        if(new RegExp("("+ k +")").test(fmt)){
	             fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
	         }
	     }
	    return fmt; 
	}   
</script>
</html>