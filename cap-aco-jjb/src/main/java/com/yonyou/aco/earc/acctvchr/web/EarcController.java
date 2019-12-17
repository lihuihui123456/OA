package com.yonyou.aco.earc.acctvchr.web;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import net.sf.json.JSONArray;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.earc.acctvchr.entity.EarcBean;
import com.yonyou.aco.earc.acctvchr.entity.EarcBizIEntity;
import com.yonyou.aco.earc.acctvchr.service.IEarcService;
import com.yonyou.aco.earc.ctlg.entity.EarcCtlgTreeBean;
import com.yonyou.aco.earc.ctlg.service.IEarcCtlgService;
import com.yonyou.cap.common.util.DataGridView;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 电子档案控制层 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年5月2日
 * @author 贺国栋
 * @since 1.0.0
 */
@Controller
@RequestMapping("/earcController")
public class EarcController {

	@Resource
	IEarcService earcService;

	@Resource
	IEarcCtlgService earcCtlgService;

	/**
	 * 
	 * TODO: 档案登记列表页
	 * 
	 * @return
	 */
	@RequestMapping("/goToFileIndex/{solId} ")
	public ModelAndView toIndex(@PathVariable String solId) {
		ModelAndView mv = new ModelAndView();
		List<EarcCtlgTreeBean> list;
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user != null) {
			list = earcCtlgService.findCtlgInfoByUserId(user.getUserId());
		} else {
			list = new ArrayList<EarcCtlgTreeBean>();
		}
		mv.addObject("treeList", JSONArray.fromObject(list).toString());
		mv.addObject("solId", solId);
		mv.setViewName("/aco/biz/earcmgr/acctvchr/list/acctvchr-list");
		return mv;
	}

	/**
	 * 
	 * TODO: 电子档案归档获取档案信息构建Ztreejson格式
	 * 
	 * @return
	 */
	@RequestMapping("/findZtreeListByUserId")
	@ResponseBody
	public String findZtreeListByUserId() {
		List<EarcCtlgTreeBean> list;
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user != null) {
			list = earcCtlgService.findCtlgInfoByUserId(user.getUserId());
		} else {
			list = new ArrayList<EarcCtlgTreeBean>();
		}
		return JSONArray.fromObject(list).toString();
	}

	/**
	 * 
	 * TODO: 会计凭证列表
	 * 
	 * @param pageNum
	 *            当前页
	 * @param pageSize
	 *            页大小
	 * @param acctVchrName
	 *            会计档案名称
	 * @param sortName
	 *            排序列
	 * @param sortOrder
	 *            拍序方式
	 * @return
	 */
	@RequestMapping("/findEarcAcctVchrInfo")
	@ResponseBody
	public DataGridView<EarcBean> findEarcAcctVchrInfo(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "solId", defaultValue = "") String solId,
			@RequestParam(value = "acctVchrName", defaultValue = "") String acctVchrName,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "queryParams", defaultValue = "") String queryParams) {
		DataGridView<EarcBean> page = new DataGridView<EarcBean>();
		try {
			acctVchrName = new String(acctVchrName.getBytes("iso-8859-1"),"utf-8");
			queryParams = java.net.URLDecoder.decode(queryParams,"UTF-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<EarcBean> pags = null;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			if (user != null) {
				pags = earcService.findEarcAcctVchrInfo(pageNum, pageSize,
						solId, acctVchrName, sortName, sortOrder,
						user.getUserId(), queryParams);
			}
			if (pags != null) {
				page.setRows(pags.getResults());
				page.setTotal(pags.getTotalrecord());
			}
			return page;
		} catch (Exception e) {
			return null;
		}

	}

	/**
	 * 
	 * TODO: 保存档案业务状态
	 * 
	 * @return
	 */
	@RequestMapping("/doSaveEarcState")
	@ResponseBody
	public String doSaveEarcState(
			@RequestParam(value = "earcId", defaultValue = "") String earcId,
			@RequestParam(value = "earcCtlgId", defaultValue = "") String earcCtlgId,
			@RequestParam(value = "earcType", defaultValue = "") String earcType,
			@RequestParam(value = "securityLevel", defaultValue = "") String securityLevel,
			@RequestParam(value = "term", defaultValue = "") String term) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		Date operTime = new Date();
		if (user != null) {
			if (StringUtils.isNotBlank(earcId)
					&& StringUtils.isNotBlank(earcType)) {
				EarcBizIEntity ebEntity = new EarcBizIEntity();
				ebEntity.setID(null);
				ebEntity.setEARC_CTLG_ID(earcCtlgId);
				ebEntity.setEARC_TYPE(earcType);
				ebEntity.setEARC_ID(earcId);
				ebEntity.setEARC_STATE("0");
				if(StringUtils.isNotBlank(earcCtlgId)){
					ebEntity.setOPER_USER(user.getUserId());
					ebEntity.setOPER_TIME(operTime);
				}
				ebEntity.setSECURITY_LEVEL(securityLevel);
				ebEntity.setTERM(term);
				earcService.doSaveEarcState(ebEntity);
				return "true";
			} else {
				return "false";
			}
		} else {
			return "false";
		}

	}

	/**
	 * 
	 * TODO: 电子档案归档
	 * 
	 * @param earcId
	 * @param earcCtlgId
	 * @return
	 */
	@RequestMapping("/earcFileByCtlgId")
	@ResponseBody
	public String earcFileByCtlgId(
			@RequestParam(value = "earcId", defaultValue = "") String earcId,
			@RequestParam(value = "ctlgId", defaultValue = "") String ctlgId) {

		if (StringUtils.isNotBlank(earcId) && StringUtils.isNotBlank(ctlgId)) {
			earcService.earcFileByCtlgId(earcId, ctlgId);
			return "true";
		} else {
			return "false";
		}

	}

	@RequestMapping("/updateEarcStateByEarcId")
	@ResponseBody
	public String updateEarcStateByEarcId(
			@RequestParam(value = "earcId", defaultValue = "") String earcId,
			@RequestParam(value = "earcState", defaultValue = "") String earcState) {
		if (StringUtils.isNotBlank(earcId) && StringUtils.isNotBlank(earcState)) {
			earcService.updateEarcStateByEarcId(earcId, earcState);
			return "true";
		} else {
			return "false";
		}
	}

	@RequestMapping("/doSaveEarcBizInfo")
	@ResponseBody
	public String doSaveEarcBizInfo(
			@RequestParam(value = "earcId", defaultValue = "") String earcId,
			@RequestParam(value = "earcType", defaultValue = "") String earcType,
			@RequestParam(value = "securityLevel", defaultValue = "") String securityLevel,
			@RequestParam(value = "term", defaultValue = "") String term) {
		if (StringUtils.isNotBlank(earcId) && StringUtils.isNotBlank(earcType)
				&& StringUtils.isNotBlank(securityLevel)
				&& StringUtils.isNotBlank(term)) {
			EarcBizIEntity ebEntity = new EarcBizIEntity();
			ebEntity.setID(null);
			ebEntity.setEARC_ID(earcId);
			ebEntity.setEARC_TYPE(earcType);
			ebEntity.setSECURITY_LEVEL(securityLevel);
			ebEntity.setTERM(term);
			earcService.doSaveEarcBizInfo(ebEntity);
			return "true";
		} else {
			return "false";
		}
	}
}
