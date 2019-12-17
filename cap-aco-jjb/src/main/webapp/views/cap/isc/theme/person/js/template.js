var template = (function(){
	var init = function(){
		var ul =  $(".template_menu > ul");
	    ul.hide();
	    ul.eq(0).show();
	    $(".template_menu > h5").click(function(){
            $('.icon').attr('class', 'icon fa fa-angle-right');
            $('.template_menu').find('ul').hide();
            $(this).find('i.icon').attr('class', 'icon fa fa-angle-down');
            $(this).next().show();
        });
	}
	var conW = function(){
		$(".template_con").outerWidth($("body").outerWidth() -'30');
	}
	
	var drop = function(){
		
        $( ".li-img" ).draggable({
            scope : 'img',
            revert:'invalid',
            opacity:0.7,
            helper:'clone',
            connectToSortable :'.template'
        });
        $.each($('.panel'),function(i, n){

            $(n).droppable({
                scope : 'img',
                revertDuration: 200,
                drop  : function(event, ui){
                    ui.draggable.clone().appendTo($(n));
                }, 
                stop  :function(event,ui){
                    ui.draggable.css({
                        position    : 'absolute',
                        left        : ui.offset.left,
                        top         : ui.offset.top  
                    }); 
                }
            });
        });
	}
	return {
		init:function(){
			init();
			conW();
		},
		drop:function(){
			drop();
		}
	}
})();
template.init();
template.drop();