package com.yonyou.aco.mtgmgr.entity;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * 名称: 会议室申请审批表  (分页排序). 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 
 * @author
 * @since 1.0.0
 */
public class RoomUsingSearchBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4980747703737814209L;

	@JsonProperty("id_")
	private String id_;
	
	@JsonProperty("room_apply_id")
	private String room_apply_id;
	
	@JsonProperty("meeting_name")
	private String meeting_name;
	
	@JsonProperty("room_name")
	private String room_name;
	
	@JsonProperty("USER_NAME")
	private String USER_NAME;
	
	@JsonProperty("start_time")
	private String start_time;
	
	@JsonProperty("end_time")
	private String end_time;
	
	@JsonProperty("status")
	private String status;// 状态
	

	public String getId_() {
		return id_;
	}

	public void setId_(String id_) {
		this.id_ = id_;
	}

	public String getRoom_apply_id() {
		return room_apply_id;
	}

	public void setRoom_apply_id(String room_apply_id) {
		this.room_apply_id = room_apply_id;
	}

	public String getMeeting_name() {
		return meeting_name;
	}

	public void setMeeting_name(String meeting_name) {
		this.meeting_name = meeting_name;
	}

	public String getRoom_name() {
		return room_name;
	}

	public void setRoom_name(String room_name) {
		this.room_name = room_name;
	}

	public String getUSER_NAME() {
		return USER_NAME;
	}

	public void setUSER_NAME(String uSER_NAME) {
		USER_NAME = uSER_NAME;
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

	
	

	
}
