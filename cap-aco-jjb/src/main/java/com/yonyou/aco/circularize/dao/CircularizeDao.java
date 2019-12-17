package com.yonyou.aco.circularize.dao;

import java.util.List;

import com.yonyou.aco.circularize.entity.BizCircularizeBasicInfoEntity;
import com.yonyou.aco.circularize.entity.BizCircularizeLinkEntity;
import com.yonyou.cap.bpm.entity.DeskTaskBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;


public interface CircularizeDao extends IBaseDao {

	public String queryGTasksstatus(Long id);
	
	public List<DeskTaskBean> findCyLinkList(String userid);

	public String getMaxTableid();

	public PageResult<BizCircularizeBasicInfoEntity> getAllBasicinfoJs(int pageNum,int pageSize, String userid, String query);

	public BizCircularizeLinkEntity queryLinkById(String id, String bid);

	public PageResult<BizCircularizeLinkEntity> getAllLinkinfo(String id);

	public BizCircularizeLinkEntity findLinkInfoByUserId(String id, String userid);

	public BizCircularizeLinkEntity getCount(String id);
	
}
