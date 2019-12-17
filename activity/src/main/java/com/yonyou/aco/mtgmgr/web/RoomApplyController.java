package com.yonyou.aco.mtgmgr.web;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.mtgmgr.entity.BizMtRoomApplyEntity;
import com.yonyou.aco.mtgmgr.entity.BizMtRoomUsingEntity;
import com.yonyou.aco.mtgmgr.entity.RoomApplySearchBean;
import com.yonyou.aco.mtgmgr.entity.RoomBean;
import com.yonyou.aco.mtgmgr.service.IMeetingRoomService;
import com.yonyou.aco.mtgmgr.service.IRoomApplyService;
import com.yonyou.aco.mtgmgr.service.IRoomUsedService;
import com.yonyou.cap.common.audit.operatelog.annotation.AroundAspect;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.service.IOrgService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * 名称: 会议室预定申请信息
 * ---------------------------------------------------------
 * 
 * @Date 2016年3月18日
 * @author 卢昭炜
 * @since 1.0.0
 */
@Controller
@RequestMapping("/roomApply")
public class RoomApplyController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource
	private IRoomApplyService roomApplyService;

	@Resource
	private IMeetingRoomService meetingRoomService;

	@Resource
	private IRoomUsedService roomUsedService;

	@Resource
	private IOrgService orgService;

	private ShiroUser getUser() {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		return user;
	}

	private String getTime() {
		String time = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
		return time;
	}

	/**
	 * 会议室申请审批页跳转方法
	 */
	@RequestMapping("/toRoomApplyList")
	@AroundAspect(description="会议室申请审批-审批页跳转")
	public ModelAndView toRoomApplyList(HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("modCode", request.getParameter("modCode"));
		mv.setViewName("/aco/meetingroom/roomapplylist");
		return mv;
	}

	
	/**
	 * 获取会议室申请记录
	 * @param modCode      模块code
	 * @param pageNum      当前页码数
	 * @param pageSize     每页分页数
	 * @param meetingname  会议名称（搜索参数）
	 * @return
	 */
	@RequestMapping("/findRoomApplyData")
	@ResponseBody
	@AroundAspect(description="会议室申请审批-分页获取会议室申请记录")
	public  Map<String, Object> findAllPerApply(
			@RequestParam String modCode,
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "meetingname", defaultValue = "") String meetingname,
			@RequestParam(value = "modeCode", defaultValue = "") String modeCode,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value="query", required=false) String queryParams) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			if (pageNum > 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			meetingname = new String(meetingname.getBytes("iso-8859-1"), "utf-8");
			queryParams = java.net.URLDecoder.decode(queryParams,"UTF-8");
			queryParams = java.net.URLDecoder.decode(queryParams,"UTF-8");
			PageResult<RoomApplySearchBean> page = roomApplyService.findRoomApplyData(modCode,
					pageNum, pageSize,sortName,sortOrder, meetingname,queryParams);
			if(page!=null && page.getTotalrecord()>0){
				map.put("total", page.getTotalrecord());
				map.put("rows", page.getResults());
			}else {
				map.put("total", "0");
				map.put("rows", new ArrayList<RoomApplySearchBean>());
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}

	/**
	 * 名称: 获取一条记录
	 * 备注：原方法名（getOneData）
	 * @param id
	 * @return
	 */
	@RequestMapping("/findPerApplyById")
	@AroundAspect(description="会议室申请审批-查看一条会议室申请记录信息")
	public @ResponseBody RoomBean findPerApplyById(@RequestParam(value="id") String id) {
		RoomBean roomApply = new RoomBean();
		try {
			roomApply = roomApplyService.findPerApplyById(id);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return roomApply;
	}

	/**
	 * 名称: 获取列表数据 
	 * 备注：原方法名（getAllData）
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	@RequestMapping("/findAllPerApply")
	@AroundAspect(description="会议室预定申请--分页获取会议室申请记录")
	public @ResponseBody Map<String, Object> findAllPerApply(@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "meetingname", defaultValue = "") String meetingname) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			if (pageNum > 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			meetingname = new String(meetingname.getBytes("iso-8859-1"), "utf-8");
			PageResult<RoomBean> page = roomApplyService.findAllPerApply(meetingname,pageNum,pageSize, getUser().getUserId());
			map.put("total", page.getTotalrecord());
			map.put("rows", page.getResults());
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}

	/**
	 * 名称: 新增记录保存方法
	 * 备注：原方法名（saveNewData）
	 * @param roomApply
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/doSaveRoomApply/{model}")
	@AroundAspect(description="会议室预定申请--新增会议室申请记录")
	public void doSaveRoomApply(@Valid BizMtRoomApplyEntity roomApply,@PathVariable String model,
							HttpServletResponse response) throws IOException {
		try {
			model = new String(model.getBytes("iso-8859-1"), "utf-8");
			ShiroUser user = getUser();
			if(null != user){
				roomApply.setApply_user_id(user.getUserId());
				roomApply.setApply_org_id(user.getUserId());
				roomApply.setTs(getTime());
				roomApply.setSort(getSort());
				roomApply.setDataDeptId(user.getDeptId());
				roomApply.setDataOrgId(user.getOrgid());
				roomApply.setDataUserId(user.getUserId());
				roomApply.setDataTenantId(user.getUserId());
				if ("暂存".equals(model)) {
					// 0  表示暂存（目前没有使用）
					roomApply.setStatus("0");
				} else {
					// 1  表示已送，等待批示
					roomApply.setStatus("1");
				}
				roomApplyService.doSaveRoomApply(roomApply);
				doSaveRoomUsed(roomApply);
				response.getWriter().write("true");
				response.getWriter().flush();
			}
		} catch (Exception e) {
			logger.error("error",e);
			response.getWriter().write("false");
			response.getWriter().flush();
		}

	}
	
	/**
	 * 名称: 新增会议室占用信息
	 * @param roomApply
	 */
	@AroundAspect(description="会议室申请-新增会议室占用信息")
	private void doSaveRoomUsed(BizMtRoomApplyEntity roomApply) {
		try {
			BizMtRoomUsingEntity roomUsed = new BizMtRoomUsingEntity();
			roomUsed.setRoom_id(roomApply.getRoom_id());
			roomUsed.setMeeting_name(roomApply.getMeeting_name());
			roomUsed.setPurpose(roomApply.getPurpose());
			roomUsed.setStart_time(roomApply.getStarttime());
			roomUsed.setEnd_time(roomApply.getEndtime());
			roomUsed.setApply_user_id(roomApply.getApply_user_id());
			roomUsed.setApply_time(roomApply.getTs());
			roomUsed.setRoom_apply_id(roomApply.getId());
			roomUsed.setDataDeptId(roomApply.getDataDeptId());
			roomUsed.setDataOrgId(roomApply.getDataOrgId());
			roomUsed.setDataUserId(roomApply.getDataUserId());
			roomUsed.setDataTenantId(roomApply.getDataUserId());
			//设置此占用信息状态为 审批中
			roomUsed.setStatus("1");
			roomUsedService.doSaveMtRoomUsing(roomUsed);
			System.out.println("------");
		} catch (Exception e) {
			logger.error("error",e);
		}

	}

	/**
	 * 名称: 获取当前排序
	 * 
	 * @return
	 */
	public int getSort() {
		int count = roomApplyService.getCount();
		count++;
		return count;

	}

}