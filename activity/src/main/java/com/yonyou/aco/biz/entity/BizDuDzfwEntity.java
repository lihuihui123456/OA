package com.yonyou.aco.biz.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Table;

import org.apache.commons.lang.StringUtils;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 名字: 党组发文: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年9月9日
 * @author 卢昭炜
 * @since 1.0.0
 */
@Entity
@Table(name = "biz_du_dzfw")
public class BizDuDzfwEntity extends IdEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1564167420658632359L;
	/** 业务ID */
	private String bizId_;
	/** 文件标题 */
	private String title_;
	/** 发文字号 */
	private String fwzh_;
	/** 主送单位 */
	private String mainSend_;
	/** 抄送单位 */
	private String copySend_;
	/** 紧急程度 */
	private String urgencyLevel_;
	/** 密级 */
	private String securityLevel_;
	/** 签发意见 */
	private String commentQfyj_;
	/** 审核意见 */
	private String commentShyj_;
	/** 局意见 */
	private String commentJyj_;
	/** 处室意见 */
	private String commentCsyj_;
	/** 核稿人 */
	private String checkUserId_;
	/** 核稿人名称 */
	private String checkUserIdName_;
	/** 拟稿单位 */
	private String draftDeptId_;
	/** 拟稿单位名称 */
	private String draftDeptIdName_;
	/** 拟稿人 */
	private String draftUserId_;
	/** 拟稿人名称 */
	private String draftUserIdName_;
	/** 印刷单位 */
	private String printDeptId_;
	/** 拟稿部门名称 */
	private String printDeptIdName_;
	/** 印刷单位 */
	private String printNumber_;
	/** 打印时间 */
	private String printTime_;

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

	public String getFwzh_() {
		return fwzh_;
	}

	public void setFwzh_(String fwzh_) {
		this.fwzh_ = fwzh_;
	}

	public String getMainSend_() {
		return mainSend_;
	}

	public void setMainSend_(String mainSend_) {
		this.mainSend_ = mainSend_;
	}

	public String getCopySend_() {
		return copySend_;
	}

	public void setCopySend_(String copySend_) {
		this.copySend_ = copySend_;
	}

	public String getUrgencyLevel_() {
		return urgencyLevel_;
	}

	public void setUrgencyLevel_(String urgencyLevel_) {
		this.urgencyLevel_ = urgencyLevel_;
	}

	public String getSecurityLevel_() {
		return securityLevel_;
	}

	public void setSecurityLevel_(String securityLevel_) {
		this.securityLevel_ = securityLevel_;
	}

	public String getCommentQfyj_() {
		return commentQfyj_;
	}

	public void setCommentQfyj_(String commentQfyj_) {
		this.commentQfyj_ = commentQfyj_;
	}

	public String getCommentShyj_() {
		return commentShyj_;
	}

	public void setCommentShyj_(String commentShyj_) {
		this.commentShyj_ = commentShyj_;
	}

	public String getCommentJyj_() {
		return commentJyj_;
	}

	public void setCommentJyj_(String commentJyj_) {
		this.commentJyj_ = commentJyj_;
	}

	public String getCommentCsyj_() {
		return commentCsyj_;
	}
	
	public void setCommentCsyj_(String commentCsyj_) {
		this.commentCsyj_ = commentCsyj_;
	}
	
	public String getCheckUserId_() {
		return checkUserId_;
	}

	public void setCheckUserId_(String checkUserId_) {
		this.checkUserId_ = checkUserId_;
	}

	public String getCheckUserIdName_() {
		return checkUserIdName_;
	}

	public void setCheckUserIdName_(String checkUserIdName_) {
		this.checkUserIdName_ = checkUserIdName_;
	}

	public String getDraftDeptId_() {
		return draftDeptId_;
	}

	public void setDraftDeptId_(String draftDeptId_) {
		this.draftDeptId_ = draftDeptId_;
	}

	public String getDraftDeptIdName_() {
		return draftDeptIdName_;
	}

	public void setDraftDeptIdName_(String draftDeptIdName_) {
		this.draftDeptIdName_ = draftDeptIdName_;
	}

	public String getDraftUserId_() {
		return draftUserId_;
	}

	public void setDraftUserId_(String draftUserId_) {
		this.draftUserId_ = draftUserId_;
	}

	public String getDraftUserIdName_() {
		return draftUserIdName_;
	}

	public void setDraftUserIdName_(String draftUserIdName_) {
		this.draftUserIdName_ = draftUserIdName_;
	}

	public String getPrintDeptId_() {
		return printDeptId_;
	}

	public void setPrintDeptId_(String printDeptId_) {
		this.printDeptId_ = printDeptId_;
	}

	public String getPrintDeptIdName_() {
		return printDeptIdName_;
	}

	public void setPrintDeptIdName_(String printDeptIdName_) {
		this.printDeptIdName_ = printDeptIdName_;
	}

	public String getPrintNumber_() {
		return printNumber_;
	}

	public void setPrintNumber_(String printNumber_) {
		this.printNumber_ = printNumber_;
	}

	public String getPrintTime_() {
		if (StringUtils.isNotBlank(printTime_)) {
			return printTime_.substring(0, 19);
		} else {
			return "";
		}
	}

	public void setPrintTime_(String printTime_) {
		this.printTime_ = printTime_;
	}

}
