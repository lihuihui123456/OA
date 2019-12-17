package com.yonyou.aco.mtgmgr.web;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.mtgmgr.entity.BizMtMeetingRoomBean;
import com.yonyou.aco.mtgmgr.entity.BizMtMeetingRoomEntity;
import com.yonyou.aco.mtgmgr.service.IMeetingRoomService;
import com.yonyou.cap.common.audit.operatelog.annotation.AroundAspect;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 方法: 会议室基础信息管理 
 * 备注：原controller名称（roomManager）
 * ---------------------------------------------------------
 * 
 * @Date 2016年3月18日
 * @author 卢昭炜
 * @since 1.0.0
 */
@Controller
@RequestMapping("/meetingRoom")
public class MeetingRoomController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@Resource
	private IMeetingRoomService meetingRoomService;

	/**
	 * 名称: 跳转到会议室列表页 
	 * 备注：原方法名（roomList）
	 * @return
	 */
	@RequestMapping(value = "/toRroomList")
	@AroundAspect(description="会议室-跳转到会议室列表页")
	public String toRroomList() {
		return "/aco/meetingroom/roomlist";
	}

	/**
	 * 名称: 查询会议室信息
	 * 说明: 通过主键查询会议室信息
	 * 备注：原方法名（getDataById）
	 * @param id
	 * @return
	 */
	@RequestMapping("/findMTGRoomById/{id}")
	@AroundAspect(description="会议室-查询会议室信息")
	public @ResponseBody BizMtMeetingRoomEntity findMTGRoomById(@PathVariable String id){
		BizMtMeetingRoomEntity meetingRoom = new BizMtMeetingRoomEntity();
		try {
			meetingRoom = meetingRoomService.findMTGRoomById(id);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return meetingRoom;
	}

	/**
	 * 获取所有会议室
	 * 备注：原方法名称（getAllData）
	 * @param pagen
	 * @param rows
	 * @param roomName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findAllMTGRoom")
	@AroundAspect(description="会议室-分页查询所有会议室")
	public Map<String, Object> findAllMTGRoom(@RequestParam(value = "page", defaultValue = "0") int pageNum,
			@RequestParam(value = "rows", defaultValue = "10") int pageSize,
			@RequestParam(value = "roomName", defaultValue = "") String roomName,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value="query", required=false) String queryParams) {
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<BizMtMeetingRoomBean> pags;
			roomName = new String(roomName.getBytes("iso-8859-1"), "utf-8");
			if (!"".equals(roomName)) {
				pags = meetingRoomService.findAllMTGInfo(pageNum, pageSize,roomName,sortName,sortOrder);
				if(pageNum!=1&&pags.getTotalrecord()>0&&pags.getResults().size()==0){
					pags = meetingRoomService.findAllMTGInfo(pageNum-1, pageSize,roomName,sortName,sortOrder);
				}
			}else if(StringUtils.isNotBlank(queryParams)){
				pags = meetingRoomService.findAllMTGInfo(pageNum, pageSize,roomName,sortName,sortOrder,queryParams);
				if(pageNum!=1&&pags.getTotalrecord()>0&&pags.getResults().size()==0){
					pags = meetingRoomService.findAllMTGInfo(pageNum-1, pageSize,roomName,sortName,sortOrder,queryParams);
				}
			}else {
				pags = meetingRoomService.findAllMTGInfo(pageNum, pageSize,sortName,sortOrder);
				if(pageNum!=1&&pags.getTotalrecord()>0&&pags.getResults().size()==0){
					pags = meetingRoomService.findAllMTGInfo(pageNum-1, pageSize,sortName,sortOrder);
				}
			}
			map.put("total", pags.getTotalrecord());
			map.put("rows", pags.getResults());
			return map;
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
	}

	
	
	/**
	 * 通过Id获取会议室
	 * 
	 * @param id
	 * @return
	 */
	/*@ResponseBody
	@RequestMapping(value = "getMeetingRoomById")
	public BizMtMeetingRoomEntity getMeetingRoomById(
			@RequestParam(value = "id", defaultValue = "0") String id) {

		BizMtMeetingRoomEntity meetingRoom = new BizMtMeetingRoomEntity();
		try {
			meetingRoom = meetingRoomService.findMTGRoomById(id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return meetingRoom;
	}*/

	/**
	 * 添加会议室
	 * 备注：原方法名（addMeetingRoom）
	 * @param mr
	 * @return
	 * @throws IOException
	 */
	@RequestMapping(value = "doAddMeetingRoom")
	@AroundAspect(description="会议室-添加会议室")
	public @ResponseBody String doAddMeetingRoom(BizMtMeetingRoomEntity mr,HttpServletRequest request) throws IOException {
		
		
		String room_name=mr.getRoom_name();
		String room_num=mr.getRoom_num();
		boolean roomexit=findExstRoomName("room_name",room_name);
		boolean numexit=findEXSTRoomNum("room_num",room_num);
		if(roomexit==false){
			return "{\"result\":\"roomname\"}";
		}else if(numexit==false){
			return "{\"result\":\"roomnum\"}";
		}else{
			try{
				if(mr.getRoom_name()!=null&&mr.getRoom_num()!=null&&mr.getSeats()!=null){
					mr.setId(null);
					String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
					mr.setTs(date);
					mr.setRecord_date(date);
					ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
					if (user != null) {
						mr.setRecord_userid(user.getUserId());
					}
					mr.setSort(getSort());
					meetingRoomService.doAddMeetingRoom(mr);
				}
				return "{\"result\":\"true\"}";
			}catch(Exception e){
				logger.error("error",e);
				return "{\"result\":\"false\"}";
			}
		}
	}

	/**
	 * TODO: 获取当前排序
	 * 
	 * @return
	 */
	public int getSort() {
		int count = meetingRoomService.getCount();
		count++;
		return count;

	}

	/**
	 * 修改会议室
	 * 备注：原方法名（updateMeetingRoom）
	 * @param mr
	 * @return
	 * @throws IOException
	 */
	@ResponseBody
	@RequestMapping(value = "doUpdateMeetingRoom")
	@AroundAspect(description="会议室-修改会议室")
	public String doUpdateMeetingRoom(BizMtMeetingRoomEntity mr,HttpServletRequest request) throws IOException {
		try{
			BizMtMeetingRoomEntity mtr=meetingRoomService.findMTGRoomById(mr.getId());
			mr.setRoom_name(mtr.getRoom_name());
			mr.setRoom_num(mtr.getRoom_num());
			meetingRoomService.doUpdateMeetingRoom(mr);
			return "{\"result\":\"true\"}";
		}catch(Exception e){
			logger.error("error",e);
			return "{\"result\":\"false\"}";
		}
	}

	/**
	 * 根据id删除会议室 可批量删除
	 * 备注：原方法名（delMeetingRoom）
	 * @param ids
	 *            多个id拼成的字符串以 , 分割
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "doDelMeetingRoom")
	@AroundAspect(description="会议室-删除会议室")
	public int doDelMeetingRoom(@RequestParam(value = "ids[]") String[] ids) {
		int count = 0;//未成功删除的记录数
		try {
			if (ids != null && ids.length != 0) {
			count = meetingRoomService.doDelMeetingRoom(ids);
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return count;
	}
	
	/**
	 * 名称: 检测新增房间是否存在.
	 * 备注：原方法名（checkRoom）
	 * @param fileId
	 * @param fieldValue
	 * @return
	 */
	public boolean findEXSTRoomNum(String fileId,String fieldValue) {
		try {
			fieldValue = new String(fieldValue.getBytes("iso-8859-1"), "utf-8");
		} catch (UnsupportedEncodingException e) {
			logger.error("error",e);
		}
		List<BizMtMeetingRoomEntity> list = meetingRoomService.findEXSTRoom(fileId,fieldValue);
		if (list != null && list.size() > 0) {
			return false;
		} else {
			return true;
		}
	}
	
	/**
	 * 方法: 会议室名称验证.
	 * @param fileId
	 * @param fieldValue
	 * @return
	 */
	public boolean findExstRoomName(String fileId,String fieldValue) {
		/*try {
			fieldValue = new String(fieldValue.getBytes("iso-8859-1"), "gbk");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}*/
		List<BizMtMeetingRoomEntity> list = meetingRoomService.getDataByRoomname(fileId,fieldValue);
		if (list != null && list.size() > 0) {
			return false;
		} else {
			return true;
		}
	}
}
