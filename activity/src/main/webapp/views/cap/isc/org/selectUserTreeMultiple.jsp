<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>人员组织结构树</title>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.min.js"></script>
<script type="text/javascript">
	var setting = {
		async : {
			enable : true,
			dataType : "json",
			type : "post",
			url : "${ctx}/orgController/getUserTreeMultiple",
			autoParam : [ "id" ],
			idKey : "id",
			pIdKey : "pId",
			rootPId : 0
			//dataFilter : filterNode
		},
		check: {  
            enable: true,  
            chkStyle: "checkbox",               //多选  
            chkboxType: { "Y" : "", "N" : "" }  //不级联父节点选择  
        },  
		callback : {
			onClick : zTreeOnClick,
			onAsyncSuccess : onAsyncSuccess
		}
	};
	$(document).ready(function() {
		$.fn.zTree.init($("#userTree"), setting);
	});
	
	function zTreeOnClick(event, treeId, treeNode) {
		if (!treeNode.isParent) {
			alert(treeNode.id+":"+treeNode.name);
		}
	};

	//异步加载成功回调函数  
    function onAsyncSuccess(event, treeId, treeNode, msg) {  
        alert(msg);
    	var zTree = $.fn.zTree.getZTreeObj("userTree");
		var allNodes=zTree.getNodes();//这里只能找到最外层所有的节点
		//去掉选框
		if(allNodes.length>0){
		    for(var i=0;i<allNodes.length;i++){
		        if(allNodes[i].isParent || allNodes[i].isParent == 'true'){//找到父节点
		            allNodes[i].nocheck=true;//nocheck为true表示没有选择框
		            zTree.updateNode(allNodes[i]);
		        }
		    }
		}
    }  

  //异步加载成功回调函数  
    function filterNode(treeId, parentNode, childNodes) {  
    	var zTree = $.fn.zTree.getZTreeObj("userTree");
    	//var node = zTreeObj.getNodeByParam("id", treeId, null);
    	/* if(childNodes.isParent || childNodes.isParent == 'true'){//找到父节点
    		node.nocheck=true;//nocheck为true表示没有选择框
            //zTree.updateNode(allNodes[i]);
        }
        return childNodes; */

        if (childNodes) {
            for(var i =0; i < childNodes.length; i++) {
            	if(childNodes[i].isParent || childNodes[i].isParent == 'true'){//找到父节点
            		childNodes[i].nocheck=true;//nocheck为true表示没有选择框
                    //zTree.updateNode(allNodes[i]);
                }else {
                	childNodes[i].nocheck=false;
                 }
            }
          }
          return childNodes;
    }  
</script>

</head>
<body style="text-align: center;background-color: #f9f9f9;">
	<table style="border: 0px;width:400px;">
		<tr style="background-color: #f4f4f4;border:1px solid #ececec;">
			<td style="vertical-align: middle;"  width="50%">
				<ul id="userTree" class="ztree" style="height: 300px;"></ul>
			</td>
		</tr>
	</table>
</body>
</html>