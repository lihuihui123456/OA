<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>变量配置</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/pro.css">
    <script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
     <script type="text/javascript">
     var editIndex = undefined;
     	/** 结束当前编辑状态  **/
        function endEditing(tabid){
        	 var editIndex = undefined;
	       	 var row = tabid.datagrid('getSelected');
	       	 editIndex = tabid.datagrid('getRowIndex', row);
            if (editIndex == undefined){return true}
            if (tabid.datagrid('validateRow', editIndex)){
            	tabid.datagrid('endEdit', editIndex);
                editIndex = undefined;
                return true;
            } else {
                return false;
            }
        }
        
     	/** 点击单元格触发事件 **/
        function onClickCell(index, field){
        	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
            if (endEditing($(this))){
            	$(this).datagrid('selectRow', index)
                        .datagrid('editCell', {index:index,field:field});
                editIndex = index;
            }
        }
        
     	/** 停止编辑状态时触发事件 **/
        function onEndEdit(index, row){
            var ed = $(this).datagrid('getEditor', {
                index: index,
                field: 'type_'
            });
            row.productname = $(ed.target).combobox('getText');
        }
        
     	/** 添加行 **/
        function append(id,nodeid){
        	var procdefid='${procdefid}';
        	var sol_id_='${solId}';
            if (endEditing($('#'+id))){
                $('#'+id).datagrid('appendRow',{required_:'P',node_info_id_:nodeid,proc_def_id_:procdefid,sol_id_:sol_id_});
                editIndex = $('#'+id).datagrid('getRows').length-1;
                $('#'+id).datagrid('selectRow', editIndex)
                        .datagrid('editCell', editIndex);
            }
        }
        
     	/** 删除行 **/
        function removeit(id){
            var row = $('#'+id).datagrid('getSelected');
            var editIndex = $('#'+id).datagrid('getRowIndex', row);
            if (row){
                if (editIndex == undefined){return}
                $('#'+id).datagrid('cancelEdit', editIndex)
                        .datagrid('deleteRow', editIndex);
                if(row.id!='' && row.id!=undefined){
                	 $.ajax({
         				url : "${ctx}/bizSolMgr/dodeleteVarBykey?id="+row.id,
         				type : 'POST',
         				dataType : 'json',
         				success : function(result) {
         					if (result.result == "success") {
         						$('#'+id).datagrid('reload');
         					}
         				}
         			});
                }
                editIndex = undefined;
            }else{
            	$.messager.alert('警告','选择一条数据');  
            }
        }
        
     	/** 保存变量信息 **/
        function savevarcnfgs(id){
        	if(endEditing($('#'+id))){
        		var effectRow = new Object();
            	effectRow[id]=JSON.stringify($('#'+id).datagrid('getData'));
            	$.ajax({
    				url : '${ctx}/bizSolMgr/savevarcnfgs?actid='+id,
    				type : 'POST',
    				dataType : 'json',
    				data: effectRow,
    				success : function(result) {
    					if (result.result == "success") {
    						$('#'+id).datagrid('reload');
    					}
    				}
    			});
        	}
        }
        
     	/** 变量信息保存（批量保存）**/
        function saveallvar(){
        	$("table[name='vartable']").each(function(){
        		var tabid=$(this).attr("id");
	       		savevarcnfgs(tabid);
    		});	
        }
        
     	/** 取消编辑状态 **/
        function cancelEdit(){
        	$("table[name='vartable']").each(function(){
        		var id=$(this).attr("id");
        		var row = $('#'+id).datagrid('getSelected');
        		var thisindex = $('#'+id).datagrid('getRowIndex', row);
         		$("#"+id).datagrid('endEdit', thisindex);
         		editIndex = undefined;
    		});	
        }
    </script>
<!--     <style >
		.datagrid-header-inner,.datagrid-body,.datagrid-header{
			width:100%!important;
		}
		.datagrid-htable,.datagrid-btable,.datagrid-view,.datagrid {
			width:100%!important;
		}
		.datagrid-view2,.datagrid-wrap{
			width:100%!important;
		}
		.datagrid-body table{
			width:100%!important;
		}
		.datagrid-body{
			overflow:hidden;
		}
	</style> -->
</head>
<body onclick="cancelEdit()">
<div style="padding:5px">
	<span>
 <a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveallvar()">保存</a>
<p>说明：以下配置的变量会相应写入流程实例中，参与流程的规则运算。</p>
	</span>
</div>
<div style="padding:5px ">
<table class="table-style">
	<tr>
		<th width="15%" class="Theader">作用域</th>
		<th width="85%" class="Theader">变量</th>
	</tr>
	<tr>
		<th>全局</th>
		<td style="padding:10px;">
			<table id="dg" name="vartable" class="easyui-datagrid" title="" style="width:100%;height:auto;"
	            data-options=" iconCls: 'icon-edit', singleSelect: true, toolbar: '#tb',
	                url: '${ctx}/bizSolMgr/listVariables?procdefid=${procdefid}&&solId=${solId}', method: 'get', onClickCell: onClickCell">
		        <thead>
		            <tr>
		            	<th data-options="field:'ck',resizable:false,checkbox:true,align:'center'"></th>
		                <th data-options="field:'var_name_',width:'10%',resizable:false,align:'center',
		                			editor:{
		                				type:'textbox',
		                				options:{
		                					required:true,
		                				}
		                			}
		                			">变量名</th>
		                <th data-options="field:'key_',width:'10%',resizable:false,align:'center',
									editor:{
		                				type:'textbox',
		                				options:{
		                					required:true,
		                				}
		                			}
									">变量key</th>
		                <th data-options="field:'type_',width:'10%',resizable:false,align:'center',
		                        formatter:function(value,row){
		                            return row.type_;
		                        },
		                        editor:{
		                            type:'combobox',
		                            options:{
		                                valueField:'type',
		                                textField:'productname',
		                                method:'get',
		                                required:true,
		                                data: [{
											type: 'String',
											productname: '字符串'
										},{
											type: 'Number',
											productname: '数字'
										},{
											type: 'Date',
											productname: '日期'
										}]
		                            }
		                        }">类型</th>
		                <th data-options="field:'default_value_',width:'20%',resizable:false,align:'center',editor:'textbox'">缺省值</th>
		                <th data-options="field:'expression_',width:'10%',resizable:false,align:'center',editor:'textbox'">计算表达式</th>
		                <th data-options="field:'required_',width:'10%',resizable:false,align:'center',editor:{type:'checkbox',options:{on:'P',off:''}}">是否必填</th>
		                <th data-options="field:'sort_',width:'5%',resizable:false,align:'center',editor:'numberspinner'">序号</th>
		            </tr>
		        </thead>
	    	</table>
	    	<div id="tb" style="height:auto">
		        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append('dg')">添加</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit('dg')">删除</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="accept()">从表单中添加</a>
		        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="savevarcnfgs('dg')">保存</a>
		    </div>
	    </td>
	</tr>
	<c:choose>
   		<c:when test="${not empty nodelist}">
   			<c:forEach items="${nodelist}" var="node" varStatus="vs">
   				<tr>
   					<th>${node.actName_}</th>
   					<td style="padding:10px;">
						<table id="${node.actId_}" name="vartable" class="easyui-datagrid" title="" style="width:100%;height:auto"
				            data-options=" iconCls: 'icon-edit', singleSelect: true, toolbar: '#${node.actId_}_1',
				                url: '${ctx}/bizSolMgr/listVariables?procdefid=${procdefid}&&actid=${node.id}&&solId=${solId}', method: 'get', onClickCell: onClickCell">
					        <thead>
					            <tr>
					            	<th data-options="field:'ck',checkbox:true,align:'center'"></th>
					               <th data-options="field:'var_name_',width:'10%',resizable:false,align:'center',
				                			editor:{
				                				type:'textbox',
				                				options:{
				                					required:true,
				                				}
				                			}
				                			">变量名</th>
					                <th data-options="field:'key_',width:'10%',resizable:false,align:'center',
												editor:{
					                				type:'textbox',
					                				options:{
					                					required:true,
					                				}
					                			}
											">变量key</th>
					                <th data-options="field:'type_',width:'10%',align:'center',
					                        formatter:function(value,row){
					                            return row.type_;
					                        },
					                        editor:{
					                            type:'combobox',
					                            options:{
					                                valueField:'type',
					                                textField:'productname',
					                                method:'get',
					                                required:true,
					                                data: [{
														type: 'String',
														productname: '字符串'
													},{
														type: 'Number',
														productname: '数字'
													},{
														type: 'Date',
														productname: '日期'
													}]
					                            }
					                        }">类型</th>
					                <th data-options="field:'default_value_',width:'20%',align:'center',editor:'textbox'">缺省值</th>
					                <th data-options="field:'expression_',width:'10%',align:'center',editor:'textbox'">计算表达式</th>
					                <th data-options="field:'required_',width:'10%',align:'center',editor:{type:'checkbox',options:{on:'P',off:''}}">是否必填</th>
					                <th data-options="field:'sort_',width:'5%',align:'center',editor:'numberspinner'">序号</th>
					            </tr>
					        </thead>
				    	</table>
				    	<div id="${node.actId_}_1" style="height:auto">
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append('${node.actId_}','${node.id}')">添加</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit('${node.actId_}')">删除</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="accept()">从表单中添加</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="savevarcnfgs('${node.actId_}')">保存</a>
					    </div>
				    </td>
   				</tr>
   			</c:forEach>
   		</c:when>
   	</c:choose>
</table>
</div>
<script type="text/javascript">
//扩展方法，点击事件触发一个单元格的编辑
$.extend($.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field){
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});
</script>
</body>
</html>
