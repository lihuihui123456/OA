<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>审批人员</title>
    <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
    <link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/pro.css">
    <script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
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
        
        //从表单中获取变量信息
        function accept(id,nodeid){
        	var procdefid='${procdefid}';
        	var sol_id_='${solId}';
            if (endEditing($('#'+id))){
                $('#'+id).datagrid('appendRow',{user_type_:13,required_:'P',com_user_:'p',node_info_id_:nodeid,proc_def_id_:procdefid,sol_id_:sol_id_});
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
        			//用户组
        			$("#choose_user").attr("src",'${ctx}/userGroupController/selectUserGroup');
            	}else if(row.user_type_=='4'){
            		//部门树
            		$("#choose_user").attr("src",'${ctx}/orgController/getOrgDeptTreeAsyn');
            	}else if(row.user_type_=='5'){
            		//岗位
            		$("#choose_user").attr("src",'${ctx}/orgController/selectDeptPostTree');
            	}else if(row.user_type_=='6'){
            		//角色
            		$("#choose_user").attr("src",'${ctx}/roleController/selectRoleList');
            	}else if(row.user_type_=='13'){
            		$("#choose_user").attr("src",'${ctx}/bizSolMgr/tofindEntityMessage?solId=${solId}');
            	}else{
            		//人员
            		$("#choose_user").attr("src",'${ctx}/orgController/selectOrgDeptUser');
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
        	var arr=document.getElementById("choose_user").contentWindow.doSaveMessage();
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
        
        /**
        *1、如果变量是人员，如果只有一个人运算符用and
        *
        */
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
			usertype: '部门'
		},{
			type: '5',
			usertype: '岗位'
		},{
			type: '6',
			usertype: '角色'
		},{
			type: '7',
			usertype: '用户或组来自流程变量'
		},{
			type: '8',
			productname: '用户或组来自表单数据'
		},{
			type: '9',
			usertype: '用户或组来自脚本运算结果'
		},{
			type: '10',
			usertype: '用户来自用户关系运算结果'
		},{
			type: '11',
			usertype: '用户组来自用户与组关系运算结果'
		},{
			type: '12',
			usertype: '用户来自用户与组关系运算结果'
		},{
			type: '13',
			usertype: '变量来自表单'
		}];
        
    </script>
    
    <style >
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
	</style>
    
</head>
<body onclick="cancelEdit()">
<a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveallassessofc()">批量保存</a>
<table class="table-style" style="margin-top:10px;">
	<tr>
		<th width="15%" class="Theader">审批环节</th>
		<th width="85%" class="Theader">人员配置</th>
	</tr>
	<c:choose>
   		<c:when test="${not empty nodelist}">
   			<c:forEach items="${nodelist}" var="node" varStatus="vs">
				<tr>
					<th>${node.actName_}</th>
					<td style="padding:10px;">
						<table id="${node.actId_}" name="asstable" class="easyui-datagrid table-inner" title="" style="width:100%;height:auto"
				            data-options=" iconCls: 'icon-edit', singleSelect: true, toolbar: '#${node.actId_}_1',
				                url: '${ctx}/bizSolMgr/listApproveUser?procdefid=${procdefid}&&actid=${node.id}&&solId=${solId}', method: 'get', 
				                onClickCell: onClickCell, onEndEdit: onEndEdit,onBeforeEdit:onBeforeEdit">
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
					    <div id="${node.actId_}_1" style="height:auto">
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append('${node.actId_}','${node.id}')">添加</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit('${node.actId_}')">删除</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="accept('${node.actId_}','${node.id}')">从表单中添加</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveassessofc('${node.actId_}')">保存</a>
					    </div>
				    </td>
				</tr>
			</c:forEach>
		</c:when>
	</c:choose>
</table>

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