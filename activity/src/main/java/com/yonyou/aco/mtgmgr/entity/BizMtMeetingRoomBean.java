package com.yonyou.aco.mtgmgr.entity;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * 名称: 会议室表  (分页排序). 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 
 * @author
 * @since 1.0.0
 */
public class BizMtMeetingRoomBean implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8075493071692936174L;

	@JsonProperty("id_")
	private String id_;
	
	@JsonProperty("room_num")
	private String room_num;
	
	@JsonProperty("room_name")
	private String room_name;
	
	@JsonProperty("seats")
	private Integer seats;// 座位数
	
	@JsonProperty("floor")
	private String floor;
	
	@JsonProperty("area")
	private String area;
	
	@JsonProperty("projector")
	private String projector;
	
	@JsonProperty("video_conference")
	private String video_conference;
	
	@JsonProperty("status")
	private String status;// 状态

	public String getId_() {
		return id_;
	}

	public void setId_(String id_) {
		this.id_ = id_;
	}

	public String getRoom_num() {
		return room_num;
	}

	public void setRoom_num(String room_num) {
		this.room_num = room_num;
	}

	public String getRoom_name() {
		return room_name;
	}

	public void setRoom_name(String room_name) {
		this.room_name = room_name;
	}

	public Integer getSeats() {
		return seats;
	}

	public void setSeats(Integer seats) {
		this.seats = seats;
	}

	public String getFloor() {
		return floor;
	}

	public void setFloor(String floor) {
		this.floor = floor;
	}

	public String getArea() {
		return area;
	}

	public void setArea(String area) {
		this.area = area;
	}

	public String getProjector() {
		return projector;
	}

	public void setProjector(String projector) {
		this.projector = projector;
	}

	public String getVideo_conference() {
		return video_conference;
	}

	public void setVideo_conference(String video_conference) {
		this.video_conference = video_conference;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	
	

	
}
