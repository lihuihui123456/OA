package com.yonyou.jjb.leavemgr.dao;

import java.util.List;

import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.jjb.leavemgr.entity.BizLeaveBean;
import com.yonyou.jjb.leavemgr.entity.BizLeaveEntity;

public interface ILeaveMgrDao extends IBaseDao{
	public List<BizLeaveEntity> findAllLeaveInfo(String sql,String modCode);
	public List<BizLeaveBean> findAllLeaveBeanInfo(String sql,String modCode);

}
