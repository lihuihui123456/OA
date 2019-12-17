package com.yonyou.aco.lucene.entity;

import java.io.Serializable;

public class DbsSql implements Serializable{

	private static final long serialVersionUID = 1094631691712971335L;

	private String luce_id;//主键id,唯一标识
	private String luce_title;//标题
	private String luce_contents;//内容,描述
	private String luce_path;//查看链接url
	private String luce_time;//创建时间
	private String luce_role;//权限字段,若无则传""
	private String index_type;//索引类型,1:通知公告;2:收发文;3:传阅件;4:工作事项;5:物资管理;6:附件下载
	private String luce_condition;//正文字段
	private String luce_annex;//附件id
	private String luce_document;//附件主键(字段名称)
	private String luce_key;//其他业务字段,若无则传""
	
	public String getLuce_id() {
		return luce_id;
	}

	public void setLuce_id(String luce_id) {
		this.luce_id = luce_id;
	}

	public String getLuce_title() {
		return luce_title;
	}

	public void setLuce_title(String luce_title) {
		this.luce_title = luce_title;
	}

	public String getLuce_contents() {
		return luce_contents;
	}

	public void setLuce_contents(String luce_contents) {
		this.luce_contents = luce_contents;
	}

	public String getLuce_path() {
		return luce_path;
	}

	public void setLuce_path(String luce_path) {
		this.luce_path = luce_path;
	}

	public String getLuce_time() {
		return luce_time;
	}

	public void setLuce_time(String luce_time) {
		this.luce_time = luce_time;
	}

	public String getLuce_role() {
		return luce_role;
	}

	public void setLuce_role(String luce_role) {
		this.luce_role = luce_role;
	}

	public String getIndex_type() {
		return index_type;
	}

	public void setIndex_type(String index_type) {
		this.index_type = index_type;
	}

	public String getLuce_condition() {
		return luce_condition;
	}

	public void setLuce_condition(String luce_condition) {
		this.luce_condition = luce_condition;
	}

	public String getLuce_annex() {
		return luce_annex;
	}

	public void setLuce_annex(String luce_annex) {
		this.luce_annex = luce_annex;
	}

	public String getLuce_document() {
		return luce_document;
	}

	public void setLuce_document(String luce_document) {
		this.luce_document = luce_document;
	}

	public String getLuce_key() {
		return luce_key;
	}

	public void setLuce_key(String luce_key) {
		this.luce_key = luce_key;
	}
}