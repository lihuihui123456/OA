package com.yonyou.aco.circularize.web;

import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import javax.validation.Valid;

import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.circularize.entity.BizCircularizeBasicInfoEntity;
import com.yonyou.aco.circularize.entity.BizCircularizeLinkEntity;
import com.yonyou.aco.circularize.service.CircularizeService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 方法: 传阅件（文件交互）
 * 说明: 填写Class详细说明 
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年11月9日
 * @author  薛志超
 * @since   1.0.0
 */
@Controller
@RequestMapping("/circularize")
public class CircularizeController {


	@Autowired
	CircularizeService circularizeService ;
	
	/**
	 * 拟稿
	 * @return
	 */
	@RequestMapping("/index")
	public @ResponseBody ModelAndView indexCircularize(){
		
		ModelAndView mv=new ModelAndView();
		BizCircularizeBasicInfoEntity basicinformation = new BizCircularizeBasicInfoEntity();
		//原tableid增加1策略，改成uuid生成机制
		//String tableid = circularizeService.getMaxTableid();
		String tableid = UUID.randomUUID().toString();
		System.out.println("------"+tableid);
		basicinformation.setTable_id(tableid);
		
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			basicinformation.setCirculated_people(user.getName());
			basicinformation.setCirculated_people_id(user.getUserId());
		}
		String id = UUID.randomUUID().toString();
		mv.addObject("id", id);
		mv.addObject("action", "add");
		mv.addObject("basicinformation", basicinformation);
		mv.addObject("mainBodySRC","iWebPdf/toPdfDeitPage?bizId="+id);
		mv.setViewName("aco/circularize/filecy");
		
		return mv;
	}
	
	/**
	 * 阅件传阅列表
	 * @return
	 */
	@RequestMapping("/inexlist")
	public String indexList(){
		return "aco/circularize/filecylist";
	}
	
	/**
	 * 
	 * TODO: 分页查询列表，模糊搜索标题
	 * @param page
	 * @param rows
	 * @param query
	 * @return
	 */
	@RequestMapping("/getAllBasicinfo")
	public @ResponseBody TreeGridView<BizCircularizeBasicInfoEntity> getAllBasicinfo(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "query") String query){

		TreeGridView<BizCircularizeBasicInfoEntity> treeGridview = new TreeGridView<BizCircularizeBasicInfoEntity>();
		try {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			
			StringBuffer sb = new StringBuffer();
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			sb.append("1=1 and circulated_people_id like '%"+user.getId()+"%'");
			if (!"".equals(query) && query != null) {
				query=new String(query.getBytes("iso-8859-1"),"utf-8");
				sb.append(" and title like '%"+query+"%'");
			}
			sb.append(" order by creation_time desc");
			PageResult<BizCircularizeBasicInfoEntity> pags =  circularizeService.getAllBasicinfo(pageNum, pageSize, sb.toString());
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return treeGridview;
	}
	
	/**
	 * TODO: 保存表单信息操作
	 * @param basicinformation 
	 * @return
	 */
	@RequestMapping("/saveInfor/{action}")
	public @ResponseBody String saveInfo(@PathVariable String action,@Valid BizCircularizeBasicInfoEntity basicinformation){
		String statusId ="";
		if("add".equals(action)){
			Timestamp currentTime = new Timestamp(System.currentTimeMillis());
			basicinformation.setCreation_time(currentTime);
			statusId = circularizeService.saveInfo(basicinformation);
		}else{
			statusId = circularizeService.doUpdateInfo(basicinformation);
		}
		return statusId;
	}
	
	/**
	 * 阅件传阅修改、查看 数据回显方法
	 * @param id
	 * @param type 
	 * @return
	 */
	@RequestMapping("/queryBasicById")
	public @ResponseBody ModelAndView queryBasicById(
			@RequestParam(value = "id") String id,
			@RequestParam(value = "type") String type){
		
		System.out.println(type);
		int[] numbers = {0,0,0};
		
		BigInteger con1 = null;//总数
		BigInteger con2 = null;//已处理数
		BigInteger con3 = null;//未处理数
		BizCircularizeLinkEntity link = circularizeService.getCount(id);
		if (link != null) {
			con1 = link.getCol1();
			con2 = link.getCol2();
			con3 = link.getCol3();
			
			numbers[0] = con1.intValue();
			numbers[1] = con2.intValue();
			numbers[2] = con3.intValue();
		}
		
		ModelAndView mv=new ModelAndView();
		mv.addObject("type",type);
		mv.addObject("numbers",numbers);
		mv.addObject("action", "update");
		BizCircularizeBasicInfoEntity basicinformation=circularizeService.queryBasicById(id);
		mv.addObject("basicinformation", basicinformation);
		mv.addObject("id", id);
		mv.addObject("mainBodySRC","iWebPdf/toPdfDeitPage?bizId="+id);
		mv.setViewName("aco/circularize/filecy");
		return mv;
	}
	
	/**
	 * 阅件接收查看方法
	 * @param id
	 * @param type
	 * @return
	 */
	@RequestMapping("/queryBasicById_js")
	public @ResponseBody ModelAndView queryBasicById_js(
			@RequestParam(value = "id") String id,
			@RequestParam(value = "type") String type){
		
		System.out.println(type);
		
		int[] numbers = {0,0,0};
		
		BigInteger con1 = null;//总数
		BigInteger con2 = null;//已处理数
		BigInteger con3 = null;//未处理数
		BizCircularizeLinkEntity link = circularizeService.getCount(id);
		if (link != null) {
			con1 = link.getCol1();
			con2 = link.getCol2();
			con3 = link.getCol3();
			
			numbers[0] = con1.intValue();
			numbers[1] = con2.intValue();
			numbers[2] = con3.intValue();
		}
		ModelAndView mv=new ModelAndView();
		
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		BizCircularizeLinkEntity bean = circularizeService.queryLinkById(id,user.getId());
		
		bean.setStatus("1");
		circularizeService.saveLinkInfo(bean);
		
		
		BizCircularizeBasicInfoEntity basicinformation = circularizeService.queryBasicById(id);
		basicinformation.setOpinion(bean.getOpinion());
		String val = bean.getId();
		basicinformation.setBid(val.toString());
		mv.addObject("type",type);
		mv.addObject("numbers",numbers);
		mv.addObject("id", id);
		mv.addObject("basicinformation", basicinformation);
		mv.addObject("action", "update");
		mv.addObject("mainBodySRC","iWebPdf/toPdfDeitPage?bizId="+id);
		mv.setViewName("aco/circularize/filejs");
		return mv;
	}
	
	@RequestMapping("/queryGTasksstatus")
	public @ResponseBody String queryGTasksstatus(
		   @RequestParam(value = "id") Long id){
		return circularizeService.queryGTasksstatus(id);
	}
	
	@RequestMapping("/sendGTasks")
	public @ResponseBody String sendGTasks(
			@RequestParam(value = "circulatedpeopleid") String circulatedpeopleid,
			@RequestParam(value = "mustseeid") String mustseeid,
			@RequestParam(value = "sceneid") String sceneid,
			@RequestParam(value = "id") String id){
		circularizeService.saveLink(circulatedpeopleid, mustseeid, sceneid, id);
		return "1";
	}
	
	@RequestMapping("/sendInfor")
	public @ResponseBody String sendInfor(
			@RequestParam(value = "id") String id){
		BizCircularizeBasicInfoEntity bean = circularizeService.queryBasicById(id);
		
		bean.setStatus("1");
		circularizeService.saveInfo(bean);
		
		String circulatedpeopleid = null;
		String mustseeid = null;
		String sceneid = null;
		if(bean != null){
			circulatedpeopleid = bean.getCirculated_people_id();
			mustseeid = bean.getMustsee_id();
			sceneid = bean.getScene_id();
		}
		circularizeService.saveLink(circulatedpeopleid, mustseeid, sceneid, bean.getId());
		return "1";
	}
	
	
	@RequestMapping("/inexJslist")
	public String inexJslist(){
		return "aco/circularize/filejslist";
	}
	
	/**
	 * 阅件接收
	 * @param page
	 * @param rows
	 * @param query
	 * @return
	 */
	@RequestMapping("/getAllBasicinfoJs")
	public @ResponseBody TreeGridView<BizCircularizeBasicInfoEntity> getAllBasicinfoJs(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "query") String query){

		TreeGridView<BizCircularizeBasicInfoEntity> treeGridview = new TreeGridView<BizCircularizeBasicInfoEntity>();
		PageResult<BizCircularizeBasicInfoEntity> pags = new PageResult<BizCircularizeBasicInfoEntity>();
		
		try {
			if (pageNum != 0){
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			
			if (!"".equals(query) && query != null) {
				query=new String(query.getBytes("iso-8859-1"),"utf-8");
			}
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			String userid = user.getId();
			pags =  circularizeService.getAllBasicinfoJs(pageNum, pageSize, userid,query);
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return treeGridview;
	}
	
	/**
	 * TODO: 保存表单信息操作
	 * @param basicinformation 
	 * @return
	 */
	@RequestMapping("/saveLinkInfor")
	public @ResponseBody String saveLinkInfor(@Valid BizCircularizeBasicInfoEntity basicinformation,
			@RequestParam(value = "flag") String flag){
		Date now = new Date();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//可以方便地修改日期格式
		String time = dateFormat.format( now ); 
		String id = basicinformation.getId();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		/**
		 * 保存人员信息(提交时保存)
		 */
		if("1".equals(flag)){
			
			String circulatedpeopleid = user.getId();
			String	circulatedpeople = user.getName();
			String mustseeid =  basicinformation.getMustsee_id();
			String mustsee = basicinformation.getMustsee();
			String sceneid = basicinformation.getScene_id();
			String scene = basicinformation.getScene();
			
			BizCircularizeBasicInfoEntity entity = circularizeService.queryBasicById(id);
			String _circulatedpeopleid = entity.getCirculated_people_id();
			String _circulatedpeople = entity.getCirculated_people();
			String _mustseeid =  entity.getMustsee_id();
			String _mustsee = entity.getMustsee();
			String _sceneid = entity.getScene_id();
			String _scene = entity.getScene();
			
			if(_circulatedpeopleid !=null && !"".equals(_circulatedpeopleid) 
					&& _circulatedpeopleid.indexOf(circulatedpeopleid) == -1){
				entity.setCirculated_people_id(_circulatedpeopleid + ","+circulatedpeopleid);
				entity.setCirculated_people(_circulatedpeople + ","+circulatedpeople);
			}
			
			if(_mustseeid.indexOf(mustseeid) == -1){
				if(_mustseeid == null || "".equals(_mustseeid)) {
					entity.setMustsee_id(mustseeid);
					entity.setMustsee(mustsee);
				}else{
					entity.setMustsee_id(_mustseeid + ","+mustseeid);
					entity.setMustsee(_mustsee + ","+mustsee);
				}
				
			}
			
			if(_sceneid.indexOf(sceneid) == -1){
				if(_sceneid == null || "".equals(_sceneid)) {
					entity.setScene_id(sceneid);
					entity.setScene(scene);
				}else{
					entity.setScene_id(_sceneid + ","+sceneid);
					entity.setScene(_scene + ","+scene);
				}
			}
			
			circularizeService.saveInfo(entity);
		}
		
		/**
		 * 保存意见信息
		 */
		BizCircularizeLinkEntity bean = circularizeService.queryLinkById(id,user.getId());
		bean.setFinishtime(time);
		bean.setOpinion(basicinformation.getOpinion());
		
		circularizeService.saveLinkInfo(bean);
		return "1";
	}
	
	/**
	 * 查看阅件信息
	 * @param page
	 * @param rows
	 * @param query
	 * @return
	 */
	@RequestMapping("/getAllLinkinfo")
	public @ResponseBody TreeGridView<BizCircularizeLinkEntity> getAllLinkinfo(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "id") String id){

		TreeGridView<BizCircularizeLinkEntity> treeGridview = new TreeGridView<BizCircularizeLinkEntity>();
		PageResult<BizCircularizeLinkEntity> pags = new PageResult<BizCircularizeLinkEntity>();
		
		try {
			pags =  circularizeService.getAllLinkinfo(id);
			treeGridview.setRows(pags.getResults());
			treeGridview.setTotal(pags.getTotalrecord());
			return treeGridview;
		} catch (Exception e) {
			return null;
		}
	}
	
	/**
	 * 删除
	 * @param request
	 * @return
	 */
	@RequestMapping("/deleteBasicById")
	public @ResponseBody String deleteBasicById(
			@RequestParam(value = "ids") String id){
		try {
			if (id != null && !"".equals(id)) {
				String[] ids = id.split(",");
				for (int i = 0; i < ids.length; i++) {
					circularizeService.deleteById(ids[i]);
				}
			}
			return "true";
		} catch (Exception ex) {
			return "false";
		}
	}
}
