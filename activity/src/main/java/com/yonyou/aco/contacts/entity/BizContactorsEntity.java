package com.yonyou.aco.contacts.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;
/**
 * 通讯录常用联系人表
 * @Date 2016-12-6
 * @author 葛鹏
 *
 */
@Entity
@Table(name = "biz_contactors")
public class BizContactorsEntity extends IdEntity implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -5442516337721503213L;
	
	/**
	 * 常用联系人ID
	 */
	private String contactsUserId;
	
	/**
	 * 创建人ID
	 */
	private String createUserId;
	
	/**
	 * 创建时间
	 */
	private String createDate;
	
	/**
	 * 删除标志
	 */
	private String dr;

	public String getContactsUserId() {
		return contactsUserId;
	}

	public void setContactsUserId(String contactsUserId) {
		this.contactsUserId = contactsUserId;
	}

	public String getCreateUserId() {
		return createUserId;
	}

	public void setCreateUserId(String createUserId) {
		this.createUserId = createUserId;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getDr() {
		return dr;
	}

	public void setDr(String dr) {
		this.dr = dr;
	}

	
}
