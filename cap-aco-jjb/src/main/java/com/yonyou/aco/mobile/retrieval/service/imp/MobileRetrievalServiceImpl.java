package com.yonyou.aco.mobile.retrieval.service.imp;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import com.yonyou.aco.contacts.dao.IBizContactsDao;
import com.yonyou.aco.contacts.entity.BizContactsUserBean;
import com.yonyou.aco.mobile.retrieval.service.IMobileRetrievalService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.sys.lucene.entity.DocumentEntity;
import com.yonyou.cap.sys.lucene.service.ILuceneService;

@Service("mobileRetrievalService")
public class MobileRetrievalServiceImpl implements IMobileRetrievalService {

	@Resource
	IBizContactsDao iBizContactsDao;

	@Resource
	ILuceneService luceneService;

	@SuppressWarnings("unchecked")
	@Override
	public String getDataCount(String userId, String searchValue,
			String searchType, int pageNum, int perPageNum,HttpServletRequest request)
			throws JSONException {
		JSONObject json = new JSONObject();
		JSONObject contactsJson = new JSONObject();
		JSONObject taskJson = new JSONObject();
		JSONObject noticeJson = new JSONObject();
		JSONArray res;
		if ("1".equals(searchType)) {
			/** 通知公告检索包括附件 */
			Map<String, Object> noticeMap = luceneService.mobileSearchIndex(
					searchValue, "", pageNum, "1", perPageNum,request);
			int noticeCount = (int) noticeMap.get("count");
			List<DocumentEntity> noticeList = (List<DocumentEntity>) noticeMap
					.get("result");
			if (noticeList != null && !noticeList.isEmpty()) {
				res = listToString(noticeList);
				noticeJson.put("exist", true);
				noticeJson.put("items", res);
				noticeJson.put("totalNums", String.valueOf(noticeCount));
				json.put("errorMessage", "查询成功");
				json.put("errorCode", "0");
				json.put("allNotices", noticeJson);
				return json.toString();
			} else {
				noticeJson.put("exist", false);
				noticeJson.put("items", "");
				noticeJson.put("totalNums", "");
				json.put("errorMessage", "未找到相关信息");
				json.put("errorCode", "0");
				json.put("allNotices", noticeJson);
			}

		} else if ("2".equals(searchType)) {
			/** 收发文检索包括正文附件 */
			Map<String, Object> taskMap = luceneService.mobileSearchIndex(
					searchValue, "", pageNum, "2", perPageNum,request);
			List<DocumentEntity> list = (List<DocumentEntity>) taskMap
					.get("result");
			int taskCount = (int) taskMap.get("count");
			if (list.size() > 1) {
				res = listToString(list);
				taskJson.put("exist", true);
				taskJson.put("items", res);
				taskJson.put("totalNums", String.valueOf(taskCount));
				json.put("errorMessage", "查询成功");
				json.put("errorCode", "0");
				json.put("allMatters", taskJson);
				return json.toString();
			} else {
				taskJson.put("exist", false);
				taskJson.put("items", "");
				taskJson.put("totalNums", "");
				json.put("errorMessage", "未找到相关信息");
				json.put("errorCode", "0");
				json.put("contacts", taskJson);
			}

		} else if ("3".equals(searchType)) {
			/** 通讯录用户检索 */
			PageResult<BizContactsUserBean> page = iBizContactsDao
					.findAllUserBySearchValue(searchValue, userId, pageNum,
							perPageNum);
			List<BizContactsUserBean> contactsList = page.getResults();
			if (contactsList!=null) {
				JSONArray resArr = ContactsListToString(contactsList);
				contactsJson.put("exist", true);
				contactsJson.put("items", resArr);
				contactsJson.put("totalNums", page.getTotalrecord());
				json.put("errorMessage", "查询成功");
				json.put("errorCode", "0");
				json.put("contacts", contactsJson);
			} else {
				contactsJson.put("exist", false);
				contactsJson.put("items", "");
				contactsJson.put("totalNums", "");
				json.put("errorMessage", "未找到相关信息");
				json.put("errorCode", "0");
				json.put("contacts", contactsJson);
			}
			return json.toString();
		} else {
			/** 人员 */
			PageResult<BizContactsUserBean> page = iBizContactsDao
					.findAllUserBySearchValue(searchValue, userId, pageNum,
							perPageNum);
			List<BizContactsUserBean> contactsList = page.getResults();
			/** 收发文检索包括正文附件 */
			Map<String, Object> taskMap = luceneService.mobileSearchIndex(
					searchValue, "", pageNum, "2", perPageNum,request);
			List<DocumentEntity> list = (List<DocumentEntity>) taskMap
					.get("result");
			int taskCount = (int) taskMap.get("count");
			/** 通知公告检索包括附件 */
			Map<String, Object> noticeMap = luceneService.mobileSearchIndex(
					searchValue, "", pageNum, "1", perPageNum,request);
			int noticeCount = (int) noticeMap.get("count");
			List<DocumentEntity> noticeList = (List<DocumentEntity>) noticeMap
					.get("result");
			if (contactsList != null || list != null || noticeList != null) {
				json.put("errorMessage", "查询成功");
				json.put("errorCode", "0");
				/** 通讯录Array **/
				JSONArray contactsArr = null;
				/** 收发文Array **/
				JSONArray taskArr = null;
				/** 通知通告Array **/
				JSONArray noticeArr = null;
				if (!contactsList.isEmpty()) {
					contactsArr = ContactsListToString(contactsList);
					contactsJson.put("exist", true);
					contactsJson.put("items", contactsArr);
					contactsJson.put("totalNums", page.getTotalrecord());
					json.put("contacts", contactsJson);
				} else {
					contactsJson.put("exist", false);
					contactsJson.put("items", contactsArr);
					contactsJson.put("totalNums", "");
					json.put("contacts", contactsJson);
				}
				if (!list.isEmpty()) {
					taskArr = listToString(list);
					taskJson.put("exist", true);
					taskJson.put("items", taskArr);
					taskJson.put("totalNums", String.valueOf(taskCount));
					json.put("allMatters", taskJson);
				} else {
					taskJson.put("exist", false);
					taskJson.put("items", taskArr);
					taskJson.put("totalNums", "");
					json.put("allMatters", taskJson);
				}
				if (!noticeList.isEmpty()) {
					noticeArr = listToString(noticeList);
					noticeJson.put("exist", true);
					noticeJson.put("items", noticeArr);
					noticeJson.put("totalNums", String.valueOf(noticeCount));
					json.put("allNotices", noticeJson);
				} else {
					noticeJson.put("exist", false);
					noticeJson.put("items", noticeArr);
					noticeJson.put("totalNums", "");
					json.put("allNotices", noticeJson);
				}
			} else {
				json.put("errorMessage", "查询失败");
				json.put("errorCode", "1");
			}
		}
		return json.toString();
	}

	/**
	 * 
	 * @Description: list转String
	 * @param @param list
	 * @param @return
	 * @return String
	 * @throws
	 * @author hegd
	 * @date 2016年10月11日
	 */
	public JSONArray ContactsListToString(List<BizContactsUserBean> list) {
		String picUrl = "/cap-aco/uploader/uploadfile?pic=";
		List<Object> listArr = new ArrayList<Object>();
		for (int i = 0; i < list.size(); i++) {
				Map<String, String> map = new HashMap<String, String>();
				map.put("id", list.get(i).getUserId());
				map.put("departmentName", list.get(i).getDeptName());
				map.put("company", list.get(i).getOrgName());
				map.put("userCode", list.get(i).getUserCode());
				map.put("phone", list.get(i).getUserMobile());
				map.put("tel", list.get(i).getTel());
				map.put("email", list.get(i).getUserEmail());
				map.put("imgUrl", picUrl+list.get(i).getPicUrl());
				map.put("userName", list.get(i).getUserName());
				listArr.add(map);
		}
		return JSONArray.fromObject(listArr);
	}

	/**
	 * 
	 * @Description: list转String
	 * @param @param list
	 * @param @return
	 * @return String
	 * @throws
	 * @author hegd
	 * @date 2016年10月11日
	 */
	public JSONArray listToString(List<DocumentEntity> list) {
		List<Object> reslist = new ArrayList<Object>();
		for (int i = 0; i < list.size(); i++) {
			Map<String, String> taskMap = new HashMap<String, String>();
			
			/**
			 * 通知公告没有taskId
			 */
			taskMap.put("taskId", list.get(i).getBuskey());
			/**
			 * 主键ID
			 */
			taskMap.put("bizid", list.get(i).getId());
			/**
			 * 正文内容
			 */
			taskMap.put("contents", list.get(i).getContents());
			/**
			 * 文件标题
			 */
			taskMap.put("title", list.get(i).getFilename());
			/**
			 * 最后编辑时间
			 */
			taskMap.put("last_modify", list.get(i).getLastModify());
			/**
			 * 手发文文件类型
			 */
			taskMap.put("biz_type", list.get(i).getTable());
			/**
			 * 附件内容
			 */
			taskMap.put("text", list.get(i).getText());
			reslist.add(taskMap);
		}
		return JSONArray.fromObject(reslist);
	}

}
