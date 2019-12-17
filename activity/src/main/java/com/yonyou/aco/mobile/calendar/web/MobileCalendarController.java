package com.yonyou.aco.mobile.calendar.web;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.calendar.entity.BizCalendarEntity;
import com.yonyou.aco.calendar.service.IBizCalendarService;
import com.yonyou.aco.mobile.calendar.service.IMobileCalendarService;
import com.yonyou.cap.common.util.DateUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("mobileCalendarController")
public class MobileCalendarController {
	@Resource
	IMobileCalendarService mobileCalendarService;

	@Resource
	IBizCalendarService bizCalendarService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@RequestMapping("/findCalendarInfoByUserId")
	public void findCalendarInfoByUserId(HttpServletRequest request,
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
			String type = "";

			if (jsonObject.has("userId")) {
				userId = jsonObject.getString("userId");
			}
			if (jsonObject.has("type")) {
				type = jsonObject.getString("type");
			}

			if (userId != null && !"".equals(userId) && type != null
					&& !"".equals(type)) {

				res = mobileCalendarService.findCalendarInfoByUserId(userId,
						type);

				System.out.println(res);
			} else {
				erroCode = "2";
				json.put("message", "参数存在空值");
				json.put("erroCode", erroCode);
				res = json.toString();
			}
		} else {
			erroCode = "1";
			json.put("message", "json为空");
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
	 * 通过年、月查询当前月份有数据的日期
	 * 
	 * @param request
	 * @param response
	 * @throws JSONException
	 */
	@RequestMapping("findMonthMessageDay")
	public void findMonthMessageDay(HttpServletRequest request,
			HttpServletResponse response) {
		String year = request.getParameter("year");
		String month = request.getParameter("month");
		String userId = request.getParameter("userId");
		if (StringUtils.isNotEmpty(year) && StringUtils.isNotEmpty(month)
				&& StringUtils.isNotEmpty(userId)) {
			if (month.length() == 1) {
				month = "0" + month;
			}
			String time = year + "-" + month;
			List<BizCalendarEntity> list = mobileCalendarService
					.findMonthMessageDay(time, userId);
			StringBuilder sb = new StringBuilder("");
			for (int i = 0; i < list.size(); i++) {
				BizCalendarEntity bcEntity = list.get(i);
				String daytime = DateUtil.formatDate(bcEntity.getStartTime_(),
						"YYYY-mm-dd");
				sb.append(daytime.substring(8, 10));
				sb.append(",");
			}
			try {
				response.setContentType("text/xml;charset=utf-8");
				if (StringUtils.isNotEmpty(sb)) {
					response.getWriter()
							.print(sb.substring(0, sb.length() - 1));
				} else {
					response.getWriter().print("");
				}
				response.getWriter().flush();
			} catch (IOException e) {
				logger.error("error",e);
			}
		} else {
			response.setContentType("text/xml;charset=utf-8");
			try {
				response.getWriter().print(
						"参数存在空值USERID=" + userId + "year=" + year + "month="
								+ month);
				response.getWriter().flush();
			} catch (IOException e) {
				logger.error("error",e);
			}
		}

	}

	/**
	 * 手机端新增日程修改日程
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws JSONException
	 * @throws UnsupportedEncodingException
	 */
	@RequestMapping("doAddOrUpdateCalendarByMobile")
	@ResponseBody
	public String doAddOrUpdateCalendarByMobile(HttpServletRequest request,
			HttpServletResponse response) throws JSONException {
		String paramJson = request.getParameter("json");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if (paramJson != null) {
			JSONObject jsonObject = new JSONObject(paramJson);
			/** 日程Id */
			String id = "";
			/** 用户Id */
			String userId = "";
			/** 日程标题 */
			String title = "";
			/** 日程地址 */
			String place = "";
			/** 日程类型 */
			String calendarType = "";
			/** 日程提醒时间 */
			String awokeTime = "";
			/** 日程级别 */
			String importance = "";
			/** 日程内容 */
			String detail = "";
			/** 日程开始时间 */
			String startTime = "";
			/** 日程结束时间 */
			String stopTime = "";
			/** 用户名称 */
			String userName = "";
			if (jsonObject.has("id")) {
				id = jsonObject.getString("id");
			}
			if (jsonObject.has("userId")) {
				userId = jsonObject.getString("userId");
			}
			if (jsonObject.has("title")) {
				title = jsonObject.getString("title");
			}
			if (jsonObject.has("place")) {
				place = jsonObject.getString("place");
			}
			if (jsonObject.has("calendarType")) {
				calendarType = jsonObject.getString("calendarType");
			}
			if (jsonObject.has("awokeTime")) {
				awokeTime = jsonObject.getString("awokeTime");
				awokeTime = getOrderNumber(awokeTime);
			}
			if (jsonObject.has("importance")) {
				importance = jsonObject.getString("importance");
				if ("高".equals(importance)) {
					importance = "3";
				}
				if ("中".equals(importance)) {
					importance = "2";
				}
				if ("低".equals(importance)) {
					importance = "1";
				}
			}
			if (jsonObject.has("detail")) {
				detail = jsonObject.getString("detail");
			}
			if (jsonObject.has("startTime")) {
				startTime = jsonObject.getString("startTime") + ":00";
			}
			if (jsonObject.has("stopTime")) {
				stopTime = jsonObject.getString("stopTime") + ":00";
			}
			if (jsonObject.has("userName")) {
				userName = jsonObject.getString("userName");
			}
			Date startDate = null;
			Date endDate = null;
			if (StringUtils.isNotEmpty(userId) && StringUtils.isNotEmpty(place)
					&& StringUtils.isNotEmpty(stopTime)
					&& StringUtils.isNotEmpty(startTime)
					&& StringUtils.isNotEmpty(title)) {
				try {
					startDate = sdf.parse(startTime);
					endDate = sdf.parse(stopTime);
				} catch (ParseException e) {
					logger.error("error",e);
				}
				BizCalendarEntity bcEntity = new BizCalendarEntity();
				bcEntity.setId(id);
				bcEntity.setAddress_(place);
				bcEntity.setContent_(detail);
				bcEntity.setEndTime_(endDate);
				bcEntity.setLevel_(importance);
				bcEntity.setRemindTime_(awokeTime);
				bcEntity.setStartTime_(startDate);
				bcEntity.setState_("1");
				bcEntity.setTitle_(title);
				bcEntity.setUserId_(userId);
				bcEntity.setUserName_(userName);
				bcEntity.setType_(calendarType);
				/**
				 * id为空修改日程不为空新增日程
				 */
				if (StringUtils.isNotEmpty(id)) {
					bizCalendarService.doSaveOrUpdateCalendar(bcEntity);
					return "true";
				} else {
					bcEntity.setId(null);
					return bizCalendarService.doSaveOrUpdateCalendar(bcEntity);
				}
			} else {
				return "false";
			}
		}
		return "false";
	}

	/**
	 * 移动端-根据日程ID删除日程信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("doDelCalendarById")
	@ResponseBody
	public String doDelCalendarById(HttpServletRequest request,
			HttpServletResponse response) {
		String id = request.getParameter("id");
		if (StringUtils.isNotEmpty(id)) {
			bizCalendarService.doDeleteCalendarByUserid(id);
			return "true";
		} else {
			return "false";
		}
	}

	/**
	 * 去除中文字符
	 * 
	 * @param str
	 * @return
	 */
	public String getOrderNumber(String str) {
		String regex = "[\u4e00-\u9fa5]";
		Pattern pat = Pattern.compile(regex);
		Matcher mat = pat.matcher(str);
		String repickStr = mat.replaceAll("");
		return repickStr;
	}
}
