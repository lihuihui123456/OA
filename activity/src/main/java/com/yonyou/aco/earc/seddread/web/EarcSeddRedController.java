package com.yonyou.aco.earc.seddread.web;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;



import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.earc.ctlg.service.IEarcCtlgService;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedBean;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedEntity;
import com.yonyou.aco.earc.seddread.entity.EarcSeddRedListQuery;
import com.yonyou.aco.earc.seddread.service.IEarcSeddRedService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;

@Controller
@RequestMapping("/earcSeddRedController")
public class EarcSeddRedController {

	@Resource IEarcSeddRedService  earcSeddRedService;
	@Resource
	IEarcCtlgService earcCtlgService;
	@RequestMapping("/doSaveSeddRedInfo")
	@ResponseBody
	public String doSaveSeddRedInfo(
			@RequestParam(value = "earcId", defaultValue = "") String earcId,
			@RequestParam(value = "receiveUser", defaultValue = "") String receiveUser,
			@RequestParam(value = "sendUser", defaultValue = "") String sendUser,
			@RequestParam(value = "startDate", defaultValue = "") String startDate,
			@RequestParam(value = "endDate", defaultValue = "") String endDate) {

		String res = "true";
		EarcSeddRedEntity esrEntity;
		SimpleDateFormat sdf = new SimpleDateFormat("YYYY-MM-DD");
		if (StringUtils.isNotBlank(earcId) && StringUtils.isNotBlank(receiveUser)
				&& StringUtils.isNotBlank(sendUser)
				&& StringUtils.isNotBlank(startDate)
				&& StringUtils.isNotBlank(endDate)){
			try {
				Date newStartDate = sdf.parse(startDate);
				Date newEndDate = sdf.parse(endDate);
				esrEntity = new EarcSeddRedEntity();
				esrEntity.setID(null);
				esrEntity.setEARC_ID(earcId);
				esrEntity.setEND_DATE(newEndDate);
				esrEntity.setSTART_DATE(newStartDate);
				esrEntity.setRECEIVE_USER(receiveUser);
				esrEntity.setSEND_USER(sendUser);
				earcSeddRedService.doSaveSeddRedInfo(esrEntity);
			} catch (ParseException e) {
				e.printStackTrace();
				res = "false";
			}
			
		}
		return res;

	}
	@RequestMapping("/gotoIndex/{solId}")
	public ModelAndView toIndex(@PathVariable String solId) {
		ModelAndView mv = new ModelAndView();
/*		List<EarcCtlgTreeBean> list;
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user != null) {
			list = earcCtlgService.findCtlgInfoByUserId(user.getUserId());
		} else {
			list = new ArrayList<EarcCtlgTreeBean>();
		}
		mv.addObject("treeList", JSONArray.fromObject(list).toString());*/
		mv.addObject("solId", solId);
		mv.setViewName("/aco/biz/earcmgr/earcseddread/seddread-index");
		return mv;
	}
	/**
	 * 
	 * TODO: 调阅列表
	 * 
	 * @param pageNum
	 *            当前页
	 * @param pageSize
	 *            页大小
	 * @param acctVchrName
	 *            会计档案名称
	 * @return
	 */
	@RequestMapping("/findEarcSeddRedInfo")
	@ResponseBody
	public TreeGridView<EarcSeddRedBean> findEarcSeddRedInfo(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@ModelAttribute EarcSeddRedListQuery earcSeddRedListQuery) {
		  TreeGridView<EarcSeddRedBean> plist = new TreeGridView<EarcSeddRedBean>();
			try {
				earcSeddRedListQuery.setBiz_title_(new String(earcSeddRedListQuery.getBiz_title_().getBytes("iso-8859-1"), "utf-8"));
				earcSeddRedListQuery.setReceive_user(new String(earcSeddRedListQuery.getReceive_user().getBytes("iso-8859-1"), "utf-8"));
				earcSeddRedListQuery.setSend_user(new String(earcSeddRedListQuery.getSend_user().getBytes("iso-8859-1"), "utf-8"));

				if (pageNum != 0) {
					pageNum = pageNum / pageSize;
				}
				pageNum++;
				PageResult<EarcSeddRedBean> pags = earcSeddRedService
						.pageEarcSeddRedBeanList(pageNum, pageSize,
								earcSeddRedListQuery);
				List<EarcSeddRedBean> list = new ArrayList<EarcSeddRedBean>();
                list=pags.getResults();
				plist.setRows(list);
				plist.setTotal(pags.getTotalrecord());
			} catch (Exception e) {
				e.printStackTrace();
			}
			return plist;
	}
	

	/**
	 * 
	 * TODO: 选择档案
	 * 
	 * @param pageNum
	 *            当前页
	 * @param pageSize
	 *            页大小
	 * @return
	 */
	@RequestMapping("/searchEarcSeddRedInfo")
	@ResponseBody
	public TreeGridView<EarcSeddRedBean> searchEarcSeddRedInfo(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize) {
		  TreeGridView<EarcSeddRedBean> plist = new TreeGridView<EarcSeddRedBean>();
			try {
				if (pageNum != 0) {
					pageNum = pageNum / pageSize;
				}
				pageNum++;
				PageResult<EarcSeddRedBean> pags = earcSeddRedService
						.pageEarcSeddRedBeanList(pageNum, pageSize);
				List<EarcSeddRedBean> list = new ArrayList<EarcSeddRedBean>();
                list=pags.getResults();
				plist.setRows(list);
				plist.setTotal(pags.getTotalrecord());
			} catch (Exception e) {
				e.printStackTrace();
			}
			return plist;
	}
	@RequestMapping("/searchEarcSeddReadLoad")
	public ModelAndView searchEarcSeddReadLoad() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("/aco/biz/earcmgr/earcseddread/seddread-list");
		return mv;
	}
}
