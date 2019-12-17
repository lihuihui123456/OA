package com.yonyou.aco.contacts.entity;

import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.GenericGenerator;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * 
 * @ClassName: BizAddressBookGroupEntity
 * @Description: 通讯录分组实体类
 * @author hegd
 * @date 2016-8-11 上午11:23:39
 */
@Entity
@Table(name = "biz_contacts_group")
public class BizContactsGroupEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 组ID */
	private String groupId;
	/** 组名 */
	private String groupName;
	/** 创建用户ID */
	private String createUserId;
	/** 创建时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date createTime;
	/** 删除行 Y已删除 N未删除 */
	private String dr;
	/** 备注 */
	private String remark;
	/** 创建时间 */
	@Transient
	private String create_time;

	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	@Column(name = "groupId", unique = true, nullable = false, length = 64)
	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public String getCreateUserId() {
		return createUserId;
	}

	public void setCreateUserId(String createUserId) {
		this.createUserId = createUserId;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getDr() {
		return dr;
	}

	public void setDr(String dr) {
		this.dr = dr;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	@Transient
	public String getCreate_time() {
		if (this.createTime == null || "".equals(this.createTime)) {
			return this.create_time;
		} else {
			Date time = this.createTime;
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			return sdf.format(time);
		}
	}
	@Transient
	public void setCreate_time(String create_time) {
		this.create_time = create_time;
	}

}
