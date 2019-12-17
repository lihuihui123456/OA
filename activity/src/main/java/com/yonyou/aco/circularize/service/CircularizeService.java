package com.yonyou.aco.circularize.service;

import java.util.List;

import com.yonyou.aco.circularize.entity.BizCircularizeBasicInfoEntity;
import com.yonyou.aco.circularize.entity.BizCircularizeLinkEntity;
import com.yonyou.cap.bpm.entity.DeskTaskBean;
import com.yonyou.cap.common.util.PageResult;


public interface CircularizeService {

	
	/**
	 * 
	 * TODO: 填入方法概括.
	 * TODO: 填入方法说明
	 * @param pageNum
	 * @param pageSize
	 * @param wheresql
	 * @return
	 */
	public PageResult<BizCircularizeBasicInfoEntity> getAllBasicinfo(int pageNum,int pageSize,String wheresql);
	/**
	 * 
	 * TODO: 填入方法概括.
	 * TODO: 填入方法说明
	 * @param basicinformation
	 * @return
	 */
	public String saveInfo(BizCircularizeBasicInfoEntity basicinformation);
	/**
	 * 
	 * TODO: 填入方法概括.
	 * TODO: 填入方法说明
	 * @param id
	 * @return
	 */
	public BizCircularizeBasicInfoEntity queryBasicById(String id);
	/**
	 * 
	 * TODO: 填入方法概括.
	 * TODO: 填入方法说明
	 * @param id
	 * @return
	 */
	public String queryGTasksstatus(Long id);
	/**
	 * 
	 * TODO: 填入方法概括.
	 * TODO: 填入方法说明
	 * @param circulatedpeopleid
	 * @param mustseeid
	 * @param sceneid
	 * @param id
	 */
	public void saveLink(String circulatedpeopleid,String mustseeid,String sceneid,String id);
	
	
	
	public List<DeskTaskBean> findCyLinkList(String userid);
	
	public String getMaxTableid();
	
	public PageResult<BizCircularizeBasicInfoEntity> getAllBasicinfoJs(int pageNum,int pageSize, String userid, String query);
	
	public BizCircularizeLinkEntity queryLinkById(String id, String bid);
	
	public void saveLinkInfo(BizCircularizeLinkEntity bean);
	
	public PageResult<BizCircularizeLinkEntity> getAllLinkinfo(String id);
	
	public void deleteById(String id);
	
	public BizCircularizeLinkEntity getCount(String id);
	
	public String doUpdateInfo(BizCircularizeBasicInfoEntity basicinformation);
	
}
