$(document).ready(function() {
	$.ajax({
		type : "POST",
		url : "bootstrapTreeController/bootstraptree",
		async : true,
		dataType : "json",
		success : function(data) {
			$(data.treeData).each(function(i){
				var obj = data.treeData[i];
				obj.state = {
					expanded : obj.attributes
				}
			})
			
			var $tree = $('#treeview12').treeview({
				color : "#666666",
				text : '16px',
				icon : 'fa fa-group',
		        expandIcon : 'fa fa-angle-right',
				collapseIcon : 'fa fa-angle-down',
				nodeIcon : 'iconfont icon-bookmark',
				levels : 1,
				enableLinks : true,
				data : data.treeData
			});
			if (data.userTheme == 'float') {
				bindFloatDivHandler(data.treeData);
			}
		}
	});

});

function bindFloatDivHandler(data) {
	$('#treeview12').find(".list-group-item").each(function(i, e) {
		var $target = $(e);
		$target.mouseenter(function() {
			refresh();
			$(this).css({
				'background-color' : '#fff',
				'border' : 'none',
				'border-left-style' : 'solid',
				'border-left-width' : '5px',
				'border-left-color' : '#d33237'
			});
			$(this).find('.node-icon').css('color', '#d33237');
			$(this).find('a').css('color', '#d33237');
			if ($(this).find(".fa-angle-right")) {
				$(this).find(".fa-angle-right").hide();
			}
			createfloatDiv($target, data);
		}).mouseleave(function() {
			if ($(this).find('.fa-angle-right').length <= 0) {
				$(this).css({
					'background-color' : '',
					'border' : 'none'
				});
				$(this).find('.node-icon').css('color', '#c6dedb');
				$(this).find('a').css('color', '#c6dedb');
			}
		}).click(function(e) {
			e.stopPropagation();
			if ($(this).find('.fa-angle-right').length <= 0) {
				$('.float-content').hide();
				return;
			}
			if (!$('.float-content').is(":hidden")) {
				$('.float-content').hide();
			} else {
				$('.float-content').show();
			}
		});
		$(document).click(function() {
			refresh();
		}).keyup(function() {
			refresh();
		});
	});

}

function createfloatDiv($target, data) {
	if ($target.find('.fa-angle-right').length <= 0) {
		$('.float-content').hide();
		return;
	}
	if ($('.float-content').length <= 0) {
		$('.sidebar').after('<div class="float-content"></div>');
		$('.float-content').click(function(e) {
			e.stopPropagation();
		}).keyup(function(e) {
			e.stopPropagation();
		});
	}
	var top = ($target.offset().top
			- +getNumber($target.css("border-top-width") || 1) - 1)
			+ 'px';
	/*
	 * var left= ($target.offset().left + $target.width() +
	 * getNumber($target.css("margin-left")) +
	 * getNumber($target.css("margin-right")) +
	 * getNumber($target.css("padding-left")) +
	 * getNumber($target.css("padding-right")) +
	 * getNumber($target.css("border-left-width")||1) +
	 * getNumber($target.css("border-right-width")||1)) + 'px';
	 */

	var left = null;
	var Mwidth = $(".sidebar").width();
	if (Mwidth == '240') {
		left = '240px';
	} else {
		left = '45px';
	}
	$('.float-content').css({
		"position" : "absolute",
		"top" : top,
		"left" : left
	});
	$('.float-content').show();
	var html = '<input type="hidden" value="'
			+ $.trim($target.find("a").html()) + '"/>', item = '';
	var height = 38 + 22;
	for (var i = 0; i < data.length; i++) {
		var icon_default = 'icon-gaqb';
		if ($.trim($target.find("a").html()) == $.trim(data[i].text)) {
			var c1 = 0;
			var nodes2 = data[i].nodes;
			var temp = '<div class="menu-item2" >' +
			// ' <span class="menu-item2-text">' + data[i].text + '</span><br>'
			// +
			'	<span class="menu-item2-content">';
			for (var j = 0; j < nodes2.length; j++) {
				var node2 = nodes2[j];
				if (node2.nodes) {
				} else {
					c1++;
					item += ('		<span class="menu-item3" onclick="createTabFromNode(\''
							+ node2.text
							+ '\',\''
							+ node2.id
							+ '\',\''
							+ node2.href
							+ '\',\''
							+ ($.trim(node2.icon).length == 0 ? icon_default
									: node2.icon)
							+ '\')"><i class="icon node-icon '
							+ ($.trim(node2.icon).length == 0 ? icon_default
									: node2.icon) + '"></i><br>' + node2.text + '</span>');
				}
			}
			item += '	</span>' + '</div>';
			if (c1 > 0) {
				html += (temp + item);
				height = 90 * (c1 + 3) / 4;
			}
		}
		item = '';
		if ($.trim($target.find("a").html()) == $.trim(data[i].text)) {
			var nodes2 = data[i].nodes;
			var temph = 0, c3 = 0;
			for (var j = 0; j < nodes2.length; j++) {
				var node2 = nodes2[j];
				if (node2.nodes) {
					item += '<div class="menu-item2" >'
							+ '	<span class="menu-item2-text">' + node2.text
							+ '</span><br>'
							+ '	<span class="menu-item2-content">';
					var nodes3 = node2.nodes;
					var c2 = 0;
					for (var k = 0; k < nodes3.length; k++) {
						var node3 = nodes3[k];
						c2++;
						item += '		<span class="menu-item3" onclick="createTabFromNode(\''
								+ node3.text
								+ '\',\''
								+ node3.id
								+ '\',\''
								+ node3.href
								+ '\',\''
								+ ($.trim(node3.icon).length == 0 ? icon_default
										: node3.icon)
								+ '\')"><i class="icon node-icon '
								+ ($.trim(node3.icon).length == 0 ? icon_default
										: node3.icon)
								+ '"></i><br>'
								+ node3.text + '</span>';
					}
					temph += 90 * (c2 + 3) / 4;
					c3++;
				}
				item += '	</span>' + '</div>';
			}
			if (c3 > 0) {
				html += item;
				height += temph;
			}
		}
	}
	$('.float-content').html(html).css('height', height + 'px').mouseleave(
			function() {
				$(this).hide();
				refresh();
			}).find('.menu-item3').each(
			function() {
				$(this).mouseenter(
						function() {
							$(this).addClass('menu-item3-color').find('i').css(
									'color', '#d33238');
						}).mouseleave(
						function() {
							$(this).removeClass('menu-item3-color').find('i')
									.css('color', '');
						});
			});
}

function refresh() {
	if ($('.float-content').length > 0)
		$('.float-content').hide();
	$('#treeview12').find(".list-group-item").each(
			function() {
				$(this).css({
					'background-color' : '',
					'border' : 'none'
				});
				$(this).find('.node-icon').css('color', '#c6dedb');
				$(this).find('a').css('color', '#c6dedb');
				if ($(this).find(".fa-angle-right")
						&& $(this).find(".fa-angle-right").is(':hidden')) {
					$(this).find(".fa-angle-right").show();
				}
			});
}

function createTabFromNode(text, id, href, icon) {
	var options = {
		"text" : text,
		"id" : id,
		"href" : href,
		"isDelete" : false,
		"isReturn" : false,
		"isRefresh" : false,
		"icon" : icon
	};
	createTab(options);
	refresh();
}

function getNumber(value) {
	return parseInt(value.replace(/[^0-9]/ig, "")) || 0;
}

$(function() {
	$("#sidebar-menu").hover(function() {
		// 鼠标经过的操作
		$('#sidebar-menu').css('overflow-y', 'auto');
	}, function() {
		// 鼠标离开的操作
		$('#sidebar-menu').css('overflow-y', 'hidden');
	});
});