package com.yonyou.aco.biz.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import org.apache.commons.lang.StringUtils;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 函件报批单实体类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年9月13日
 * @author  薛志超
 * @since   1.0.0
 */
@Entity
@Table(name = "biz_du_hjbpd")
public class BizDuHjbpdEntity extends IdEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -832277362130619275L;
	
	/** 业务主键 **/
	private String bizId_;
	/**  标题 **/
	private String title_;
	/** 来函单位  **/
	private String textUnit_;
	/** 来函人姓名  **/
	private String textName_;
	/** 收函部门  **/
	private String receiveDepartIdName_;
	/** 收函部门编号  **/
	private String receiveDepartId_;
	/** 收函日期  **/
	private String receiveDate_;
	/**  院领导批示 **/
	private String commentYld_;
	/** 局领导批示  **/
	private String commentJld_;
	/** 部门负责人意见  **/
	private String commentBm_;
	/**  删除行 Y已删除 N未删除  **/
	private char dr_;
	public String getBizId_() {
		return bizId_;
	}
	public void setBizId_(String bizId_) {
		this.bizId_ = bizId_;
	}
	public String getTitle_() {
		return title_;
	}
	public void setTitle_(String title_) {
		this.title_ = title_;
	}
	public String getTextUnit_() {
		return textUnit_;
	}
	public void setTextUnit_(String textUnit_) {
		this.textUnit_ = textUnit_;
	}
	public String getTextName_() {
		return textName_;
	}
	public void setTextName_(String textName_) {
		this.textName_ = textName_;
	}
	
	public String getReceiveDepartIdName_() {
		return receiveDepartIdName_;
	}
	public void setReceiveDepartIdName_(String receiveDepartIdName_) {
		this.receiveDepartIdName_ = receiveDepartIdName_;
	}
	public String getReceiveDepartId_() {
		return receiveDepartId_;
	}
	public void setReceiveDepartId_(String receiveDepartId_) {
		this.receiveDepartId_ = receiveDepartId_;
	}
	public String getReceiveDate_() {
		if(StringUtils.isNotEmpty(receiveDate_)){
			return receiveDate_.substring(0, 10);
		}else{
			return "";
		}
	}
	public void setReceiveDate_(String receiveDate_) {
		this.receiveDate_ = receiveDate_;
	}
	public String getCommentYld_() {
		return commentYld_;
	}
	public void setCommentYld_(String commentYld_) {
		this.commentYld_ = commentYld_;
	}
	public String getCommentJld_() {
		return commentJld_;
	}
	public void setCommentJld_(String commentJld_) {
		this.commentJld_ = commentJld_;
	}
	public String getCommentBm_() {
		return commentBm_;
	}
	public void setCommentBm_(String commentBm_) {
		this.commentBm_ = commentBm_;
	}
	public char getDr_() {
		return dr_;
	}
	public void setDr_(char dr_) {
		this.dr_ = dr_;
	}
}
