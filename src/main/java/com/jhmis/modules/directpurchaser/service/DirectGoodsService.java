/**
 * Copyright &copy; 2005-2020 <a href="http://www.jhmis.com/">jhmis</a> All rights reserved.
 */
package com.jhmis.modules.directpurchaser.service;

import com.haier.link.upper.dto.ProductInfo;
import com.haier.link.upper.model.ProductMaterial;
import com.haier.link.upper.model.ProductSpecification;
import com.haier.link.upper.model.Sign;
import com.haier.link.upper.model.SimpleProduct;
import com.haier.link.upper.service.LinkProductUpperReadService;
import com.haier.oms.client.model.qiyegou.QiYeGouQueryStockInfo;
import com.haier.util.OMS_Query;
import com.jhmis.common.config.Global;
import com.jhmis.core.persistence.Page;
import com.jhmis.core.service.CrudService;
import com.jhmis.modules.directpurchaser.mapper.DirectGoodsMapper;
import com.jhmis.modules.shop.entity.*;
import com.jhmis.modules.shop.mapper.*;
import com.jhmis.modules.shop.service.MdmCustomersPartnerService;
import com.jhmis.modules.shop.service.MdmCustomersSourceService;
import com.jhmis.modules.shop.service.StoreGoodsService;
import com.jhmis.modules.sys.entity.User;
import com.jhmis.modules.sys.utils.UserUtils;
import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;

/**
 * 商品表Service
 * @author tity
 * @version 2018-07-23
 */
@Service
@Transactional(readOnly = true)
public class DirectGoodsService extends CrudService<GoodsMapper, Goods> {
	 protected Logger logger = LoggerFactory.getLogger(DirectGoodsService.class);
	@Resource
	private GoodsExtMapper goodsExtMapper;

	@Resource
	private GoodsCategoryMapper goodsCategoryMapper;
	
    @Autowired
    private MdmCustomersPartnerService mdmCustomersPartnerService;
    
    @Autowired
    private MdmCustomersSourceService mdmCustomersSourceService;

   @Resource
    private TrancheProductMapper trancheProductMapper;

    @Resource
	private GoodsPropertiesMapper goodsPropertiesMapper;
    
    
    @Resource
	private DirectGoodsMapper directGoodsMapper;
    @Resource
	private StoreGoodsService storeGoodsService;


	public Goods get(String id) {
		return super.get(id);
	}

	public Goods findByCode(String code) {
		return directGoodsMapper.findByCode(code);
	}
	
	public List<Goods> findList(Goods goods) {
		return super.findList(goods);
	}
	
	public Page<Goods> findPage(Page<Goods> page, Goods goods) {
		return super.findPage(page, goods);
	}

	/**
	 * 查询分页数据
	 * @param page 分页对象
	 * @param goods
	 * @return
	 */
	public Page<Goods> findNoPublishPage(Page<Goods> page, Goods goods) {
		dataRuleFilter(goods);
		goods.setPage(page);
		page.setList(mapper.findNoPublishList(goods));
		return page;
	}
	
	
	public Page<Goods> purchaserGoodsRelDate(Page<Goods> page, String purchaserId) {
		
		List<Goods> newList = new ArrayList<Goods>();
		List<Goods> glist=directGoodsMapper.findPurchaserRelList(purchaserId);
		if(CollectionUtils.isNotEmpty(glist)){
			List<String> codes = new ArrayList<String>();
			for(Goods goods : glist){
				codes.add(goods.getCode());
			}
			if(CollectionUtils.isNotEmpty(codes)){
				Map<String,StoreGoods> map = new HashMap<String, StoreGoods>();
				StoreGoods storeGoods = new StoreGoods();
				storeGoods.setIdList(codes);
				List<StoreGoods> storeGoodsList = storeGoodsService.getStoreGoodsByCodes(storeGoods);
				if(CollectionUtils.isNotEmpty(storeGoodsList)){
					for(StoreGoods s : storeGoodsList){
						map.put(s.getCode(),s);
					}
					for(Goods goods : glist){
						if(map != null){
							StoreGoods s = map.get(goods.getCode());
							if(s != null){
								goods.setStoreGoodsId(s.getId());
							}
							newList.add(goods);
						}
					}

				}

			}

		}


		if(newList!=null && newList.size()>0){
			page.setCount(newList.size());
		}
		page.setList(newList);
		return page;
	}

	public Goods findPurchaserRelByGoods(Goods goods){
		return directGoodsMapper.findPurchaserRelByGoods(goods);
	}
	
	public Page<Goods> purchaserGoodsRelDate(Page<Goods> page,Goods g) {
		
        String code = g.getCustomersPartnerID();
        String salesFactory ="";
        String mainHouse="";
        logger.info("code================"+code);
        if(StringUtils.isNotBlank(code)){
			MdmCustomersSource  mdms=new MdmCustomersSource ();
			mdms.setCusCode(code);
			List<MdmCustomersSource>  ms= mdmCustomersSourceService.findList(mdms);
			logger.info("ms============"+ms);
			if(ms!=null && ms.size()>0){
				MdmCustomersSource m=ms.get(0);
				logger.info("sssssssssss"+m);
				if(m!=null){
//        		销售工厂
					salesFactory=m.getComCode();
					//工贸
					mainHouse=m.getOrgId();
				}
			}
		}
        logger.info("1111111111111111"+code);
		List<Goods> newList = new ArrayList<Goods>();
		List<Goods> glist=directGoodsMapper.findPurchaserRelListByGoods(g);
		logger.info("glist=============="+glist.size());
		if(CollectionUtils.isNotEmpty(glist)){
			List<String> codes = new ArrayList<String>();
			logger.info("11111111111111111111111");
			for(Goods goods : glist){
				codes.add(goods.getCode());
			}
			logger.info("222222222222222222");
			if(CollectionUtils.isNotEmpty(codes)){
				logger.info("33333333333333333");
				Map<String,StoreGoods> map = new HashMap<String, StoreGoods>();
				StoreGoods storeGoods = new StoreGoods();
				storeGoods.setIdList(codes);
				List<StoreGoods> storeGoodsList = storeGoodsService.getStoreGoodsByCodes(storeGoods);
				if(CollectionUtils.isNotEmpty(storeGoodsList)){
					for(StoreGoods s : storeGoodsList){
						logger.info("sdss");
						map.put(s.getCode(),s);
					}
					logger.info("2222222222222222");
					for(Goods goods : glist){
						if(map != null){
							StoreGoods s = map.get(goods.getCode());
							if(s != null){
								goods.setStoreGoodsId(s.getId());
							}
						}
						logger.info("3333333333333");
						if(StringUtils.isNotEmpty(salesFactory)){
							Map mapret=OMS_Query.query(salesFactory, mainHouse, goods.getCode());
							logger.info("mapret=============="+mapret);
							if(mapret!=null){
								if("SUCCESS".equals(mapret.get("result"))){
									List<QiYeGouQueryStockInfo> stockList=(List)mapret.get("detail");
									if(stockList!=null && stockList.size()>0){
										QiYeGouQueryStockInfo si=stockList.get(0);
										if(si!=null){
											goods.setStock(si.getNum());
										}
									}
								}
							}
						}
						newList.add(goods);
					}

				}else {
					logger.info("44444444444444444");
					newList.addAll(glist);
				}

			}

		}

		logger.info("6666666666666666");
		if(newList!=null && newList.size()>0){
			page.setCount(newList.size());
		}
		logger.info("vvvvvvvvvvvvvvvvvvv");
		page.setList(newList);
		return page;
	}
	
//	public Page<Goods> purchaserGoodsRelDate(Page<Goods> page, Goods goods) {
////		page.setList(directGoodsMapper.findPurchaserRelListByGoods(goods));
//		System.out.println(page.getList().size());
//		return page;
//	}
	
	
	@Transactional(readOnly = false)
	public void save(Goods goods,LinkProductUpperReadService linkProductUpperReadService,long key,String secret) {
		if(mapper.findByCode(goods.getCode())!=null){
			//更新时先删后插
			goodsExtMapper.deleteByCode(goods.getCode());
			goods.setUpdateDate(new Date());
			//处理图片全路径
			if(goods.getMainPicUrl()!=null){
				//证明有值则判断是否是来自用户总新的
				String arr[] = goods.getMainPicUrl().split("\\|");
				if(arr.length>0){
					String endMainPicUrl = "";
					for(int i=0; i<arr.length; i++){
						if(arr[i].contains("http://file.c.haier.net")){
							endMainPicUrl = goods.getMainPicUrl();
						}else if(arr[i].contains(Global.BASE_URL)){
							endMainPicUrl = goods.getMainPicUrl();
						}
						else{
							endMainPicUrl += Global.BASE_URL + arr[i] + "|";
						}
					}
					String endStr = endMainPicUrl.substring(endMainPicUrl.length()-1,endMainPicUrl.length());
					if("|".equals(endStr)){
						endMainPicUrl.substring(0,endMainPicUrl.length()-1);
					}
					goods.setMainPicUrl(endMainPicUrl);
				}
			}
			mapper.update(goods);
		}else{
			//进行属性赋值
			Sign s = new Sign(key, secret);
			ProductInfo productInfo = linkProductUpperReadService.getProductInfoByCode(goods.getCode(), s).getResult();
			List<ProductSpecification> productSpecificationList = productInfo.getProductSpecifications();
			List<ProductMaterial> productPicturesList = productInfo.getProductPictures();
			//图片赋值
			if(productPicturesList!=null){
				String imgurl = "";
				for(ProductMaterial productMaterial:productPicturesList){
					imgurl +=productMaterial.getUrl()+ "|";
				}
				if(!"".equals(imgurl)){
					goods.setMainPicUrl(imgurl.substring(0,imgurl.length()-1));
				}
			}else{
				//如果存在自己录入值
				//处理图片全路径
				if(goods.getMainPicUrl()!=null){
					//证明有值则判断是否是来自用户总新的
					String arr[] = goods.getMainPicUrl().split("\\|");
					if(arr.length>0){
						String endMainPicUrl = "";
						for(int i=0; i<arr.length; i++){
							if(arr[i].contains("http://")){
								endMainPicUrl = goods.getMainPicUrl();
							}else{
								endMainPicUrl += Global.BASE_URL + arr[i] + "|";
							}
						}
						goods.setMainPicUrl(endMainPicUrl);
					}
				}
			}
			//属性赋值
			if(productSpecificationList!=null){
				//属性值不为空,进行循环赋值
				for(ProductSpecification productSpecification:productSpecificationList){
					GoodsProperties goodsProperties = new GoodsProperties();
					goodsProperties.setGoodsCode(goods.getCode());
					goodsProperties.setTag(productSpecification.getTag());
					goodsProperties.setName(productSpecification.getName());
					goodsProperties.setValue(productSpecification.getValue());
					User user = UserUtils.getUser();
					if (StringUtils.isNotBlank(user.getId())){
						goodsProperties.setCreateBy(user);
					}
					goodsProperties.setCreateDate(new Date());
					goodsPropertiesMapper.insert(goodsProperties);
				}
			}
			super.save(goods);
		}
		GoodsCategory goodsCategory = goodsCategoryMapper.get(goods.getCat().getId());
		//附加属性插入
		GoodsExt goodsExt = new GoodsExt();
		goodsExt.setCategoryId(goodsCategory.getId());
		goodsExt.setCategoryPid(goodsCategory.getParentId());
		goodsExt.setCode(goods.getCode());
		goodsExt.setMarketPrice(goods.getMarketPrice());
		goodsExt.setState(goods.getState());
		goodsExt.setCreateBy(new User());
		goodsExt.setCreateDate(new Date());
		goodsExtMapper.insert(goodsExt);

	}
	
	@Transactional(readOnly = false)
	public void delete(Goods goods) {
		goodsExtMapper.deleteByCode(goods.getCode());
		super.delete(goods);
	}
    /**
     * 导入一期产品
     */
    @Transactional(readOnly = false)
	public void importTranche(Sign s,LinkProductUpperReadService linkProductUpperReadService){
        TrancheProduct t = new TrancheProduct();
        List<TrancheProduct> trancheProduct_list = trancheProductMapper.findList(t);
        for(TrancheProduct trancheProduct:trancheProduct_list){
        	if(trancheProduct.getProductCode()!=null){
        		Goods hasGoods = mapper.findUniqueByProperty("code",trancheProduct.getProductCode());
        		if(hasGoods!=null){
        			continue;
				}
			}
            Goods good = new Goods();
            String code = trancheProduct.getProductCode();
			ProductInfo productInfo = linkProductUpperReadService.getProductInfoByCode(code, s).getResult();
            if(productInfo!=null){
                SimpleProduct simpleProduct = productInfo.getSimpleProduct();
				List<ProductMaterial> productPicturesList = productInfo.getProductPictures();
				List<ProductSpecification> productSpecificationList = productInfo.getProductSpecifications();
				//图片赋值
				String imgurl = "";
				if(productPicturesList!=null){
					for(ProductMaterial productMaterial:productPicturesList){
						imgurl +=productMaterial.getUrl()+ "|";
					}
					if(!"".equals(imgurl)){
						good.setMainPicUrl(imgurl.substring(0,imgurl.length()-1));
					}
				}
				//属性赋值
				if(productSpecificationList!=null){
					//属性值不为空,进行循环赋值
					for(ProductSpecification productSpecification:productSpecificationList){
						GoodsProperties goodsProperties = new GoodsProperties();
						goodsProperties.setGoodsCode(code);
						goodsProperties.setTag(productSpecification.getTag());
						goodsProperties.setName(productSpecification.getName());
						goodsProperties.setValue(productSpecification.getValue());
						User user = UserUtils.getUser();
						if (StringUtils.isNotBlank(user.getId())){
							goodsProperties.setCreateBy(user);
						}
						goodsProperties.setCreateDate(new Date());
						goodsPropertiesMapper.insert(goodsProperties);
					}
				}
                //在产品中心存在,证明查到了
                trancheProduct.setProductIscheck("0");
                good.setCode(simpleProduct.getCode());
                good.setMainPicUrl(imgurl);
                good.setName(simpleProduct.getProductGroupName()+simpleProduct.getName());
                super.save(good);
            }else{
                //在产品中心不存在,证明未查到了
                trancheProduct.setProductIscheck("1");
				trancheProductMapper.update(trancheProduct);
            }

        }
    }
}