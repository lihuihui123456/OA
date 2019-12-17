package com.yonyou.aco.arc.prj.service;

import com.yonyou.aco.arc.prj.entity.ArcPrjBean;
import com.yonyou.aco.arc.prj.entity.ArcPrjEntity;
import com.yonyou.aco.arc.prj.entity.ArcPrjPageBean;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

public interface IArcPrjService {

	/**
	 * 
	 * TODO: 通过Id获取工程基建档案基本信息
	 * 
	 * @param arcId
	 * @return
	 */
	public ArcPrjBean findArcPrjByArcId(String arcId,String fileStart);

	/**
	 * 
	 * TODO:添加工程基建基本信息
	 * 
	 * @param abEntity
	 */
	public void doAddarcprjInfo(ArcPrjEntity abEntity);

	/**
	 * 
	 * TODO: 获取工程基建档案基本信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @param prjName
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public PageResult<ArcPrjBean> findAllArcPrjData(int pageNum, int pageSize,
			String arcName, String prjName, String startTime, String endTime,
			String year, String fileStart,ShiroUser user);
	/**
	 * 
	 * TODO: 获取工程基建档案基本信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @param prjName
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public PageResult<ArcPrjPageBean> findAllArcPrjData(int pageNum, int pageSize,
			String arcName, String prjName, String startTime, String endTime,
			String year, String fileStart,ShiroUser user,String sortName, String sortOrder);

	/**
	 * 
	 * TODO: 修改工程基建信息
	 * 
	 * @param adEntity
	 */
	public void doUpdateArcPrjInfo(ArcPrjEntity adEntity);

}
