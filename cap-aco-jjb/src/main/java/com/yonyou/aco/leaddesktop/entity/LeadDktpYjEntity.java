package com.yonyou.aco.leaddesktop.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 领导批示意见
 * @Date 2016-12-8
 * @author 王瑞朝
 *
 */
@Entity
@Table(name = "leader_opinion")
public class LeadDktpYjEntity extends IdEntity implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7233931824348091556L;
	
	/**
	 * 领导处理意见
	 */
	private String leaderComment;
	
	/**
	 * 意见次数
	 */
	private int yjCount;
	
	/**
	 * 用户ID
	 */
	private String userId;

	public String getLeaderComment() {
		return leaderComment;
	}

	public void setLeaderComment(String leaderComment) {
		this.leaderComment = leaderComment;
	}

	public int getYjCount() {
		return yjCount;
	}

	public void setYjCount(int yjCount) {
		this.yjCount = yjCount;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}
	

}
