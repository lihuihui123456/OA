$(function() {
	if (singleSelect) {
		$("#southArea").remove();
	}else{
		idStr = idStr.replace("deptSelf,", "");
		nameStr = nameStr.replace("本部门,", "");
		//isContainSelf = 'true';
		if (isContainSelf == 'true') {
			$("#content").append('<a id="deptSelf">本部门</a>');
			ids += 'deptSelf,';
			names += '本部门,';
		}
		if (nameStr != null && nameStr != '') {
			var nameArr = nameStr.split(",");
			var idArr = idStr.split(",");
			var deptId = "";
			var deptName = "";
			for (var j = 0;j < idArr.length;j++) {
				deptId = idArr[j];
				deptName = nameArr[j];
				if (deptId == '') {
					continue;
				}
				$("#content").append('<a id="'+deptId+'">'+deptName+'<span class="close_man" onclick="removeDept(\''+deptId+'\',\''+deptName+'\')">×</span></a>');
				ids += deptId + ",";
				names += deptName + ",";
			}
		}
	}
	
	InitTreeData();
	findDeptListByOrgId("0");
	
});

var sel_deptId = "";
/**
 * 初始化加载左侧树
 */
function InitTreeData() {
	$('#org_dept_tree').tree({
		url : 'orgController/findOrgTree',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			//展开点击选中的节点
			$('#org_dept_tree').tree('expand', node.target)
			
			reload(node.id);
		}
	});
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_dept_tree").tree('search',searchValue);
}

/**
 * 按组织机构，查询条件加载用户列表信息
 * 
 * @param orgId 组织机构id
 */
function findDeptListByOrgId(orgId) {
	var url = "deptController/findByCondition";
	
	$('#deptList').treegrid({
		url : url,
		method : 'POST',
		idField : 'id',
		treeField:'text',
		striped : true,
		fitColumns : true,
		fit : true,
		singleSelect : singleSelect,
		rownumbers : true,
		nowrap : false,
		toolbar : '#toolBar',
		queryParams : {
			orgId : orgId
		},
		columns : [ [ 
		    { field : 'ck', checkbox : true }, 
 		    { field : 'id', title : 'id', hidden : true }, 
 		    { field : 'text', title : '部门名称', width : 150, align : 'left' }, 
 		    { field : 'deptCode', title : '部门编码', width : 150, align : 'left',formatter:formaterDeptCode },
 		    { field : 'deptDesc', title : '部门描述', width : 250, align : 'left',formatter:formaterDeptDesc } 
 		] ],
		 onCheck : function(row) {
			 if (!singleSelect) {
				 insertSelectData(row);
			 }
		},
		onUncheck : function(row) {
			 if (!singleSelect) {
				var deptId = row.id;
				var deptName = row.text;
				removeDept(deptId,deptName);
			 }
		},
		onCheckAll : function(rows) {
			 if (!singleSelect) {
				$(rows).each(function(index,row){
						insertSelectData(row);
				});
			 }
		},
		onUncheckAll : function(rows) {
			if (!singleSelect) {
				$(rows).each(function(index,row){
					removeDept(row.id,row.text);
				});
			 }
		},
		onLoadSuccess : function(row,data) {
			/*if (data!=null&&data.rows[0] != null) {
				if (idStr != null && idStr != '') {
					var idAttr = idStr.split(",");
					for(var i=0;i<data.rows.length;i++){
						for (var j = 0;j < idAttr.length;j++) {
							if(data.rows[i].id == idAttr[j]){
								$('#deptList').treegrid('select',i);
							}
						}
					}
				}
            }*/
			
			var rows = $("#deptList").treegrid('getRoots');
			if (rows == null) {
				return;
			}
			if (idStr == null || idStr == '') {
				return;
			}
			var nodes = [];
			var idAttr = idStr.split(",");
			for ( var i = 0; i < rows.length; i++) {
				nodes.push(rows[i]);
				var children = $("#deptList").treegrid('getChildren',rows[i].target);
				for ( var j = 0; j < children.length; j++) {
					nodes.push(children[j]);
				}
			}
		    for (var i = 0; i < nodes.length; i++) {  
		    	for (var j = 0;j < idAttr.length;j++) {
					if(nodes[i].id == idAttr[j]){
						$('#deptList').treegrid('select',idAttr[j]);
					}
				}
		    }  
		}
	});
}

function findByCondition() {
	var node = $('#org_dept_tree').tree('getSelected');
	var orgId = node.id;
	
	reload(orgId);
}

/**
 * 重新加载列表
 */
function reload(orgId) {
	
	$('#deptList').treegrid('loadData',[]);
	$('#deptList').treegrid('load', {
		orgId : orgId,
		searchValue : $("#search").searchbox('getValue')
	});
}

function clearSearchBox(){
	 $("#search").searchbox("setValue","");
}

function doSaveSingleData(){
	var selecteds = $('#deptList').treegrid('getChecked');
	
	var _ids = '';
	var _names = '';
	$(selecteds).each(function(index) {
		_ids = _ids + selecteds[index].id + ",";
		_names = _names + selecteds[index].text + ",";
	});
	
	if(_ids != ''){
		_ids = _ids.substring(0, _ids.length - 1);
	}
	if(_names != ''){
		_names = _names.substring(0, _names.length - 1);
	}

	var arr=new Array();
	arr[0]=_ids;
	arr[1]=_names;
	return arr;
}

var ids = '';
var names = '';
function insertSelectData(row){
	var deptId = row.id;
	var deptName = row.text;
	if (ids.indexOf(deptId) != -1) {
		return;
	}
	$("#content").append('<a id="'+deptId+'">'+row.text+'<span class="close_man" onclick="removeDept(\''+deptId+'\',\''+deptName+'\')">×</span></a>');
	ids += row.id + ",";
	names += row.text + ",";
	
	idStr += row.id + ",";
	nameStr += row.text + ",";
}

function removeDept(deptId,deptName){
	if (ids.indexOf(deptId) == -1) {
		return;
	}
	$("#"+deptId).remove();
	

	ids = ids.replace(deptId+",", "");
	names = names.replace(deptName+",", "");

	idStr = idStr.replace(deptId+",", "");
	nameStr = nameStr.replace(deptName+",", "");
	
	var rows = $("#deptList").treegrid('getRoots');
	var nodes = [];
	for ( var i = 0; i < rows.length; i++) {
		nodes.push(rows[i]);
		var children = $("#deptList").treegrid('getChildren',rows[i].target);
		for ( var j = 0; j < children.length; j++) {
			nodes.push(children[j]);
		}
	}
    for (var i = 0; i < nodes.length; i++) {    
        if (nodes[i].id == deptId) {    
            $('#deptList').treegrid('unselect',deptId);
            break;    
        }    
    }  
}

function doSaveData(){
	if (singleSelect) {
		return doSaveSingleData();
	} else {
		var arr = new Array();
		arr[0] = ids.substring(0,ids.length-1);
		arr[1] = names.substring(0,names.length-1);
		return arr;
	}
}

/**
 * 格式化部门编码
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formaterDeptCode(val, row) {
	return row.attributes.deptCode
}

/**
 * 格式化部门描述
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formaterDeptDesc(val, row) {
	return row.attributes.deptDesc
}