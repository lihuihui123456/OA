package com.yonyou.jjb.leavemgr.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;



@Entity
@Table(name = "biz_leave")
public class BizLeaveEntity implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 234113412346561148L;
	/** id */
	private String id;
	/** id */
	private String biz_id_;
	/** 人员姓名 */
	private String user_name;
	/** 所在部门 */
	private String dept_name;
	/** 职务 */
	private String post_name;
	/** 参加工作时间 */
	private String work_time;
	/** 可休假天数 */
	private String leave_day;
	/** 已休假天数 */
	private String already_day;
	/** 请假时间 */
	private String leave_time;
	/** 请假截止时间 */
	private String leave_time_end;
	/** 休假时间 */
	private String rest_time;
	/** 休假截止时间 */
	private String rest_time_end;
	/** 是否出京*/
	private String leave_capital;
	/** 出京目的地*/
	private String capital;
	/** 是否出境*/
	private String leave_country;
	/** 出境目的地*/
	private String country;
	/** 所在部门意见*/
	private String comment_bm;
	/** 领导意见*/
	private String comment_ld;
	/** 请假类型 */
	private String leave_type;
	/** 已请假天数 */
	private String leave_already;
	/** 请假事由*/
	private String leave_reason;
	/** 时间戳 */
	private String ts;
	/** 删除行 Y已删除 N未删除 */
	private String dr;
	/** 备注 */
	private String remark;
	/** 用户id */
	private String dataUserId;
	/** 用户部门code */
	private String dataDeptCode;
	/** 单位id */
	private String dataOrgId;
	/** 租户id */
	private String dataTenantId;
    /**状态*/
	private String state;
	/**本年度剩余休假天数*/
	private String surplus_days;
	/**本年度请假总天数*/
	private String total_days;
	/**本次休假天数*/
	private String xiujia_days;
	/**本次请假天数*/
	private String qingjia_days;
	/**提交时间*/
	private String sendTime;
	@Transient
	private String startTime;
	@Transient
	private String endTime;	
	@Id
	@Column(name = "id", unique = true, nullable = false, length = 64)
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBiz_id_() {
		return biz_id_;
	}
	public void setBiz_id_(String biz_id_) {
		this.biz_id_ = biz_id_;
	}
	public String getUser_name() {
		return user_name;
	}
	public void setUser_name(String user_name) {
		this.user_name = user_name;
	}
	public String getPost_name() {
		return post_name;
	}
	public void setPost_name(String post_name) {
		this.post_name = post_name;
	}
	public String getWork_time() {
		return work_time;
	}
	public void setWork_time(String work_time) {
		this.work_time = work_time;
	}
	public String getLeave_day() {
		return leave_day;
	}
	public void setLeave_day(String leave_day) {
		this.leave_day = leave_day;
	}
	public String getAlready_day() {
		return already_day;
	}
	public void setAlready_day(String already_day) {
		this.already_day = already_day;
	}
	public String getLeave_time() {
		return leave_time;
	}
	public void setLeave_time(String leave_time) {
		this.leave_time = leave_time;
	}
	public String getLeave_capital() {
		return leave_capital;
	}
	public void setLeave_capital(String leave_capital) {
		this.leave_capital = leave_capital;
	}
	public String getLeave_country() {
		return leave_country;
	}
	public void setLeave_country(String leave_country) {
		this.leave_country = leave_country;
	}
	public String getComment_bm() {
		return comment_bm;
	}
	public void setComment_bm(String comment_bm) {
		this.comment_bm = comment_bm;
	}
	public String getComment_ld() {
		return comment_ld;
	}
	public void setComment_ld(String comment_ld) {
		this.comment_ld = comment_ld;
	}
	public String getLeave_type() {
		return leave_type;
	}
	public void setLeave_type(String leave_type) {
		this.leave_type = leave_type;
	}
	public String getLeave_already() {
		return leave_already;
	}
	public void setLeave_already(String leave_already) {
		this.leave_already = leave_already;
	}
	public String getLeave_reason() {
		return leave_reason;
	}
	public void setLeave_reason(String leave_reason) {
		this.leave_reason = leave_reason;
	}
	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}
	public String getDr() {
		return dr;
	}
	public void setDr(String dr) {
		this.dr = dr;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getCountry() {
		return country;
	}
	public void setCountry(String country) {
		this.country = country;
	}
	public String getRest_time() {
		return rest_time;
	}
	public void setRest_time(String rest_time) {
		this.rest_time = rest_time;
	}
	public String getLeave_time_end() {
		return leave_time_end;
	}
	public void setLeave_time_end(String leave_time_end) {
		this.leave_time_end = leave_time_end;
	}
	public String getRest_time_end() {
		return rest_time_end;
	}
	public void setRest_time_end(String rest_time_end) {
		this.rest_time_end = rest_time_end;
	}
	public String getDept_name() {
		return dept_name;
	}
	public void setDept_name(String dept_name) {
		this.dept_name = dept_name;
	}
	
	public String getDataUserId() {
		return dataUserId;
	}
	public void setDataUserId(String dataUserId) {
		this.dataUserId = dataUserId;
	}
	public String getDataDeptCode() {
		return dataDeptCode;
	}
	public void setDataDeptCode(String dataDeptCode) {
		this.dataDeptCode = dataDeptCode;
	}
	public String getDataOrgId() {
		return dataOrgId;
	}
	public void setDataOrgId(String dataOrgId) {
		this.dataOrgId = dataOrgId;
	}
	public String getDataTenantId() {
		return dataTenantId;
	}
	public void setDataTenantId(String dataTenantId) {
		this.dataTenantId = dataTenantId;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getSurplus_days() {
		return surplus_days;
	}
	public void setSurplus_days(String surplus_days) {
		this.surplus_days = surplus_days;
	}
	public String getTotal_days() {
		return total_days;
	}
	public void setTotal_days(String total_days) {
		this.total_days = total_days;
	}
	public String getXiujia_days() {
		return xiujia_days;
	}
	public void setXiujia_days(String xiujia_days) {
		this.xiujia_days = xiujia_days;
	}
	public String getQingjia_days() {
		return qingjia_days;
	}
	public void setQingjia_days(String qingjia_days) {
		this.qingjia_days = qingjia_days;
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
	public String getSendTime() {
		return sendTime;
	}
	public void setSendTime(String sendTime) {
		this.sendTime = sendTime;
	}
}
