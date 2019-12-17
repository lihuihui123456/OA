package com.yonyou.aco.calendar.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.springframework.format.annotation.DateTimeFormat;

import com.yonyou.cap.common.util.IdEntity;
/**
 * 
 * <p>概述：业务模块——日程管理实体类
 * <p>功能：实体类
 * <p>作者：贺国栋
 * <p>创建时间：2016年8月1日
 * <p>类调用特殊情况：无
 */
@Entity
@Table(name = "biz_calendar_info")
public class BizCalendarEntity extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;
	/** 日程安排用户ID */
	private String userId_;
	/** 人员中文名 */
	private String userName_;
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	/**开始时间*/
	private Date startTime_;
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	/**结束时间*/
	private Date endTime_;
	/** 日程类型 */
	private String type_;
	/** 提醒周期 */
	private String remindTime_;
	/** 日程级别 */
	private String level_;
	/** 日程标题 */
	private String title_;
	/** 日程内容 */
	private String content_;
	/** 日程地点 */
	private String address_;
	/** 日程状态 */
	private String state_ = "0";
	/** 被安排人 */
	private String appoint_user_;

	@Transient
	private String startTime;
	@Transient
	private String endTime;
	@Transient
	private String appoint_user_name;



	public String getUserId_() {
		return userId_;
	}

	public void setUserId_(String userId_) {
		this.userId_ = userId_;
	}

	public String getUserName_() {
		return userName_;
	}

	public void setUserName_(String userName_) {
		this.userName_ = userName_;
	}

	public Date getStartTime_() {
		return startTime_;
	}

	public void setStartTime_(Date startTime_) {
		this.startTime_ = startTime_;
	}

	public Date getEndTime_() {
		return endTime_;
	}

	public void setEndTime_(Date endTime_) {
		this.endTime_ = endTime_;
	}

	public String getType_() {
		return type_;
	}

	public void setType_(String type_) {
		this.type_ = type_;
	}

	public String getRemindTime_() {
		return remindTime_;
	}

	public void setRemindTime_(String remindTime_) {
		this.remindTime_ = remindTime_;
	}

	public String getLevel_() {
		return level_;
	}

	public void setLevel_(String level_) {
		this.level_ = level_;
	}

	public String getTitle_() {
		return title_;
	}

	public void setTitle_(String title_) {
		this.title_ = title_;
	}

	public String getContent_() {
		return content_;
	}

	public void setContent_(String content_) {
		this.content_ = content_;
	}

	public String getAddress_() {
		return address_;
	}

	public void setAddress_(String address_) {
		this.address_ = address_;
	}

	public String getState_() {
		return state_;
	}

	public void setState_(String state_) {
		this.state_ = state_;
	}
	
	

	public String getAppoint_user_() {
		return appoint_user_;
	}

	public void setAppoint_user_(String appoint_user_) {
		this.appoint_user_ = appoint_user_;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getAppoint_user_name() {
		return appoint_user_name;
	}

	public void setAppoint_user_name(String appoint_user_name) {
		this.appoint_user_name = appoint_user_name;
	}

	
}
