package com.yonyou.aco.notice.entity;

import java.io.Serializable;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.apache.commons.lang3.StringUtils;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.yonyou.cap.common.util.IdEntity;

/**
 * 
 * 通知公告基础信息类 历史记录
 * 
 * @Date 2016-5-24
 * @author yh
 * @since 1.0.0
 */
@Entity
@Table(name = "biz_notice_info")
public class BizNoticeInfoEntity extends IdEntity implements Serializable {
	private static final long serialVersionUID = 1L;

	public String title;// 标题
	public String sender; // 发送人人
	public String scene; // 选择人员
	@Column(name = "scene_id")
	public String sceneid; // 选择人员ID
	@Column(name = "sender_id")
	public String senderid; // 传阅人userId
	@Column(name = "text_field")
	public String textfield; // 文本正文
	@Column(name = "create_time")
	public String creationtime; // 创建时间
	@Column(name = "att_id")
	public String tableid; // 附件id
	public String status; // 保存状态
	@Transient
	@JsonIgnore
	public String bid; // 备用字段
	@Transient
	@JsonIgnore
	public String opinion; // 备用字段

	/**
	 * add by hegd 2016年9月23日16:32:29
	 */
	/** 移动端送办时间 **/
	@Transient
	private String mobileCreateTime;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getScene() {
		return scene;
	}

	public void setScene(String scene) {
		this.scene = scene;
	}

	@Column(name = "text_field")
	public String getTextfield() {
		return textfield;
	}

	public void setTextfield(String textfield) {
		this.textfield = textfield;
	}

	@Column(name = "create_time")
	public String getCreationtime() {
		return creationtime;
	}

	public void setCreationtime(String creationtime) {
		this.creationtime = creationtime;
	}

	@Column(name = "scene_id")
	public String getSceneid() {
		return sceneid;
	}

	public void setSceneid(String sceneid) {
		this.sceneid = sceneid;
	}

	@Column(name = "att_id")
	public String getTableid() {
		return tableid;
	}

	public void setTableid(String tableid) {
		this.tableid = tableid;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Transient
	@JsonIgnore
	public String getBid() {
		return bid;
	}

	public void setBid(String bid) {
		this.bid = bid;
	}

	@Transient
	@JsonIgnore
	public String getOpinion() {
		return opinion;
	}

	public void setOpinion(String opinion) {
		this.opinion = opinion;
	}

	public String getSender() {
		return sender;
	}

	public void setSender(String sender) {
		this.sender = sender;
	}

	@Column(name = "sender_id")
	public String getSenderid() {
		return senderid;
	}

	public void setSenderid(String senderid) {
		this.senderid = senderid;
	}

	public String getMobileCreateTime() {
		if (StringUtils.isBlank(mobileCreateTime)) {
			SimpleDateFormat sdf = new SimpleDateFormat("MM月dd日  HH:mm");
			SimpleDateFormat sdf2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date time = null;
			try {
				time = sdf2.parse(this.creationtime);
			} catch (ParseException e) {

			}
			return sdf.format(time);
		} else {
			return mobileCreateTime;
		}
	}

	public void setMobileCreateTime(String mobileCreateTime) {
		this.mobileCreateTime = mobileCreateTime;
	}
}