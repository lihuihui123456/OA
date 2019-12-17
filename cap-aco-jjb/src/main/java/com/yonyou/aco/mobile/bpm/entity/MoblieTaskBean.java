package com.yonyou.aco.mobile.bpm.entity;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 
 * ClassName: MoblieTaskBean
 * 
 * @Description: 移动端业务数据模拟Bean
 * @author hegd
 * @date 2016-8-24
 */
public class MoblieTaskBean {

	/** 业务ID*/
	private String bizId;
	/**业务标题*/
	private String title;
	/**拟稿部门*/
	private String draft_depart_name;
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	/**开始时间*/
	private Date start_time;
	/**发文类型*/
	private String biz_type;

	public String getBizId() {
		return bizId;
	}

	public void setBizId(String bizId) {
		this.bizId = bizId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDraft_depart_name() {
		return draft_depart_name;
	}

	public void setDraft_depart_name(String draft_depart_name) {
		this.draft_depart_name = draft_depart_name;
	}

	public Date getStart_time() {
		return start_time;
	}

	public void setStart_time(Date start_time) {
		this.start_time = start_time;
	}

	public String getBiz_type() {
		return biz_type;
	}

	public void setBiz_type(String biz_type) {
		this.biz_type = biz_type;
	}

}
