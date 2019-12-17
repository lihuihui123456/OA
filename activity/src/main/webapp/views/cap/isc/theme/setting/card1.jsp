<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>主题1</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/setting/js/card1.js"></script>
	<style>
		.div_td { width:280px;
		  height:160px;
		  float:left;
		  color:#FF0000;
		  text-align:center;
		  line-height:160px;
		}
		.img {
			border-style:none;
			position: absolute;
			left:0 ;
			right:0 ;
			top:0 ;
			bottom:0 ;
			margin:auto
		}
	</style>
	<script type="text/javascript">
		var path = '${ctx}';
		var list = '${list}';
	</script>
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<input type="hidden" id="typeId">
	<!-- 左侧主题类型区域 -->
	<div data-options="region:'west',split:true,collapsible:false" style="width: 200px;" class="page_menu">
			
			<div style=" border:0px;" >
				<a href="javascript:setModule('menuTree')" >
					<img id="menuTree" width="110" height="110" alt="asdsad" class="img"
						src="${ctx}/views/cap/isc/theme/img/new_contact.png">
				</a>
			</div>
	</div>

	<div data-options="region:'center'" class="content">
		<div class="div_td" style="border-bottom:1px #ddd solid; border-right:1px #ddd solid;position: relative;">
	    	<a href="javascript:setModule('imgPic1')">
	    		<img id="imgPic1" width="110" height="110" class="img"
					src="${ctx}/views/cap/isc/theme/img/new_contact.png">
			</a>
    	</div>
		<div class="div_td" style="border-bottom:1px #ddd solid;position: relative; ">
	    	<a href="javascript:setModule('imgPic2')">
				<img id="imgPic2" width="110" height="110" class="img"
					src="${ctx}/views/cap/isc/theme/img/new_contact.png">
			</a>
	    </div>
		<div class="div_td" style="border-right:1px #ddd solid;position: relative;">
	    	<a href="javascript:setModule('imgPic3')">
				<img id="imgPic3" width="110" height="110" class="img"
					src="${ctx}/views/cap/isc/theme/img/new_contact.png">
			</a>
	    </div>
		<div class="div_td" style="position: relative;">
	    	<a href="javascript:setModule('imgPic4')">
				<img id="imgPic4" width="110" height="110" class="img"
					src="${ctx}/views/cap/isc/theme/img/new_contact.png">
			</a>
	    </div> 
	</div>
	
	<!-- 主题设置dialog  -->
	<div id="moduleDialog" class="easyui-dialog" closed="true" title="选择模块" data-options="modal:true" style="width:400px;height:320px;padding:10px"  buttons="#module-buttons">
		<div class="easyui-layout" style="width: 370px; height: 250px;"> 
			<div data-options="region:'west',split:true,collapsible:false" style="width: 350px;">
				<!-- 单位树 -->
				<ul class="easyui-tree" id="menu_tree" style="margin-left:10px"></ul>
			</div>
			
			<div data-options="region:'center'">
		
			</div>
		</div>
	</div>
	<!-- 分配角色dialog END -->
</body>
</html>