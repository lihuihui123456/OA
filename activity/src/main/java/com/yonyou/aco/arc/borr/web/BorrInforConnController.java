package com.yonyou.aco.arc.borr.web;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.arc.borr.entity.IWebDocumentBean;
import com.yonyou.aco.arc.borr.service.IBorrInforService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;

@Controller
@RequestMapping("/borrInforConn")
public class BorrInforConnController {

	@Autowired
	IBorrInforService borrInforService;
	
	@RequestMapping("/enclosureFileForm")
	public ModelAndView enclosureFileForm(HttpServletRequest request){
		ModelAndView mv=new ModelAndView();
		mv.setViewName("/aco/arc/borrinfor/file-attach-list-form");
		return mv;
	}
	
	/**
	 * @param 列出所有有效的业务数据
	 * @param pagesize
	 * @return
	 */
	@RequestMapping("/listAllBiz")
	public @ResponseBody TreeGridView<IWebDocumentBean> lisAllBiz(
							@RequestParam(value = "page", defaultValue = "0") int pagenum,
							@RequestParam(value = "rows", defaultValue = "10") int pagesize,
							@RequestParam(value = "title",required=false) String title
			) {
			
		try {
			TreeGridView<IWebDocumentBean> page = new TreeGridView<IWebDocumentBean>();
			if (pagenum != 0) {
				pagenum = pagenum / pagesize;
			}
			String title_="";
			try {
				//前台两次编码，后台两次解码
				title = new String(title.getBytes("ISO-8859-1"),"utf-8");
				title=URLDecoder.decode(title,"UTF-8");
				title_=URLDecoder.decode(title,"UTF-8");
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			pagenum++;		
			String wheresql="";
			if(StringUtils.isNotEmpty(title_)){
				wheresql=" and a.ARC_NAME like '%"+title_+"%' ";
			}
			PageResult<IWebDocumentBean> pags = borrInforService.listEnclosureAndTitle(pagenum, pagesize,wheresql);
			page.setRows(pags.getResults());
			page.setTotal(pags.getTotalrecord());
			return page;
		} catch (Exception ex) {
			return null;
		}
	}

}
