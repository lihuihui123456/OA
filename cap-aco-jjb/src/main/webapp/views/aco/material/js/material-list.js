var url;
var selectionIds = [];
$(function() {
	//加载表格
	initTable();
	
	$('#input-word').bind('keypress', function (event) {
        if (event.keyCode == "13") {
        	searchData();
           return false ;   
        } });
	
	/**
    * 选中事件操作数组  
    */
    var union = function(array,ids){  
        $.each(ids, function (i, id) {  
            if($.inArray(id,array)==-1){  
                array[array.length] = id;  
            }  
        });  
         return array;  
	};
	/**
     * 取消选中事件操作数组 
     */ 
    var difference = function(array,ids){  
        $.each(ids, function (i, id) {  
             var index = $.inArray(id,array);  
             if(index!=-1){  
                 array.splice(index, 1);  
             }  
         });  
        return array;  
    };    
    var _ = {"union":union,"difference":difference};
    /**
	 * bootstrap-table 记忆选中 
	 */
	$('#dtlist').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
	var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
        return row.id;  
    });  
    func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
    selectionIds = _[func](selectionIds, ids);   
	});  


	
	/* 注册按钮事件 */
	// 新增按钮
	$("#gm_btn_new").click(function() {
		url = "bizMaterialController/doAddMaterial";
		clearForm();
		$('#btnDiv').show();
		$('#btnDiv1').hide();
		$('input,select,textarea',$('form[id="ff"]')).attr('readonly',false);
		$('#myModalLabel').text('新增物品');
		$('#myModal').modal({
			backdrop : 'static',
			keyboard : false
		});
	});
	
	// 修改按钮
	$("#gm_btn_edit").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单条数据进行修改！");
			return false;
		}
		var id = selectRow[0].id_;
		url ="bizMaterialController/doUpdateMaterial";
		$.ajax({
			url : 'bizMaterialController/findMaterialById/' + id,
			dataType:'json',
			type : 'post',
			success:function(data){
				clearForm();
				setValue(data);
				$('#myModalLabel').text('修改物品');
				$('#btnDiv').show();
				$('#btnDiv1').hide();
				$('input,select,textarea',$('form[id="ff"]')).attr('readonly',false);
				$('#myModal').modal({
					backdrop : 'static',
					keyboard : false
				});
			}
		});
	});
	
	// 查看按钮
	$("#gm_btn_view").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单条数据进行查看！");
			return false;
		}
		var id = selectRow[0].id_;
		$.ajax({
			url : 'bizMaterialController/findMaterialById/' + id,
			dataType:'json',
			type : 'post',
			success:function(data){
				setValue(data);
				$('input,select,textarea',$('form[id="ff"]')).attr('readonly',true);
				$('#btnDiv').hide();
				$('#btnDiv1').show();
				$('#myModalLabel').text('查看物品');
				$('#myModal').modal({
					backdrop : 'static',
					keyboard : false
				});
			}
		});
	});
	
	// 删除按钮
	$("#gm_btn_delete").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		var ids = '';
		$(selectRow).each(function(index) {
			ids = ids + selectRow[index].id_ + ",";
		});
		ids = validateCount(ids);
		if(ids == null || ids == ""){
			layerAlert("库存量不为0的,不能删除！");
			return;
		}
		ids = ids.substring(0, ids.length - 1);
		layer.confirm('确定删除吗？', {
			btn : [ '是', '否' ]
		}, function() {
			$.ajax({
				url : 'bizMaterialController/doDelMaterial',
				dataType : 'json',
				data : {
					ids : ids
				},
				success : function(result) {
					if(result = 'true'){
						layerAlert("删除成功！");
					}else{
						layerAlert("删除失败！");
					}
					$("#dtlist").bootstrapTable('refresh');
				}
			});
		}, function() {
		});

	});
	/* 按钮方法结束 */
	
	//开启表单验证引擎(修改部分参数默认属性)
	$('#ff').validationEngine({
		promptPosition:'topRight', //提示框的位置 
		autoHidePrompt:true, //是否自动隐藏提示信息 默认为false
		autoHideDelay:100000, //自动隐藏提示信息的延迟时间 (ms)
		maxErrorsPerField:false,//单个元素显示错误提示的最大数量，值设为数值。默认 false 表示不限制。
		showOneMessage:false, //是否只显示一个提示信息
		onValidationComplete:submitForm,//表单提交验证完成时的回调函数 function(form, valid){}，参数：form：表单元素 valid：验证结果（ture or false）使用此方法后，表单即使验证通过也不会进行提交，交给定义的回调函数进行操作。
	});
	
	//remove the error message when the modal open
	//方法适用于Bootstrape v3
	$("#myModal").on("show.bs.modal", function () {
		$('#ff').find('div .formError').remove();
	})
	
});
var mname = '';
function initTable(){
	$('#dtlist').bootstrapTable({
		url : 'bizMaterialController/findAllMaterialDataQuery', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "desc", // 排序方式
		queryParams :function(params) {
			validateData();
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					pageSize : params.limit, // 页面大小
					pageNum : params.offset, // 页码
					m_name_:$.trim(mname),
					m_number_:$.trim($("#m_number_").val()),
					standard_:$.trim($("#standard_").val()),
					unit_:$.trim($("#unit_").val()),
					supplier_:$.trim($("#supplier_").val()),
					startTime:$.trim($("#startTime").val()),
					endTime:$.trim($("#endTime").val()),
					sortName:this.sortName,
					sortOrder:this.sortOrder
				};
			    mname="";
				return temp;
/*			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					pageSize : params.limit, // 页面大小
					pageNum : params.offset, // 页码
					mname : function (){
						if($("#input-word").val()=="请输入物品名称查询"){
							return '';
						}else{
							return $("#input-word").val();
						}
					},
					sortName : this.sortName,
					sortOrder : this.sortOrder
				};
				return temp;*/
			},// 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		strictSearch : false,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "id_", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ {
			/*field : 'ck',*/
			checkbox : true,
			valign: 'middle',
			field: 'checkStatus',
			width : '3%',
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			width : '7%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'm_name_',
			title : '物品名称',
			align : 'left',
			valign: 'middle',
			width : '30%',
			sortable:true
		}, {
			field : 'm_number_',
			title : '物品编号',
			align : 'right',
			valign: 'middle',
			sortable:true
		}, {
			field : 'standard_',
			title : '规格型号',
			align : 'right',
			valign: 'middle',
			sortable:true
		}, {
			field : 'unit_',
			title : '计量单位',
			align : 'center',
			valign: 'middle',
			sortable:true
		}, {
			field : 'supplier_',
			title : '供货商',
			align : 'left',
			valign: 'middle',
			sortable:true
		}, {
			field : 'indate_',
			title : '创建时间',
			align : 'center',
			width : 160,
			valign: 'middle',
			sortable:true
//			  formatter : function(val, row) {
//				return row.indate_.substring(0,10);
//				  }
		}],
		onClickRow:function(row,tr){
			var id = row.id_;
			$.ajax({
				url : 'bizMaterialController/findMaterialById/' + id,
				dataType:'json',
				type : 'post',
				success:function(data){
					setValue(data);
					$('input,select,textarea',$('form[id="ff"]')).attr('readonly',true);
					$('#btnDiv').hide();
					$('#btnDiv1').show();
					$('#myModalLabel').text('查看物品');
					$('#myModal').modal({
						backdrop : 'static',
						keyboard : false
					});
				}
			});
		}
	});
}

function submitForm(form, valid){
	if(valid){
		$.ajax({
			type : "POST",
			url : url,
			data: form.serialize(),
			success : function(data) {
				if(data.result == '03'){
					$('#myModal').modal('hide');
					$("#dtlist").bootstrapTable('refresh');
				}else if(data.result == '04'){
					layerAlert("表单保存失败！");
				}else if(data.result == '01'){
					layerAlert("物品名字重复");
				}else if(data.result == '02'){
					layerAlert("物品编码重复");
				}
			}
		});
	}else{
		//layerAlert("表单填写错误！");
	}
}

function setValue (data){
	$('#id').val(data.id_);
	$('#sort').val(data.sort_);
	$('#indate').val(data.indate_);
	$('#status').val(data.status_);
	$('#goodsname').val(data.m_name_);
	$('#goodsname').val(data.m_name_);
	$('#goodsnumber').val(data.m_number_);
	$('#standard').val(data.standard_);
	$('#unit').val(data.unit_);
	$('#supplier').val(data.supplier_);
	$('#inventoryfloor').val(data.inventory_floor_);
	$('#remark').val(data.remark_);
}

//重置表单
function clearForm(){
	document.getElementById("ff").reset();
}
//搜索方法
function searchData() {
	$("#search_form")[0].reset();
	mname = $("#input-word").val();
	if(mname == '请输入物品名称查询'){
		mname="";
	}else{
		/*var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
		if(mname.match(reg)==null){
			layerAlert("输入内容含有非法字符！");
			return;
		}*/
	}
	$("#dtlist").bootstrapTable('refresh');
}

function validateData() {
	if($("#input-word").val()!="请输入物品名称查询"&&$("#input-word").val()!=""){
		mname=$("#input-word").val();
		$("#search_form")[0].reset();
	}
	mname=mname+$("#m_name_").val();
/*	var startTime=$("#startTime").val();
	var endTime=$("#endTime").val();
	if(startTime!=""&&endTime!=""){
		if(startTime > endTime){
			window.parent.publicAlert("库存创建开始日期不能大于结束日期");
			return;
		}
	}*/
}
$(function(){
	$("#advSearchModal").click(function() {
		var display =$('#advSearch').css('display');
		if(display == "none") {
			$("#advSearch").show();
		}else {
			$("#advSearch").hide();
		}
	})
		$("#modal_close").click(function(){
			$("#advSearch").hide();	
		})
});

	/**
 *  高级查询方法
 */
function submitFormAdv() {
/*    $('#advSearchModal').modal('hide');
*/   $("#input-word").val("请输入物品名称查询");
	$("#dtlist").bootstrapTable('refresh');
}
/**
 *  高级查询方法
 */
function clearFormAdv() {
/*	 $('#advSearchModal').modal('hide');
*/		document.getElementById("search_form").reset();
        submitFormAdv();
}

function validateCount(strs){
	strs = strs.substring(0, strs.length - 1);
	var str= new Array();
	str = strs.split(",");
	var ids = '';
	for(var i=0;i<str.length;i++){
		
		$.ajax({
			type : "POST",
			url : "bizMaterialController/findCountById",
			data: {
				id : str[i]
			},
			async : false, 
			success : function(data) {
				if(data == "0" || data == "" || data == null){
					ids += str[i] + ",";
				}
			}
		});
	}
	return ids;
}
