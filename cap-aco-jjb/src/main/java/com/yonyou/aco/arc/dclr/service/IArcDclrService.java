package com.yonyou.aco.arc.dclr.service;

import com.yonyou.aco.arc.dclr.entity.ArcDclrBean;
import com.yonyou.aco.arc.dclr.entity.ArcDclrEntity;
import com.yonyou.aco.arc.dclr.entity.ArcDclrPageBean;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

public interface IArcDclrService {

	/**
	 * 
	 * TODO: 通过档案Id获取申报课题
	 * @param arcId
	 * @return
	 */
	public ArcDclrBean findArcDclrByArcId(String arcId,String fileStart);

	/**
	 * 
	 * TODO: 通过条件获取申报课题档案信息
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @param dclrCo
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public PageResult<ArcDclrBean> findAllArcDclrData(int pageNum,
			int pageSize, String arcName, String proName, String startTime,
			String endTime,String year,String proCom,String fileStart,ShiroUser user);
	/**
	 * 
	 * TODO: 通过条件获取申报课题档案信息
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @param dclrCo
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public PageResult<ArcDclrPageBean> findAllArcDclrData(int pageNum,
			int pageSize, String arcName, String proName, String startTime,
			String endTime,String year,String proCom,String fileStart,ShiroUser user,String sortName, String sortOrder);
	/**
	 * 
	 * TODO: 添加申报课题档案信息
	 * @param adEntity
	 */
	public void doAddArcDclrInfo(ArcDclrEntity adEntity);

	/**
	 * 
	 * TODO:修改申报课题档案信息
	 * @param adEntity
	 */
	public void doUpdateArcIntlInfo(ArcDclrEntity adEntity);

}
