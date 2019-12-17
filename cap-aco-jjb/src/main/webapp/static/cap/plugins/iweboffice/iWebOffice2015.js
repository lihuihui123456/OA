var str = '';
var pathName = window.document.location.pathname;
var projectName = pathName.substring(1,pathName.substr(1).indexOf('/')+1);
var copyright="金格科技iWebOffice2015智能文档中间件[演示版];V5.0S0xGAAEAAAAAAAAAEAAAAGgBAABwAQAALAAAAJO0tDPyRkWjG0ECvwREdD7dkaLgVLm/CUjO2XXbREPUSpqj1x/HuzereBWBwjaJ+2c7vHB7ojJ007BGscZGLdp4OW3E1CrqgnDORgkIaMAF1OrtKbx3UdMd4gKUOoMH/N5KeJ6SUGKUufcSfjh2VRfHXUomgSpRYmcTCjyST+AA8UhPPiY8RHtEQy0fSGsfU7nObsAG/IlU2zMv/xI+3gbdT1/mzC8O1P1NQc8F6f/4oatmsHJPrS/QnX5Ezyd5fJCCSXgNrA4BXhNL2oQkOS9lgYP1Xjxadu90iPJDq229ItsCQSozdKMha1Df1ffIOtYfetuBzUAAM4fmo+MRwpaq+OMMcu3DrjX2/AfY/LnHxudLs4yo5y6RVjb6l0DdMhTLqEoLZdU3r/kGqo6H+7s+DejC2Vtd/DJlUQDTHnEzhZUBTF5OVra0hxZRsE9HgWWoykNNbrS88jdsOWGz5TzEHSiwA+LKpuuUb3ACab7Dj67mQcl1ttDajzpScs3uRQ==";
str += '<object id="WebOffice2015" ';

str += ' width="100%"';
str += ' height="100%"';

if ((window.ActiveXObject!=undefined) || (window.ActiveXObject!=null) ||"ActiveXObject" in window)
{
	str += ' CLASSID="CLSID:D89F482C-5045-4DB5-8C53-D2C9EE71D025"  codebase="/'+projectName+'/static/cap/plugins/iweboffice/iWebOffice2015.cab#version="';
	str += '>';
	str += '<param name="Copyright" value="' + copyright + '">';
}
else
{
	str += ' progid="Kinggrid.iWebOffice"';
	str += ' type="application/iwebplugin"';
	str += ' OnCommand="OnCommand"';
	str += ' OnReady="OnReady"';
	str += ' OnOLECommand="OnOLECommand"';
	str += ' OnExecuteScripted="OnExecuteScripted"';
	str += ' OnQuit="OnQuit"';
	str += ' OnSendStart="OnSendStart"';
	str += ' OnSending="OnSending"';
	str += ' OnSendEnd="OnSendEnd"';
	str += ' OnRecvStart="OnRecvStart"';
	str += ' OnRecving="OnRecving"';
	str += ' OnRecvEnd="OnRecvEnd"';
	str += ' OnRightClickedWhenAnnotate="OnRightClickedWhenAnnotate"';
	str += ' OnFullSizeBefore="OnFullSizeBefore"';
	str += ' OnFullSizeAfter="OnFullSizeAfter"';	
	str += ' Copyright="' + copyright + '"';
	str += '>';
}
str += '</object>';
document.write(str); 