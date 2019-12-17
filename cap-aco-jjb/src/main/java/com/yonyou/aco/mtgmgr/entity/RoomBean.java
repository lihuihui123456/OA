package com.yonyou.aco.mtgmgr.entity;

/**
 * TODO: 会议室管理模块列表模型类 TODO: 填写Class详细说明 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年3月25日
 * @author 卢昭炜
 * @since 1.0.0
 */
public class RoomBean {

	/** 会议室使用记录表id */
	private String roomused_id;
	/** 会议室申请记录表id */
	private String roomapply_id;
	/** 会议室id */
	private String room_id;
	/** 申请人 */
	private String apply_user;
	/** 申请部门 */
	private String apply_org;
	/** 使用人 */
	private String use_user;
	/** 使用部门 */
	private String use_org;
	/** 会议室名称 */
	private String room_name;
	/** 会议标题 */
	private String meeting_name;
	/** 开始时间 */
	private String start_time;
	/** 结束时间 */
	private String end_time;
	/** 申请原因用途 */
	private String purpose;
	/** 所需资源 */
	private String resource;
	/** 备注 */
	private String remark;
	/** 状态 */
	private String status;
	/** 申请时间 */
	private String apply_time;
	private String wd;
	private Integer num;
	private String virtual_time;

	public String getRoomused_id() {
		return roomused_id;
	}

	public void setRoomused_id(String roomused_id) {
		this.roomused_id = roomused_id;
	}

	public String getRoomapply_id() {
		return roomapply_id;
	}

	public void setRoomapply_id(String roomapply_id) {
		this.roomapply_id = roomapply_id;
	}

	public String getRoom_id() {
		return room_id;
	}

	public void setRoomid(String room_id) {
		this.room_id = room_id;
	}

	public String getApply_user() {
		return apply_user;
	}

	public void setApply_user(String apply_user) {
		this.apply_user = apply_user;
	}

	public String getApply_org() {
		return apply_org;
	}

	public void setApply_org(String apply_org) {
		this.apply_org = apply_org;
	}

	public String getUse_user() {
		return use_user;
	}

	public void setUse_user(String use_user) {
		this.use_user = use_user;
	}

	public String getUse_org() {
		return use_org;
	}

	public void setUse_org(String use_org) {
		this.use_org = use_org;
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

	public String getApply_time() {
		return apply_time;
	}

	public void setApply_time(String apply_time) {
		this.apply_time = apply_time;
	}

	public String getWd() {
		return wd;
	}

	public void setWd(String wd) {
		this.wd = wd;
	}

	public Integer getNum() {
		return num;
	}

	public void setNum(Integer num) {
		this.num = num;
	}

	public String getVirtual_time() {
		return virtual_time;
	}

	public void setVirtual_time(String virtual_time) {
		this.virtual_time = virtual_time;
	}

}
