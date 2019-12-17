package com.yonyou.aco.arc.type.service;

import java.util.List;

import com.yonyou.aco.arc.type.entity.ArcTypeBean;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.cap.common.util.PageResult;

public interface IActTypeService {

	/**
	 * 获取所有档案管理类型
	 * @add by zhangduoyi
	 * @return
	 */
	public List<ArcTypeEntity> findAllArcTypeList();
	
	public List<ArcTypeEntity> findParentFolderList();
	
	/**
	 * 根据父类型id获取所有子类型
	 * @add by zhangduoyi
	 * @param parentId
	 * @return
	 */
	public List<ArcTypeEntity> findChildrenByPId(String parentId);
	
	/**
	 * 
	 * TODO: 获取所有档案管理类型
	 * TODO: 填入方法说明
	 * @param pageNum
	 * @param pageSize
	 * @param typeName
	 * @return
	 */
	 public PageResult<ArcTypeBean> findAllArcTypeData(int pageNum, int pageSize,
			String typeName, String typeId);
		/**
		 * 
		 * TODO: 获取所有档案管理类型
		 * TODO: 填入方法说明
		 * @param pageNum
		 * @param pageSize
		 * @param typeName
		 * @return
		 */
		 public PageResult<ArcTypeBean> findAllArcTypeData(int pageNum, int pageSize,
				String typeName,String creUser,String startTime,String endTime,String remark, String typeId);
	 
	 /**
	  * 
	  * TODO: 添加档案管理类型
	  * TODO: 填入方法说明
	  * @param atEntity
	  */
	 public void doAddArcTypeInfo(ArcTypeEntity atEntity);


	 /**
	  * 获取所有的档案管理类型
	  * TODO: 填入方法概括.
	  * TODO: 填入方法说明
	  * @return
	  */
	public List<ArcTypeEntity> findArcTypeInfo();
	/**
	 * 方法: 根据当前用户查询文件夹.
	 * @param userid
	 * @return
	 */
	public List<ArcTypeEntity> findFolderList(String userid);

	/**
	 * 方法: 根据当前用户查询文件夹.
	 * @param userid
	 * @return
	 */
	public List<ArcTypeEntity> findTypeFolderList(String userid);
	/**
	 * 
	 * TODO: 通过ID获取档案类型.
	 * TODO: 填入方法说明
	 * @param id
	 * @return
	 */
	public List<ArcTypeBean> findArcTypeInfoById(String id);
	/**
	 * 
	 * TODO: 通过ID获取档案类型.
	 * TODO: 填入方法说明
	 * @param id
	 * @return
	 */
	public ArcTypeEntity selectArcTypeInfoById(String id);

	public String doDelArcTypeById(String id);
	
	public String validate(String id);

	/**
	 * 
	 * TODO: 获取档案类型父类
	 * @return
	 */
	public List<ArcTypeBean> findAllParentArcTypeData();

	/**
	 * 
	 * TODO: 修改档案类型
	 * @param atEntity
	 */
	public void doUpdateArcTypeInfo(ArcTypeEntity atEntity);
	/**
	 * 查询最大orderby
	 * @return
	 */
	public String selectMaxOrderBy();
}
