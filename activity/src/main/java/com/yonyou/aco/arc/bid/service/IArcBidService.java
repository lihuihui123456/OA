package com.yonyou.aco.arc.bid.service;


import com.yonyou.aco.arc.bid.entity.ArcBidBean;
import com.yonyou.aco.arc.bid.entity.ArcBidEntity;
import com.yonyou.aco.arc.bid.entity.ArcBidListBean;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 招投标档案service接口类
 * TODO: 填写Class详细说明 
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年12月22日
 * @author  hegd
 * @since   1.0.0
 */
public interface IArcBidService {

	
	/**
	 * 
	 * TODO: 新增招投标基档案
	 * TODO: 填入方法说明
	 * @param abEntity
	 */
	public void doAddArcBidInfo(ArcBidEntity abEntity);

	/**
	 * 
	 * TODO:  查询所有招投标档案信息
	 * TODO: 填入方法说明
	 * @param pageNum
	 * @param pageSize
	 * @param typeName
	 * @return
	 */
	public PageResult<ArcBidBean> findAllArcBidData(int pageNum, int pageSize,
			String arcName,String bidCo,String startTime,String endTime,String year,String fileStart,ShiroUser user);
	/**
	 * 
	 * TODO:  查询所有招投标档案信息排序
	 * TODO: 填入方法说明
	 * @param pageNum
	 * @param pageSize
	 * @param typeName
	 * @return
	 */
	public PageResult<ArcBidListBean> findAllArcBidData(int pageNum, int pageSize,
			String arcName,String bidCo,String startTime,String endTime,String year,String fileStart,ShiroUser user, String sortName, String sortOrder);
	/**
	 * 
	 * TODO: 通过Id获取招投标基本信息
	 * TODO: 填入方法说明
	 * @param arcId
	 * @return
	 */
	public ArcBidBean findArcBidByArcId(String arcId,String fileStart);

	/**
	 * 
	 * TODO: 填入方法说明
	 * @param adEntity
	 */
	public void doUpdateArcBidInfo(ArcBidEntity adEntity);

}
