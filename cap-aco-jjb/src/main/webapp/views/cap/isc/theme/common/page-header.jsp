<%@ page contentType="text/html;charset=UTF-8"%>
<style>
input::-webkit-input-placeholder {
        color: #FFFFFF;
     }
.run{ overflow:hidden; width:310px;}
.run .qimo {width:9999999999px; height:50px;}
.run .qimo div{ float:left;}
.run .qimo ul{float:left; height:50px; overflow:hidden; zoom:1; }
.run .qimo ul li{float:left; height:50px; list-style:none;}
.run li a{margin-right:10px;color:#FFFFFF;}
.urgent{
color:#FFFFFF;
}
</style>	
   	<!-- start: Header -->
	<%-- <div id="top-header">
	<div style="height:60px; width:453px; position:fixed; top:0; left:0;z-index:100; padding:10px 0 0 20px;">
		<c:choose>
			<c:when test="${not empty logoPath}">
				<img class="logo" src="${ctx}/sysLogoController/doDownLoadPicFile?picPath=${logoPath}" />
			</c:when>
			<c:otherwise>
				<img src="${ctx}/static/aco/images/logo1.png" />
			</c:otherwise>
		</c:choose>
	</div>
	<div class="navbar" id="navbar" role="navigation">
		<div class="container-fluid ">
			<ul class="nav navbar-nav navbar-right">
				<!--  
				<li class="dropdown visible-sm visible-md visible-lg">
					<ul class="nav navbar-nav navbar-actions navbar-right">
						<li class="visible-xs visible-sm"><a href="index.jsp"
							id="sidebar-menu"><i class="fa fa-navicon"></i> </a></li>
					</ul>
				</li>
				-->
			<!--是否滚动播放待办事项 -->	
			<c:if test="${gdxsKey==true}">
			  <li style="position:absolute;right:700px;">
		   <div id="urge" style="display: none"><span class="urgent">[特急]</span>
		   </div><li>
	       <li id="roll" class="run" style="position:absolute;right:380px;">
				<div class="qimo">
				    <div id="roll1">
				      <ul id="gundong"></ul>
				    </div>
				    <div id="roll2"></div>
				</div>
		   </li>
		   </c:if>
				<!-- 是否显示搜索框 -->
				<c:if test="${searchKey==true}">
				    <li class="dropdown visible-sm visible-md visible-lg">
					 	<a class="search"><i class="fa fa-search"></i> </a>
					 	<div  id="search-input">
							<input type="text" id="input-word" placeholder="请输入搜索内容" onfocus="this.placeholder=''" onblur="this.placeholder='请输入搜索内容'"><i class="fa fa-search" onclick="btnSearch()"></i>
						</div>
					</li>
				</c:if>
				
				<!-- V6.9注释消息提醒功能 update by 徐真 2016-12-26  -->
				<shiro:hasPermission name="on:msgpushController:msgpush">
					<li id="instantmessage" class="dropdown visible-sm visible-md visible-lg">
						<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">
							<i class="iconfont icon-xiaoxi2"  style="margin:0; margin-top:4px;color: #999;"></i><span class="badge" style="display: block;" >0</span> 
						</a>
						<ul id="msgs_display_board" class="dropdown-menu" style="height:450px;background-color: white; overflow:visible;">
							<li id="msgs_display_board_title">
								<div class="title">
									<i class="iconfont icon-xiaoxi2 notice-icon"></i>
									<span></span>
									<button type="button" class="btn btn-warning btn-sm pull-right btn-notice" onclick="ignoreAllNotice();">忽略全部</button>
	            				</div>
							</li>
							<li id="noticeItem" style="display:none; padding:0">
				                <div id="boxNoticeItem" class="box">
				                    <img id="senderPicImg" src="${ctx}/static/cap/plugins/msgpush/images/user1.png">
				                    <div class="box-con">
				                        <div class="name"></div>
				                        <div class="con"></div>
				                        <div class="info">
				                        	<img class="typephoto" alt="类型图标" src="">
				                            <span class="type"></span>
				                            <span class="showtime"><i class="fa fa-clock-o"></i> 5分钟前</span>
				                            <span class="realtime" style="display:none;"><i class="fa fa-clock-o"></i> 5分钟前</span>
				                        </div>
				                    </div>
				                    <div class="operation">
				                        <i class="fa fa-eye-slash"></i> 忽略
				                    </div>
				                </div>
							</li>
							<li id="msgs_display_board_footer">
								<div class="view-all">
	                				<a onclick="createMsgPushTab();">查看全部消息</a>
	            				</div>
							</li>
						</ul>
					</li> 
				</shiro:hasPermission>
				
				<!-- 添加即时通讯功能 update by 张多一 2017-04-17  -->
				<shiro:hasPermission name="on:msgpushController:msgpush">
					<shiro:hasPermission name="im:msgpushController:msgpush">
						<li id="capAcoWebIM" class="dropdown visible-sm visible-md visible-lg">
							<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown">
								<i class="iconfont icon-xiaoxi2"  style="margin:0; margin-top:4px;color: #999;"></i><span class="badge" style="display: none;" >0</span> 
							</a>
						</li> 
					</shiro:hasPermission>
				</shiro:hasPermission>
				
				<li class="dropdown visible-sm visible-md visible-lg" id="accountInfo">
					<a href="javascript:void(0);" class="dropdown-toggle" data-toggle="dropdown"> 
						<img class="user-avatar" id="nav_tx" src="${ctx}/uploader/uploadfile?pic=<shiro:principal property="picture" />" alt="user-mail">
						<label id="user"><shiro:principal property="name" /> </label>
					</a>
					
				</li>
				<li><a onclick="logout()"><i class="iconfont icon-tuichu" style="margin:0"></i> </a></li>
			</ul>
		</div>
	</div>
	</div>
	<!-- end: Header --> --%>
	
	<!-- 设置主题modal -->
	<div class="modal fade" id="theme" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">
					选择主题
					</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="themeFrame" name="themeFrame" 
							height="350" width="500" frameborder=0 scrolling=auto
							allowTransparency="true"> </iframe>
					</div>
				</div>
				<div class="modal-footer">
					
						<button class="btn btn-primary btn-sm" onClick="saveTheme();">选择</button>
						<button class="btn btn-primary btn-sm" onClick="closeThemeDialog();">关闭</button>
					
				</div>
				
			</div>
		</div>
	</div>
	<!-- 设置主题/.modal -->
	
	<!-- 关于 -->
	<div class="modal fade" id="aboutModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">关于</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="aboutFrame" name="aboutFrame" height="290" width="100%" frameborder=0 scrolling=auto allowTransparency="true"> </iframe>
					</div>
				</div>
				<div class="modal-footer" style="border-top:none; padding-top:0;margin-top:0">
					<button type="button" class="btn btn-primary btn-sm"  data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 即时通讯插件 add by 张多一 2017.04.07 -->
	<shiro:hasPermission name="on:msgpushController:msgpush">
		<shiro:hasPermission name="im:msgpushController:msgpush">
			<div id="capAcoWebIMDiv">
			</div>
		</shiro:hasPermission>
	</shiro:hasPermission>
	
	<script type="text/javascript">
	var _themeCode = '<shiro:principal property="themeCode" />';
	/**
	 * 设置主题
	 */
	function setTheme(){
		$('#theme').modal('show');
		$('#themeFrame').attr('src','${ctx}/themeController/toSelectTheme');
	}
	
	/**
	 * 关于
	 */
	function showAbout() {
		$('#aboutModal').modal('show');
		$('#aboutFrame').attr('src','${ctx}/indexController/toAbout');
	}
	
	$(function () {
		var code = '<shiro:principal property="treeColorCode" />';
		if(code == "gray"){
			$("#indexPage").attr("href","${ctx}/views/cap/isc/theme/common/css/index-page.css");
			$("#indexColor").attr("href","${ctx}/views/cap/isc/theme/common/css/index-page-color.css");
		}else if(code == "white"){
			$("#indexPage").attr("href","${ctx}/views/cap/isc/theme/common/css/index-page-white.css");
			$("#indexColor").attr("href","");
		}
	})
	
	
	/**
	 * 设置皮肤
	 */
	function setSkin(obj){
		var code = $(obj).attr("code");
		var id = $(obj).attr("id");

		$.ajax({
			type : "POST",
			url : "skinController/doSaveUserSkin",
			async: false,
			data : {id : id,code : code},
			dataType : "json",
			success : function(data) {
				window.location.reload();
				/* if(code == "red"){
					$("#top-header > .navbar").css("background","#d33336");
					$(".footer").css("background-color","#d33237");
					$("#lead_home").contents().find("#cssfile").attr("href", "${ctx}/views/aco/main/css/lead.css");
				}else if(code == "blue"){
					$("#top-header > .navbar").css("background","#0f4f80");
					$(".footer").css("background-color","#0f4f80");
					$("#lead_home").contents().find("#cssfile").attr("href", "${ctx}/views/aco/main/css/lead_blue.css");
				} */
			}
		});
	}
	
	/**
	 * 设置左侧皮肤
	 */
	function setLeftColor(obj){
		var code = $(obj).attr("code");
		if(code == "gray"){
			$("#indexPage").attr("href","${ctx}/views/cap/isc/theme/common/css/index-page.css");
			$("#indexColor").attr("href","${ctx}/views/cap/isc/theme/common/css/index-page-color.css");
		}else if(code == "white"){
			$("#indexPage").attr("href","${ctx}/views/cap/isc/theme/common/css/index-page-white.css");
			$("#indexColor").attr("href","");
		}

		$.ajax({
			type : "POST",
			url : "skinController/doSaveUserTreeColor",
			async: false,
			data : {code : code},
			dataType : "json",
			success : function(data) {
				//window.location.reload();
			}
		});
	}
	


	function refreshPic(name){
		var picPath = "${ctx}/uploader/uploadfile" + "?pic="+ name + "&" + Math.random();
		document.getElementById("nav_tx").src = picPath;
	}
	
	//搜索输入框自动补全
		$(function() {
			var cache = {};
            $("#input-word").autocomplete(
            {
                source: function(request, response) {
                    var term = request.term;
                    if (term in cache) {
                        data = cache[term];
                        response($.map(data, function(item) {
                            return { label: item.keyWord, value: item.keyWord }
                        }));
                        return { label: "", value: "" };
                    } else {
                        $.ajax({
                            url: "luceneController/autocomplete",
                            dataType: "json",
                            data: {
                                top: 10,
                                key: term
                            },
                            success: function(data) {
                                if (data.length) 
                                    cache[term] = data;
                               	response($.map(data, function(item) {
                                       return { label: item.keyWord, value: item.keyWord }
                                   }));
								return { label: "", value: "" };
                            }
                        });
                    }
                },
                select: function(event, ui) {
                	//提交搜索...
                    if (ui != '') {
                    	$("#search-input > input").val(ui.item.label);
                    	btnSearch();
                    }
                },
                minLength: 1,
                matchContains: true,        //只要包含输入字符就会显示提示
                autoFill: true,            //自动填充输入框
                mustMatch: true            //与否必须与自动完成提示匹配
            });
            var gdxsKey='${gdxsKey}';
            if(gdxsKey=='true'){
               getTaskToDo();
           	   setInterval(getTaskToDo,300000);//定时加载 
            }
		 });
		 
		 		/**
		 * 重新登录系统
		 */
		function logout(){
			if (confirm('确定重新登录系统吗？')) {
				$.cookie("autoSubmit", "0", {
					expires : 30,
					path : "/"
				});
				window.location.href = "${ctx}/logout";
			}

			/* layer.confirm('确定重新登录系统吗？', {
				btn : [ '是', '否' ]
			}, function() {
				$.cookie("autoSubmit", "0", {
					expires : 30,
					path : "/"
				});
				window.location.href = "${ctx}/logout";
			}, function() {
				return;
			}); */
		}
		function profile(){
			var options={
				"text":"用户中心",
				"id":"grxx"+1240,
				"href":"userController/findPerInfoById",
				"pid":window
			};
			if(window.parent.createTab){
				window.parent.createTab(options);
			}else{
				
				window.frames["lead_home"].createTab(options);
			}
			
		}
		

		function closeThemeDialog(){
			//$('#sz').modal('hide');
			$('#theme').modal('hide');
		}

		function saveTheme(){
			window.frames["themeFrame"].saveTheme();
		}
		
		function setLayout(){
			/* var feature = 'FullScreen=yes,scrollbars=yes,menubar=no,resizable=yes,location=no,status=no,toolbar=no';  
			var win = window.open("${ctx}/themeController/layout", 'EIS', feature);  
			win.resizeTo(screen.width, screen.height); */
			
			var options={
					"text":"桌面布局",
					"id":"layout",
					"href":"${ctx}/themeController/layout",
					"pid":window
			};
			window.parent.btnClick();
			window.parent.createTab(options);
		}
				function getLayout(){
			/* var feature = 'FullScreen=yes,scrollbars=yes,menubar=no,resizable=yes,location=no,status=no,toolbar=no';  
			var win = window.open("${ctx}/themeController/layout", 'EIS', feature);  
			win.resizeTo(screen.width, screen.height); */
			
			var options={
					"text":"测试布局",
					"id":"layin",
					"href":"${ctx}/views/cap/isc/theme/person/layout/layin.jsp",
					/* "href":"${ctx}/themeController/layout", */
					"pid":window
			};
			window.parent.btnClick();
			window.parent.createTab(options);
		}
				var myvar = 0;//全局变量目的实现同步
				var roll='';
				var roll1='';
				var roll2='';
			   function getTaskToDo(){
					$.ajax({
					        url:'${ctx}/bpmQuery/getTaskToDo',
							type:'post',
							dataType:'json',
							success:function(data){
							 clearInterval(myvar);
							 $('#gundong').empty();
							 if(data.flag=='0'){
							   $('#urge').hide();
							 }else if(data.flag=='1') {				   
							   $('#urge').show();
							   var json = data.result;
							   $.each(json, function(idx, obj){
							   if(obj.mgmtType=='deal'){
								    url = "/bizRunController/getBizOperate?status=3&solId="+ obj.solId +"&bizId="+obj.bizid+"&taskId="+obj.taskid;
								    var li="<li><a onclick='opentab(\"办理\",\"update"+obj.bizid+"\",\""+url+"\")'>"
														+obj.name_+"！！！"+"</a></li>";
							   }else if(obj.mgmtType=='view'){
							        url = "/bpmCirculate/findCirculate?bizid="+obj.bizid+"&id="+obj.id_+"&solId="+ obj.solId;
								    var li="<li><a onclick='opentab(\"查看-传阅事项\",\"cysx_view_"+obj.id_+"\",\""+url+"\")'>"
														+obj.name_+"！！！"+"</a></li>";
							   }			  
							   $('#gundong').append (li);
							   });
							    roll = document.getElementById("roll");
								roll1 = document.getElementById("roll1");
								roll2 = document.getElementById("roll2");
								roll2.innerHTML=document.getElementById("roll1").innerHTML;						       
								//自动轮播
								myvar=setInterval(Marquee,40);
								roll.onmouseout=function (){myvar=setInterval(Marquee,40);}
								roll.onmouseover=function(){clearInterval(myvar);}
							 }
						}
					});
				}
			   function Marquee(){
					if(roll.scrollLeft-roll2.offsetWidth>=0){
						roll.scrollLeft-=roll1.offsetWidth;
					}
					else{
						roll.scrollLeft++;
					}
				}
			function opentab(title,id,url) {
				var options={
						"text":title,
						"id":id,
						"href":'${ctx}'+url,
						"pid":window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":false
				};
				window.createTab(options);
			}	
	</script>