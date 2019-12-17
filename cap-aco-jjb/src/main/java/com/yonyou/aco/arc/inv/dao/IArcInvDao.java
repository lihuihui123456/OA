package com.yonyou.aco.arc.inv.dao;

import com.yonyou.aco.arc.inv.entity.ArcInvBean;
import com.yonyou.cap.common.base.IBaseDao;

/**
 * 
 * TODO: 项目投资档案dao接口类
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年12月29日
 * @author  hegd
 * @since   1.0.0
 */
public interface IArcInvDao extends IBaseDao{

	public ArcInvBean findArcInvByArcId(String arcId,String fileStart);


}
