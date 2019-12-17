$(document).ready(function(){
	
	 $.ajax({
			type : "POST",
			url : "bootstrapTreeController/bootstraptree",
			async: true,
			dataType : "json",
			success : function(data) {
				 var $tree = $('#treeview12').treeview({
					  color: "#666666",
					  text:'16px',
					  icon:'fa fa-group',
			          expandIcon:'fa fa-angle-right',
			          collapseIcon:'fa fa-angle-down',
			          nodeIcon: 'iconfont icon-bookmark',
			          levels:1,
			          enableLinks: true,          
			          data: data.treeData
			       }); 
			}
		});
	
});

function refresh(){
	if($('.float-content').length>0)
		$('.float-content').hide();
	$('#treeview12').find(".list-group-item").each(function(){
		$(this).css({
			'background-color':'',
			'border':'none'
		});
		$(this).find('.node-icon').css('color', '#c6dedb');
		$(this).find('a').css('color', '#c6dedb');
		if($(this).find(".fa-angle-right") 
				&& $(this).find(".fa-angle-right").is(':hidden')){
			$(this).find(".fa-angle-right").show();
		}
	});
}

$(function(){
	 $("#sidebar-menu").hover(function(){
	    //鼠标经过的操作
		 $('#sidebar-menu').css('overflow-y','auto');
	 },
	function(){
	   //鼠标离开的操作
		 $('#sidebar-menu').css('overflow-y','hidden');
	 });
});