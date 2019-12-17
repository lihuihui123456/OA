package com.yonyou.aco.cloudydisk.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
/**
 * 办公云盘日志表
 * @author 葛鹏
 * 2017-03-10
 **/
@Entity
@Table(name = "cloud_log")
public class CloudLogEntity implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/** 主键ID */
	private String logId;
	/** 动作 */
	private String act;
	/** 操作用户ID */
	private String actUserId;
	/** 操作用户姓名 */
	private String actUserName;
	/** dr */
	private String dr;
	/** 时间戳 */
	private String ts;
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	public String getLogId() {
		return logId;
	}
	public void setLogId(String logId) {
		this.logId = logId;
	}
	public String getAct() {
		return act;
	}
	public void setAct(String act) {
		this.act = act;
	}
	
	public String getActUserId() {
		return actUserId;
	}
	public void setActUserId(String actUserId) {
		this.actUserId = actUserId;
	}
	public String getActUserName() {
		return actUserName;
	}
	public void setActUserName(String actUserName) {
		this.actUserName = actUserName;
	}
	
	public String getDr() {
		return dr;
	}
	public void setDr(String dr) {
		this.dr = dr;
	}
	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}

	

}
