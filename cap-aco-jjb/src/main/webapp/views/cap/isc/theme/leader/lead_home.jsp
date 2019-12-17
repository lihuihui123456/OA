<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
	    <title>办公系统</title>		
		<%@ include file="/views/aco/common/head.jsp"%>
		<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
		<script src="${ctx}/views/cap/isc/theme/leader/js/lead_home.js"></script>
		<%-- <script src="${ctx}/views/cap/isc/theme/leader/js/createtab.js"></script> --%>
		<script src="${ctx}/static/cap/plugins/bootstrap/js/createtab.js"></script>
		<link href="${ctx}/views/cap/isc/theme/leader/css/lead.css" rel="stylesheet">
		<script src="${ctx}/views/cap/isc/theme/leader/js/zoomButton_lead.js"></script>
		<%@ include file="/views/cap/common/theme.jsp"%>
		<style type="text/css">
			html, head ,body { height: 100%; border:0; padding:0; margin:0; } 
			body{ overflow:auto;} 
			.left_part{top:10px;}
			.center_part{margin-top:10px;}
		</style>
	</head>
	<body onload="reloadHome()">
		<input type="hidden" id="isChecked"/>
		<input type="hidden" id="modIds"/>
		<div class="lead_left_min"></div>
		<div class="left_part">
			<!-- 左侧顶部新闻图片轮播 -->
			<div class="carousel">
				 <iframe id="newsPicsFrame" src="${ctx}/sysNewsPicController/doGetCarouselSysNewsPic" width="325" height="200"  frameborder=0 scrolling=no></iframe> 
			</div>
			<div class="panel panel-other">
			    <iframe id="notice_iframe" width="100%"  frameborder=0 scrolling=no>
				</iframe>					        
			</div>
			
		</div>
		
		<div class="center_part">
			<div class="btn_control">
				<i class="iconfont icon-max font22" onclick="btnClick();"></i>
				<!-- <img src="static/aco/images/max.png">  -->
			</div>
			<ul id="myTab" class="nav nav-tabs lead_tabs">
			</ul>
			<div id="myTabContent" class="tab-content" >
				
			</div>
			<!--  
			<div class="col-lg-6 col-md-6 col-sm-6 col-xs-6">
				<div class="panel panel-other">
					<div id="main_map" style="width:100%; height:300px;z-index:1"></div>
				</div>
			</div>
			-->
			
			<div class="clearfix"></div>
		</div>
		<div class="contact_bg"></div>
		
	<!-- 模态框（Modal） -->
	<div style="margin-top:80px;" class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 600px">
			 <div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >日程管理</h4>
				</div>
				<div class="modal-body">
					<form id="ff" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="${ctx}/bizCalendarController/doSaveOrUpdateCalendar">
						<input type="hidden" id="id" name="id"/>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" for="goodsname"
								style="text-align: left;">&nbsp;&nbsp;主题<span style="color:red;">*</span></label>
							<div class="col-md-10">
							<input id="title" name="title_" type="text" class="validate[required] form-control" placeholder="请输入标题">
							</div>
						</div>
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 control-label" for="goodsname"
								style="text-align: left;">&nbsp;&nbsp;地点<span style="color:red;">*</span></label>
							<div class="col-md-10">
							<input id="address" name="address_" type="text" class="validate[required] form-control" placeholder="请出入地点">
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label" for="goodsname"
								style="text-align: left;">&nbsp;&nbsp;开始时间</label>
							<div class="col-sm-4">
								<div class="input-group date starttime">
									<input type="text" id="starttime" name="startTime_"
										class="validate[required] form-control" onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})"/>
								</div>
							</div>
						
							<label class="col-sm-2 control-label" for="goodsname"
								style="text-align: left;">&nbsp;&nbsp;结束时间</label>
							<div class="col-sm-4">
								<div class="input-group date endtime">
									<input width="100%" type="text" id="endtime" name="endTime_" 
										class="validate[required] form-control" onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label" for="unit"
								style="text-align: left;">&nbsp;&nbsp;重要性</label>
							<div class="col-sm-4">
								<select  id="level" name="level_" class="form-control" size="1">
										<option value="1">低</option>
					    				<option value="2">中</option>
					    				<option value="3">高</option>
								</select>
							</div>
							<label class="col-sm-2 control-label" for="unit"
								style="text-align: center;">&nbsp;&nbsp;提醒</label>
							<div class="col-sm-4">
								<select  id="remindtime" name="remindTime_" class="validate[required] form-control" size="1">
										<option value="5">5分钟</option>
					    				<option value="10">10分钟</option>
					    				<option value="15">15分钟</option>
					    				<option value="30">半小时</option>
					    				<option value="60">1小时</option>
					    				<option value="90">1小时30分</option>
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label" for="remark"
								style="text-align: left;">&nbsp;&nbsp;备注</label>
							<div class="col-sm-10">
								<textarea id="content" name="content_" rows="4"
									class="form-control"></textarea>
							</div>
						</div>
						<div class="form-group" id="btnDiv" align="center">
							<button type="button" class="btn btn-primary" id="saveButton" onclick="saveCal()">保存</button>
							<button type="button" id="modal_close" class="btn btn-primary" data-dismiss="modal">关闭</button>
						</div>
					</form>
				</div>
			</div>
		</div> 
	</div>
	<!-- 更改快捷方式模态框（Modal） -->
	<div class="modal fade" id="changeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 1200px">
			<div class="modal-content">
				<div class="modal-header" >
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >自定义常用菜单</h4>
				</div>
				<div class="modal-body" style="height: 420px;overflow:auto;" id="customized">
					
				</div>
				<div>
					
				</div>
				<div class="modal-footer" style="text-align:center;">
					<button type="button" class="btn btn-primary" onclick="saveChecked()">确认</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
				</div>
			</div>	
		</div>
	</div>
	
	</body>
	<script>
	var _themeCode = '<shiro:principal property="themeCode" />';
	/**
	 * 初始化加载监听窗口改变事件
	 */
	$(window).resize(function() {
		onWinResize();
		var leadH = $("#mainbody",window.parent.document).height()-40;
		$("#myTabContent iframe").height(leadH - 40);
	});
	/**
	 * 初始化加载领导桌面左侧部分高度
	 */
	$(document).ready(function() {
		onWinResize();
	
		$('#ff').validationEngine({
		});
		$("#notice_iframe").attr("src","${ctx}/views/cap/isc/theme/leader/noticelist-desk-lead.jsp");//通知公告
	});
	//计算页面高度
	function onWinResize(){
		var winH = $("#mainbody",parent.document).height();
		$(".window-frame",parent.document).height(winH);
		//领导桌面可用高度（130：header+footer+上下背景不可用部分）
		var leadH = $("#mainbody",window.parent.document).height()-40;
		
		$(".left_part").height(leadH)
		$(".center_part").height(leadH);
		//通知公告栏高度
		$("#notice_iframe").height(42*noticeliCounts()+39);
		
		$("#myTabContent").height(leadH - 40);
		//$("#myTabContent div").height(leadH - 40);
	}
	//计算通知公告栏的行数
	function noticeliCounts(){
		var leadH = $("#mainbody",window.parent.document).height()-40;
		//200:上面轮播图的高度，40：通知公告栏上下边距
		var toCounts = Math.floor((leadH - 200 - 40 ) / 42);
		return toCounts ;
	}
	function reloadHome(){
		var params={
				"id":"home",
				"href":"${ctx}/views/cap/isc/theme/leader/lead_home_div.jsp",
				"text":"领导桌面"
		}
		createTab(params);
	}
	function saveCal(){
		if($('#ff').validationEngine('validate')){
			  start=$('#starttime').val();
			  end=$('#endtime').val();
			  if(end<start){
			  	layerAlert("开始时间不能大于结束时间");
			  	$('#endtime').val('');
			  	return;
			  }else if(end==start){
			 	layerAlert("开始时间不能等于结束时间");
			 	$('#endtime').val('');
			  	return;
			  }else{
			   	var AjaxURL= "${ctx}/bizCalendarController/doSaveOrUpdateCalendar";    
                $.ajax({
                    type: "POST",
                    url: AjaxURL,
                    data: $('#ff').serialize(),
                    success: function (data) {
                    	document.getElementById('calendar_iframe').contentWindow.location.reload(true);
                   		$('#modal_close').click();
						$('#myModal').find('.modal-body input').val("");
						$('#myModal').find('.modal-body textarea').val("");
                    },
                    error: function(data) {
                        layerAlert("error:"+data.responseText);
                     }
                });
			 }
        }
	}
	
	function openCal(){
		var params={
				"id":"calendarcontroller",
				"href":"${ctx}/bizCalendarController/index",
				"text":"日程管理"
		}
		createTab(params);
		//window.open("${ctx}/bizCalendarController/index");
	}
	
	function addCal(){
		$("#myModal").modal('show');
	}
	
	function profile(){
        alert();
		var params={
				"id":"grxx"+1240,
				"href":"userController/findPerInfoById",
				"text":"用户中心"
		}
		createTab(params);
	}
	</script>
</html>