package com.yonyou.aco.word.entity;

import java.sql.Timestamp;

/**
 * 
 * ClassName: ActHiCommentWordBean
 * 
 * @Description: 业务发文导出Word表单批示意见虚拟实体Bean
 * @author hegd
 * @date 2016-8-24
 */
public class ActHiCommentWordBean {

	/** 批示时间 **/
	private Timestamp time;
	/** 批示用户 **/
	private String userName;
	/** 批示意见 **/
	private String message;

	public Timestamp getTime() {
		return time;
	}

	public void setTime(Timestamp time) {
		this.time = time;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

}
