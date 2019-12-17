package com.yonyou.aco.arc.intl.service;

import com.yonyou.aco.arc.intl.entity.ArcIntlBean;
import com.yonyou.aco.arc.intl.entity.ArcIntlEntity;
import com.yonyou.aco.arc.intl.entity.ArcIntlPageBean;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

public interface IArcIntlService {

	public void doAddArcIntlInfo(ArcIntlEntity adEntity);

	public PageResult<ArcIntlBean> findAllArcIntlData(int pageNum,
			int pageSize, String arcName, String proName, String startTime,
			String endTime,String year,String fileStart,ShiroUser user);

	public ArcIntlBean findArcIntlByArcId(String arcId,String fileStart);

	public void doUpdateArcIntlInfo(ArcIntlEntity adEntity);
	public PageResult<ArcIntlPageBean> findAllArcIntlData(int pageNum,
			int pageSize, String arcName, String proName, String startTime,
			String endTime,String year,String fileStart,ShiroUser user, String sortName, String sortOrder);
}
