package com.yonyou.aco.ECharts.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
/**
 * 名称: 项目预算报表. 
 * ---------------------------------------------------------
 * 
 * @Date 2017年2月23日
 * @author 王瑞朝
 * @since 1.0.0
 */
@Controller
@RequestMapping("/eCharts")
public class EChartsController {

	

	/**
	 * 名称: 跳转到项目预算报表页面 注释
	 * 
	 * @return
	 */
	@RequestMapping("/toIndexList")
	public String toInexList() {
		return "aco/ECharts/eCharts";
	}

	
}
