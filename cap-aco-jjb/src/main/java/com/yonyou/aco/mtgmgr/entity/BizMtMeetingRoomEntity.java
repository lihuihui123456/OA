package com.yonyou.aco.mtgmgr.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 名称: 会议室实体类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年8月9日
 * @author  薛志超
 * @since   1.0.0
 */
@Entity
@Table(name = "biz_mt_meetingroom")
public class BizMtMeetingRoomEntity extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	private String room_num;
	private String room_name;
	private Integer seats;// 座位数
	private String address;
	private String floor;
	private String area;
	private String projector;
	private String video_conference;
	private String status;// 状态
	private String remark;
	private String record_userid;
	private String record_date;
	private String ts;
	private Integer sort;
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
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
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
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getRecord_userid() {
		return record_userid;
	}
	public void setRecord_userid(String record_userid) {
		this.record_userid = record_userid;
	}
	public String getRecord_date() {
		return record_date;
	}
	public void setRecord_date(String record_date) {
		this.record_date = record_date;
	}
	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}
	public Integer getSort() {
		return sort;
	}
	public void setSort(Integer sort) {
		this.sort = sort;
	}
}
