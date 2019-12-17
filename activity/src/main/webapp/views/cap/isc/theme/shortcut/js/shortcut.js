var arr = [];
function getSelectData(modId,modName,modIcon,modUrl){
	var checked = $("#"+modId).find("span").eq(1).attr("class");
	
	var str = {};
	str.modId = modId;
	str.modName = modName;
	str.modIcon = modIcon;
	str.modUrl = modUrl;
	str.checked = checked;
	arr.push(str);
}

function saveSelectMod(){
	window.parent.addModule(pageNum,total,arr);
	arr = [];
}