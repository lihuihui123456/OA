package com.yonyou.aco.arc.type.service.impl;





import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.arc.type.dao.IActTypeDao;
import com.yonyou.aco.arc.type.entity.ArcTypeBean;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.aco.arc.type.service.IActTypeService;
import com.yonyou.cap.common.util.PageResult;

@Service("actTypeService")
public class ActTypeServiceImpl  implements IActTypeService {

	@Resource IActTypeDao actTypeDao;
	
	@Override
	public List<ArcTypeEntity> findAllArcTypeList() {
		return actTypeDao.getListBySql(ArcTypeEntity.class, " o.dr='N' AND o.isPrnt='Y' ", null, null);
	}

	@Override
	public List<ArcTypeEntity> findChildrenByPId(String parentId) {
		return actTypeDao.getListBySql(ArcTypeEntity.class, " o.dr='N' AND o.prntId=? ", new Object[]{parentId}, null);
	}
	
	@Override
	public PageResult<ArcTypeBean> findAllArcTypeData(int pageNum,
			int pageSize, String typeName, String typeId) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT a.ID Id,trim(a.ARC_TYPE) arcType,a.CRE_TIME createTime,a.TYPE_NAME typeName,"
				+ "a.REMARK remark, u.USER_NAME userName FROM biz_arc_type_info a LEFT JOIN isc_user u ON a.CRE_USER = u.USER_ID ");
		sb.append("WHERE a.DR='N' and a.PRNT_ID!=''");
		if(!StringUtils.isEmpty(typeId)){
		if(!"123456".equalsIgnoreCase(typeId)){
			sb.append(" AND a.PRNT_ID = '"+typeId+"'");
		}
		}
		if(StringUtils.isEmpty(typeName)){
		}else{
			sb.append(" AND a.TYPE_NAME LIKE '%"+typeName+"%'");
		}
		sb.append("ORDER BY A.ORDER_BY ASC");
		PageResult<ArcTypeBean>  page = null;
		try {
			page = actTypeDao.getPageData(ArcTypeBean.class, pageNum, pageSize,sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return page;
	}

	@Override
	public void doAddArcTypeInfo(ArcTypeEntity atEntity) {
		actTypeDao.save(atEntity);
	}

	@Override
	public List<ArcTypeEntity> findArcTypeInfo() {
		return actTypeDao.findArcTypeInfo();
	}

	@Override
	public List<ArcTypeBean> findArcTypeInfoById(String id) {
		return actTypeDao.findArcTypeInfoById(id);
	}

	@Override
	public List<ArcTypeEntity> findTypeFolderList(String userid) {
		String wheresql = "is_prnt='Y' and dr='N' ORDER BY ORDER_BY ASC";
		return actTypeDao.getListBySql(ArcTypeEntity.class, wheresql, null,
				null);
	}

	@Override
	public String doDelArcTypeById(String id) {
		String result="true";
		if(StringUtils.isEmpty(id)){
			result="false";
		}else if(actTypeDao.validate(id) == "N"){
			result="false";
		}
		else{
			actTypeDao.doDelArcTypeById(id);
		}
		return result;
		
	}

	@Override
	public List<ArcTypeBean> findAllParentArcTypeData() {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT a.ID Id,trim(a.ARC_TYPE) arcType,a.CRE_TIME createTime,u.USER_NAME userName,a.TYPE_NAME typeName,"
				+ "a.REMARK remark FROM biz_arc_type_info a INNER JOIN isc_user u ON a.CRE_USER = u.USER_ID ");
		sb.append("WHERE a.DR='N' AND a.PRNT_ID ='' ");
		sb.append("ORDER BY A.ORDER_BY ASC");
		PageResult<ArcTypeBean>  page = null;
		try {
			page = actTypeDao.getPageData(ArcTypeBean.class, Integer.MIN_VALUE, Integer.MAX_VALUE,sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return page.getResults();
	}

	@Override
	public void doUpdateArcTypeInfo(ArcTypeEntity atEntity) {
		actTypeDao.update(atEntity);
	}

	public List<ArcTypeEntity> findFolderList(String userid) {
		String wheresql = "dr='N' ORDER BY ORDER_BY ASC";
		return actTypeDao.getListBySql(ArcTypeEntity.class, wheresql, null,
				null);
	}

	@Override
	public List<ArcTypeEntity> findParentFolderList() {
		List<ArcTypeEntity> arcEntity = actTypeDao.getListBySql(ArcTypeEntity.class, null, null,
				null);
		List<ArcTypeEntity> listResult = new ArrayList<ArcTypeEntity>();
		for(ArcTypeEntity arcTypeEntity:arcEntity){
			if(StringUtils.isBlank(arcTypeEntity.getPrntId())){
				listResult.add(arcTypeEntity);
			}
		}
		return listResult;
	}

	@Override
	public ArcTypeEntity selectArcTypeInfoById(String id) {
		return (ArcTypeEntity)actTypeDao.findEntityByPK(ArcTypeEntity.class, id);
	}

	@Override
	public String selectMaxOrderBy() {
		return actTypeDao.selectMaxOrderBy();
	}

	@Override
	public PageResult<ArcTypeBean> findAllArcTypeData(int pageNum,
			int pageSize, String typeName, String creUser, String startTime,
			String endTime, String remark, String typeId) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT a.ID Id,trim(a.ARC_TYPE) arcType,a.CRE_TIME createTime,a.TYPE_NAME typeName,"
				+ "a.REMARK remark, u.USER_NAME userName FROM biz_arc_type_info a LEFT JOIN isc_user u ON a.CRE_USER = u.USER_ID ");
		sb.append("WHERE a.DR='N' and a.PRNT_ID!='' ");
		if(!StringUtils.isEmpty(typeId)){
		if(!"123456".equalsIgnoreCase(typeId)){
			sb.append(" AND a.PRNT_ID = '"+typeId+"'");
		}
		}
		if(!StringUtils.isEmpty(typeName)){
			sb.append(" AND a.TYPE_NAME LIKE '%"+typeName+"%'");
		}
		if(!StringUtils.isEmpty(creUser)){
			sb.append(" AND u.USER_NAME LIKE '%"+creUser+"%'");
		}
	   if(!StringUtils.isEmpty(remark)){
		   sb.append(" AND a.REMARK LIKE '%"+remark+"%'");
		}
	   if(!StringUtils.isEmpty(startTime)){
		   sb.append(" AND a.CRE_TIME>='"+startTime+"'");
		}
	   if(!StringUtils.isEmpty(endTime)){
		   sb.append(" AND a.CRE_TIME<='"+endTime+"'");
		}
		sb.append(" ORDER BY A.ORDER_BY ASC");
		PageResult<ArcTypeBean>  page = null;
		try {
			page = actTypeDao.getPageData(ArcTypeBean.class, pageNum, pageSize,sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return page;
	}

	@Override
	public String validate(String id) {
		return actTypeDao.validate(id);
	}

}
