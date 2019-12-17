package com.yonyou.aco.mobile.retrieval.service;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

/**
 * 
 * ClassName: IMobileRetrievalService
 * 
 * @Description: 移动端-全文检索Service
 * @author hegd
 * @date 2016年10月11日
 */
public interface IMobileRetrievalService {

	/**
	 * 移动端-通过类型和用户ID获取检索内容
	 * 
	 * @param userId
	 *            用户ID
	 * @param searchValue
	 *            检索关键字
	 * @param searchType
	 *            检索类型 1:通知公告 2：手发文 3：通讯录用户  其他：全部模糊匹配
	 * @param pageNum
	 *            检索分页
	 * @return
	 * @throws JSONException
	 */
	public String getDataCount(String userId, String searchValue,
			String searchType, int pageNum,int perPageNum,HttpServletRequest request) throws JSONException;

}
