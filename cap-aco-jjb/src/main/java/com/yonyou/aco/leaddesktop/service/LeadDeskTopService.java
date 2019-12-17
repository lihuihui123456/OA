package com.yonyou.aco.leaddesktop.service;

import java.util.List;

import com.yonyou.aco.leaddesktop.entity.LeadDktpMenuBean;
import com.yonyou.aco.leaddesktop.entity.LeadDktpMenuEntity;
import com.yonyou.aco.leaddesktop.entity.LeadDktpYjEntity;
import com.yonyou.cap.bpm.entity.DeskTaskBean;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;


/**
 * <p>概述：业务模块领导桌面Service层
 * <p>功能：领导桌面
 * <p>作者：葛鹏，王瑞朝
 * <p>创建时间：2016年12月5日
 * <p>类调用特殊情况：无
 */
public interface LeadDeskTopService {
	/**
	 * 虚拟节点
	 * @return
	 */
	public List<LeadDktpMenuBean> getVirtualMenu(ShiroUser user) throws Exception;
	
	/**
	 * 非虚拟节点
	 * @return
	 */
	public List<LeadDktpMenuBean> getNonVirtualMenu(ShiroUser user) throws Exception;
	
	/**
	 * 新增自定义菜单
	 * @param modId
	 */
	public void addCustomMenu(String modId) throws Exception;
	
	/**
	 * 移除自定义菜单
	 * @param modId
	 */
	public void removeCustomMenu(String modId,ShiroUser user) throws Exception;
	
	/**
	 * 批量更新自定义菜单
	 * @param modIds
	 * @throws Exception
	 */
	public void updateCustomMenu(String modIds,ShiroUser user) throws Exception;
	
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
	 * 更新意见次数
	 * @throws Exception
	 */
	public void updateCount(LeadDktpYjEntity leader) throws Exception;

	/**
	 * 添加处理意见
	 * @throws Exception
	 */
	public void addComment(LeadDktpYjEntity leader) throws Exception;
	
	/**
	 * 查找所有处理意见
	 * @throws Exception
	 */
	public List<LeadDktpYjEntity> findAllComment(String userId) throws Exception;
	/**
	 * 查找所有数据
	 * @throws Exception
	 */
    public List<DeskTaskBean> findDeskTaskList(String bizid);
    /**
	 * 通过actid获得当前acttype
	 * @throws Exception
	 */
	public String findActTypeByActId(String actId);
	/**
	 * 批量处理阅件
	 * @throws Exception
	 */
	public String findCirculate(String ids);

}