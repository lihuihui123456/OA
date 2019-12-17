package com.yonyou.aco.docmgt.entity;

import java.io.Serializable;

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
public class BizDocInfoBean extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;
	private String id_;
	/** 表单id **/
	private String biz_id_;
	
	private String biz_title_;
	/** 文件夹id **/
	private String folder_id_;
	/** 归档时间 **/
	private String place_time_;
	/** 归档人 **/
	private String place_user_;
	/** 归档人id **/
	private String place_user_id_;
	/** 归档机构 **/
	private String place_org_;
	/** 归档部门 **/
	private String place_depart;
	/** 归档职位 **/
	private String place_post_;
	/** 文档类型 **/
	private String doc_type_;
	/** 保存时限 **/
	private int save_time_;
	
	private String is_form_;
	
	private String is_document_;
	
	private String is_media_;
	
	public String getId_() {
		return id_;
	}
	public void setId_(String id_) {
		this.id_ = id_;
	}
	public String getBiz_id_() {
		return biz_id_;
	}
	public void setBiz_id_(String biz_id_) {
		this.biz_id_ = biz_id_;
	}
	public String getBiz_title_() {
		return biz_title_;
	}
	public void setBiz_title_(String biz_title_) {
		this.biz_title_ = biz_title_;
	}
	public String getFolder_id_() {
		return folder_id_;
	}
	public void setFolder_id_(String folder_id_) {
		this.folder_id_ = folder_id_;
	}

	public String getPlace_time_() {
		return place_time_;
	}
	public void setPlace_time_(String place_time_) {
		this.place_time_ = place_time_;
	}
	public String getPlace_user_() {
		return place_user_;
	}
	public void setPlace_user_(String place_user_) {
		this.place_user_ = place_user_;
	}
	public String getPlace_org_() {
		return place_org_;
	}
	public void setPlace_org_(String place_org_) {
		this.place_org_ = place_org_;
	}
	public String getPlace_depart() {
		return place_depart;
	}
	public void setPlace_depart(String place_depart) {
		this.place_depart = place_depart;
	}
	public String getPlace_post_() {
		return place_post_;
	}
	public void setPlace_post_(String place_post_) {
		this.place_post_ = place_post_;
	}
	public String getDoc_type_() {
		return doc_type_;
	}
	public void setDoc_type_(String doc_type_) {
		this.doc_type_ = doc_type_;
	}
	public int getSave_time_() {
		return save_time_;
	}
	public void setSave_time_(int save_time_) {
		this.save_time_ = save_time_;
	}
	public String getIs_form_() {
		return is_form_;
	}
	public void setIs_form_(String is_form_) {
		this.is_form_ = is_form_;
	}
	public String getIs_document_() {
		return is_document_;
	}
	public void setIs_document_(String is_document_) {
		this.is_document_ = is_document_;
	}
	public String getIs_media_() {
		return is_media_;
	}
	public void setIs_media_(String is_media_) {
		this.is_media_ = is_media_;
	}
	public String getPlace_user_id_() {
		return place_user_id_;
	}
	public void setPlace_user_id_(String place_user_id_) {
		this.place_user_id_ = place_user_id_;
	}
	
}