package com.yonyou.aco.mtgmgr.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

@Entity
@Table(name = "biz_mt_roomusing")
public class BizMtRoomUsingEntity extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;
	private String room_apply_id;
	private String room_id;
	private String room_name;
	private String meeting_name;
	private String purpose;
	private String start_time;
	private String end_time;
	private String status;
	private String apply_user_id;
	private String apply_user_name;
	private String apply_time;
	private String flow_id;
	private String flow_table_name;

	private String dataTenantId;
	private String dataUserId;
	private String dataOrgId;
	private String dataDeptId;

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

	public String getRoom_apply_id() {
		return room_apply_id;
	}

	public void setRoom_apply_id(String room_apply_id) {
		this.room_apply_id = room_apply_id;
	}

	public String getRoom_id() {
		return room_id;
	}

	public void setRoom_id(String room_id) {
		this.room_id = room_id;
	}

	public String getRoom_name() {
		return room_name;
	}

	public void setRoom_name(String room_name) {
		this.room_name = room_name;
	}

	public String getMeeting_name() {
		return meeting_name;
	}

	public void setMeeting_name(String meeting_name) {
		this.meeting_name = meeting_name;
	}

	public String getPurpose() {
		return purpose;
	}

	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}

	public String getStart_time() {
		return start_time;
	}

	public void setStart_time(String start_time) {
		this.start_time = start_time;
	}

	public String getEnd_time() {
		return end_time;
	}

	public void setEnd_time(String end_time) {
		this.end_time = end_time;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getApply_user_id() {
		return apply_user_id;
	}

	public void setApply_user_id(String apply_user_id) {
		this.apply_user_id = apply_user_id;
	}

	public String getApply_user_name() {
		return apply_user_name;
	}

	public void setApply_user_name(String apply_user_name) {
		this.apply_user_name = apply_user_name;
	}

	public String getApply_time() {
		return apply_time;
	}

	public void setApply_time(String apply_time) {
		this.apply_time = apply_time;
	}

	public String getFlow_id() {
		return flow_id;
	}

	public void setFlow_id(String flow_id) {
		this.flow_id = flow_id;
	}

	public String getFlow_table_name() {
		return flow_table_name;
	}

	public void setFlow_table_name(String flow_table_name) {
		this.flow_table_name = flow_table_name;
	}

}
