package com.yonyou.aco.leaddesktop.dao;

import java.util.List;

import com.yonyou.aco.leaddesktop.entity.LeadDktpMenuEntity;
import com.yonyou.aco.leaddesktop.entity.LeadDktpYjEntity;
import com.yonyou.cap.bpm.entity.DeskTaskBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.isc.menu.entity.Module;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * <p>概述：业务模块领导桌面 Dao接口
 * <p>功能：实现对领导桌面业务数据处理接口类
 * <p>作者：葛鹏
 * <p>创建时间：2016年12月6日
 * <p>类调用特殊情况：无
 */
public interface LeadDeskTopDao extends IBaseDao{
	/**
	 * 插入或更新自定义菜单实体
	 * @param entity
	 */
	public void saveLeadDktpEntity(LeadDktpMenuEntity entity)throws Exception;
	
	/**
	 * 根据节点ID获取Module实体
	 * @param ModuleId
	 * @return
	 */
	public Module getModuleById(String ModuleId) throws Exception;
	
	
	/**
	 * 判断该菜单是否被选中
	 * @param ModuleId
	 * @return
	 * @throws Exception
	 */
	public String isChecked(String ModuleId) throws Exception;
	
	/**
	 * 删除节点
	 * @param modId
	 * @throws Exception
	 */
	public void removeCustomMenu(String modId,ShiroUser user) throws Exception;
	
	/**
	 * 批量删除除了modIds的所有节点
	 * @param modIds
	 * @throws Exception
	 */
	public void removeAll(ShiroUser user) throws Exception;
	
	
	/**
	 * 获取已勾选
	 * @throws Exception
	 */
	public List<LeadDktpMenuEntity> getChecked(ShiroUser user) throws Exception;
	
	/**
	 * 查询处理意见
	 * @throws Exception
	 */
	public LeadDktpYjEntity findYj(String clyj,ShiroUser user) throws Exception;

	/**
	 * 查找所有处理意见
	 * @throws Exception
	 */
	public List<LeadDktpYjEntity> findAllComment(String userId) throws Exception;
	/**
	 * 查找所有数据
	 * @throws Exception
	 */
	public List<DeskTaskBean> findDeskTaskList(String bizid,String userid);
	/**
	 * 通过actid获得当前acttype
	 * @throws Exception
	 */
	public String findActTypeByActId(String actId);
}
