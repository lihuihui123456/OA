<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<title>审批人员</title>
     <script type="text/javascript">
        var editIndex = undefined;
        var thistab= undefined;
        //结束当前行编辑
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
        
        //点击单元格事件
        function onClickCell(index, field){
        	thistab=$(this);
        	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
            if (endEditing($(this))){
            	$(this).datagrid('selectRow', index)
                        .datagrid('editCell', {index:index,field:field});
                editIndex = index;
            }
        }
        
        //单元格编辑结束事件
        function onEndEdit(index, row){
            var ed = $(this).datagrid('getEditor', {
                index: index,
                field: 'user_type_'
            });
           /*  if(ed!=null){
	            row.user_type_ = $(ed.target).combobox('getText');
            } */
            
        }
        
        //数据表格行添加事件
        function append(id,nodeid){
        	var procdefid='${procdefid}';
        	var sol_id_='${solId}';
            if (endEditing($('#'+id))){
                $('#'+id).datagrid('appendRow',{required_:'P',com_user_:'p',node_info_id_:nodeid,proc_def_id_:procdefid,sol_id_:sol_id_});
                editIndex = $('#'+id).datagrid('getRows').length-1;
                $('#'+id).datagrid('selectRow', editIndex)
                        .datagrid('editCell', editIndex);
            }
        }
        
        //数据表格行移除事件
        function removeit(id){
        	 var row = $('#'+id).datagrid('getSelected');
             var editIndex = $('#'+id).datagrid('getRowIndex', row);
             if (row){
                 if (editIndex == undefined){return}
                 $('#'+id).datagrid('cancelEdit', editIndex)
                         .datagrid('deleteRow', editIndex);
                 if(row.id!='' && row.id!=undefined){
                	 $.ajax({
          				url : "${ctx}/bizSolMgr/doDelApproveUser?id="+row.id,
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
        
        //保存审批人员信息
        function saveassessofc(id){
        	if(endEditing($('#'+id))){
        		var effectRow = new Object();
            	effectRow[id]=JSON.stringify($('#'+id).datagrid('getData'));
            	$.ajax({
    				url : '${ctx}/bizSolMgr/doSaveApproveUser?actid='+id,
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
        
        //审批人员批量保存事件
        function saveallassessofc(){
        	$("table[name='asstable']").each(function(){
        		var tabid=$(this).attr("id");
        		saveassessofc(tabid);
    		});	
        }
        
        //取消行编辑事件
        function cancelEdit(){
        	$("table[name='asstable']").each(function(){
        		var id=$(this).attr("id");
        		var row = $('#'+id).datagrid('getSelected');
                var thisindex = $('#'+id).datagrid('getRowIndex', row);
        		$("#"+id).datagrid('endEdit', thisindex);
        		editIndex = undefined;
    		});	
        }
        
        //单元格编辑前触发事件
        function onBeforeEdit(index,row){
        	if(row!=null){
				if(row.user_type_=='1'){
			        row.user_name_ = '发起人';
			        
				}
			}
        }
        
        //用户选择图标点击事件
        function onClickIcon(){
        	var row=thistab.datagrid('getSelected');
        	if(row.user_type_!='1'){
        		if(row.user_type_=='3'){
        			$("#choose_user").attr("src",'${ctx}/userGroupController/selectUserGroup');
            	}else{
            		$("#choose_user").attr("src",'${ctx}/roleUserController/selectRoleUser');
            	}
            	$('#chooseper').dialog({    
            	    title: '用户选择',    
            	    width: 800,    
            	    height: 500,    
            	    closed: false,    
            	    cache: false,    
            	    modal: true,
            	    onResize:function(){
                        $(this).dialog('center');
                    }
            	});   
        	}
        }
        
        //人员选择确定事件
        function makesure(){
        	var arr=document.getElementById("choose_user").contentWindow.doSaveRoleUser();
        	var row=thistab.datagrid('getSelected');
        	index = thistab.datagrid('getRowIndex', row);
       		var ed = thistab.datagrid('getEditor', {
               index: index,
               field: 'user_name_'
            });
        	ed.target.textbox("setValue", arr[1]);
         	row.user_value_=arr[0];
        	$('#chooseper').dialog('close');
        }
        
        var userTypeData= [{
			type: '1',
			usertype: '发起人'
		},{
			type: '2',
			usertype: '用户'
		},{
			type: '3',
			usertype: '用户组'
		},{
			type: '4',
			usertype: '用户或组来自流程变量'
		},{
			type: '5',
			productname: '用户或组来自表单数据'
		},{
			type: '6',
			usertype: '用户或组来自脚本运算结果'
		},{
			type: '7',
			usertype: '用户来自用户关系运算结果'
		},{
			type: '8',
			usertype: '用户组来自用户与组关系运算结果'
		},{
			type: '9',
			usertype: '用户来自用户与组关系运算结果'
		}];
        
    </script>
</head>
<body onclick="cancelEdit()">
<form id="hq-fm" class="window-form">
	<table border= "1" style="width: 100%"  class="table-style">
		<tr style="height: 35px">
			<th style="width:20%;text-align: right;">投票结果：</th>
			<td style="width:80%;text-align: left;">
				<input type="radio" id="yes" name="redPrint_" value="1">通过
				<input type="radio" id="no" name="redPrint_" value="0"/>拒绝
			</td>
		</tr>
		<tr style="height: 35px">
			<th style="width:20%;text-align: right;">投票结果满足时：</th>
			<td style="width:80%;text-align: left;">
				<input type="radio" id="yes" name="redPrint_" value="1">流转下一环节
				<input type="radio" id="no" name="redPrint_" value="0"/>等待投票完成
			</td>
		</tr>
		<tr style="height: 35px">
			<th style="width:20%;text-align: right;">投票计算类型：</th>
			<td style="width:80%;text-align: left;">
				<input type="radio" id="yes" name="redPrint_" value="1">票数
				<input type="radio" id="no" name="redPrint_" value="0"/>百分比
			</td>
		</tr>
		<tr style="height: 35px">
			<th style="width:20%;text-align: right;">投票值：</th>
			<td style="width:80%;text-align: left;">
				<input type="number" >
			</td>
		</tr>
		<tr>
			<th style="width:20%;text-align: right;">特权会签：</th>
			<td style="width:80%;text-align: left;">
				<table id="hqtq" name="asstable" class="easyui-datagrid" style="width:100%;height: 300px"
		            data-options="fitColumns : true, singleSelect: false, toolbar: '#hqqx_toolbar',
		                method: 'get',onClickCell: onClickCell, onEndEdit: onEndEdit,onBeforeEdit:onBeforeEdit,
		                url: ''">
			        <thead>
			            <tr>
			            	<th data-options="field:'ck',checkbox:true,align:'center'"></th>
			                <th data-options="field:'user_type_',width:'20%',align:'center',
			                        formatter:function(value,row){
			                        for (var i=0;i<userTypeData.length;i++){
				                        if (userTypeData[i].type == value) {
           									return userTypeData[i].usertype;
       									}
			                        }
			                        },
			                        editor:{
			                            type:'combobox',
			                            options:{
			                                valueField:'type',
			                                textField:'usertype',
			                                required:true,
			                                data: userTypeData
			                            }
			                        }">用户类型</th>
			                <th data-options="field:'user_name_',width:'25%',align:'center',
			                				editor:{
			                					type:'textbox',
			                					options:{
			                					required:true,
  													iconWidth:22,
							                    icons: [{
							                        iconCls:'icon-man',
							                        handler: function(e){
							                            var v = $(e.data.target).textbox('getValue');
							                        }
							                    }],
							                    onClickIcon:onClickIcon
			                					}
			                				}
			                ">用户值</th>
			                <th hidden="true" data-options="field:'user_value_',align:'center', editor:'textbox'">用户id</th>
			               
			                <th data-options="field:'com_user_',width:'10%',align:'center',editor:{type:'checkbox',options:{on:'P',off:''}}">是否计算用户</th>
			                <th data-options="field:'sort_',width:'10%',align:'center',editor:'numberspinner'">序号</th>
			            </tr>
			        </thead>
		    	</table>
			    <div id="hqqx_toolbar">
			        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append('hqtq','${node.id}')">添加</a>
			        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit('${node.actId_}')">删除</a>
			        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveassessofc('${node.actId_}')">保存</a>
			    </div>
			</td>
		</tr>
		<tr>
			<th style="width:20%;text-align: right;">加签权限：</th>
			<td style="width:80%;text-align: left;">
				<table id="jqtq" name="asstable" class="easyui-datagrid" style="width:100%;height:300px"
			            data-options="fitColumns : true,singleSelect: false, toolbar: '#jqtq_toolbar',method: 'get',onClickCell: onClickCell, onEndEdit: onEndEdit,onBeforeEdit:onBeforeEdit,
			                url: ''">
				        <thead>
				            <tr>
				            	<th data-options="field:'ck',checkbox:true,align:'center'"></th>
				                <th data-options="field:'user_type_',width:'20%',align:'center',
				                        formatter:function(value,row){
				                        for (var i=0;i<userTypeData.length;i++){
					                        if (userTypeData[i].type == value) {
            									return userTypeData[i].usertype;
        									}
				                        }
				                        },
				                        editor:{
				                            type:'combobox',
				                            options:{
				                                valueField:'type',
				                                textField:'usertype',
				                                required:true,
				                                data: userTypeData
				                            }
				                        }">用户类型</th>
				                <th data-options="field:'user_name_',width:'25%',align:'center',
				                				editor:{
				                					type:'textbox',
				                					options:{
				                					required:true,
   													iconWidth:22,
								                    icons: [{
								                        iconCls:'icon-man',
								                        handler: function(e){
								                            var v = $(e.data.target).textbox('getValue');
								                        }
								                    }],
								                    onClickIcon:onClickIcon
				                					}
				                				}
				                ">用户值</th>
				                <th hidden="true" data-options="field:'user_value_',align:'center', editor:'textbox'">用户id</th>
				                <th data-options="field:'operator_',width:'20%',align:'center', formatter:function(value,row){
				                            return row.operator_;
				                        },
				                        editor:{
				                            type:'combobox',
				                            options:{
				                                valueField:'type',
				                                textField:'operator',
				                                method:'get',
				                                required:false,
				                                data: [{
													type: 'AND',
													operator: '与'
												},{
													type: 'OR',
													operator: '或'
												},{
													type: 'NOT',
													operator: '非'
												}]
				                            }
				                        }">计算逻辑</th>
				                <th data-options="field:'com_user_',width:'10%',align:'center',editor:{type:'checkbox',options:{on:'P',off:''}}">是否计算用户</th>
				                <th data-options="field:'sort_',width:'10%',align:'center',editor:'numberspinner'">序号</th>
				            </tr>
				        </thead>
			    	</table>
			    	
				    <div id="jqtq_toolbar" style="height:auto">
				        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append('jqtq','${node.id}')">添加</a>
				        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit('${node.actId_}')">删除</a>
				        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="accept()">从表单中添加</a>
				        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveassessofc('${node.actId_}')">保存</a>
				    </div>
				</td>
			</tr>
		</table>
	</form>

<!-- 弹出选人界面 -->
<div id="chooseper" class="easyui-dialog" title="My Dialog" style="width:400px;height:200px;"   
        data-options="iconCls:'icon-save',resizable:false,modal:false" closed="true" buttons="#dlg-buttons">
	<iframe id="choose_user" src=""  width="100%" height="395" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="no" style=""></iframe>
</div>
<div id="dlg-buttons" class="window-tool">
	<a class="easyui-linkbutton" data-options="plain:true" onclick="makesure()">确定</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#chooseper').dialog('close')" plain="true">取消</a>
</div>
<!-- 弹出选人界面end  -->

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
