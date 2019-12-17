package com.yonyou.aco.arc.inv.service;

import com.yonyou.aco.arc.inv.entity.ArcInvBean;
import com.yonyou.aco.arc.inv.entity.ArcInvEntity;
import com.yonyou.aco.arc.inv.entity.ArcInvPageBean;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 项目投资档案service接口类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
public interface IArcInvService {

	/**
	 * 
	 * TODO: 新增项目投资档案 TODO: 填入方法说明
	 * 
	 * @param adEntity
	 */
	public void doAddArcInvInfo(ArcInvEntity adEntity);

	/**
	 * 
	 * TODO: 通过档案Id查询项目投资档案 TODO: 填入方法说明
	 * 
	 * @param arcId
	 * @return
	 */
	public ArcInvBean findArcInvByArcId(String arcId,String fileStart);

	/**
	 * 
	 * TODO: 查询项目投资档案分页 TODO: 填入方法说明
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @param proName
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public PageResult<ArcInvBean> findAllArcInvData(int pageNum, int pageSize,
			String arcName, String proName, String startTime, String endTime,
			String year, String invType, String fileStart,ShiroUser user);
	/**
	 * 
	 * TODO: 查询项目投资档排序分页 TODO: 填入方法说明
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @param proName
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public PageResult<ArcInvPageBean> findAllArcInvData(int pageNum, int pageSize,
			String arcName, String proName, String startTime, String endTime,
			String year, String invType, String fileStart,ShiroUser user,String sortName ,String sortOrder);

	/**
	 * 
	 * TODO: 修改项目投资档案信息
	 * 
	 * @param adEntity
	 */
	public void doUpdateSaveArcInvInfo(ArcInvEntity adEntity);

}
