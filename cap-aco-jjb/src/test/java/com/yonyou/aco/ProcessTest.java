package com.yonyou.aco;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.RuntimeService;
import org.activiti.engine.TaskService;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.yonyou.cap.bpm.service.IBpmService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "classpath:applicationContext.xml" })
@TransactionConfiguration(transactionManager="transactionManager", defaultRollback=false)  
@Transactional
public class ProcessTest {
	
	@Resource
	RepositoryService repositoryService;
	@Resource
	RuntimeService runtimeService;
	@Resource
	TaskService taskService;
	@Resource
	IBpmService bpmService;
	
	/**
	 * 部署流程
	 */
	@Test
	public void deployProcess() {
		System.out.println("部署中...");
		Deployment deploy = repositoryService.createDeployment().name("文件报批单")
				.addClasspathResource("activiti/MyProcessTest.bpmn20.xml")
				.addClasspathResource("activiti/MyProcessTest.png")
				.deploy();
		System.out.println(deploy.getId());
	}

	/**
	 * 启动流程
	 */
	@Test
	public void startProcess(){
		System.out.println("启动中...");
		
		String procDefId = "MyProcessTest:5:c0c38cbd-b244-11e6-b31f-1002b54e388d";
		
		Map<String, Object> variables = new HashMap<String, Object>();
		variables.put("userId", "u1");
		ProcessInstance processInstance =runtimeService.startProcessInstanceById(procDefId, variables);
		System.out.println("procInstId:"+processInstance.getId());
		List<Task> tasks = taskService.createTaskQuery().processInstanceId(processInstance.getId()).list();
		System.out.println("----------------------------------------------------------");
		for (Task task : tasks) {
			System.out.println("任务Id:"+ task.getId());
			System.out.println("环节:"+ task.getName());
			System.out.println("办理人:"+ task.getAssignee());
			System.out.println("----------------------------------------------------------");
		}
	}
	
	/**
	 * 送普通节点
	 */
	@Test
	public void runProcess(){
		String taskId = "26914cd5-b246-11e6-bd8a-1002b54e388d";
		Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
		Map<String, Object> variables = new HashMap<String, Object>();
		//variables.put("userId", "u3");
		//variables.put("actName", "节点二");
		taskService.complete(taskId, variables);
		List<Task> tasks = taskService.createTaskQuery().processInstanceId(task.getProcessInstanceId()).list();
		System.out.println("----------------------------------------------------------");
		for (Task tk : tasks) {
			System.out.println("任务Id:"+ tk.getId());
			System.out.println("环节:"+ tk.getName());
			System.out.println("办理人:"+ tk.getAssignee());
			System.out.println("----------------------------------------------------------");
		}
	}
	
	/**
	 * 送会签节点
	 */
	@Test
	public void runHqProcess(){
		System.out.println("送会签...");
		String taskId = "c07b441b-b245-11e6-87be-1002b54e388d";
		Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
		Map<String, Object> variables = new HashMap<String, Object>();
		variables.put("assigneeList", Arrays.asList(""));
		variables.put("actName", "拟稿会签");
		taskService.complete(taskId, variables);
		List<Task> tasks = taskService.createTaskQuery().processInstanceId(task.getProcessInstanceId()).list();
		System.out.println("----------------------------------------------------------");
		for (Task tk : tasks) {
			System.out.println("任务Id:"+ tk.getId());
			System.out.println("环节:"+ tk.getName());
			System.out.println("办理人:"+ tk.getAssignee());
			System.out.println("----------------------------------------------------------");
		}
	}
	
	@Test
	public void test() {
		String taskId = "42c01d38-4a5d-11e7-94e5-1002b54e388d";
		ActivityImpl lastActivity = bpmService.getLastActivity(taskId);
		if(lastActivity != null) {
			System.out.println(lastActivity.getId());
		}else {
			System.out.println("--");
		}
	}
}
