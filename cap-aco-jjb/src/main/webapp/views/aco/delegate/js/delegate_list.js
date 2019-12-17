$(function(){
	//加载列表数据
	initDataTable();
	/*注册按钮事件*/
	//新增	
	$("#btn_new").click(function() {
		$('#myModalLabel').text('新增');
		url = 'delegate/doAddDelegate';
		action = 'open';
		clearForm();
		checkId = -1;
		showOrHideModal(action);
	});

	// 修改
	$("#btn_edit").click(function() {
		var selectRow = $("#delegateList").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行修改！");
			return flse;
		}
		if (selectRow[0].trust_user_id==current_user||selectRow[0].create_user_id_==current_user) {
			var id = selectRow[0].id;
			var delegate_id = selectRow[0].delegate_id;
			$.ajax({
				url: 'delegate/findDelegateInfo?id='+id+'&delegate_id='+delegate_id,
				dataType:'json',
				success: function(data){
					setValue(data);
					$('#myModalLabel').text('修改');
					url = 'delegate/doUpdateDelegate';
					action = 'edit';
					showOrHideModal(action);
				}
			});
		}else{
			layerAlert("被委托人没有修改权限！");
		}
	});

	// 查看
	$("#btn_view").click(function() {
		var selectRow = $("#delegateList").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行查看！");
			return flse;
		}
		var id = selectRow[0].id;
		var delegate_id = selectRow[0].delegate_id;
		$.ajax({
			url: 'delegate/findDelegateInfo?id='+id+'&delegate_id='+delegate_id,
			dataType:'json',
			success: function(data){
				setValue(data);
				$('#myModalLabel').text('查看');
				action = 'hide';
				showOrHideModal(action);
			}
		});
	});

	// 删除按钮
	$("#btn_delete").click(function() {
		var selectRow = $("#delegateList").bootstrapTable('getSelections');
		if (selectRow.length!= 1) {
			layerAlert("请选择单行操作！");
			return false;
		}
		if (selectRow[0].trust_user_id==current_user||selectRow[0].create_user_id_==current_user){
			var ids = [];
			var delegates = [];
			$(selectRow).each(function(index) {
				ids[index] = selectRow[index].id;
				delegates[index] = selectRow[index].delegate_id;
			});
			
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
			}, function() {
				$.ajax({
					url : 'delegate/doDelDelegate',
					dataType : 'json',
					data : {
						ids : ids,
						delegates:delegates
					},
					success : function(data) {
						if(data='true'){
						  layerAlert("删除成功");
						}else{
						  layerAlert("删除失败");
						}
						$("#delegateList").bootstrapTable('refresh');
					}
				});
			});	
		}else{
			layerAlert("被委托人没有删除权限！");
		}
		
	});
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	search();
	       return false ;   
	    } }); 
});

var userType="";
var title = "";//搜索参数
function initDataTable() {
	$('#delegateList').bootstrapTable({
		url : 'delegate/findDelegateList', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true,
		sortOrder : "desc",
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					rows  : params.limit, // 页面大小
					page : params.offset,
					title : $("#input-word").val()=="请输入委托人或被委托人姓名查询"?"":$("#input-word").val(),
					sortName : this.sortName,
					sortOrder : this.sortOrder
				};
				return temp;
			},// 传递参数（*）
        sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		pageList : [ 10, 25, 50, 100 ], // 可供选择的每页的行数（*）
		clickToSelect : true, // 是否启用点击选中行
        idField : "id",  //指定主键列
        columns: [{
            	 field: 'index',
	        	 title: '序号',
	        	 align : 'center',
	  			 valign: 'middle',
	  			 width : '7%',
                 formatter: function (value, row, index) {
                     return index+1;
                 }
            },{
            	 field: 'id',
	        	 align : 'center',
	  			 valign: 'middle',
	  			 visible : false
            },{
               	 field: 'delegate_id',
	        	 align : 'center',
	  			 valign: 'middle',
	  			 visible : false
            },{
               	 field: 'trust_user_id',
	        	 align : 'center',
	  			 valign: 'middle',
	  			 visible : false
            },{
            	 field: 'trust_user_name',
            	 title:'委托人',
            	 align : 'left',
            	 width : '13%',
            	 sortable: true,
	  			 valign: 'middle'
            },{
               	 field: 'user_id',
	        	 align : 'center',
	  			 valign: 'middle',
	  			 visible : false
            },{
            	 field: 'user_name',
            	 title:'被委托人',
            	 align : 'left',
            	 sortable: true,
	  			 width : '13%' 
            },{
            	 field: 'start_time_',
            	 title:'委托开始日期',
            	 align : 'center',
            	 cellStyle : cellStyle,
            	 sortable: true,
	  			 valign: 'middle',
	  			 formatter:function(value,row){
					if (value != null&&value!=''){
						return value.substring(0,10);
					}
				}
            },{
    			field : 'end_time_',
    			title : '委托结束日期',
    			cellStyle : cellStyle,
    			align : 'center',
    			sortable: true,
    			valign: 'middle',
    			formatter:function(value,row){
					if (value != null&&value!=''){
						return value.substring(0,10);
					}
				}
    		},{
               	 field: 'ts',
            	 title:'配置时间',
            	 cellStyle : cellStyle,
            	 align : 'center',
            	 width : '22%',
            	 sortable: true,
            	 valign: 'middle'
            },{
               	 field: 'create_user_id_',
            	 align : 'center',
	  			 valign: 'middle',
	  			 visible : false
            }, {
			 field: 'operate',
             title: '操作',
             halign: 'center',
             align:'center',
             width : '10%',
             events: operateEvents,
             formatter: operateFormatter
		}],
        onClickRow : function (row, obj) {
        	var id = row.id;
    		var delegate_id = row.delegate_id;
    		var deleurl='delegate/findDelegateInfo?id='+id+'&delegate_id='+delegate_id;
    		if (row.trust_user_id==current_user||row.create_user_id_==current_user){
    			$.ajax({
        			url: deleurl,
        			dataType:'json',
        			success: function(data){
        				setValue(data);
        				$('#myModalLabel').text('修改');
        				url = 'delegate/doUpdateDelegate';
        				action = 'edit';
        				showOrHideModal(action);
        			}
        		});
    		}else{
    			$.ajax({
    				url: deleurl,
    				dataType:'json',
    				success: function(data){
    					setValue(data);
    					$('#myModalLabel').text('查看');
    					action = 'hide';
    					showOrHideModal(action);
    				}
    			});
    		}   		
    }
	});
}

function search() {
	title = $("#input-word").val();
	if (title == '请输入委托人或被委托人姓名查询') {
		title = "";
	}
	$("#delegateList").bootstrapTable('refresh',{
		url : "delegate/findDelegateList",
		query:{
			title : title
		}
	});
}
function showOrHideModal(action){
	if(action =='open'){
		$('#trust_user_name').attr("disabled",false);
		$('.view').attr("readonly", false);
		$('#btnDiv').show();
		$('#btnDiv1').hide();
	}else if(action =='edit'){
		$('#trust_user_name').attr("disabled",true);
		$('.view').attr("readonly", false);
		$('#btnDiv').show();
		$('#btnDiv1').hide();
	}else{
		$('#trust_user_name').attr("disabled",true);
		$('.view').attr("readonly", true);
		$('#btnDiv').hide();
		$('#btnDiv1').show();
	}
	$('#myModal').modal({
		backdrop : 'static',
		keyboard : false
	});
}
//重置表单
function clearForm(){
	document.getElementById("ff").reset();
}
function saveDelegate(){
	if($('#ff').validationEngine('validate')){
		if(!checkTime()){
			layerAlert("委托开始时间不能大于结束时间！");
		}else if(!checkUser()){
			layerAlert("委托人和被委托人不能相同！");
		}else{
			$('#trust_user_name').attr("disabled",false);
			$.ajax({
				type : "POST",
				url : url,
				data: $("#ff").serialize(),
				dataType:"json",
				success : function(data) {
					if(data='true'){
						$('#myModal').modal('hide');
						$("#delegateList").bootstrapTable('refresh');
						checkId = -1;
					}
				}
			});	
		}
	}
}
function choseUser(type){
	userType=type;
	$('#group').attr('src',"treeController/zSinglePurposeContacts?state=0");
	$('#delegateModel').modal('show');
}
	//选人确定按钮
function makesure() {
		var arr = $("#group")[0].contentWindow.doSaveSelectUser();
		var userName = arr[1];
		var userId = arr[0];
		if(userType=='1'){
			$('#trust_user_id').val(userId);
			$('#trust_user_name').val(userName);
			$('#sol_id').val('');
			$('#sol_name').val('');
		}else if(userType=='2'){
			$('#user_id').val(userId);
			$('#user_name').val(userName);
		}
		$('#delegateModel').modal('hide');
	}
function checkTime(){
	if($('#start_time_').val()>$('#end_time_').val()){
		return false;
	}else{
		return true;
	}
}
function openSol(){
	if($('#trust_user_id').val()==null||$('#trust_user_id').val()==''||$('#trust_user_name').val()==null||$('#trust_user_name').val()==''){
		layerAlert("请选择委托人！");
	}else{
		$('#solModal').modal('show');
		$('#solframe').attr("src","delegate/toDelegatePage?userid="+$('#trust_user_id').val());
	}	
}
function saveSol(){
	var arr = document.getElementById("solframe").contentWindow.doSaveSelects();
	document.getElementById("sol_name").value = arr[1];
	document.getElementById("sol_id").value = arr[0];

	$('#solModal').modal('hide');
	$('#sol_name').focus();
}
//表单回显
function setValue(data){
	$('#id').val(data.id);
	$('#delegate_id').val(data.delegate_id);
	$('#trust_user_id').val(data.trust_user_id);
	$('#trust_user_name').val(data.trust_user_name);
	$('#user_id').val(data.user_id);
	$('#user_name').val(data.user_name);
	$('#sol_id').val(data.sol_id);
	$('#sol_name').val(data.sol_name);
	$('#comment_').val(data.comment_);
	$('#remark_').val(data.remark_);
	if(data.start_time_!=null&&data.start_time_!=''){
		$('#start_time_').val(data.start_time_.substring(0,10));
	}
	if(data.end_time_!=null&&data.end_time_!=''){
		$('#end_time_').val(data.end_time_.substring(0,10));
	}
}
/******************格式化方法********************/
 function indexFormatter(value, row, index) {
	return index + 1;
 }
 window.operateEvents = {
		    'click .editSubject': function (e, value, row, index) {
		    		stopPropagation();
		    		var ids = [];
		    		var delegates = [];
		    		ids[0] = row.id;
		    		delegates[0] = row.delegate_id;	
		    		if (row.trust_user_id==current_user||row.create_user_id_==current_user){
		    			layer.confirm('确定删除吗？', {
			    			btn : [ '是', '否' ]
			    		}, function() {
			    			$.ajax({
			    				url : 'delegate/doDelDelegate',
			    				dataType : 'json',
			    				data : {
			    					ids : ids,
			    					delegates:delegates
			    				},
			    				success : function(data) {
			    					if(data='true'){
			    					  layerAlert("删除成功");
			    					}else{
			    					  layerAlert("删除失败");
			    					}
			    					$("#delegateList").bootstrapTable('refresh');
			    				}
			    			});
			    		});	
		    		}else{
		    			layerAlert("被委托人没有删除权限！");
		    		}				
		    },
	    'click .fordetails': function (e, value, row, index) {
	    	stopPropagation();
	    	var id = row.id;
			var delegate_id = row.delegate_id;
			var deleurl='delegate/findDelegateInfo?id='+id+'&delegate_id='+delegate_id;
    		if (row.trust_user_id==current_user||row.create_user_id_==current_user){
    			$.ajax({
        			url: deleurl,
        			dataType:'json',
        			success: function(data){
        				setValue(data);
        				$('#myModalLabel').text('修改');
        				url = 'delegate/doUpdateDelegate';
        				action = 'edit';
        				showOrHideModal(action);
        			}
        		});
    		}else{
    			$.ajax({
    				url: deleurl,
    				dataType:'json',
    				success: function(data){
    					setValue(data);
    					$('#myModalLabel').text('查看');
    					action = 'hide';
    					showOrHideModal(action);
    				}
    			});
    		}   	  	
	    }
	};

	function operateFormatter(value, row, index) {
	    return ['<a class="editSubject" style="color:#167495;" href="javascript:void(0)" title="删除">',
	            '<i class="fa fa-remove"></i>',
	            '</a>  '        
	    ].join('');
	}
	function checkUser(){
		if($('#trust_user_id').val()==$('#user_id').val()){
			return false;
		}else{
			return true;
		}
	}