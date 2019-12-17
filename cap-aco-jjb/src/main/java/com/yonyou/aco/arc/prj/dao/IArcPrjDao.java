package com.yonyou.aco.arc.prj.dao;

import com.yonyou.aco.arc.prj.entity.ArcPrjBean;
import com.yonyou.cap.common.base.IBaseDao;

/**
 * 
 * TODO: 工程基建档案dao接口类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年12月29日
 * @author  hegd
 * @since   1.0.0
 */
public interface IArcPrjDao extends IBaseDao {

	/**
	 * 
	 * TODO: 通过档案id获取工程基建档案信息
	 * @param arcId
	 * @return
	 */
	public  ArcPrjBean findArcPrjByArcId(String arcId,String fileStart);

}
