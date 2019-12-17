var fildId;
var phrasebookDiv = $('#phrasebook_div');
function openPhrasebookDiv(spaceId, event) {
	if ($('#phrasebook_iframe').attr("src") == "") {
		$('#phrasebook_iframe').attr('src', "bpmPhrasebookController/toPhrasebookTree");
	}
	phrasebookDiv.css({
		"top" : (event.clientY+10) + "px",
		"left" : event.clientX + "px",
		"display" : "block"
	});
	fildId = spaceId;
}

$(function() {
	//鼠标点击事件不在节点上时隐藏右键菜单 
	$("body").bind("mousedown",function(event) {
		if (!(event.target.id == "phrasebook_div" || $(
				event.target).parents("#phrasebook_div").length > 0)) {
			phrasebookDiv.css({
				"display" : "none"
			});
		}
	});
})
function setPhrasebook(phrasebook) {
	$('#' + fildId).val(phrasebook);
	phrasebookDiv.css({"display" : "none"});
}


