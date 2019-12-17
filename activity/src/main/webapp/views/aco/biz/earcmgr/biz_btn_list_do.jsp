<%@ page contentType="text/html;charset=UTF-8"%>
<!-- table工具栏 -->
<div class="btn-div btn-group">
	<button id="btn_dobiz" type="button" class="btn btn-default btn-sm">
		<span id="doBizBtnName" class="fa fa-plus" aria-hidden="true">登记</span>
	</button>
	<button id="btn_delete" type="button" class="btn btn-default btn-sm">
		<span class="fa fa-remove" aria-hidden="true">删除</span>
	</button>
</div>
<script type="text/javascript">
$(function() {
	//拟稿
	$("#btn_dobiz").click(function() {
		var operateUrl = "${ctx}/bizRunController/getBizOperate?solId="+"${solId}"+"&operateUrl="+"${operateUrl}";
		if(operateUrl!=null) {
			var btnName = $("#doBizBtnName").text();
			date = new Date().getTime();
			var options = {
				"text" : btnName,
				"id" : date,
				"href" : operateUrl,
				"pid" : window,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":false
			};
			window.parent.parent.createTab(options);
		}
	});
	//删除按钮事件
	$("#btn_delete").click(function() {
		var selectRow = $("#earcTable").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return;
		}
		var bizIds = [];
		var state = '';
		var flag = true;
		$(selectRow).each(function(index) {
			state = selectRow[index].EARC_STATE;
			if(state == '0'){
				bizIds[index] = selectRow[index].ID_;
			}else {
				flag = false;
			}
		});
		if(flag){
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
				// 按钮
				}, function(index) {
					$.ajax({
						url : 'bpmRuBizInfoController/doDeleteBpmRuBizInfoEntitysByBizIds',
						dataType : 'text',
						data : {
							'bizIds' : bizIds
						},
						success : function(data) {
							if (data == 'Y') {
								layerAlert("删除成功！");
								$("#earcTable").bootstrapTable('refresh');
							} else {
								layerAlert("删除失败！");
							}
						}
					});
					layer.close(index);
				}, function() {
					return;
			});
		}else{
			layerAlert("只能删除未归档的记录！");
		}
	});
});
</script>