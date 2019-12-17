package com.yonyou.aco.earc.acctvchr.service.impl;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.earc.acctvchr.dao.IEarcDao;
import com.yonyou.aco.earc.acctvchr.entity.EarcBean;
import com.yonyou.aco.earc.acctvchr.entity.EarcBizIEntity;
import com.yonyou.aco.earc.acctvchr.service.IEarcService;
import com.yonyou.cap.common.util.PageResult;

@Service("earcService")
public class EarcServiceImpl implements IEarcService {

	@Resource
	IEarcDao earcDao;

	@Override
	public PageResult<EarcBean> findEarcAcctVchrInfo(int pageNum, int pageSize,
			String solId, String acctVchrName, String sortName,
			String sortOrder, String userId,String queryParams) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT b.ID_ ,b.SOL_ID_,b.BIZ_TITLE_ ,u.USER_NAME CREATE_USER_ID_,trim(e.SECURITY_LEVEL) "
				+ "SECURITY_LEVEL, e.TERM,trim(e.OPER_TIME) OPER_TIME,trim(e.EARC_STATE) EARC_STATE "
				+ "FROM bpm_ru_biz_info b INNER JOIN earc_biz_info e ON e.EARC_ID = b.ID_ INNER JOIN isc_user u "
				+ "ON u.USER_ID = b.CREATE_USER_ID_");
		sb.append(" WHERE b.SOL_ID_='" + solId + "' AND  b.DR_='N' AND b.CREATE_USER_ID_='"
				+ userId + "'");
		// 简单查询
		if (StringUtils.isNotBlank(acctVchrName)) {
			sb.append(" AND b.BIZ_TITLE_ LIKE '%" + acctVchrName + "%'");
		}
		// 列表高级查询
		if (StringUtils.isNotBlank(queryParams)) {
			String[] paramsArr = queryParams.split("&");
			if (paramsArr != null && paramsArr.length > 0) {
				String[] keyValueArr;
				for (String keyValue : paramsArr) {
					keyValueArr = keyValue.split("=");
					if (keyValueArr.length == 2) {
						String key = keyValueArr[0];
						String value = keyValueArr[1];
						if (StringUtils.isNotBlank(key)
								&& StringUtils.isNotBlank(value)) {
							if ("BIZ_TITLE_".equals(key)) {
								sb.append(" AND BIZ_TITLE_ like '%" + value.trim()+ "%'");
							} else if ("CREATE_USER_ID_".equals(key)) {
								sb.append(" AND CREATE_USER_ID_ = '" + value+"'");
							} else if ("TERM".equals(key)) {
								sb.append(" AND TERM = '" + value+"'");
							}else if ("SECURITY_LEVEL".equals(key)) {
								sb.append(" AND SECURITY_LEVEL = '" + value+ "'");
							} else if ("EARC_STATE".equals(key)) {
								sb.append(" AND EARC_STATE = '" + value + "'");
							} else if ("CREATE_TIME_START_".equals(key)) {
								sb.append(" AND OPER_TIME >= '" + value + "'");
							} else if ("CREATE_TIME_END_".equals(key)) {
								sb.append(" AND OPER_TIME <= '" + value + "'");
							}
						}
					}
				}
			}
		}
		// 列表排序功能
		if (StringUtils.isNotBlank(sortName)
				&& StringUtils.isNotBlank(sortOrder)) {
			sb.append(" ORDER BY CONVERT(" + sortName + " USING gbk) "
					+ sortOrder);
		} else {
			sb.append(" ORDER BY b.CREATE_TIME_ DESC");
		}
		
		return earcDao.getPageData(EarcBean.class, pageNum, pageSize,
				sb.toString());

	}

	@Override
	public void doSaveEarcState(EarcBizIEntity ebEntity) {
		earcDao.update(ebEntity);
	}

	@Override
	public void earcFileByCtlgId(String earcId, String earcCtlgId) {
		earcDao.earcFileByCtlgId(earcId, earcCtlgId);
	}

	@Override
	public void updateEarcStateByEarcId(String earcId, String earcState) {
		earcDao.updateEarcStateByEarcId(earcId, earcState);
		
	}

	@Override
	public void doSaveEarcBizInfo(EarcBizIEntity ebEntity) {
		earcDao.save(ebEntity);
	}

}
