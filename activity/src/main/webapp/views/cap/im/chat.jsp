<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>即时通讯</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/views/cap/im/css/chat.css">
<link href="${ctx}/static/cap/plugins/ztree/css/demo.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/views/cap/im/css/zTreeStyle.css" rel="stylesheet">
<script type="text/javascript" src="${ctx}/views/cap/im/js/cometd_chat.js"></script>

<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.min.js"></script>
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.min.js"></script>

<script type="text/javascript" src="${ctx}/static/cap/plugins/cometd/cometd.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/cometd/AckExtension.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/cometd/ReloadExtension.js"></script>
    
<script type="text/javascript" src="${ctx}/static/cap/plugins/cometd/jquery/jquery.cookie.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/cometd/jquery/jquery.cometd.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/cometd/jquery/jquery.cometd-reload.js"></script>
    
<script type="text/javascript" src="${ctx}/views/cap/im/js/chat.js"></script>
    
<script type="text/javascript">
	var config = {
	    contextPath: location.href.replace(/https?:\/\/[^\/]*/, '').replace(/\/jquery-examples\/.*$/, '')
	}
</script>
<script type="text/javascript">
var currenUser='${imuser}';
var chatto='${chatto}';
if(currenUser!=null&&currenUser!=''&&chatto!=''&&chatto!=null){
	recMsgFromUser(chatto);
}

$(function(){
	if(!placeholderSupport()){   // 判断浏览器是否支持 placeholder
	    $('[placeholder]').focus(function() {
	        var input = $(this);
	        if (input.val() == input.attr('placeholder')) {
	            input.val('');
	            input.removeClass('placeholder');
	        }
	    }).blur(function() {
	        var input = $(this);
	        if (input.val() == '' || input.val() == input.attr('placeholder')) {
	            input.addClass('placeholder');
	            input.val(input.attr('placeholder'));
	        }
	    }).blur();
	};
});

function placeholderSupport() {
	    return 'placeholder' in document.createElement('input');
}

$(function(){
	$(".lanrenzhijia .tab #comment").click(function(){
		$('.lanrenzhijia .content .content_item').hide();
		$('#content_message').show();
		$(".lanrenzhijia .tab #user").css("color","#198cbb");
		$(".lanrenzhijia .tab #group").css("color","#198cbb");
		$(".lanrenzhijia .tab #sitemap").css("color","#198cbb");
		$(".lanrenzhijia .tab #comment").css("color","#d33237");
    });
	$(".lanrenzhijia .tab #user").click(function(){
		$('.lanrenzhijia .content .content_item').hide();
		$('#content_contacts').show();
		$(".lanrenzhijia .tab #user").css("color","#d33237");
		$(".lanrenzhijia .tab #group").css("color","#198cbb");
		$(".lanrenzhijia .tab #sitemap").css("color","#198cbb");
		$(".lanrenzhijia .tab #comment").css("color","#198cbb");
	});
	$(".lanrenzhijia .tab #group").click(function(){
		$('.lanrenzhijia .content .content_item').hide();
		$('#content_group').show();
		$(".lanrenzhijia .tab #user").css("color","#198cbb");
		$(".lanrenzhijia .tab #group").css("color","#d33237");
		$(".lanrenzhijia .tab #sitemap").css("color","#198cbb");
		$(".lanrenzhijia .tab #comment").css("color","#198cbb");
	});
	$(".lanrenzhijia .tab #sitemap").click(function(){
		$('.lanrenzhijia .content .content_item').hide();
		$('#content_structure').show();
		$(".lanrenzhijia .tab #user").css("color","#198cbb");
		$(".lanrenzhijia .tab #group").css("color","#198cbb");
		$(".lanrenzhijia .tab #sitemap").css("color","#d33237");
		$(".lanrenzhijia .tab #comment").css("color","#198cbb");
	});
});
</script>

<style>

.lanrenzhijia{ width:100%; height:520px;}
.lanrenzhijia .tab a{ display:block;}
.lanrenzhijia .tab a.on{color:#fff;}
.lanrenzhijia .content{ overflow:hidden;}

</style>

</head>
<body>
<!-- the container of the chat boxes -->
	<div class="container-fluid " style="margin-top:20px">
	<div class="row">
	<div id="chat-boxes">
	<!-- class="col-sm-3" -->
	<div class="col-sm-3" style="width:25%; float: left;">
		<div class="panel panel-default" style=" border:1px #ddd solid;">
			<div class="panel-body" style="padding:0;">
			               <div class="lanrenzhijia">
			               
	                         <div class="row tab" style="margin-top:10px;margin-bottom:10px;margin-left:0;margin-right:0;">
						    	<div class="col-sm-2" style="text-align:center">
						    		<a href="javascript:;" style="position:relative;">
						    			<i class="fa fa-comment" id="comment" style="font-size:25px;color:#198cbb;"></i><span class="badge" id="msg_total_num" style="position:absolute;right:-4px; top:-6px; display: none;">0</span>
						    		</a>
						    	</div> 
						        <div class="col-sm-2" style="text-align:center"><a href="javascript:;" ><i class="fa fa-user" id="user" style="font-size:25px;color:#d33237;"></i></a></div>
						        <!-- <div class="col-sm-2" style="text-align:center"><a href="javascript:;" ><i class="fa fa-group" id="group" style="font-size:25px;color:#198cbb;"></i></a></div> -->
						        <!-- <div class="col-sm-2" style="text-align:center"><a href="javascript:;" ><i class="fa fa-sitemap" id="sitemap" style="font-size:25px;color:#198cbb;"></i></a></div> -->
						        <!-- <div class="col-sm-2 col-sm-offset-2" style="text-align:center;">
							        <div class="btn-group">
										<div class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-plus" id="plus" style="font-size:25px;color:#198cbb;"></i></div>
											<ul class="dropdown-menu pull-right" role="menu" style="text-align:right;">
												<li><a href="#">添加用户</a></li>
												<li><a href="#">添加群</a></li>
												<li><a href="#">添加讨论组</a></li>
											</ul>
									</div>
								</div> /btn-group -->
							</div>
							<div class="content">
					        	<div class="content_item" id="content_message" style="display:none;background-color:#f8f8f8;">
					        		<div class="zTreeDemoBackground left">
	                            		<ul id="history_message" class="list-group" style="width:100%;">
	                            		</ul>
                                	</div>
					        	</div>
					        	<div class="content_item" id="content_contacts" style="display:block;background-color:#f8f8f8;">
					            	<div class="input-group">
			                            <input type="text" id="input1-group2" name="input1-group2" class="form-control" placeholder="查询联系人">
			                            <span class="input-group-btn">
			                            	<button type="button" class="btn btn-primary" onclick="searchGrouper()"><i class="fa fa-search"></i></button>
			                            </span>				                    	
			                    	</div>
			                    	<div class="zTreeDemoBackground left" id='contacts_tree_div'>
	                            		<ul id="contacts_tree" class="ztree" style="width:100%;height:400px;"></ul>
                                	</div>
                                	<div class="zTreeDemoBackground left" id='search_contacts_tree_div' style="display: none;">
                                		<div class="topbtn"><a onclick='switchShow("search_contacts_tree_div","contacts_tree_div")'><img src="${ctx}/views/cap/im/img/btn_close.png" width="19" height="19" /></a></div>
	                            		<ul id="search_contacts_tree" class="ztree" style="width:100%;height:450px;"></ul>
                                	</div>

			                    	<div id="div_addnewgroup" class="input-group" >
			                            <button id="addnewgroup" class="btn btn-primary" style="margin-left:9px;" >添加联系人分组</button>
			                            <button id="addnewfriend" class="btn btn-primary" style="margin-left:9px;">添加联系人</button>
			                    	</div>
			                    	<div id="rMenu" style="top: 258px; visibility: hidden; left: 145px; position: absolute; margin: 5px; padding-left: 15px; padding-right: 5px; border: 2px solid rgb(0, 0, 0);">
									</div>
					            </div>
					            <div class="content_item" id="content_group" style="display:none;height:490px;background-color:#f8f8f8;">
					            	<div class="zTreeDemoBackground left">
	                           			 <ul id="group_chat" class="ztree" style="width:100%;"></ul>
                                	</div>
					            </div >
					            <div class="content_item" id="content_structure" style="display:none;height:490px;background-color:#f8f8f8;">
					            	<div class="zTreeDemoBackground left">
	                            		<ul id="organization_structure" class="ztree" style="width:100%;"></ul>
                                	</div>
					            </div>
							</div>
                      </div>
			</div>
		</div>
    </div><!--/.col-->	
    <!-- test for cometd 
    <div>
        <button id="joinButton" class="button">cometd</button>
    </div>	-->
	<!-- chatbox class="chatbox col-sm-9" -->
	  <div class="chatbox col-sm-9" id="default_chatbox" style="width:75%; display: none;float: left;" >
	    <div class="topbox">
	      <div class="toptitle">
	      <!-- the user to chat  -->
	        <p  id="username"></p>
	        <!-- the department of the user 
	        <p class="yfb" id="department"></p> -->
	      </div>
	      <!-- close-button -->
	      <div class="topbtn"><a onclick="closeChatBox()"><img src="${ctx}/views/cap/im/img/btn_close.png" width="19" height="19" /></a></div>
	    </div>
	    
	    <!-- this bloc to show the messages -->
	    <div class="talkbox" id="message_container" style="overflow:auto" >
	    <!-- the time of the history information -->
	       <p class="time"></p>
	    </div>
	    
	    <!-- the message-input talkbox -->
	    <div class="whrite">
	    	<!-- the function-toolbar under talkbox -->
	        <div class="lefticon">
	         <!-- 
	         <a href="#"><img src="${ctx}/static/images/im_images/icon_bq.png" /></a>
	          <a href="#"><img src="${ctx}/static/images/im_images/icon_prt.png" /></a>
	          <a href="#"><img src="${ctx}/static/images/im_images/icon_dd.png" /></a>
	          <a href="#"><img src="${ctx}/static/images/im_images/icon_pic.png" /></a>
	          <a href="#"><img src="${ctx}/static/images/im_images/icon_wj.png" /></a>
	          <a href="#"><img src="${ctx}/static/images/im_images/icon_jl.png" /></a> 
	          -->
	        </div> 
	        <div class="righticon">
	        <!--  <a href="#"><img src="${ctx}/static/images/im_images/icon_yy.png" /></a>
	          <a href="#"><img src="${ctx}/static/images/im_images/icon_sp.png" /></a>  -->
	        </div>  
	        <!-- the input information -->  
	       <textarea class="whritetext"></textarea>
	       
	       <!-- send the message -->
	      <div class="chatbtn" onclick="sendMsg()">发送</div>
	      <!-- close the message box 
	       <div class="chatbtn"><a >关闭</a></div> -->
	    </div>
	  </div>
	  
		 <!-- each message at the left -->
		<div class="dhk" id="default_message_out" style="display:none">
			<div class="chatuser"></div>
			<div class="chatj"></div>
			<!-- the information from user b -->
			<div class="chatuserb"></div>
		</div>
	 
		<!-- each message at the right -->
		<div class="dhk" id="default_message_in" style="display:none">
			<div class="chatuserright" style=" background:url(${ctx}/views/cap/im/img/default_grouper_header.png)"></div>
			<div class="chatr"></div>
			<div class="chatuserbr"></div>
		</div> 
	</div>  
	
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="myModal1"  role="dialog"
		aria-labelledby="myModalLabel1" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 500px;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel1" ></h4>
				</div>
				<div class="modal-body">

						<div class="form-group" id="authorDiv" style="height:30px;">
							<label class="col-md-3 control-label" id="modal_form1_label1" for="authorToShow"></label>
							<div class="col-md-6">
								<input type="text" id="modal_form1_input1" name=""
									class="form-control" >
							</div>
						</div>
						<div class="form-group" id="btnDiv" align="center">
							<button type="button" class="btn btn-primary" id="modal_form1_submit" >添加</button>
							<button type="button" class="btn btn-primary"
								data-dismiss="modal">关闭</button>
						</div>
						<div class="form-group" style="height:10px;">
							<label class="col-md-3 control-label" for="authorToShow"></label>
							<div class="col-md-6" id="back_infor" style="">
							</div>
						</div>

				</div>
			</div>
		</div>
	</div>
</body>
</html>
