package com.yonyou.aco.biz.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import org.apache.commons.lang.StringUtils;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 文件呈批传阅笺实体类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年9月13日
 * @author  薛志超
 * @since   1.0.0
 */
@Entity
@Table(name = "biz_du_wjcpcyj")
public class BizDuWjcpcyjEntity extends IdEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -832277362130619275L;
	
	private String bizId_;
	
	private String title_;
	
	private String textUnit_;
	
	private String receiveDate;
	
	private String securityLevel_;
	
	private String receiveNum_;
	
	private String commentZgjl_;
	
	private String commentSf_;
	
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

	public String getReceiveDate() {
		if(StringUtils.isNotEmpty(receiveDate)){
			return receiveDate.substring(0, 10);
		}else{
			return "";
		}
	}

	public void setReceiveDate(String receiveDate) {
		this.receiveDate = receiveDate;
	}

	public String getSecurityLevel_() {
		return securityLevel_;
	}

	public void setSecurityLevel_(String securityLevel_) {
		this.securityLevel_ = securityLevel_;
	}

	public String getReceiveNum_() {
		return receiveNum_;
	}

	public void setReceiveNum_(String receiveNum_) {
		this.receiveNum_ = receiveNum_;
	}

	public String getCommentZgjl_() {
		return commentZgjl_;
	}

	public void setCommentZgjl_(String commentZgjl_) {
		this.commentZgjl_ = commentZgjl_;
	}

	public String getCommentSf_() {
		return commentSf_;
	}

	public void setCommentSf_(String commentSf_) {
		this.commentSf_ = commentSf_;
	}

	public char getDr_() {
		return dr_;
	}

	public void setDr_(char dr_) {
		this.dr_ = dr_;
	}
}
