<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>全文检索</title>
	<%@ include file="/views/aco/common/head.jsp"%>
	<META http-equiv=content-type content=text/html;charset=UTF-8">
	<link href="${ctx}/views/cap/sys/lucene/css/result.css" rel="stylesheet" type="text/css">
	<link href="${ctx}/views/cap/sys/lucene/css/searchIndex.css" rel="stylesheet" type="text/css">
	<link rel="stylesheet" href="${ctx}/views/cap/sys/lucene/css/jquery-ui.css">
	<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/jquery-ui.js"></script>
	<script type="text/javascript">
		var _indextype = ${indextype};
		
		/**
		 * 当点击回车时执行登录操作
		 * keyCode == 13 为回车监听码
		 */
		document.onkeydown = function(e){ 
	   	    var ev = document.all ? window.event : e;
	   	    if(ev.keyCode==13) {
	   	    	searchData();
	   	    }
	   	}

		$(function() {
			var cache = {};
            $("#input-word").autocomplete(
            {
                source: function(request, response) {
                    var term = request.term;
                    if (term in cache) {
                        data = cache[term];
                        response($.map(data, function(item) {
                            return { label: item.keyWord, value: item.keyWord }
                        }));
                        return { label: "", value: "" };
                    } else {
                        $.ajax({
                            url: "luceneController/autocomplete",
                            dataType: "json",
                            data: {
                                top: 10,
                                key: term
                            },
                            success: function(data) {
                                if (data.length) 
                                    cache[term] = data;
                               	response($.map(data, function(item) {
                                       return { label: item.keyWord, value: item.keyWord }
                                   }));
								return { label: "", value: "" };
                            }
                        });
                    }
                },
                select: function(event, ui) {
                    //提交搜索...
                    if (ui != '') {
                    	$("#input-word").val(ui.item.label);
                    	searchData();
                    }
                },
                minLength: 0,
                matchContains: true,        //只要包含输入字符就会显示提示
                autoFill: true,            //自动填充输入框
                mustMatch: true            //与否必须与自动完成提示匹配
            });
		 });
	</script>
	<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<table height=94 cellSpacing=0 cellPadding=0 width="99%" align=center>
		<tbody>
			<tr vAlign=center>
				<%-- <td vAlign=top noWrap
					style="padding-left: 100px; width: 20%; padding-top: 40px">
					<p>
						<img src="${ctx}/views/cap/sys/lucene/img/rj_f.png" width="135"
							height="38">
					</p>
				</td> --%>
				<td vAlign="top" style="padding-left: 10%; width: 80%;">
					<div class="Tit" style="padding-top: 40px"></div>

					<table style="margin-left: 1px; height: 40px;width:100%;" cellSpacing=0 cellPadding=0>
						<tbody>
							<tr>
								<td valign="top">
									<select id="indextype" style="display:none;" onchange="changeType()" class="form-control select_type">
									</select>
								</td>
								<td width="" vAlign="top" noWrap>
									<!--<input id="searchkey" type="text" name="fieldname" size="42"
											value="${sk}" maxlength="100" /> 
											 <button onclick="searchData()"
											style="cursor:pointer;width: 104px; height: 39px; border: none; background: url(${ctx}/views/cap/sys/lucene/img/m_r.png) left top no-repeat" />
											 -->

									<div class="input-group" style="width:80%;">
										<input type="text" id="input-word" class="form-control search_input" value="${sk}"
											onfocus="if (value =='请输入要搜索的内容'){value=''}else{$('#removeName').show();}" onblur="if (value ==''){value='请输入要搜索的内容'}"
											style="width:100%;height: 36px;"><i class="fa fa-remove" id="removeName" style="display:none" onclick="$('#input-word').val('').focus();"></i>
										<span class="input-group-btn">
											<button type="button" class="btn btn-primary" onclick="searchData()" style="width:100px;margin-left:-4px;height: 36px;">
												<b>全文检索</b>
											</button>
										</span>
									</div>
								</td>
								<!-- <td width="26" align="center" noWrap>&nbsp;&nbsp; <A
									href="advancesearch.jsp"></A>
								</td> -->
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</tbody>
	</table>

	<div class="wrapper">
		<div id="tab_con" style="width:99%">
			<div id="tab_con_1">
				<table class="bi" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
					<tbody>
						<tr>
							<hr />
						</tr>
						<tr>
							<td noWrap align="left" style="text-align:center">
								<span class="style1"> &nbsp; 搜到相关文档&nbsp;${rsize}&nbsp;篇;本页&nbsp;${pagecount}&nbsp;篇&nbsp;&nbsp;</span>
							</td>
						</tr>
					</tbody>
				</table>

				<!--开始处理分 -->
				<br>
				<c:choose><c:when test="${empty requestScope.pageNumBean.pages}">
					<div style="text-align:center;font-size:18px;font-family:microsoft yahei;">很抱歉，没有找到与"<span style="color:red;">${sk}</span>"相关的信息</div>			
				</c:when></c:choose>
				<c:forEach items="${rlist}" var="eachdoc">
					<table cellSpacing="0" cellPadding="0" border="0" style="margin-left: 10%; width:65%;">
						<tbody>
							<tr>
								<td style="width:80%; padding-bottom: 10px;padding-left:2px;">
									
									<a href="javascript:void(0);" onclick="openWinnew('${eachdoc.id}','${eachdoc.path}')"
										class="title_a" style="line-height: 150%">${eachdoc.filename}</a>
									<span class="f13" style="text-align: left;display:block;  ">${eachdoc.contents}</span>
									<c:choose>
										<c:when test="${not empty eachdoc.contentName}">
											<span style="font-style: italic;color: #c1c1c1;display:block;">附件</span>
											<span class="f13" style="text-align: left;display:block;">${eachdoc.contentName}
											</span>
										</c:when>
										<c:when test="${empty eachdoc.contentName && not empty eachdoc.text}">
											<span style="font-style: italic;color: #c1c1c1;display:block;">附件内容</span>
											<span class="f13" style="text-align: left;display:block;">${eachdoc.text}
											</span>
										</c:when>
									</c:choose>
									
										<span class="style1" style="text-align: left;"><c:if test="${eachdoc.lastModify != '1'}">${eachdoc.lastModify}</c:if>
											<c:if test="${not empty eachdoc.type }">&nbsp;&nbsp;${eachdoc.type}</c:if>
										</span>
								</td>
							</tr>
						</tbody>
					</table>
				</c:forEach>
				<div class="page_number">
				<c:choose><c:when test="${not empty requestScope.pageNumBean.pages}">
					<span style="text-align: center;    margin-left: 10%;"> 
						<c:choose>
							<c:when test="${not empty requestScope.pageNumBean.upPageNum}">
								<a href="${pageUrl}${requestScope.pageNumBean.upPageNum}" class="up_down">
									<!-- <img src="${ctx}/views/cap/sys/lucene/img/sy_yd.png" width="85" height="34" style="border: 0"> -->
									< 上一页
								</a>
							</c:when>
							<c:otherwise>
								<%-- <img src="${ctx}/views/cap/sys/lucene/img/sy_y.png" width="85" height="34" style="border: 0"> --%>
							</c:otherwise>
						</c:choose>
						<c:forEach items="${requestScope.pageNumBean.pages}" var="item">
							<c:choose>
								<c:when test="${item == requestScope.pageNumBean.currentNum}">
									<a href="${pageUrl}${item}" class="selected">
										${item}
									</a>
								</c:when>
								<c:otherwise>
									<a href="${pageUrl}${item}" class="normal">
										${item}
									</a>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<c:choose>
							<c:when test="${not empty requestScope.pageNumBean.downPageNum}">
								<a href="${pageUrl}${requestScope.pageNumBean.downPageNum} " class="up_down">
									<!-- <img src="${ctx}/views/cap/sys/lucene/img/x_y.png" width="85" height="34" style="border: 0"> -->
									下一页 >
								</a>
							</c:when>
							<c:otherwise>
			    				<%-- <img src="${ctx}/views/cap/sys/lucene/img/x_yd.png" width="85" height="34"> --%>
							</c:otherwise>
						</c:choose>
					</span>
					</c:when></c:choose>
				</div>
			</div>
		</div>
	</div>
</body>
</html>

<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/searchIndex.js"></script>