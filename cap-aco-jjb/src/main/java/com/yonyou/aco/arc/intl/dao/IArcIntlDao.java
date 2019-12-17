package com.yonyou.aco.arc.intl.dao;

import com.yonyou.aco.arc.intl.entity.ArcIntlBean;
import com.yonyou.cap.common.base.IBaseDao;

/**
 * 
 * TODO: 内部项目档案do接口类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年12月29日
 * @author  hegd
 * @since   1.0.0
 */
public interface IArcIntlDao extends IBaseDao {

	public ArcIntlBean findArcIntlByArcId(String arcId,String fileStart);

	
}
