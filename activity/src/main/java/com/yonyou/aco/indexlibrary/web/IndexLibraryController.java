package com.yonyou.aco.indexlibrary.web;

import javax.annotation.Resource;
import javax.validation.Valid;
import javax.websocket.server.PathParam;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.indexlibrary.entity.IndexLibrary;
import com.yonyou.aco.indexlibrary.service.IIndexLibraryService;
import com.yonyou.cap.common.util.DataGridView;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

@Controller
@RequestMapping("indexLibraryController")
public class IndexLibraryController {
	@Resource
	IIndexLibraryService indexLibraryService;
	
	/**
	 * 指标库列表页
	 * 
	 * @author wangjiankun
	 * @since 2017-06-27
	 * */
	@RequestMapping("indexLibraryList")
	public String indexLibraryList(){
		return "aco/indexLibrary/indexLibraryList";
	}
	
	@RequestMapping("gotoIndexLibraryFron")
	public ModelAndView gotoIndexLibraryFron(@PathParam(value = "id") String id){
		ModelAndView mv = new ModelAndView();
		if(StringUtils.isNotBlank(id)){
			IndexLibrary ilEntity =indexLibraryService.findIndexLibDateById(id); 
			mv.addObject("id", ilEntity.getId());
			mv.addObject("deptName", ilEntity.getDeptName());
			mv.addObject("userName", ilEntity.getCreateUserName());
			mv.addObject("createTime", ilEntity.getCreateTime());
			mv.addObject("proName", ilEntity.getProName());
			mv.addObject("funcType", ilEntity.getFuncType());
			mv.addObject("je", ilEntity.getBudgetAmount());
			mv.addObject("remarks", ilEntity.getRemarks());
			mv.setViewName("aco/indexLibrary/index-library-update-from");
		}else{
			mv.setViewName("aco/indexLibrary/index-library-from");
		}
		return mv;
	}
	
	/**
	 * 
	 * 多条件分页获取列表信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param userName
	 * @return
	 */
	@SuppressWarnings("null")
	@RequestMapping("/findIndexLibDateByQueryParams")
	@ResponseBody
	public DataGridView<IndexLibrary> findIndexLibDateByQueryParams(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "deptName", defaultValue = "") String deptName ){
		DataGridView<IndexLibrary> page = new DataGridView<IndexLibrary>();
		try {
			deptName = new String(deptName.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<IndexLibrary> pags = null;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if (user != null) {
				pags = indexLibraryService.findLeaveDateByQueryParams(pageNum, pageSize, deptName);
			}
			if (pags != null) {
				page.setRows(pags.getResults());
				page.setTotal(pags.getTotalrecord());
			}else{
				page.setRows(pags.getResults());
				page.setTotal(0);
			}
			return page;
		} catch (Exception e) {
			return null;
		}

	}
	
	/**
	 * 保存指标库信息
	 * @param ilEntity
	 * @return
	 */
	@RequestMapping("/doSaveIndexLibraryInfo")
	@ResponseBody
	public String doSaveOrUpdateIndexLibraryInfo(@Valid IndexLibrary ilEntity){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user == null) {
			return "0";
		}else{
			indexLibraryService.doSaveOrUpdateIndexLibraryInfo(ilEntity);
			return "1";
		}
	}
	
	@RequestMapping("/doDelIndexLiarbryById")
	@ResponseBody
	public String doDelIndexLiarbryById(@RequestParam(value="Id",defaultValue="") String Id){
		if(StringUtils.isNotBlank(Id)){
			indexLibraryService.doDelIndexLiarbryById(Id);
			return "1";
		}else{
			return "0";
		}
		
		
	}
}
