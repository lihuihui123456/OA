package com.yonyou.aco;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.yonyou.cap.isc.menu.entity.Module;
import com.yonyou.cap.isc.menu.service.IModuleService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:config/spring/spring-context.xml" })
@TransactionConfiguration(transactionManager="transactionManager", defaultRollback=false)  
@Transactional
public class BpmTest {
	
	@Resource
	IModuleService moduleService;
	
	/**
	 * 创建流程模型
	 */
	@Test
	public void test1(){
		List<Module> lists = moduleService.findAllModule();
		String oldUrl;
		String newUrl;
		String id = null;
		int i = 0;
		try {
			for(Module module : lists){
				newUrl = "/bpmRunController/bpmRunList";
				oldUrl = module.getModUrl();
				if(StringUtils.isNotEmpty(oldUrl) 
						&& oldUrl.startsWith("/bpmRuBizInfoController/solRunList/")){
					id=module.getModId();
					System.out.println("旧路径="+module.getModUrl());
					newUrl +=oldUrl.substring(oldUrl.lastIndexOf("/"), oldUrl.length());
					System.out.println("新路径="+newUrl);
					/*module.setModUrl(newUrl);
					moduleService.doUpdateModule(module);*/
					i++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("=================执行到次记录出现问题："+id+"===============");
		}finally{
			System.out.println("=================更新条目数："+i);
		}
		
	}
	
	/**
	 * 创建流程模型
	 */
	@Test
	public void test(){
		List<Module> lists = moduleService.findAllModule();
		String oldUrl;
		String newUrl;
		String id = null;
		int i = 0;
		try {
			for(Module module : lists){
				newUrl = "/bpmRunController/bpmRunList";
				oldUrl = module.getModUrl();
				if(StringUtils.isNotEmpty(oldUrl) 
						&& oldUrl.startsWith("/bpmRuBizInfoController/solRunList/")){
					id=module.getModId();
					System.out.println("旧路径="+module.getModUrl());
					newUrl +=oldUrl.substring(oldUrl.lastIndexOf("/"), oldUrl.length());
					System.out.println("新路径="+newUrl);
					module.setModUrl(newUrl);
					moduleService.doUpdateModule(module);
					i++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("=================执行到次记录出现问题："+id+"===============");
		}finally{
			System.out.println("=================更新条目数："+i);
		}
		
	}
}
