package com.yonyou.aco.fromscomponents.web;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.adapter.IIscOrgAdapter;
import com.yonyou.cap.isc.adapter.IIscUserAdapter;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.org.service.IDeptService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.entity.UserInfo;

/**
 * 概 述：       表单组件控制层
 * 功 能：       实现业务运行时请求处理
 * 作 者：       齐瀚
 * 创建时间：2017年3月13日 15:51:26
 * 类调用特殊情况：
 */
@Controller
@RequestMapping("/fromsComponentsController")
public class FromsComponentsController {


	@Resource
	IDeptService deptService;
	@Resource
	IIscUserAdapter userAdapter;
	@Resource
	IIscOrgAdapter orgAdapter;

	/**
	 * 查询人员列表信息功能方法
	 * @param pageNum  当前页码数
	 * @param pageSize 每页条目数
	 * @param name     人员名称
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/findUserByName")
	@ResponseBody
	public TreeGridView<User> findUserByName(
			@RequestParam(value = "page") int pageNum,
			@RequestParam(value = "rows") int pageSize,
			@RequestParam(required = false, defaultValue = "") String searchValue) throws UnsupportedEncodingException{
			//已办理状态、标题为查询条件获取业务数据
		//	String searchValue1 = new String(searchValue.getBytes("iso-8859-1"), "utf-8");
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();	
		PageResult<User> pags = userAdapter.findUsersInfo(null, user.getOrgid(),searchValue, pageNum, pageSize);
			if (pags.getResults()!= null && !"".equals(pags.getResults())) {
				ArrayList<User> infos = (ArrayList<User>) pags.getResults();//获取初始化用户信息
				ArrayList<User> userInfos = new ArrayList<User>();//拼接后返回用户信息
				for (int i = 0; i < infos.size(); i++) {
					User info = infos.get(i);
					StringBuilder builder = new StringBuilder();
					builder.append("<span class='peopleList_username'>");
					builder.append(info.getUserName());
					builder.append("</span>");
					builder.append("<span class='peopleList_info'>");
					builder.append(info.getOrgName());
					builder.append("-");
					builder.append(info.getDeptName());
					builder.append("-");
					builder.append(info.getPostName());
					builder.append("</span>");
					info.setPostName(builder.toString());
					userInfos.add(info);
				}
				TreeGridView<User> treeGridView = new TreeGridView<User>();
				treeGridView.setRows(userInfos);
				treeGridView.setTotal(pags.getTotalrecord());
				return treeGridView;
			}else {
				return null;
			}
	}
	/**
	 * 查询部门列表信息功能方法
	 * @param pageNum  当前页码数
	 * @param pageSize 每页条目数
	 * @param name     部门名称
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/findDeptByName")
	@ResponseBody
	public TreeGridView<Dept> findDeptByName(
			@RequestParam(value = "page") int pageNum,
			@RequestParam(value = "rows") int pageSize,
			@RequestParam(required = false, defaultValue = "") String searchValue) throws UnsupportedEncodingException{
			//已办理状态、标题为查询条件获取业务数据
			//String searchValue1 = new String(searchValue.getBytes("iso-8859-1"), "utf-8");
			PageResult<Dept> pags = orgAdapter.findDeptListByName(null, null,searchValue, pageNum, pageSize);
			
			if (pags.getResults()!= null && !"".equals(pags.getResults())) {
				ArrayList<Dept> depts = (ArrayList<Dept>) pags.getResults();//获取初始化用户信息
				ArrayList<Dept> deptlist = new ArrayList<Dept>();//拼接后返回用户信息
				for (int i = 0; i < depts.size(); i++) {
					Dept dept = depts.get(i);    
					StringBuilder builder = new StringBuilder();
					builder.append("<span class='deptList_deptname'>");
					builder.append(dept.getDeptName());
					builder.append("</span>");
					builder.append("<span class='deptList_info'>");
					if (dept.getParentDeptName() == null) {
						builder.append("-");
					}else {
						builder.append(dept.getParentDeptName());
					}
					builder.append("</span>");
					dept.setParentDeptName(builder.toString());
					deptlist.add(dept);
				}
				TreeGridView<Dept> treeGridView = new TreeGridView<Dept>();
				treeGridView.setRows(deptlist);
				treeGridView.setTotal(pags.getTotalrecord());
				return treeGridView;
			}else {
				return null;
			}
	}

}
