package com.yonyou.aco.arc.bid.dao;

import com.yonyou.aco.arc.bid.entity.ArcBidBean;
import com.yonyou.cap.common.base.IBaseDao;


/**
 * 
 * TODO: 招投标Dao接口类.
 * TODO: 填写Class详细说明 
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年12月22日
 * @author  hegd
 * @since   1.0.0
 */
public interface IArcBidDao extends IBaseDao{

	/**
	 * 
	 * TODO: 通过Id获取招投标基本信息
	 * TODO: 填入方法说明
	 * @param arcId
	 * @return
	 */
	public ArcBidBean findArcBidByArcId(String arcId,String fileStart);

}
