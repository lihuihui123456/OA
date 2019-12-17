package com.yonyou.aco.contacts.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

/**
 * 
 * @ClassName: BizRoleAddressBookEntity
 * @Description:通讯录用户分组关联实体类
 * @author hegd
 * @date 2016-8-11 下午1:46:05
 */
@Entity
@Table(name = "biz_cuser_ref_cgroup")
public class BizCuserRefCgroupEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 主键ID */
	private String id;
	/** 组ID */
	private String groupId;

	/** 用户ID */
	private String userId;

	
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	@Column(name = "id", unique = true, nullable = false, length = 64)
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

}
