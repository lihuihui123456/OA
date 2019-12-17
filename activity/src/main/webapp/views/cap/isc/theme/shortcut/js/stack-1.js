$(function () { 
	// Stack initialize
	var openspeed = 300;
	var closespeed = 300;
	$('.stack>img').toggle(function(){
		var vertical = 0;
		var horizontal = 0;
		var $el=$(this);
		$el.next().children().each(function(){
			$(this).animate({top: '-' + vertical + 'px', left: horizontal + 'px'}, openspeed);
			vertical = vertical + 55;
			//horizontal = (horizontal+.75)*2;
		});
		$el.next().animate({top: '-40px', left: '18px'}, openspeed).addClass('openStack')
		   .find('li a>i').animate({width: '50px', marginLeft: '9px'}, openspeed);
		$el.animate({paddingTop: '0'});
	}, function(){
		//reverse above
		var $el=$(this);
		$el.next().removeClass('openStack').children('li').animate({top: '55px', left: '-2px'}, closespeed);
		$el.next().find('li a>i').animate({width: '79px', marginLeft: '0'}, closespeed);
		$el.animate({paddingTop: '15px'});
	});
	
	// Stacks additional animation
	$('.stack li a').hover(function(){
		$("i",this).animate({"font-size": '56px'}, 100);
		$("span",this).animate({marginRight: '30px'});
	},function(){
		$("i",this).animate({"font-size": '50px'}, 100);
		$("span",this).animate({marginRight: '0'});
	});
});