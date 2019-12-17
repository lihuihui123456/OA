package com.yonyou.aco.delegate.service;

import java.util.List;

import com.yonyou.cap.bpm.entity.BizRuDelegateEntity;
import com.yonyou.cap.bpm.entity.BizSolBean;
import com.yonyou.cap.bpm.entity.BizSolRelationEntity;
import com.yonyou.cap.common.util.PageResult;


public interface IDelegateService {
	/**
	 * 获取所有委托信息
	 * @param pagen
	 * @param rows
	 * @param title 查询信息
	 * @return
	 */
	public PageResult<BizRuDelegateEntity> findDelegateList(int pageNum, int pageSize,String title,String sortName,String sortOrder,String userid);
	/**
	 * 获取和userid有关的业务解决方案信息
	 * @param pagen
	 * @param rows
	 * @param title 查询信息
	 * @param userid
	 * @return
	 */
	public PageResult<BizSolBean> findSolList(int pageNum, int pageSize,String userid,String title);
	/**
	 * 保存委托配置信息
	 */
	public void doAddDelegate(BizRuDelegateEntity delegateEntity);
	/**
	 * 保存委托事项信息
	 */
	public void doAddSolRelation(BizSolRelationEntity solRelationEntity);
	/**
	 * 删除委托事项信息
	 */
	public void doDelDelegate(String[] ids,String[] delegates);
	/**
	 * 根据delegateId获取biz_sol_relation表中的数据
	 * @param delegateId
	 * @return
	 */
	public List<BizSolBean> findSolRelations(String delegateId);
	/**
	 * 根据主键获取委托信息
	 * @param Id
	 * @return
	 */
	public BizRuDelegateEntity findBizRuDelegateEntityById(String id);
	/**
	 * 更新委托信息
	 */
	public void doUpdateDelegate(BizRuDelegateEntity delegateEntity);
	/**
	 * 删除biz_sol_relation信息
	 */
	public void doDelete(String id);
}
