package com.yonyou.aco.circularize.entity;

import java.io.Serializable;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.yonyou.cap.common.util.IdEntity;

/**
 * 名称: 传阅件基础信息类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年8月9日
 * @author  薛志超
 * @since   1.0.0
 */
@Entity
@Table(name = "biz_circularize_basicinfo")
public class BizCircularizeBasicInfoEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name="id_",unique = true, length = 64, nullable = false)
	private String id;
	private String title;//标题
	private String circulated_people; //传阅人
	private String priority;  //紧急程度
	private String mustsee;  //必看
	private String mustsee_id; //必看人员id
	private String scene;  //选看人员
	private String scene_id; //选看人员ID
	private String circulated_people_id; //传阅人userId
	private String text_field; //文本正文
	public Timestamp creation_time; //创建时间
	private String endtime;  // 结束时间
	private String table_id;  // 附件id
	private String status;  // 保存状态
	private String bid;  // 备用字段
	
	@Transient
	@JsonIgnore
	public String opinion;  // 备用字段

	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getCirculated_people() {
		return circulated_people;
	}
	public void setCirculated_people(String circulated_people) {
		this.circulated_people = circulated_people;
	}
	public String getPriority() {
		return priority;
	}
	public void setPriority(String priority) {
		this.priority = priority;
	}
	public String getMustsee() {
		return mustsee;
	}
	public void setMustsee(String mustsee) {
		this.mustsee = mustsee;
	}
	public String getMustsee_id() {
		return mustsee_id;
	}
	public void setMustsee_id(String mustsee_id) {
		this.mustsee_id = mustsee_id;
	}
	public String getScene() {
		return scene;
	}
	public void setScene(String scene) {
		this.scene = scene;
	}
	public String getScene_id() {
		return scene_id;
	}
	public void setScene_id(String scene_id) {
		this.scene_id = scene_id;
	}
	public String getCirculated_people_id() {
		return circulated_people_id;
	}
	public void setCirculated_people_id(String circulated_people_id) {
		this.circulated_people_id = circulated_people_id;
	}
	public String getText_field() {
		return text_field;
	}
	public void setText_field(String text_field) {
		this.text_field = text_field;
	}

	public Timestamp getCreation_time() {
		return creation_time;
	}

	public void setCreation_time(Timestamp creation_time) {
		this.creation_time = creation_time;
	}

	public String getEndtime() {
		return endtime;
	}
	public void setEndtime(String endtime) {
		this.endtime = endtime;
	}
	public String getTable_id() {
		return table_id;
	}
	public void setTable_id(String table_id) {
		this.table_id = table_id;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
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
	
}
