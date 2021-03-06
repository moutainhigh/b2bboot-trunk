/**
 * Copyright &copy; 2005-2020 <a href="http://www.jhmis.com/">jhmis</a> All rights reserved.
 */
package com.jhmis.modules.shop.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;

import org.apache.shiro.authz.annotation.Logical;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.common.collect.Lists;
import com.jhmis.common.utils.DateUtils;
import com.jhmis.common.config.Global;
import com.jhmis.common.json.AjaxJson;
import com.jhmis.core.persistence.Page;
import com.jhmis.core.web.BaseController;
import com.jhmis.common.utils.StringUtils;
import com.jhmis.common.utils.excel.ExportExcel;
import com.jhmis.common.utils.excel.ImportExcel;
import com.jhmis.modules.shop.entity.DirectCart;
import com.jhmis.modules.shop.service.DirectCartService;

/**
 * 直采购物车Controller
 * @author hdx
 * @version 2019-03-27
 */
@Controller
@RequestMapping(value = "${adminPath}/shop/directCart")
public class DirectCartController extends BaseController {

	@Autowired
	private DirectCartService directCartService;
	
	@ModelAttribute
	public DirectCart get(@RequestParam(required=false) String id) {
		DirectCart entity = null;
		if (StringUtils.isNotBlank(id)){
			entity = directCartService.get(id);
		}
		if (entity == null){
			entity = new DirectCart();
		}
		return entity;
	}
	
	/**
	 * 直采购物车列表页面
	 */
	@RequiresPermissions("shop:directCart:list")
	@RequestMapping(value = {"list", ""})
	public String list() {
		return "modules/shop/directCartList";
	}
	
	/**
	 * 直采购物车列表数据
	 */
	@ResponseBody
	@RequiresPermissions("shop:directCart:list")
	@RequestMapping(value = "data")
	public Map<String, Object> data(DirectCart directCart, HttpServletRequest request, HttpServletResponse response, Model model) {
		Page<DirectCart> page = directCartService.findPage(new Page<DirectCart>(request, response), directCart); 
		return getBootstrapData(page);
	}

	/**
	 * 查看，增加，编辑直采购物车表单页面
	 */
	@RequiresPermissions(value={"shop:directCart:view","shop:directCart:add","shop:directCart:edit"},logical=Logical.OR)
	@RequestMapping(value = "form")
	public String form(DirectCart directCart, Model model) {
		model.addAttribute("directCart", directCart);
		if(StringUtils.isBlank(directCart.getId())){//如果ID是空为添加
			model.addAttribute("isAdd", true);
		}
		return "modules/shop/directCartForm";
	}

	/**
	 * 保存直采购物车
	 */
	@RequiresPermissions(value={"shop:directCart:add","shop:directCart:edit"},logical=Logical.OR)
	@RequestMapping(value = "save")
	public String save(DirectCart directCart, Model model, RedirectAttributes redirectAttributes) throws Exception{
		if (!beanValidator(model, directCart)){
			return form(directCart, model);
		}
		//新增或编辑表单保存
		directCartService.save(directCart);//保存
		addMessage(redirectAttributes, "保存直采购物车成功");
		return "redirect:"+Global.getAdminPath()+"/shop/directCart/?repage";
	}
	
	/**
	 * 删除直采购物车
	 */
	@ResponseBody
	@RequiresPermissions("shop:directCart:del")
	@RequestMapping(value = "delete")
	public AjaxJson delete(DirectCart directCart, RedirectAttributes redirectAttributes) {
		AjaxJson j = new AjaxJson();
		directCartService.delete(directCart);
		j.setMsg("删除直采购物车成功");
		return j;
	}
	
	/**
	 * 批量删除直采购物车
	 */
	@ResponseBody
	@RequiresPermissions("shop:directCart:del")
	@RequestMapping(value = "deleteAll")
	public AjaxJson deleteAll(String ids, RedirectAttributes redirectAttributes) {
		AjaxJson j = new AjaxJson();
		String idArray[] =ids.split(",");
		for(String id : idArray){
			directCartService.delete(directCartService.get(id));
		}
		j.setMsg("删除直采购物车成功");
		return j;
	}
	
	/**
	 * 导出excel文件
	 */
	@ResponseBody
	@RequiresPermissions("shop:directCart:export")
    @RequestMapping(value = "export", method=RequestMethod.POST)
    public AjaxJson exportFile(DirectCart directCart, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes) {
		AjaxJson j = new AjaxJson();
		try {
            String fileName = "直采购物车"+DateUtils.getDate("yyyyMMddHHmmss")+".xlsx";
            Page<DirectCart> page = directCartService.findPage(new Page<DirectCart>(request, response, -1), directCart);
    		new ExportExcel("直采购物车", DirectCart.class).setDataList(page.getList()).write(response, fileName).dispose();
    		j.setSuccess(true);
    		j.setMsg("导出成功！");
    		return j;
		} catch (Exception e) {
			j.setSuccess(false);
			j.setMsg("导出直采购物车记录失败！失败信息："+e.getMessage());
		}
			return j;
    }

	/**
	 * 导入Excel数据

	 */
	@RequiresPermissions("shop:directCart:import")
    @RequestMapping(value = "import", method=RequestMethod.POST)
    public String importFile(MultipartFile file, RedirectAttributes redirectAttributes) {
		try {
			int successNum = 0;
			int failureNum = 0;
			StringBuilder failureMsg = new StringBuilder();
			ImportExcel ei = new ImportExcel(file, 1, 0);
			List<DirectCart> list = ei.getDataList(DirectCart.class);
			for (DirectCart directCart : list){
				try{
					directCartService.save(directCart);
					successNum++;
				}catch(ConstraintViolationException ex){
					failureNum++;
				}catch (Exception ex) {
					failureNum++;
				}
			}
			if (failureNum>0){
				failureMsg.insert(0, "，失败 "+failureNum+" 条直采购物车记录。");
			}
			addMessage(redirectAttributes, "已成功导入 "+successNum+" 条直采购物车记录"+failureMsg);
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入直采购物车失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/shop/directCart/?repage";
    }
	
	/**
	 * 下载导入直采购物车数据模板
	 */
	@RequiresPermissions("shop:directCart:import")
    @RequestMapping(value = "import/template")
    public String importFileTemplate(HttpServletResponse response, RedirectAttributes redirectAttributes) {
		try {
            String fileName = "直采购物车数据导入模板.xlsx";
    		List<DirectCart> list = Lists.newArrayList(); 
    		new ExportExcel("直采购物车数据", DirectCart.class, 1).setDataList(list).write(response, fileName).dispose();
    		return null;
		} catch (Exception e) {
			addMessage(redirectAttributes, "导入模板下载失败！失败信息："+e.getMessage());
		}
		return "redirect:"+Global.getAdminPath()+"/shop/directCart/?repage";
    }

}