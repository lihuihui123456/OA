package com.yonyou.aco.mobile.retrieval.web;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.mobile.retrieval.service.IMobileRetrievalService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * ClassName: MobileRetrievalControlle
 * 
 * @Description: 移动端-全文检索controller
 * @author hegd
 * @date 2016年10月11日
 */
@Controller
@RequestMapping("/mobileRetrievalControlle")
public class MobileRetrievalControlle {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource
	IMobileRetrievalService mobileRetrievalService;

	@RequestMapping(value = "getDataCount")
	@ResponseBody
	public void getDataCount(HttpServletRequest request,
			HttpServletResponse response) throws JSONException {

		/** json参数 **/
		String paramJson = request.getParameter("json");
		/** 用户名 **/
		String userId = ""; 
		/** 检索关键字 **/
		String searchValue = "";
		/** 检索类型 1：为单独查询人员 2：为单独查询当前登陆人相关联文件 3：为模糊查询全部 **/
		String searchType = "";

		int page = 1;
		int perPageNum = 10;
		/** 返回json **/
		JSONObject json = new JSONObject();
		String res = "";
		if (paramJson != null && !"".equals(paramJson)) {

			JSONObject jsonObject = new JSONObject(paramJson);
			if (jsonObject.has("userId")) {
				userId = jsonObject.getString("userId");
			}
			if (jsonObject.has("searchValue")) {
				searchValue = jsonObject.getString("searchValue");
			}
			if (jsonObject.has("searchType")) {
				searchType = jsonObject.getString("searchType");
			}
			if (jsonObject.has("page")) {
				page = jsonObject.getInt("page");
			}
			if (jsonObject.has("perPageNum")) {
				perPageNum = jsonObject.getInt("perPageNum");
			}
			if (StringUtils.isNotEmpty(userId)
					&& StringUtils.isNotEmpty(searchValue)
					&& StringUtils.isNotEmpty(searchType)) {
/*				try {
					searchValue = new String(
							searchValue.getBytes("ISO-8859-1"), "GBK");

				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				}
*/				res = mobileRetrievalService.getDataCount(userId, searchValue,
						searchType,page,perPageNum,request);

			} else {
				json.put("errorMessage", "参数存在空值,userId:" + userId
						+ "searchValue:" + searchValue + "searchType:"
						+ searchType);
				json.put("errorCode", "2");
			}
		} else {
			json.put("errorMessage", "参数为空!");
			json.put("errorCode", "1");
		}
		try {
			res.getBytes("utf-8");
			response.setContentType("text/xml;charset=utf-8");
			response.getWriter().print(res);
			response.getWriter().flush();
		} catch (IOException e) {
			logger.error("error",e);
		}
	}

}
