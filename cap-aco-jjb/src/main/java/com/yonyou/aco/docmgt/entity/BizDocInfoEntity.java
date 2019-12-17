package com.yonyou.aco.docmgt.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 
 * 文档管理-个人文件夹数据基础信息类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016-6-20
 * @author  yh
 * @since   1.0.0
 */
@Entity
@Table(name = "biz_doc_info")
public class BizDocInfoEntity extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;
	private String bizId;
	private String placeUserId;
	private String placeTime;
	private String docType;
	public String getBizId() {
		return bizId;
	}
	public void setBizId(String bizId) {
		this.bizId = bizId;
	}
	public String getPlaceUserId() {
		return placeUserId;
	}
	public void setPlaceUserId(String placeUserId) {
		this.placeUserId = placeUserId;
	}
	public String getPlaceTime() {
		return placeTime;
	}
	public void setPlaceTime(String placeTime) {
		this.placeTime = placeTime;
	}
	public String getDocType() {
		return docType;
	}
	public void setDocType(String docType) {
		this.docType = docType;
	}
}