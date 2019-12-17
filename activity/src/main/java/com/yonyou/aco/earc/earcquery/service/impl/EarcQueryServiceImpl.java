package com.yonyou.aco.earc.earcquery.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.earc.earcquery.dao.IEarcQueryDao;
import com.yonyou.aco.earc.earcquery.entity.EarcQuery;
import com.yonyou.aco.earc.earcquery.entity.EarcQueryBean;
import com.yonyou.aco.earc.earcquery.service.IEarcQueryService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.dataauth.datarule.service.IDataRuleService;

/**
 * 
 * TODO: 档案总库查询服务层实现类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年5月3日
 * @author 贺国栋
 * @since 1.0.0
 */
@Service("earcQueryService")
public class EarcQueryServiceImpl implements IEarcQueryService {

	@Resource
	IEarcQueryDao earcQueryDao;

	@Resource
	IDataRuleService dataRuleService;

	@Override
	public PageResult<EarcQueryBean> findEarcDateAll(String modeCode,
			int pageNum, int pageSize,String ctlgId, String userId, String title,
			String sortName, String sortOrder, String queryParams) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT b.ID_,b.SOL_ID_,b.BIZ_TITLE_ BIZ_TITLE_,u.USER_NAME CREATE_USER_ID_,"
				+ " c.SOL_CTLG_NAME_ EARC_TYPE,trim(e.SECURITY_LEVEL) SECURITY_LEVEL,trim(e.OPER_TIME) OPER_TIME,"
				+ "trim(e.EARC_STATE) EARC_STATE  "
				+ "FROM bpm_ru_biz_info b INNER JOIN earc_biz_info e "
				+ "ON e.EARC_ID = b.ID_ INNER JOIN isc_user u "
				+ "ON u.USER_ID = b.CREATE_USER_ID_ "
				+ "INNER JOIN bpm_re_sol_ctlg c ON "
				+ "c.code = e.EARC_TYPE ");

		sb.append(" WHERE b.DR_='N' AND e.EARC_STATE !='0' ");
		// 列表数据权限
/*		SqlParam sqlParam = dataRuleService.createSqlParam(modeCode, "b");
*/		/*if (sqlParam != null && sqlParam.isHasDataRole()) {
			sb.append(sqlParam.getParam());
		} else {
			sb.append(" AND b.CREATE_USER_ID_ ='" + userId + "' ");
		}*/
		// 简单查询
		if (StringUtils.isNotBlank(title)) {
			sb.append(" AND b.BIZ_TITLE_ like '%" + title + "%'");
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
								sb.append(" AND b.BIZ_TITLE_ like '%" + value.trim()+ "%'");
							} else if ("CREATE_USER_ID_".equals(key)) {
								sb.append(" AND b.CREATE_USER_ID_ = '" + value+ "'");
							} else if ("EARC_TYPE".equals(key)) {
								sb.append(" AND c.SOL_CTLG_NAME_ LIKE '%" + value+ "%'");
							} else if ("SECURITY_LEVEL".equals(key)) {
								sb.append(" AND e.SECURITY_LEVEL = '" + value+ "'");
							} else if ("EARC_STATE".equals(key)) {
								sb.append(" AND e.EARC_STATE = '" + value + "'");
							} else if ("advStartDate".equals(key)) {
								sb.append(" AND e.OPER_TIME >= '" + value + "'");
							} else if ("advEndDate".equals(key)) {
								sb.append("  AND e.OPER_TIME <= '" + value + "'");
							}else if ("TEAM".equals(key)) {
									sb.append("  AND e.TEAM = '" + value + "'");
								}
						}
					}
				}
			}
		}
		//目录查询
		if(StringUtils.isNotBlank(ctlgId) && !"07f6190b-f3e9-4fc5-a00e-d6a742b43b31".equals(ctlgId)){
			sb.append(" AND e.EARC_CTLG_ID='"+ctlgId+"'");
		}
		// 列表排序功能
		if (StringUtils.isNotBlank(sortName)
				&& StringUtils.isNotBlank(sortOrder)) {
			sb.append(" ORDER BY CONVERT(" + sortName + " USING gbk) "
					+ sortOrder);
		} else {
			sb.append(" ORDER BY b.CREATE_TIME_ DESC");
		}
		return earcQueryDao.getPageData(EarcQueryBean.class, pageNum, pageSize,
				sb.toString());
	}

	@Override
	public List<EarcQueryBean> findEarcDateAll(String modeCode,
			String ctlgId, String userId, String title, EarcQuery earcQuery) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT b.ID_,b.SOL_ID_,b.BIZ_TITLE_ BIZ_TITLE_,u.USER_NAME CREATE_USER_ID_,"
				+ " c.SOL_CTLG_NAME_ EARC_TYPE,trim(e.SECURITY_LEVEL) SECURITY_LEVEL,trim(e.OPER_TIME) OPER_TIME,"
				+ "trim(e.EARC_STATE) EARC_STATE  "
				+ "FROM bpm_ru_biz_info b INNER JOIN earc_biz_info e "
				+ "ON e.EARC_ID = b.ID_ INNER JOIN isc_user u "
				+ "ON u.USER_ID = b.CREATE_USER_ID_ "
				+ "INNER JOIN bpm_re_sol_ctlg c ON "
				+ "c.code = e.EARC_TYPE ");

		// 列表数据权限
		sb.append(" WHERE b.DR_='N'AND e.EARC_STATE !='0' ");
/*		SqlParam sqlParam = dataRuleService.createSqlParam(modeCode, "b");
*/		/*if (sqlParam != null && sqlParam.isHasDataRole()) {
			sb.append(sqlParam.getParam());
		} else {
			sb.append(" AND b.CREATE_USER_ID_ ='" + userId + "' ");
		}*/
		// 简单查询
		if (StringUtils.isNotBlank(title)) {
			sb.append(" AND b.BIZ_TITLE_ like '%" + title + "%'");
		}
		// 列表高级查询
		if (StringUtils.isNotBlank(earcQuery.getBIZ_TITLE_())) {
			sb.append(" AND b.BIZ_TITLE_ like '%" + earcQuery.getBIZ_TITLE_() + "%'");
		}
		if (StringUtils.isNotBlank(earcQuery.getCREATE_USER_ID_())) {
			sb.append(" AND b.CREATE_USER_ID_ = '" + earcQuery.getCREATE_USER_ID_()+ "'");
	
		}
		if (StringUtils.isNotBlank(earcQuery.getEARC_TYPE())) {
			sb.append(" AND c.SOL_CTLG_NAME_ LIKE '%" + earcQuery.getEARC_TYPE()+ "%'");
	
		}
		if (StringUtils.isNotBlank(earcQuery.getSECURITY_LEVEL())) {
			sb.append(" AND e.SECURITY_LEVEL = '" + earcQuery.getSECURITY_LEVEL()+ "'");
	
		}
		if (StringUtils.isNotBlank(earcQuery.getEARC_STATE())) {
			sb.append(" AND e.EARC_STATE = '" + earcQuery.getEARC_STATE() + "'");
	
		}
		
		if (StringUtils.isNotBlank(earcQuery.getAdvStartDate())) {
			sb.append(" AND e.OPER_TIME >= '" + earcQuery.getAdvStartDate() + "'");
	
		}
		if (StringUtils.isNotBlank(earcQuery.getAdvEndDate())) {
			sb.append("  AND e.OPER_TIME <= '" + earcQuery.getAdvEndDate() + "'");
	
		}

/*		if (StringUtils.isNotBlank(queryParams)) {
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
								sb.append(" AND b.BIZ_TITLE_ like '%" + value.trim()+ "%'");
							} else if ("CREATE_USER_ID_".equals(key)) {
								sb.append(" AND b.CREATE_USER_ID_ = '" + value+ "'");
							} else if ("EARC_TYPE".equals(key)) {
								sb.append(" AND c.SOL_CTLG_NAME_ LIKE '%" + value+ "%'");
							} else if ("SECURITY_LEVEL".equals(key)) {
								sb.append(" AND e.SECURITY_LEVEL = '" + value+ "'");
							} else if ("EARC_STATE".equals(key)) {
								sb.append(" AND e.EARC_STATE = '" + value + "'");
							} else if ("advStartDate".equals(key)) {
								sb.append(" AND e.OPER_TIME >= '" + value + "'");
							} else if ("advEndDate".equals(key)) {
								sb.append("  AND e.OPER_TIME <= '" + value + "'");
							}else if ("TEAM".equals(key)) {
									sb.append("  AND e.TEAM = '" + value + "'");
								}
						}
					}
				}
			}
		}*/
		//目录查询
		if(StringUtils.isNotBlank(ctlgId) && !"07f6190b-f3e9-4fc5-a00e-d6a742b43b31".equals(ctlgId)){
			sb.append(" AND e.EARC_CTLG_ID='"+ctlgId+"'");
		}
		return earcQueryDao.findEarcDateAll(sb.toString());
	}

	@Override
	public EarcQueryBean findEarcQueryBeanById(String id) {
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT b.ID_,b.SOL_ID_,b.BIZ_TITLE_ BIZ_TITLE_,u.USER_NAME CREATE_USER_ID_,"
				+ " c.SOL_CTLG_NAME_ EARC_TYPE,trim(e.SECURITY_LEVEL) SECURITY_LEVEL,trim(e.OPER_TIME) OPER_TIME,"
				+ "trim(e.EARC_STATE) EARC_STATE  "
				+ "FROM bpm_ru_biz_info b INNER JOIN earc_biz_info e "
				+ "ON e.EARC_ID = b.ID_ INNER JOIN isc_user u "
				+ "ON u.USER_ID = b.CREATE_USER_ID_ "
				+ "INNER JOIN bpm_re_sol_ctlg c ON "
				+ "c.code = e.EARC_TYPE ");

		// 列表数据权限
		sb.append(" WHERE b.DR_='N' and b.ID_= '"+id+"'");
		return earcQueryDao.getPageData(EarcQueryBean.class, 1, 1,
				sb.toString()).getResults().get(0);
	}

}
