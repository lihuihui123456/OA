package com.yonyou.aco.notice.entity;

import java.io.Serializable;

public class BizNoticeInfoBean implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String id_;
	
	private String title;
	
	private String sender_id;
	
	private String sender;
	
	private String scene_id;
	
	private String scene;
	
	private String text_field;
	
	private String create_time;
	
	private String att_id;
	
	private String status;
	
	private String TENANT_ID;

	public String getId_() {
		return id_;
	}

	public void setId_(String id_) {
		this.id_ = id_;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getSender_id() {
		return sender_id;
	}

	public void setSender_id(String sender_id) {
		this.sender_id = sender_id;
	}

	public String getSender() {
		return sender;
	}

	public void setSender(String sender) {
		this.sender = sender;
	}

	public String getScene_id() {
		return scene_id;
	}

	public void setScene_id(String scene_id) {
		this.scene_id = scene_id;
	}

	public String getScene() {
		return scene;
	}

	public void setScene(String scene) {
		this.scene = scene;
	}

	public String getText_field() {
		return text_field;
	}

	public void setText_field(String text_field) {
		this.text_field = text_field;
	}

	public String getCreate_time() {
		return create_time;
	}

	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}

	public String getAtt_id() {
		return att_id;
	}

	public void setAtt_id(String att_id) {
		this.att_id = att_id;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getTENANT_ID() {
		return TENANT_ID;
	}

	public void setTENANT_ID(String tENANT_ID) {
		TENANT_ID = tENANT_ID;
	}
	
	

}
