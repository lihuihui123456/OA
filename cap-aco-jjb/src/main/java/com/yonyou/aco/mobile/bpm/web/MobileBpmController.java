package com.yonyou.aco.mobile.bpm.web;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.mobile.bpm.service.IMobileBpmCountService;
import com.yonyou.aco.mobile.bpm.service.IMobileBpmListService;
import com.yonyou.aco.notice.entity.BizNoticeInfoEntity;
import com.yonyou.aco.notice.entity.BizNoticePeopleEntity;
import com.yonyou.aco.notice.service.NoticeService;
import com.yonyou.cap.bpm.entity.BizGwCircularsBean;
import com.yonyou.cap.bpm.entity.BizGwCircularsEntity;
import com.yonyou.cap.bpm.entity.TaskBean;
import com.yonyou.cap.bpm.service.IBpmCirculateService;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.bpm.service.IBpmService;
import com.yonyou.cap.common.util.PageResult;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 
 * ClassName: MobileBpmController
 * 
 * @Description: 移动端-流程业务控制层
 * @author hegd
 * @date 2016-8-23
 */
@Controller
@RequestMapping(value = "/mobileBpmController")
public class MobileBpmController {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource
	IMobileBpmCountService mobileBpmService;

	@Resource
	IMobileBpmListService mobileBpmListService;

	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;

	@Resource
	IBpmCirculateService bpmCirculateService;

	@Resource
	IBpmService bpmService;
	@Resource
	NoticeService noticeService;

	@RequestMapping("/BackLog")
	public void getToDoDocmanagerNum(HttpServletRequest request,
			HttpServletResponse response) throws org.json.JSONException {
		/** json参数 **/
		String paramJson = request.getParameter("json");
		/** 返回结果json **/
		JSONObject json = new JSONObject();
		if (paramJson != null) {
			JSONObject jsonObject = new JSONObject(paramJson);
			/** 用户ID **/
			String userId = "";
			/** 状态位 **/
			String status = "";

			if (jsonObject.has("uid")) {
				userId = jsonObject.getString("uid");
			}
			if (jsonObject.has("status")) {
				status = jsonObject.getString("status");
			}

			/**
			 * 待办 待阅 通知公告 有数量其他都是分页
			 */
			/** 结果信息 **/
			String message = "查询成功";
			/** 结果code **/
			String erroCode = "0";
			/** 数量 **/
			int backLogNum = 0;
			/** 标题 */
			String newMsg = "";
			/** 时间 */
			String newTime = "";
			// 待阅事项
			if ("0".equals(status)) {
				PageResult<BizGwCircularsBean> page = mobileBpmService
						.findMobileReadInfoByUserId(1, Integer.MAX_VALUE,
								userId);
				if (page.getTotalrecord()>0) {
					newMsg = page.getResults().get(0).getBiz_title();
					newTime = page.getResults().get(0).getMobileCreateTime();
					backLogNum = (int) page.getTotalrecord();
				}

			}
			// 通知公告
			if ("1".equals(status)) {
				/*PageResult<BizNoticeInfoEntity> page = mobileBpmService
						.findNoticeInfoByUserId(1, Integer.MAX_VALUE, userId);*/
				//
				PageResult<BizNoticeInfoEntity> page = mobileBpmService
						.findUneadNoticeNoReadInfoByUserId(1, Integer.MAX_VALUE, userId);
				if (page.getTotalrecord()>0) {
					newMsg = page.getResults().get(0).getTitle();
					newTime = page.getResults().get(0).getMobileCreateTime();
					backLogNum = (int) page.getTotalrecord();
				}

			}
			// 即时消息
			if ("2".equals(status)) {
				// 目前没有开发该功能
			}
			// 会议通知
			if ("3".equals(status)) {
				// 目前没有开发该功能
			}
			// 邮件消息
			if ("4".equals(status)) {
				// 目前没有开发该功能
			}
			// 待办事项
			if ("5".equals(status)) {
				PageResult<TaskBean> page = mobileBpmService
						.findtTaskInfoByUserId(1, Integer.MAX_VALUE, userId);
				if (page.getTotalrecord()>0) {
					newMsg = page.getResults().get(0).getBiz_title();
					newTime = page.getResults().get(0).getMobileCreateTime();
					backLogNum = (int) page.getTotalrecord();
				}

			}
			json.put("errorMessage", message);
			json.put("errorCode", erroCode);
			json.put("backLogNum", backLogNum);
			json.put("newMsg", newMsg);
			json.put("newTime", newTime);
		} else {
			json.put("errorMessage", "参数有误，请联系管理员");
			json.put("erroCode", "1");
			json.put("backLogNum", "0");
		}
		try {
			String res = json.toString();
			res.getBytes("utf-8");
			response.setContentType("text/xml;charset=utf-8");
			response.getWriter().print(res);
			response.getWriter().flush();
		} catch (IOException e) {
			logger.error("error",e);
		}
	}

	/**
	 * 
	 * @Description: 移动端-通过类型和用户Id获取待办信息
	 * @param @param request
	 * @param @param response
	 * @param @return
	 * @param @throws JSONException
	 * @return String
	 * @throws
	 * @author hegd
	 * @date 2016年10月12日
	 */
	@RequestMapping("/getTaskListInfor")
	public void getTaskInfor(HttpServletRequest request,
			HttpServletResponse response) throws JSONException {

		/** json参数 **/
		String paramJson = request.getParameter("json");
		/** 返回结果json **/
		JSONObject json = new JSONObject();
		/** 结果信息 **/
		/** 结果code 1：json为空 2：参数存在空值 0：成功 **/
		String erroCode;
		String res;
		if (paramJson != null) {
			JSONObject jsonObject = new JSONObject(paramJson);
			/** 用户ID **/
			String userId = "";
			/** 状态位 **/
			String status = "";
			int page = 0;
			int perPageNum = 0;

			if (jsonObject.has("uid")) {
				userId = jsonObject.getString("uid");
			}
			if (jsonObject.has("status")) {
				status = jsonObject.getString("status");
			}
			if (jsonObject.has("page")) {
				page = jsonObject.getInt("page");
			}
			if (jsonObject.has("perpagenums")) {
				perPageNum = jsonObject.getInt("perpagenums");
			}

			if (StringUtils.isNotEmpty(userId)
					&& StringUtils.isNotEmpty(status)) {
				res = mobileBpmListService.findBpmList(userId, status, page,
						perPageNum);
			} else {
				erroCode = "2";
				json.put("errorMessage", "参数存在空值");
				json.put("erroCode", erroCode);
				res = json.toString();
			}
		} else {
			erroCode = "1";
			json.put("errorMessage", "json为空");
			json.put("erroCode", erroCode);
			res = json.toString();
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

	/**
	 * 移动端-获取待办表单数据
	 * 
	 * @param request
	 * @param response
	 * @throws JSONException
	 */
	@RequestMapping("/findMobileTaskInfoByTaskIdAndBizInfoId")
	public void findMobileTaskInfoByTaskIdAndBizInfoId(
			HttpServletRequest request, HttpServletResponse response)
			throws JSONException {

		/** json参数 **/
		String paramJson = request.getParameter("json");
		/** 返回结果json **/
		JSONObject json = new JSONObject();
		/** 结果信息 **/
		/** 结果code 1：json为空 2：参数存在空值 0：成功 **/
		String erroCode;
		String res;
		if (paramJson != null) {
			JSONObject jsonObject = new JSONObject(paramJson);
			/** 流程任务Id **/
			String taskId = "";
			/** 业务基本信息Id **/
			String bizId = "";
			/** 获取类型1：只取表单数据 2：取附件 **/
			String valueType = "";
			if (jsonObject.has("taskId")) {
				taskId = jsonObject.getString("taskId");
			}
			if (jsonObject.has("bizId")) {
				bizId = jsonObject.getString("bizId");
			}
			if (jsonObject.has("valueType")) {
				valueType = jsonObject.getString("valueType");
			}
			if (StringUtils.isNotEmpty(bizId) && StringUtils.isNotEmpty(taskId)
					&& StringUtils.isNotEmpty(valueType)) {
				/** 收发文表单数据和附件 **/
				res = mobileBpmListService
						.findMobileTaskInfoByTaskIdAndBizInfoId(taskId, bizId,
								"1", valueType);

			} else if (StringUtils.isNotEmpty(bizId)) {
				/** 通知公告表单数据和附件 **/
				res = mobileBpmListService
						.findMobileTaskInfoByTaskIdAndBizInfoId("", bizId, "",
								valueType);
			} else {
				erroCode = "2";
				json.put("errorMessage", "参数存在空值");
				json.put("erroCode", erroCode);
				res = json.toString();
			}
		} else {
			erroCode = "1";
			json.put("errorMessage", "json为空");
			json.put("erroCode", erroCode);
			res = json.toString();
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

	/**
	 * 方法: 人员数据. 说明: 移动端下一节点人员选择数据
	 * 
	 * @param procinstId
	 * @param actId
	 * @return
	 * @throws JSONException
	 */
	@RequestMapping("/findMobileSendUser")
	public void findMobileSendUser(HttpServletRequest request,
			HttpServletResponse response) throws JSONException {

		/** json参数 **/
		String paramJson = request.getParameter("json");
		/** 返回结果json **/
		JSONObject json = new JSONObject();
		/** 结果code 1：json为空 2：参数存在空值 0：成功 **/
		String erroCode;
		String res;
		if (paramJson != null) {
			JSONObject jsonObject = new JSONObject(paramJson);
			/** 流程定义id **/
			String procdefId = "";
			/** 业务基本信息Id **/
			String bizId = "";
			/** 当前节点id **/
			String nodeId = "";
			/** 业务解决方案Id **/
			String solId = "";
			if (jsonObject.has("procdefId")) {
				procdefId = jsonObject.getString("procdefId");
			}
			if (jsonObject.has("bizId")) {
				bizId = jsonObject.getString("bizId");
			}
			if (jsonObject.has("nodeId")) {
				nodeId = jsonObject.getString("nodeId");
			}
			if (jsonObject.has("solId")) {
				solId = jsonObject.getString("solId");
			}
			//bizId = "7ed2f698-8dfb-4f20-809b-99af3c489ddf";
			if (StringUtils.isNotEmpty(bizId) && StringUtils.isNotEmpty(nodeId)
					&& StringUtils.isNotEmpty(procdefId)
					&& StringUtils.isNotEmpty(solId)) {
				res = mobileBpmListService.findMobileSendUser(procdefId,
						nodeId, bizId, solId);
			} else {
				erroCode = "2";
				json.put("errorMessage", "参数存在空值");
				json.put("erroCode", erroCode);
				res = json.toString();
			}
		} else {
			erroCode = "1";
			json.put("errorMessage", "json为空");
			json.put("erroCode", erroCode);
			res = json.toString();
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

	/**
	 * 获取下一环节送交节点
	 * 
	 * @param request
	 * @param response
	 * @throws JSONException
	 */
	@RequestMapping("/findSendTaskNode")
	public void findSendTaskNode(HttpServletRequest request,
			HttpServletResponse response) throws JSONException {

		/** json参数 **/
		String paramJson = request.getParameter("json");
		/** 返回结果json **/
		JSONObject json = new JSONObject();
		/** 结果信息 **/
		/** 结果code 1：json为空 2：参数存在空值 0：成功 **/
		String erroCode = "0";
		String res = "";
		if (paramJson != null) {
			JSONObject jsonObject = new JSONObject(paramJson);
			/** 流程定义id **/
			String procdefId = "";
			/** 当前任务id **/
			String taskId = "";
			/** 流程是否允许自由选择 **/
			String isFreeSelect = "";
			/**业务解决Id **/
			String solId="";
			if (jsonObject.has("procdefId")) {
				procdefId = jsonObject.getString("procdefId");
			}
			if (jsonObject.has("taskId")) {
				taskId = jsonObject.getString("taskId");
			}
			if (jsonObject.has("isFreeSelect")) {
				isFreeSelect = jsonObject.getString("isFreeSelect");
			}
			if (jsonObject.has("solId")) {
				solId = jsonObject.getString("solId");
			}
			
			if (StringUtils.isNotEmpty(isFreeSelect)
					&& StringUtils.isNotEmpty(taskId)
					&& StringUtils.isNotEmpty(procdefId)
			) {
				res = mobileBpmListService.findSendTaskNode(procdefId,
						taskId,isFreeSelect,solId);
			} else {
				erroCode = "2";
				json.put("errorMessage", "参数存在空值");
				json.put("erroCode", erroCode);
				res = json.toString();
			}
		} else {
			erroCode = "1";
			json.put("errorMessage", "json为空");
			json.put("erroCode", erroCode);
			res = json.toString();
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

	/**
	 * 移动端-送交公文
	 * 
	 * @param request
	 * @param response
	 * @param redirectAttributes
	 * @return
	 * @throws JSONException
	 */
	@RequestMapping("/sendTaskInfo")
	@ResponseBody
	public String sendTaskInfo(HttpServletRequest request,
			HttpServletResponse response) throws JSONException {
		/** json参数 **/
		String paramJson = request.getParameter("json");
		/** 基本业务主键 **/
		String bizId = "";
		/** 下一环节办理人 **/
		String userId = "";
		/** 当前任务id **/
		String taskId = "";
		/** 意见字段 **/
		String fieldName = "";
		/** 审批意见 **/
		String comment = "";
		/** 目标节点id **/
		String nodeId = "";
		/** 是否自由选择 1：是 **/
		String isFreeSelect = "";
		if (paramJson != null) {
			JSONObject jsonObject = new JSONObject(paramJson);
			if (jsonObject.has("bizId")) {
				bizId = jsonObject.getString("bizId");
			}
			if (jsonObject.has("userId")) {
				userId = jsonObject.getString("userId");
			}
			if (jsonObject.has("taskId")) {
				taskId = jsonObject.getString("taskId");
			}
			if (jsonObject.has("fieldName")) {
				fieldName = jsonObject.getString("fieldName");
			}
			if (jsonObject.has("comment")) {
				comment = jsonObject.getString("comment");
			}
			if (jsonObject.has("nodeId")) {
				nodeId = jsonObject.getString("nodeId");
			}
			if (jsonObject.has("isFreeSelect")) {
				isFreeSelect = jsonObject.getString("isFreeSelect");
			}
			if (StringUtils.isNotEmpty(bizId)

			&& StringUtils.isNotEmpty(taskId) && StringUtils.isNotEmpty(nodeId)

			&& StringUtils.isNotEmpty(isFreeSelect)) {
				String res;
				try {
					res = bpmService.runBpmProcess(bizId, taskId, nodeId,
							isFreeSelect, userId, fieldName, comment, "",null);
					if (res.equals("0")) {
						return "false";
					} else {
						return "true";
					}
				} catch (Exception e) {
					logger.error("error",e);
					return "false";
				}
			}
			return "false";
		} else {
			return "false";
		}
	}

	/**
	 * 修改待阅文件状态
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws JSONException
	 */
	@RequestMapping("/doUpdateCirculateStatus")
	@ResponseBody
	public String doUpdateCirculateStatus(HttpServletRequest request,
			HttpServletResponse response) throws JSONException {
		/** json参数 **/
		String paramJson = request.getParameter("json");
		JSONObject jsonObject = new JSONObject(paramJson);
		/** 结果code 1：json为空 2：参数存在空值 0：成功 **/
		if (paramJson != null) {
			/** 业务解决方案id **/
			String readId = "";
			if (jsonObject.has("readId")) {
				readId = jsonObject.getString("readId");
			}
			if (StringUtils.isNotEmpty(readId)) {
				BizGwCircularsEntity bizcir = bpmCirculateService
						.findCirById(readId);
				bizcir.setIsread("1");
				bizcir.setView_time(new Date());
				bpmCirculateService.updatecir(bizcir);
				return "true";
			} else {
				return "false";
			}
		} else {
			return "false";
		}

	}

	/**
	 * 修改待通知公告阅读状态
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws JSONException
	 */
	@RequestMapping("/doUpdateNoticeStatus")
	@ResponseBody
	public String doUpdateNoticeStatus(HttpServletRequest request,
			HttpServletResponse response) throws JSONException {
		/** json参数 **/
		String paramJson = request.getParameter("json");
		JSONObject jsonObject = new JSONObject(paramJson);
		/** 结果code 1：json为空 2：参数存在空值 0：成功 **/
		if (paramJson != null) {
			/** 主鍵Id **/
			String bizId = "";
			/** 用戶id **/
			String userId = "";
			if (jsonObject.has("bizId")) {
				bizId = jsonObject.getString("bizId");
			}
			if (jsonObject.has("userId")) {
				userId = jsonObject.getString("userId");
			}
			if (StringUtils.isNotEmpty(bizId) && StringUtils.isNotEmpty(userId)) {
				BizNoticePeopleEntity bean = noticeService.queryPeopleById(
						bizId, userId);
				Date now = new Date();
				SimpleDateFormat dateFormat = new SimpleDateFormat(
						"yyyy-MM-dd HH:mm:ss");// 可以方便地修改日期格式
				String time = dateFormat.format(now);
				bean.setStatus("1");
				bean.setFinishtime(time);
				noticeService.doSaveNoticePeopleInfo(bean);
				return "true";
			} else {
				return "false";
			}
		} else {
			return "false";
		}

	}
}
