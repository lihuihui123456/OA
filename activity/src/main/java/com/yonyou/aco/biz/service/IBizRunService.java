package com.yonyou.aco.biz.service;

import java.util.List;

import com.yonyou.aco.biz.entity.BizNodeFormBean;
import com.yonyou.cap.bpm.entity.BpmReSolInfoEntity;

public interface IBizRunService {

	/**
	 *  获取业务模型基本信息
	 *  @param	主键id
	 */
	public BpmReSolInfoEntity getBpmReSolInfoEntity(String id);
	
	/**
	 * 获取业务模型绑定的不同作用域的表单信息
	 * @param solId 解决方案Id
	 * @param scope 作用域 2： 明细表单 3：开始表单 4：全局表单
	 * @return
	 */
	public List<BizNodeFormBean> findNodeFormInfo(String solId,String scope);
	
	/**
	 * 获取业务模型绑定的不同作用域的表单信息
	 * @param solId 解决方案Id
	 * @param scope 作用域 2： 明细表单 3：开始表单 4：全局表单
	 * @return
	 */
	public List<BizNodeFormBean> findNodeFormInfo(String solId);
	/**
	 * 模糊获取收发文信息  发文文:1001***  收文:1001***  
	 * @param bizCode 收发文类型code
	 * 用于查询 收发文类型
	 * @return
	 */
	public List<BizNodeFormBean> findNodeFormInfoList(String bizCode);

}