package com.yonyou.aco.contacts.dao;

import java.util.List;

import com.yonyou.aco.contacts.entity.BizContactsUserBean;
import com.yonyou.aco.contacts.entity.ContactsUserBean;
import com.yonyou.aco.contacts.entity.ContactsUserInfoBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
/**
 * <p>概述：业务模块通讯录导出Dao层
 * <p>功能：通讯录
 * <p>作者：葛鹏
 * <p>创建时间：2017年2月23日
 * <p>类调用特殊情况：无
 */
public interface IBizContactsDao extends IBaseDao {
	
	/**
	 * @param searchValue
	 * @param userId
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	public PageResult<BizContactsUserBean> findAllUserBySearchValue(String searchValue,
			String userId,int pageNum,int pageSize);
	/**
	 * @param userId
	 * @param orgId
	 * @return
	 */
	public List<BizContactsUserBean> findMobileBizContactsUserInfo(
			String userId, String orgId);
	
	/**
	 * @param userId
	 * @return
	 */
	public String findOrgIdByUserId(String userId);
	/**
	 * @param userId
	 * @return
	 */
	public String findOrgNameByUserId(String userId);
	
	/**
	 * 查询机构
	 * @return
	 */
	public List<Dept> findDeptList();

	
	/**
	 * 查询部门下的人员信息
	 * @return
	 */
	public PageResult<ContactsUserBean> findUserByDept(int pageNum,int pageSize,String deptId,String word,String param);
	/**
	 * 查询部门下的人员信息
	 * @param pageNum
	 * @param pageSize
	 * @param userIds
	 * @return
	 */
	public PageResult<ContactsUserBean> findUserByDept(int pageNum,int pageSize,String userIds,String isSelectorNot);
	
	/**
	 * 增加常用联系人
	 * @param userIds
	 */
	public void addAlwaysContactors(String userIds,ShiroUser user);
	/**
	 * 删除常用联系人
	 * @param userIds
	 */
	public void deleteAlwaysContactors(String userIds,ShiroUser user);
	/**
	 * 查询常用联系人是否已经存在
	 * @return
	 */
	public boolean isHasAlwaysContactors(String sendUserId,String receiverUserId);
	/**
	 * 查询常用联系人
	 * @return
	 */
	public PageResult<ContactsUserBean> findAlwaysContactors(int pageNum,int pageSize,String word,String param,ShiroUser user);
	
	/**
	 * 查询某常用联系信息
	 * @param userId
	 * @return
	 */
	public ContactsUserBean queryContactor(String userId);
	
	
	/**
	 * 查询所有人
	 * @return
	 */
	public List<ContactsUserInfoBean> queryAllUserData();
	
	/**
	 * 查询常用联系人
	 * @return
	 */
	public List<ContactsUserInfoBean> queryAllContactors(String userId);
	
}
