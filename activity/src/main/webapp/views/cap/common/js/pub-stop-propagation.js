/**
 * add by hegd
 * 阻止事件冒泡
 * 2017年3月28日14:13:41
 */
var stopPropagation = function(event){
    event = event || window.event ;
    if(event.stopPropagation){
        event.stopPropagation();
     }else{
          event.cancelBubble = true;
     }
}

/**
 * add by hegd
 * 刷新表格
 * @param Id: 表格Id
 * @param url:表格数据URL
 * 2017年3月31日11:09:40
 */
function refreshTable(Id,url){
	var opt = {
			url : url,
			silent : true,
			query:{    
				type:1,
				level:2   
			} 
		};
	$("#"+Id).bootstrapTable('refresh', opt);
}

/**
 * 设置列表中有排序字段的居中方法
 * @param value
 * @param row
 * @param index
 * @param field
 * @returns {___anonymous622_654}
 */
function cellStyle(value, row, index, field) {
  return {css: {"padding-right": "30px;"}};
}