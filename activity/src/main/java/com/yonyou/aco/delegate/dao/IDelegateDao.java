package com.yonyou.aco.delegate.dao;

import java.util.List;
import com.yonyou.cap.bpm.entity.BizSolBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;

public interface IDelegateDao extends IBaseDao{
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
	 * 根据delegateId获取biz_sol_relation表中的数据
	 * @param delegateId
	 * @return
	 */
	public List<BizSolBean> findSolRelations(String delegateId);
}
