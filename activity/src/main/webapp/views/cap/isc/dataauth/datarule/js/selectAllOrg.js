$(function() {
	if (singleSelect) {
		$("#southArea").remove();
	}else{
		idStr = idStr.replace("orgSelf,", "");
		nameStr = nameStr.replace("本单位,", "");
		//isContainSelf = 'true';
		if (isContainSelf == 'true') {
			$("#content").append('<a id="orgSelf">本单位</a>');
			ids += 'orgSelf,';
			names += '本单位,';
		}
		if (nameStr != null && nameStr != '') {
			var nameArr = nameStr.split(",");
			var idArr = idStr.split(",");
			var orgId = "";
			var orgName = "";
			for (var j = 0;j < idArr.length;j++) {
				orgId = idArr[j];
				orgName = nameArr[j];
				if (orgId == '') {
					continue;
				}
				$("#content").append('<a id="'+orgId+'">'+orgName+'<span class="close_man" onclick="removeOrg(\''+orgId+'\',\''+orgName+'\')">×</span></a>');
				ids += orgId + ",";
				names += orgName + ",";
			}
		}
	}
	
	InitTreeData();
	findOrgListByOrgId("0");
	
});

var sel_orgId = "";
/**
 * 初始化加载左侧树
 */
function InitTreeData() {
	$('#org_tree').tree({
		url : 'orgController/findOrgTree',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			//展开点击选中的节点
			$('#org_tree').tree('expand', node.target)
			
			reload(node.id);
		}
	});
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_tree").tree('search',searchValue);
}

/**
 * 按组织机构，查询条件加载用户列表信息
 * 
 * @param orgId 组织机构id
 */
function findOrgListByOrgId(orgId) {
	var url = "orgController/findChildrenById";
	
	$('#orgList').datagrid({
		url : url,
		method : 'POST',
		idField : 'orgId',
		striped : true,
		fitColumns : true,
		fit : true,
		singleSelect : singleSelect,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams : {
			orgId : orgId
		},
		columns : [ [ 
		    { field : 'ck', checkbox : true }, 
 		    { field : 'orgId', title : 'orgId', hidden : true }, 
 		    { field : 'orgName', title : '单位名称', width : 150, align : 'left' }, 
 		    { field : 'orgCode', title : '单位编码', width : 150, align : 'left' },
 		    { field : 'orgDesc', title : '单位描述', width : 250, align : 'left' } 
 		] ],
		 onCheck : function(index, row) {
			 if (!singleSelect) {
				 insertSelectData(row);
			 }
		},
		onUncheck : function(index, row) {
			 if (!singleSelect) {
				var orgId = row.orgId;
				var orgName = row.orgName;
				removeOrg(orgId,orgName);
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
					removeOrg(row.orgId,row.orgName);
				});
			 }
		},
		onLoadSuccess : function(data) {
			if (data!=null&&data.rows[0] != null) {
				if (idStr != null && idStr != '') {
					var idAttr = idStr.split(",");
					for(var i=0;i<data.rows.length;i++){
						for (var j = 0;j < idAttr.length;j++) {
							if(data.rows[i].orgId == idAttr[j]){
								$('#orgList').datagrid('selectRow',i);
							}
						}
					}
				}
            }
		},
	});
}

function findByCondition() {
	var node = $('#org_tree').tree('getSelected');
	var orgId = node.id;
	
	reload(orgId);
}

/**
 * 重新加载列表
 */
function reload(orgId) {
	
	$('#orgList').datagrid('load', {
		orgId : orgId,
		searchValue : $("#search").searchbox('getValue')
	});
}

function clearSearchBox(){
	 $("#search").searchbox("setValue","");
}

function doSaveSingleData(){
	var selecteds = $('#orgList').datagrid('getChecked');
	
	var _ids = '';
	var _names = '';
	$(selecteds).each(function(index) {
		_ids = _ids + selecteds[index].orgId + ",";
		_names = _names + selecteds[index].orgName + ",";
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
	var orgId = row.orgId;
	var orgName = row.orgName;
	if (ids.indexOf(orgId) != -1) {
		return;
	}
	$("#content").append('<a id="'+orgId+'">'+row.orgName+'<span class="close_man" onclick="removeOrg(\''+orgId+'\',\''+orgName+'\')">×</span></a>');
	ids += row.orgId + ",";
	names += row.orgName + ",";
	
	idStr += row.orgId + ",";
	nameStr += row.orgName + ",";
}

function removeOrg(orgId,orgName){
	if (ids.indexOf(orgId) == -1) {
		return;
	}
	$("#"+orgId).remove();
	

	ids = ids.replace(orgId+",", "");
	names = names.replace(orgName+",", "");

	idStr = idStr.replace(orgId+",", "");
	nameStr = nameStr.replace(orgName+",", "");
	
	var rows = $("#orgList").datagrid('getData').rows;
    for (var i = 0; i < rows.length; i++) {    
        if (rows[i].orgId == orgId) {    
            $('#orgList').datagrid('unselectRow',i);
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