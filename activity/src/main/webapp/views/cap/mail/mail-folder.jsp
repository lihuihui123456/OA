<%@ page contentType="text/html;charset=UTF-8"%>       
<script type="text/javascript">
	//alert("load the mail folder!!");
	//TODO temporaly delete the customize folder load function
/* 	$.ajax({
		url : 'emailFolder/getFolderList',
		dataType:'json',
		type : 'post',
	    success: function(res) {
	    	if(res!=null){
				//create the mail folder list
	    		$(res).each(function(index) {
	               $("<li>"+
	            		   "<a>"+res[index]+"<i class=\"fa fa-times\"></i><i class=\"fa fa-fa fa-pencil\"></i>"+
	            		   "</a>"+
	            	"</li>").appendTo("#user_folder_list");
	    		});
	    	}
	    },
	    error: function() {
	        //请求出错处理
	    	layerAlert("服务器出现问题，请重新登录！");
	    }
	}); */
	
	//initialize the folder delete button
 	$(".my_menu .fa-times").live('click',function(event){
		//alert($(this).parent().parent().index());
		var liElement = $(this).parent().parent();
		delMailFoler($(liElement).text(),liElement);
		//$(this).parent().parent().index();
		event.stopPropagation();
	});
	
	//initialize the folder rename button
 	$(".my_menu .fa-pencil").live('click',function(event){
		//alert($(this).parent().parent().index());
		var liElement = $(this).parent().parent();
//		delMailFoler($(liElement).text(),liElement);
		var oldname =$(liElement).text();
		//modal show
		$('#mail_addFolder_modal_Label1').text('重命名文件夹 ： '+ oldname);
		$('#mail_modal_form1_label1').html('重命名文件夹');
		$('#mail_modal_form1_input1').attr("placeholder","请输入新建文件夹名称");
		$('#mail_modal_form1_input1').val('');
		$('#mail_response_infor').text('');
		$("#mail_modal_form1_submit").text("提交");
		//$('#mail_modal_form1_submit').attr("onclick","renameMailFoler('"+$(liElement).text()+"',"+liElement+")");
		$('#mail_modal_form1_submit').bind('click', function() {
			var newname = $("#mail_modal_form1_input1").val();
			$.ajax({
				url : 'emailFolder/renameFolder',
				dataType:'text',
				type : 'post',
				data :{
					currName: oldname,
					newName: newname
					},
			    success: function(res) {
			    	if(res!=null){
						//deal with the results
						if(res=="00"){
							$('#mail_response_infor').text("已经退出文件交换，请重新登录！");
						}else if(res=="01"){
							//TODO
							$('#mail_response_infor').text("新命名文件夹已经存在，请重新输入！");
						}else if(res=="02"){
							$('#mail_response_infor').text("重命名文件夹失败！");
						}else if(res=="03"){
							//rename folder name, li.text(newname) run wrong;
							//delete first
							$(liElement).remove();
							//add new one
			               $("<li>"+
			            		   "<a>"+newname+"<i class=\"fa fa-times\"></i><i class=\"fa fa-fa fa-pencil\"></i>"+
			            		   "</a>"+
			            	"</li>").appendTo("#user_folder_list");
			               $('#mail_response_infor').text("重命名文件夹成功！");
							setTimeout(mailModelHide,1000);
						}
			    	}
			    },
			    error: function() {
			        //请求出错处理
			    	layerAlert("服务器出现问题，请重新登录！");
			    }
			});
		});

		//initialize the create time
		$('#mail_addFolder_modal').modal({
			backdrop : 'static',
			keyboard : false
		});
		event.stopPropagation();
	});
	
</script >

<script type="text/javascript">
	$(function(){
		$("#add_user_folder_btn").click(function(event){
			//answer the "create"
			//new_user_folder_input
			//$("#new_user_folder_li").show();
			//modal show
			$('#mail_addFolder_modal_Label1').text('新建文件夹');
			$('#mail_modal_form1_label1').html('新建文件夹');
			$('#mail_modal_form1_input1').attr("placeholder","请输入新建文件夹名称");
			$('#mail_modal_form1_input1').val('');
			$('#mail_response_infor').text('');
			$("#mail_modal_form1_submit").text("添加");
			$('#mail_modal_form1_submit').attr("onclick","createNewMailFoler()");
			//initialize the create time
			$('#mail_addFolder_modal').modal({
				backdrop : 'static',
				keyboard : false
			});
			event.stopPropagation();
		});
		
		$("#new_user_folder_input").click(function(event){
			//listen the key press event
			$("#new_user_folder_input").keypress(function(e){
				
				var key = e.which;
				//if press "enter" then trigger the function
			    if (key == 13) {
			    	var name = $("#new_user_folder_input").val();
			    	//alert(name);
			    	if(!(name==null||name=="")){
			    		//TODO check the input
			    		createNewMailFoler1(name);
			    		$("#new_user_folder_input").val("");
				    	//hide the input 
				    	$("#new_user_folder_li").hide();
			    	}
			    }
			});
			event.stopPropagation();
		});
	}); 
</script>

<script type="text/javascript">

	function mailModelHide(){
		$('#mail_addFolder_modal').modal('hide');
	}
	
    /*以输入框形式创建文件夹
     * */
	function createNewMailFoler1(name){
		$.ajax({
			url : 'emailFolder/createFolder',
			dataType:'text',
			type : 'post',
			data :{folderName:name },
		    success: function(res) {
		    	if(res!=null){
					//deal with the results
					if(res=="00"){
						layerAlert("已经退出，请重新登录！");
					}else if(res=="01"){
						//TODO
						layerAlert("文件夹已经存在，请重新输入！");
					}else if(res=="02"){
						layerAlert("创建文件夹失败！");
					}else if(res=="03"){
						//append folder list
		               $("<li>"+
		            		   "<a>"+name+"<i class=\"fa fa-times\"></i><i class=\"fa fa-pencil\"></i>"+
		            		   "</a>"+
		            	"</li>").appendTo("#user_folder_list");
					}
		    	}
		    },
		    error: function() {
		        //请求出错处理
		    	layerAlert("服务器出现问题，请重新登录！");
		    }
		});
	}
	
    /*创建自定义文件夹
     * */
	function createNewMailFoler(){
		var name = $("#mail_modal_form1_input1").val();
		$.ajax({
			url : 'emailFolder/createFolder',
			dataType:'text',
			type : 'post',
			data :{folderName:name },
		    success: function(res) {
		    	if(res!=null){
					//deal with the results
					if(res=="00"){
						$('#mail_response_infor').text("已经退出文件交换，请重新登录！");
					}else if(res=="01"){
						//TODO
						$('#mail_response_infor').text("文件夹已经存在，请重新输入！");
					}else if(res=="02"){
						$('#mail_response_infor').text("创建文件夹失败！");
					}else if(res=="03"){
						//append folder list
		               $("<li>"+
		            		   "<a>"+name+"<i class=\"fa fa-times\"></i><i class=\"fa fa-pencil\"></i>"+
		            		   "</a>"+
		            	"</li>").appendTo("#user_folder_list");
		               $('#mail_response_infor').text("添加文件夹成功！");
						setTimeout(mailModelHide,1000);
					}
		    	}
		    },
		    error: function() {
		        //请求出错处理
		    	layerAlert("服务器出现问题，请重新登录！");
		    }
		});
	}
    /*对邮箱中自定义文件夹删除
     * name ： 文件夹名字
     * li : 对应的列表项
     * */
	function delMailFoler(name, li){
		$.ajax({
			url : 'emailFolder/deleteFolder',
			dataType:'text',
			type : 'post',
			data :{folderName:name },
		    success: function(res) {
		    	if(res!=null){
					//deal with the results
					if(res=="00"){
						layerAlert("已经退出，请重新登录！");
					}else if(res=="01"){
						//TODO
						layerAlert("文件夹已经存在，请重新输入！");
					}else if(res=="02"){
						layerAlert("创建文件夹失败！");
					}else if(res=="03"){
						//TODO delete folder

						$(li).remove();
					}
		    	}
		    },

		    error: function() {
		        //请求出错处理
		    	layerAlert("服务器出现问题，请重新登录！");
		    }
		});
	}
    /*对邮箱中自定义文件夹重命名
     * oldname ： 文件夹旧名字
     * li_object: li节点的object
     * */
	function renameMailFoler(oldname, li_object){
		var newname = $("#mail_modal_form1_input1").val();
		alert($(li_object).text());
		$.ajax({
			url : 'emailFolder/renameFolder',
			dataType:'text',
			type : 'post',
			data :{
				currName: oldname,
				newName: newname
				},
		    success: function(res) {
		    	if(res!=null){
					//deal with the results
					if(res=="00"){
						$('#mail_response_infor').text("已经退出文件交换，请重新登录！");
					}else if(res=="01"){
						//TODO
						$('#mail_response_infor').text("文件夹已经存在，请重新输入！");
					}else if(res=="02"){
						$('#mail_response_infor').text("创建文件夹失败！");
					}else if(res=="03"){
						//rename folder name
						$(li_object).text(newname);
		               $('#mail_response_infor').text("添加文件夹成功！");
		               
						setTimeout(mailModelHide,1000);
					}
		    	}
		    },
		    error: function() {
		        //请求出错处理
		    	layerAlert("服务器出现问题，请重新登录！");
		    }
		});
	}
	
</script>


<div class="functionBar">
    <div class="title">
        <a id="recieve_email_a"><i class="fa fa-download"></i>收件</a>
        <a id="write_email_a"><i class="fa fa-edit"></i>写信</a>
    </div>
    <ul class="mail_menu folder_list" id="mail_folder_list">
        <li class="active" id="mail_folder_inbox"><a>收件箱 <span id="unread_mail_count" style="display: none;">(0)</span></a></li>
        <li ><a>已发送</a></li>
        <li ><a>垃圾箱</a></li>
        <li ><a>已删除</a></li>
        <li ><a>草稿箱</a></li>
    </ul>
    <%--  自定义文件展示模块，暂时隐藏此功能，  
    <ul class="mail_menu" >
    	<li >
            <a id="add-menu"><i class="fa fa-angle-down icon"></i>文件夹<i class="fa fa-plus add" id="add_user_folder_btn"></i></a>
         </li>
        
		<ul class="my_menu folder_list" id="user_folder_list" >
		    <li id="new_user_folder_li" style="display: none;">
		        <input  placeholder="请填写新文件夹" id="new_user_folder_input" > </input>
		    </li>
		    <!--
		    <li>
		        <a>我的文件夹<i class="fa fa-times"></i><i class="fa fa-pencil"></i></a>
		    </li>
		     
		    <li>
		        <a>其他文件夹<i class="fa fa-pencil"></i><i class="fa fa-trash"></i></a>
		    </li> -->
		
		</ul>
		
    </ul>--%>
    
    	<!-- 模态框（Modal） -->
	<div class="modal fade" id="mail_addFolder_modal"  role="dialog"
		aria-labelledby="mail_addFolder_modal_Label1" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 500px;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="mail_addFolder_modal_Label1" ></h4>
				</div>
				<div class="modal-body">

						<div class="form-group" id="authorDiv" style="height:30px;">
							<label class="col-md-3 control-label" id="mail_modal_form1_label1" for="authorToShow"></label>
							<div class="col-md-6">
								<input type="text" id="mail_modal_form1_input1" name=""
									class="form-control" >
							</div>
						</div>
						<div class="form-group" id="btnDiv" align="center">
							<button type="button" class="btn btn-primary" id="mail_modal_form1_submit" ></button>
							<button type="button" class="btn btn-primary"
								data-dismiss="modal">关闭</button>
						</div>
						<div class="form-group" style="height:10px;">
							<label class="col-md-3 control-label" for="authorToShow"></label>
							<div class="col-md-6" id="mail_response_infor" style="">
							</div>
						</div>

				</div>
			</div>
		</div>
	</div>
    
    
    
    
    
</div>
