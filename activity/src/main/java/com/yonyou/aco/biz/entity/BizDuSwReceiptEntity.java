package com.yonyou.aco.biz.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Table;

import org.apache.commons.lang.StringUtils;

import com.yonyou.cap.common.util.IdEntity;

@Entity
@Table(name = "biz_du_sw_receipt")
public class BizDuSwReceiptEntity extends IdEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4147364943551017293L;

	/**  */
	private String bizId_;
	/** 文件标题 */
	private String title_;
	/** 来文单位 */
	private String textUnit_;
	/** 密级 1公开 2内部 */
	private String securityLevel_;
	/** 来文文号 */
	private String receiveNumber_;
	/** 登记部门ID */
	private String registDepartId_;
	/** 登记部门名称 */
	private String registDepartIdName_;
	/** 登记人ID */
	private String registUserId_;
	/** 登记人名称 */
	private String registUserIdName_;
	/** 院领导批示意见 */
	private String commentYld_;
	/** 单位领导意见 */
	private String commentDwld_;
	/** 承办处意见 */
	private String commentCbc_;
	/** 收文日期 */
	private String receiveTime_;
	/** 成文日期 */
	private String completeTime_;
	/** 删除标记 */
	private String DR_;

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

	public String getSecurityLevel_() {
		return securityLevel_;
	}

	public void setSecurityLevel_(String securityLevel_) {
		this.securityLevel_ = securityLevel_;
	}

	public String getReceiveNumber_() {
		return receiveNumber_;
	}

	public void setReceiveNumber_(String receiveNumber_) {
		this.receiveNumber_ = receiveNumber_;
	}

	public String getRegistDepartId_() {
		return registDepartId_;
	}

	public void setRegistDepartId_(String registDepartId_) {
		this.registDepartId_ = registDepartId_;
	}

	public String getRegistDepartIdName_() {
		return registDepartIdName_;
	}

	public void setRegistDepartIdName_(String registDepartIdName_) {
		this.registDepartIdName_ = registDepartIdName_;
	}

	public String getRegistUserId_() {
		return registUserId_;
	}

	public void setRegistUserId_(String registUserId_) {
		this.registUserId_ = registUserId_;
	}

	public String getRegistUserIdName_() {
		return registUserIdName_;
	}
	
	public void setRegistUserIdName_(String registUserIdName_) {
		this.registUserIdName_ = registUserIdName_;
	}

	public String getCommentYld_() {
		return commentYld_;
	}

	public void setCommentYld_(String commentYld_) {
		this.commentYld_ = commentYld_;
	}

	public String getCommentDwld_() {
		return commentDwld_;
	}

	public void setCommentDwld_(String commentDwld_) {
		this.commentDwld_ = commentDwld_;
	}

	public String getCommentCbc_() {
		return commentCbc_;
	}
	
	public void setCommentCbc_(String commentCbc_) {
		this.commentCbc_ = commentCbc_;
	}

	public String getReceiveTime_() {
		if(StringUtils.isNotEmpty(receiveTime_)){
			return receiveTime_.substring(0, 10);
		}else {
			return "";
		}
	}

	public void setReceiveTime_(String receiveTime_) {
		this.receiveTime_ = receiveTime_;
	}

	public String getCompleteTime_() {
		if(StringUtils.isNotEmpty(completeTime_)){
			return completeTime_.substring(0, 10);
		}else{
			return "";
		}
	}

	public void setCompleteTime_(String completeTime_) {
		this.completeTime_ = completeTime_;
	}

	public String getDR_() {
		return DR_;
	}

	public void setDR_(String dR_) {
		DR_ = dR_;
	}

}
