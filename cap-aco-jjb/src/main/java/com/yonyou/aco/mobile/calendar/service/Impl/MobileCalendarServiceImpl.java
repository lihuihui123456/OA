package com.yonyou.aco.mobile.calendar.service.Impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import net.sf.json.JSONObject;

import com.yonyou.aco.calendar.dao.IBizCalendarDao;
import com.yonyou.aco.calendar.entity.BizCalendarEntity;
import com.yonyou.aco.mobile.calendar.service.IMobileCalendarService;

/**
 * 
 * ClassName: MobileCalendarServiceImpl
 * 
 * @Description: 移动端-日程管理实现类
 * @author hegd
 * @date 2016-8-31
 */
@Repository(value="mobileCalendarService")
public class MobileCalendarServiceImpl implements IMobileCalendarService {

	@Resource IBizCalendarDao iBizCalendarDao;

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public String findCalendarInfoByUserId(String userId,String type) {
		JSONObject json = new JSONObject();
		if ("1".equals(type)) {
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			// 通过用户ID获取用户日程信息
			List<BizCalendarEntity> list = iBizCalendarDao
					.findAllCalendarByUserId(userId,"0");
			// 结果List
			List<Map> mapList = new ArrayList<Map>();
			if (list != null && !list.isEmpty()) {
				for (int i = 0; i < list.size(); i++) {
					// 结果Map
					Map map = new HashMap();
					BizCalendarEntity bcEntity = list.get(i);
					/** 日程Id */
					String id = bcEntity.getId();
					/** 日程标题 */                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
					String title = bcEntity.getTitle_();
					/** 日程地址 */
					String place = bcEntity.getAddress_();
					/** 日程类型 */
					String calendarType = bcEntity.getType_();
					if(calendarType==null){
						calendarType = "";
					}
					/** 日程提醒时间 */
					String awokeTime = bcEntity.getRemindTime_();
					/** 日程级别 */
					String importance = bcEntity.getLevel_();
					/** 日程内容 */
					String detail = bcEntity.getContent_();
					/** 日程开始时间 */
					Date startTime = bcEntity.getStartTime_();
					/** 日程结束时间 */
					Date stopTime = bcEntity.getEndTime_();
					map.put("id", id);
					map.put("title", title);
					map.put("place", place);
					map.put("type", calendarType);
					map.put("awokeTime", awokeTime);
					map.put("importance", importance);
					map.put("detail", detail);
					map.put("startTime", sdf.format(startTime));
					map.put("stopTime", sdf.format(stopTime));
					mapList.add(map);
					/**
					 * 修改是否发送手机端状态0：未发送 1：已发送
					 */
					iBizCalendarDao.doUpdateCalendarStateByUserId(id);
				}
				json.put("errorCode", "0");// 成功编码 0 为成功 其他为失败
				json.put("errorMessage", "查询成功");// 成功编码 0 为成功 其他为失败
				json.put("items", mapList);
			} else {
				json.put("errorCode", "1");
				json.put("errorMessage", "用户当前没有安排日程！");
				json.put("items", "");
			}
			return json.toString();
		} else {
			json.put("errorCode", "1");
			json.put("errorMessage", "查询失败,查询类型错误!");
			json.put("items", "");
			return json.toString();
		}
	}

	@Override
	public List<BizCalendarEntity> findMonthMessageDay(String time,String userId) {
		// TODO Auto-generated method stub
		return iBizCalendarDao.findMonthMessageDay(time,userId);
	}
}
