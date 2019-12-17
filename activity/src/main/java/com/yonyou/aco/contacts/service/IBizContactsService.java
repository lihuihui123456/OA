package com.yonyou.aco.contacts.service;

import java.util.List;

import com.yonyou.aco.contacts.entity.BizContactsUserBean;
import com.yonyou.aco.contacts.entity.ContactsUserBean;
import com.yonyou.aco.contacts.entity.ContactsUserInfoBean;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
/**
 * <p>概述：业务模块通讯录导出Service层
 * <p>功能：通讯录
 * <p>作者：葛鹏
 * <p>创建时间：2017年2月23日
 * <p>类调用特殊情况：无
 */
public interface IBizContactsService {

	
	/**
	 * 
	 * @param @param pageNum
	 * @param @param pageSize
	 * @param @param userId
	 * @param @param title
	 * @param @return   
	 * @return PageResult<BizContactsGroupEntity>  
	 * @throws
	 * @author hegd
	 * @date 2016-9-21
	 */
	public List<BizContactsUserBean> findMobileBizContactsUserInfo(String userId);
	/**
	 * 查询所有部门
	 * @return
	 */
	public List<Dept> findDeptList();
	
	/**
	 * 查询部门下的人员信息
	 * @return
	 */
	public PageResult<ContactsUserBean> findUserByDept(int pageNum,int pageSize,String deptId,String word,String param);
	
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
	 * 查询常用联系人
	 * @return
	 */
	public PageResult<ContactsUserBean> findAlwaysContactors(int pageNum,int pageSize,String word,String userName,ShiroUser user);
	
	
	/**
	 * 
	 * @Description: 通讯录-导出用户 Excel格式 POI
	 * @param @return   
	 * @return PATH  
	 * @throws
	 * @author 葛鹏
	 * @date 2017-2-27
	 */
	public String exportContactsUserToExcelByPoi(List<ContactsUserBean> list);
	
	/**
	 * 查询部门下的人员信息
	 * @param pageNum
	 * @param pageSize
	 * @param userIds
	 * @return
	 */
	public PageResult<ContactsUserBean> findUserByDept(int pageNum,int pageSize,String userIds,String isSelectorNot);
	
	
	/**
	 * 查询某常用联系信息
	 * @param userId
	 * @return
	 */
	public ContactsUserBean queryContactor(String userId);
	
	/**
	 * 判断该用户是否被收藏
	 * @param thisUserId 当前用户
	 * @param userId 被判断用户
	 * @return
	 */
	public String valIsInContactors(String thisUserId,String userId);
	
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
	
	
	/**
	 * 通过USERID查询机构名称
	 * @param userId
	 * @return
	 */
	public String getOrgNameByUserId(String userId);
}
