<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="cn">
<head>
    <meta charset="utf-8" />
    <title></title>
    <link href="${ctx}/views/aco/pdf/res/css/style.css" rel="stylesheet" />
    <script src="${ctx}/views/aco/pdf/res/js/jq.js"></script>
    <script src="${ctx}/views/aco/pdf/res/js/core.js"></script>

	<script type="text/javascript">
    	var ctx = '${ctx}';
    	var httpUrl = "<%=basePath %>/iWebPdf/upfile";
    </script>
</head>
<body onbeforeunload="CaptureOcx.CloseCamera();">
    <div class="main">
		<OBJECT id="CaptureOcx" classid="clsid:DC8400AB-E293-41AD-99CE-57ED1808C2FC" >
		</OBJECT>
		<form name="Reso" >
        <table>
            <tr>
                <td>
                    <input id="opendevices" type="button" value="打开设备" onclick="StartVideo()"/></td>
                <td rowspan="2">
                    <input id="snap" onclick="Capture_IMG()" type="button" value="拍摄" style="height: 70px; font-size: 35px" /></td>
            </tr>
            <tr>
                <td>
                    <input id="closedevices" onclick="closecamera()" type="button" value="关闭设备" /></td>
            </tr>
            <tr>
                <td>
                    <input class="rotate" onclick="LeftRotate_IMG()" type="button" value="左转90°" /></td>
                <td>
                    <input class="rotate" onclick="RightRotate_IMG()" type="button" value="右转90°" /></td>
            </tr>
            <tr>
                <td>
                    <select name="Resolution" id="Resolution" onchange="SetResolution()" style="width:135px;height:30px;padding:3px 0;border-radius:5px;border: 1px solid #999999;line-height: 30px;">
						<option value="0">开启视频后获取分辨率</option>
						<option value="1"></option>
						<option value="2"></option>
						<option value="3"></option>
						<option value="4"></option>
						<option value="5"></option>
						<option value="6"></option>
						<option value="7"></option>
						<option value="8"></option>
						<option value="9"></option>
					</select> 
                <td>
                   <input type="button" onclick="switchCamera()" value="切换摄像头" id="btnToggleDevice" /></td>
            </tr>
            <tr>
                <td>
                    <fieldset>
                        <legend>矫正类型</legend>
                        <label>
                            <input value="0" name="crop" type="radio"/>从不矫正</label>
                        <label>
                            <input value="1" name="crop" type="radio" checked="checked"/>智能矫正</label>
                        <label>
                            <input value="2" name="crop" type="radio" />手动裁切</label>
                    </fieldset>
                </td>
                <td>
                    <fieldset>
                        <legend>拍摄类型</legend>
                        <label>
                            <input value="0" name="color" type="radio" checked="checked" />彩色</label>
                        <label>
                            <input value="1" name="color" type="radio" />灰度</label>
                        <label>
                            <input value="2" name="color" type="radio" />黑白</label>
                    </fieldset>
                </td>
            </tr>
            <%-- <tr>
                <td colspan="2" class="exp">曝光度
                    <input class="setExposure" type="button" value="<" />
                    <input type="text" readonly="" value="-3" maxlength="1" class="Exposure" />
                    <input id="Button2" type="button" value=">" class="setExposure" />
                    <label>
                        <input id="autoExposure" type="checkbox" />自动</label></td>
            </tr>
            <tr>
                <td colspan="2" class="qua">压缩比例
                    <input class="setQuality" type="button" value="<" />
                    <input type="text" readonly="" value="80" maxlength="2" class="Quality" />
                    <input type="button" value=">" class="setQuality" /></td>
            </tr> --%>
            <!-- <tr>
                <td colspan="2" class="savetype">
                    <fieldset>
                        <legend>保存类型</legend>
                        <label>
                            <input value="jpeg" type="radio" name="imageFormat" checked="checked" />*.Jpeg</label>
                        <label>
                            <input value="bmp" type="radio" name="imageFormat" />*.Bmp</label>
                        <label>
                            <input value="png" type="radio" name="imageFormat" />*.Png</label>
                        <label>
                            <input value="tiff" type="radio" name="imageFormat" />*.Tiff</label>
                    </fieldset>
                </td>
            </tr> -->
            <!-- <tr>
                <td>
                    <input type="button" value="刷新设备" id="refresh" onclick="CaptureOcx.RefreshCamera()"/></td>
                <td>
                    <input type="button" value="条码识别" id="barcode" onclick="captureandqrcode()"/></td>
            </tr> -->
            <tr>
                <td>
                    <input type="button" value="刷新设备" id="refresh" onclick="CaptureOcx.RefreshCamera()"/></td>
           		<td>
                    <input type="button" value="视频属性" id="DevicesProperty" onclick="showSetting()"/></td>
            </tr>
             <tr>
                <td>
                    <input type="button" onclick="SeriesCapture_IMG()" value="自动拍摄" /></td>
           		<td>
                    <input type="button" onclick="saveAsPdf()" value="生成PDF文件" id="CreatePdf" /></td>
            </tr>
           <tr>
                <td>
                    <fieldset style="width:135px;height:100px;">
                    	<img id="0" onclick="javascript:window.open(this.src,'查看图片',' toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no')" style="width:135px;height:100px;">
                    </fieldset>
				</td>
				<td>
                    <fieldset style="width:135px;height:100px;">
                     	<img id="1" onclick="javascript:window.open(this.src,'查看图片',' toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no')" style="width:135px;height:100px;">
                    </fieldset>
				</td>
            </tr>
            <tr>
                <td>
                    <fieldset style="width:135px;height:100px;">
                    	<img id="2" onclick="javascript:window.open(this.src,'查看图片',' toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no')" style="width:135px;height:100px;">
                    </fieldset>
				</td>
				<td>
                    <fieldset style="width:135px;height:100px;">
                   		<img id="3" onclick="javascript:window.open(this.src,'查看图片',' toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no, status=no')" style="width:135px;height:100px;">
                    </fieldset>
				</td>
            </tr>
        </table>
        </form>
    </div>
</body>
</html>
