package com.yonyou.aco.earc.earcquery.web;

import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.Identities;

import com.yonyou.aco.earc.ctlg.entity.EarcCtlgTreeBean;
import com.yonyou.aco.earc.ctlg.service.IEarcCtlgService;
import com.yonyou.aco.earc.earcquery.entity.EarcQuery;
import com.yonyou.aco.earc.earcquery.entity.EarcQueryBean;
import com.yonyou.aco.earc.earcquery.service.IEarcQueryService;
import com.yonyou.aco.earc.util.ExcelUtil;
import com.yonyou.cap.bpm.entity.BizRuNestEntity;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.common.util.DataGridView;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 档案总库查询控制层 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年5月3日
 * @author 贺国栋
 * @since 1.0.0
 */
@Controller
@RequestMapping("/earcQueryController")
public class EarcQueryController {

	@Resource
	IEarcQueryService earcQueryService;
	@Resource
	IEarcCtlgService earcCtlgService;

	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;

	@RequestMapping("/gotoQueryIndex/{solId}")
	public ModelAndView gotoQueryIndex(@PathVariable String solId) {
		
		ModelAndView mv = new ModelAndView();
		List<EarcCtlgTreeBean> list;
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user != null) {
			list = earcCtlgService.findCtlgInfoByUserId(user.getUserId());
		} else {
			list = new ArrayList<EarcCtlgTreeBean>();
		}
		mv.addObject("queryTree", JSONArray.fromObject(list).toString());
		mv.addObject("solId", solId);
		mv.setViewName("/aco/biz/earcmgr/earcquery/earc-query-index");
		return mv;
	}

	@RequestMapping("/findEarcDateAll")
	@ResponseBody
	public DataGridView<EarcQueryBean> findEarcDateAll(
			@RequestParam(value = "pageNum", defaultValue = "") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "") int pageSize,
			@RequestParam(value = "ctlgId", defaultValue = "") String ctlgId,
			@RequestParam(value = "title", defaultValue = "") String title,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "queryParams", required = false) String queryParams) {
		DataGridView<EarcQueryBean> page = new DataGridView<EarcQueryBean>();
		try {
			pageNum = computeNum(pageNum, pageSize);
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			String userId = user.id;
			PageResult<EarcQueryBean> pags = null;
			// 查询参数二次解码

			queryParams = java.net.URLDecoder.decode(queryParams, "UTF-8");
			title = new String(title.getBytes("iso-8859-1"), "utf-8");
			pags = earcQueryService.findEarcDateAll("", pageNum, pageSize,
					ctlgId, userId, title.trim(), sortName, sortOrder,
					queryParams);
			if (pags != null) {
				page.setRows(pags.getResults());
				page.setTotal(pags.getTotalrecord());
			}
			return page;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return page;

	}

	/**
	 * 方法: 计算当前页码.
	 * 
	 * @param pagenum
	 * @param pagesize
	 * @return
	 */
	public int computeNum(int pagenum, int pagesize) {
		if (pagenum != 0) {
			pagenum = pagenum / pagesize;
			pagenum++;
		}
		return pagenum;
	}

	@RequestMapping("/exportExcel")
	@ResponseBody
	public void exportExcel(
			HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value = "selectIds", defaultValue = "") String selectIds,
			@RequestParam(value = "ctlgId", defaultValue = "") String ctlgId,
			@RequestParam(value = "title", defaultValue = "") String title,
			@ModelAttribute EarcQuery earcQuery) {
		List<EarcQueryBean> page = new ArrayList<EarcQueryBean>();
		try {
			if (!StringUtils.isBlank(selectIds)) {
				String[] split = selectIds.split(",");
				for (int i = 0; i < split.length; i++) {
					EarcQueryBean findEarcQueryBeanById = earcQueryService
							.findEarcQueryBeanById(split[i]);
					page.add(findEarcQueryBeanById);
				}
			} else {
				ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
						.getPrincipal();
				String userId = user.id;
				// 查询参数二次解码
				title = new String(title.getBytes("iso-8859-1"), "utf-8");
				earcQuery.setBIZ_TITLE_(new String(earcQuery.getBIZ_TITLE_()
						.getBytes("iso-8859-1"), "utf-8"));
				earcQuery.setEARC_TYPE(new String(earcQuery.getEARC_TYPE()
						.getBytes("iso-8859-1"), "utf-8"));

				page = earcQueryService.findEarcDateAll("", ctlgId, userId,
						title.trim(), earcQuery);
			}

			// 处理对象的相关属性值
			for (EarcQueryBean earcQueryBean : page) {
				String securityLevel = earcQueryBean.getSECURITY_LEVEL();
				if (!StringUtils.isBlank(securityLevel)) {
					if ("1".equals(securityLevel)) {
						earcQueryBean.setSECURITY_LEVEL("低级");
					} else if ("2".equals(securityLevel)) {
						earcQueryBean.setSECURITY_LEVEL("中级");
					} else if ("3".equals(securityLevel)) {
						earcQueryBean.setSECURITY_LEVEL("高级");
					}
				}
				String earcState = earcQueryBean.getEARC_STATE();
				if (!StringUtils.isBlank(earcState)) {
					if ("0".equals(earcState)) {
						earcQueryBean.setEARC_STATE("未归档");
					} else if ("1".equals(earcState)) {
						earcQueryBean.setEARC_STATE("已归档");
					} else if ("2".equals(earcState)) {
						earcQueryBean.setEARC_STATE("已作废");
					} else if ("3".equals(earcState)) {
						earcQueryBean.setEARC_STATE("已销毁");
					} else if ("4".equals(earcState)) {
						earcQueryBean.setEARC_STATE("已到期");
					}
				}
			}

			OutputStream ops = response.getOutputStream();
			HSSFWorkbook workbook = null;
			// 表头和对象属性
			String[] columnNames = { "标题", "责任人", "档案类型", "密级", "归档日期", "档案状态" };
			String[] columnValues = { "BIZ_TITLE_", "CREATE_USER_ID_",
					"EARC_TYPE", "SECURITY_LEVEL", "OPER_TIME", "EARC_STATE" };
			workbook = ExcelUtil.generateExcelFile(page, columnNames,
					columnValues);
			workbook.write(ops);
			String filename = "档案总库";
			String agent = request.getHeader("USER-AGENT");
			if (null != agent && -1 != agent.indexOf("MSIE") || null != agent
					&& -1 != agent.indexOf("Trident")) {// ie

				String name = java.net.URLEncoder.encode(filename, "UTF8");

				filename = name;
			} else if (null != agent && -1 != agent.indexOf("Mozilla")) {// 火狐,chrome等
				filename = new String(filename.getBytes("UTF-8"), "iso-8859-1");
			}
			response.setContentType("text/html");
			response.setHeader("Content-Disposition", "attachment;filename="
					+ filename + ".xls");
			ops.close();

		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	@RequestMapping("/doSaveBizRuNestInfo")
	@ResponseBody
	public String doSaveBizRuNestInfo(
			@RequestParam(value = "bizid_attach", defaultValue = "") String bizid_attach,
			@RequestParam(value = "attach_title", defaultValue = "") String attach_title) {

		Date date = new Date();
		String bizId = Identities.uuid();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM:dd HH:mm:ss");
		BizRuNestEntity brnEntity = new BizRuNestEntity();
		brnEntity.setId(null);
		brnEntity.setBizid(bizId);
		brnEntity.setAttach_title(attach_title);
		brnEntity.setBizid_attach(bizid_attach);
		brnEntity.setCreate_time(sdf.format(date));
		bpmRuBizInfoService.savefileattach(brnEntity);
		return bizId;
	}
}
