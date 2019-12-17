package com.yonyou.aco.mtgmgr.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Table;
import com.yonyou.cap.common.util.IdEntity;

@Entity
@Table(name = "biz_mt_roomapply")
public class BizMtRoomApplyEntity extends IdEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;
	/** 申请人id */
	private String apply_user_id;
	/** 申请人部门id */
	private String apply_org_id;
	/** 填表时间 */
	private String ts;
	/** 使用人id */
	private String user_id;
	/** 使用人部门id */
	private String user_org_id;
	/** 标题 */
	private String meeting_name;
	/** 会议室id */
	private String room_id;
	/** 参会人ids */
	private String attendee;
	/** 开始时间 */
	private String starttime;
	/** 结束时间 */
	private String endtime;
	/** 申请方式 */
	private String apply_model;
	/** 申请用途 */
	private String purpose;
	/** 所需资源 */
	private String resource;
	/** 备注 */
	private String remark;
	/** 状态 */
	private String status;
	/** 排序值 */
	private Integer sort;

	private String dataTenantId;
	private String dataUserId;
	private String dataOrgId;
	private String dataDeptId;

	public String getApply_user_id() {
		return apply_user_id;
	}

	public void setApply_user_id(String apply_user_id) {
		this.apply_user_id = apply_user_id;
	}

	public String getApply_org_id() {
		return apply_org_id;
	}

	public void setApply_org_id(String apply_org_id) {
		this.apply_org_id = apply_org_id;
	}

	public String getTs() {
		return ts;
	}

	public void setTs(String ts) {
		this.ts = ts;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public String getUser_org_id() {
		return user_org_id;
	}

	public void setUser_org_id(String user_org_id) {
		this.user_org_id = user_org_id;
	}

	public String getMeeting_name() {
		return meeting_name;
	}

	public void setMeeting_name(String meeting_name) {
		this.meeting_name = meeting_name;
	}

	public String getRoom_id() {
		return room_id;
	}

	public void setRoom_id(String room_id) {
		this.room_id = room_id;
	}

	public String getAttendee() {
		return attendee;
	}

	public void setAttendee(String attendee) {
		this.attendee = attendee;
	}

	public String getStarttime() {
		return starttime;
	}

	public void setStarttime(String starttime) {
		this.starttime = starttime;
	}

	public String getEndtime() {
		return endtime;
	}

	public void setEndtime(String endtime) {
		this.endtime = endtime;
	}

	public String getApply_model() {
		return apply_model;
	}

	public void setApply_model(String apply_model) {
		this.apply_model = apply_model;
	}

	public String getPurpose() {
		return purpose;
	}

	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}

	public String getResource() {
		return resource;
	}

	public void setResource(String resource) {
		this.resource = resource;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Integer getSort() {
		return sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public String getDataTenantId() {
		return dataTenantId;
	}

	public void setDataTenantId(String dataTenantId) {
		this.dataTenantId = dataTenantId;
	}

	public String getDataUserId() {
		return dataUserId;
	}

	public void setDataUserId(String dataUserId) {
		this.dataUserId = dataUserId;
	}

	public String getDataOrgId() {
		return dataOrgId;
	}

	public void setDataOrgId(String dataOrgId) {
		this.dataOrgId = dataOrgId;
	}

	public String getDataDeptId() {
		return dataDeptId;
	}
	
	public void setDataDeptId(String dataDeptId) {
		this.dataDeptId = dataDeptId;
	}
}
