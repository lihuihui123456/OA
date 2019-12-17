package com.yonyou.aco.contacts.web;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;

import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.contacts.entity.ContactsUserBean;
import com.yonyou.aco.contacts.entity.ContactsUserInfoBean;
import com.yonyou.aco.contacts.service.IBizContactsService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.org.service.IDeptService;
import com.yonyou.cap.isc.org.service.IOrgService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.service.IUserService;
/**
 * <p>概述：业务模块通讯录Controller层
 * <p>功能：通讯录
 * <p>作者：葛鹏
 * <p>创建时间：2017年2月23日
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/bizContactsController")
public class BizContactsController {


	@Autowired
	private HttpServletRequest request;
	@Autowired
	private IOrgService orgService;
	@Resource
	IUserService iUserService;
	@Resource
	IBizContactsService iBizContactsService;
	@Autowired
	private IDeptService deptService;

	/**
	 * 最上级部门
	 */
	private static final String TOP_DEPT="0";
	
	private static final String ALWAYS_CONTACTORS="1";
	
	private static final String NORMAL_DEPT="2";
	
	private static final String CONTACTORS="3";
	
	private static final String TOP_DEPT_NAME="所有联系人";
	
	private static final String ALWAYS_CONTACTORS_NAME="常用联系人";
	//公司图片
//	private static final String IMAGE_PATH_COMPANY="./views/aco/contacts/images/company.png";
	//部门图片
	private static final String IMAGE_PATH_DEPT="./views/aco/contacts/images/dept.png";
	//常用联系人图片
	private static final String IMAGE_PATH_CONTACTS="./views/aco/contacts/images/contactors.png";
	//多人图片
	private static final String IMAGE_PATH_MORE_PEOPLE="./views/aco/contacts/images/morepeople.png";
	
	@RequestMapping("/index")
	@ResponseBody
	public ModelAndView initDeptTree(HttpServletRequest request){
		ModelAndView mv=new ModelAndView();
		List<Dept> treeList=iBizContactsService.findDeptList();
		StringBuffer sb = new StringBuffer("[");
		for(int i = 0;i < treeList.size();i++) {
			Dept dept= treeList.get(i);
			sb.append("{'id':'").append(dept.getDeptId()+"'");
			sb.append(",'name':'").append(dept.getDeptName()+"'");
			sb.append(",'pId':'").append(dept.getParentDeptId()+"',type:'"+NORMAL_DEPT+"',icon:'"+IMAGE_PATH_DEPT+"'}");
			if (i != treeList.size() - 1) {
				sb.append(",");
			}
		}
		List<ContactsUserBean> listCub=new ArrayList<ContactsUserBean>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
		PageResult<ContactsUserBean> pr=iBizContactsService.findAlwaysContactors(0, Integer.MAX_VALUE, "", "",user);
		
		listCub=pr.getResults();
		if(listCub.size()>0){
			sb.append(",");
		}
		for(int i = 0;i < listCub.size();i++) {
			ContactsUserBean cub= listCub.get(i);
			sb.append("{'id':'").append(cub.getUserId()+"'");
			sb.append(",'name':'").append(cub.getUserName()+"'");
			sb.append(",'pId':'").append("alwaysContactors',type:'"+CONTACTORS+"',icon:'"+IMAGE_PATH_CONTACTS+"'}");
			if (i != listCub.size() - 1) {
				sb.append(",");
			}
		}
		if(treeList.size()>0){
			String orgName=iBizContactsService.getOrgNameByUserId(user.getId());
			if(orgName==null||"".equals(orgName)){
				orgName=TOP_DEPT_NAME;
			}
			sb.append(",{id:'"+treeList.get(0).getOrgId()+"',name:'"+orgName+"',pId:'',open:'true',type:'"+TOP_DEPT+"',icon:'"+IMAGE_PATH_MORE_PEOPLE+"'}");
		}
		}
		sb.append(",{id:'alwaysContactors',name:'"+ALWAYS_CONTACTORS_NAME+"',pId:'',open:'true',type:'"+ALWAYS_CONTACTORS+"',icon:'"+IMAGE_PATH_MORE_PEOPLE+"'}");
		sb.append("]");
		mv.addObject("treeList", sb);
		mv.setViewName("/aco/contacts/contacts-center");
		return mv;
	}
	@RequestMapping("/queryUserByDept")
	@ResponseBody	
	public TreeGridView<ContactsUserBean> queryUserByDept(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "deptId", defaultValue = "") String deptId,
			@RequestParam(value = "type", defaultValue = "") String type,
			@RequestParam(value = "word", defaultValue = "") String word,
			@RequestParam(value = "userName", defaultValue = "") String param) throws UnsupportedEncodingException{
		TreeGridView<ContactsUserBean> tgv=new TreeGridView<ContactsUserBean>();
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		PageResult<ContactsUserBean> pags = null;
		param=new String(param.getBytes("iso-8859-1"), "utf-8");//防止中文乱码
		if(type.equals(ALWAYS_CONTACTORS)){//常用联系人
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
			pags = iBizContactsService.findAlwaysContactors(pageNum, pageSize, word,param,user);
			tgv.setRows(pags.getResults());
			tgv.setTotal(pags.getTotalrecord());
			}
			return tgv;
		}else if(type.equals(TOP_DEPT)){
			deptId="";
		}
		pags = iBizContactsService.findUserByDept(pageNum,pageSize,deptId,word,param);
		tgv.setRows(pags.getResults());
		tgv.setTotal(pags.getTotalrecord());
		return tgv;
	}
	//添加常用联系人
	@RequestMapping("/addAlwaysContactors")
	@ResponseBody	
	public String addAlwaysContactors(String userIds){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			iBizContactsService.addAlwaysContactors(userIds,user);
			return "success";
		}
		return "";
		
	}
	//删除常用联系人
	@RequestMapping("/deleteAlwaysContactors")
	@ResponseBody
	public String deleteAlwaysContactors(String userIds){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			iBizContactsService.deleteAlwaysContactors(userIds,user);
			return "success";
		}
		return "";
	}
	@RequestMapping("/ajaxContactors")
	@ResponseBody
	public JSONArray ajaxContactors(){
		List<ContactsUserBean> listCub=new ArrayList<ContactsUserBean>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			PageResult<ContactsUserBean> pr=iBizContactsService.findAlwaysContactors(0, Integer.MAX_VALUE, "", "",user);
			listCub=pr.getResults();
		}
		JSONArray obj  =JSONArray.fromObject(listCub);
		return obj;
	}
	
	@RequestMapping("/queryContactor")
	@ResponseBody
	public JSONArray queryContactor(String userId){
		ContactsUserBean bean=iBizContactsService.queryContactor(userId);
		JSONArray obj  =JSONArray.fromObject(bean);
		return obj;
	}
	
	@RequestMapping("/valIsInContactors")
	@ResponseBody
	public String valIsInContactors(String userId){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		String count="";
		if(user!=null){
			count=iBizContactsService.valIsInContactors(user.getId(),userId);
		}
		return count;
	}
	@RequestMapping("/queryAllUserData")
	@ResponseBody
	public List<ContactsUserInfoBean> queryAllUserData(){
		return iBizContactsService.queryAllUserData();
	}
	@RequestMapping("/queryAllDeptData")
	@ResponseBody
	public List<Dept> findDeptList(){
		return iBizContactsService.findDeptList();
	}
	
	@RequestMapping("/queryAllContactorsData")
	@ResponseBody
	public List<ContactsUserInfoBean> queryAllContactorsData(){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user==null){
			return null;
		}
		return iBizContactsService.queryAllContactors(user.getId());
	}
}
