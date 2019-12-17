package com.yonyou.aco.arc.dclr.dao;

import com.yonyou.aco.arc.dclr.entity.ArcDclrBean;
import com.yonyou.cap.common.base.IBaseDao;

public interface IArcDclrDao extends IBaseDao{

	public ArcDclrBean findArcDclrByArcId(String arcId,String fileStart);


}
