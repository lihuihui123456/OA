package com.yonyou.aco.biz.entity;

import java.io.Serializable;
import javax.persistence.Entity;
import javax.persistence.Table;

import org.apache.commons.lang.StringUtils;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 名字: 自由发文实体类. 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年9月9日
 * @author 卢昭炜
 * @since 1.0.0
 */
@Entity
@Table(name = "biz_du_zyfw")
public class BizDuZyfwEntity extends IdEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2924712251666495689L;
	/** 业务D */
	private String bizId_;
	/** 标题 */
	private String title_;
	/** 紧急程度 */
	private String urgencyLevel_;
	/** 密级 */
	private String securityLevel_;
	/** 部门负责人意见 */
	private String commentBm_;
	/** 核稿人 Id */
	private String checkUserId_;
	/** 核稿人名称 */
	private String checkUserIdName_;
	/** 拟稿部门Id */
	private String draftDeptId_;
	/** 拟稿部门名称 */
	private String draftDeptIdName_;
	/** 拟稿人Id */
	private String draftUserId_;
	/** 拟稿人名称 */
	private String draftUserIdName_;
	/** 拟稿时间 */
	private String draftTime_;
	/** 删除行 Y已删除 N未删除 */
	private String dr_;

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

	public String getCommentBm_() {
		return commentBm_;
	}

	public void setCommentBm_(String commentBm_) {
		this.commentBm_ = commentBm_;
	}

	public String getCheckUserId_() {
		return checkUserId_;
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

	public void setCheckUserId_(String checkUserId_) {
		this.checkUserId_ = checkUserId_;
	}

	public String getDraftTime_() {
		if (StringUtils.isNotBlank(draftTime_)) {
			return draftTime_.substring(0, 19);
		} else {
			return "";
		}
	}

	public void setDraftTime_(String draftTime_) {
		this.draftTime_ = draftTime_;
	}

	public String getDr_() {
		return dr_;
	}

	public void setDr_(String dr_) {
		this.dr_ = dr_;
	}
}
