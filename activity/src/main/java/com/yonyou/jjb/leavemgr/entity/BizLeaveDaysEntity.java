package com.yonyou.jjb.leavemgr.entity;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;



@Entity
@Table(name = "biz_leave_days")
public class BizLeaveDaysEntity implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 5450862361632412139L;

	/** userId */
	private String userId;
	
	/** 已休假总天数 */
	private String totalDays_;
	/** 已请假假总天数 */
	private String leaveDays_;
	
	@Id
	@Column(name = "userId", unique = true, nullable = false, length = 64)
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getTotalDays_() {
		return totalDays_;
	}
	public void setTotalDays_(String totalDays_) {
		this.totalDays_ = totalDays_;
	}
	public String getLeaveDays_() {
		return leaveDays_;
	}
	public void setLeaveDays_(String leaveDays_) {
		this.leaveDays_ = leaveDays_;
	}
}
