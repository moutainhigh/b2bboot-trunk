﻿<%@ page contentType="text/html;charset=UTF-8" %>
<script>
$(document).ready(function() {
	$('#cmsActivityTable').bootstrapTable({
		 
		  //请求方法
               method: 'get',
               //类型json
               dataType: "json",
               //显示刷新按钮
               showRefresh: true,
               //显示切换手机试图按钮
               showToggle: true,
               //显示 内容列下拉框
    	       showColumns: true,
    	       //显示到处按钮
    	       showExport: true,
    	       //显示切换分页按钮
    	       showPaginationSwitch: true,
    	       //最低显示2行
    	       minimumCountColumns: 2,
               //是否显示行间隔色
               striped: true,
               //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）     
               cache: false,    
               //是否显示分页（*）  
               pagination: true,   
                //排序方式 
               sortOrder: "asc",  
               //初始化加载第一页，默认第一页
               pageNumber:1,   
               //每页的记录行数（*）   
               pageSize: 10,  
               //可供选择的每页的行数（*）    
               pageList: [10, 25, 50, 100],
               //这个接口需要处理bootstrap table传递的固定参数,并返回特定格式的json数据  
               url: "${ctx}/wechat/cmsActivity/data?meetingId=${meetingId}",
               //默认值为 'limit',传给服务端的参数为：limit, offset, search, sort, order Else
               //queryParamsType:'',   
               ////查询参数,每次调用是会带上这个参数，可自定义                         
               queryParams : function(params) {
               	var searchParam = $("#searchForm").serializeJSON();
               	searchParam.pageNo = params.limit === undefined? "1" :params.offset/params.limit+1;
               	searchParam.pageSize = params.limit === undefined? -1 : params.limit;
               	searchParam.orderBy = params.sort === undefined? "" : params.sort+ " "+  params.order;
                   return searchParam;
               },
               //分页方式：client客户端分页，server服务端分页（*）
               sidePagination: "server",
               contextMenuTrigger:"right",//pc端 按右键弹出菜单
               contextMenuTriggerMobile:"press",//手机端 弹出菜单，click：单击， press：长按。
               contextMenu: '#context-menu',
               onContextMenuItem: function(row, $el){
                   if($el.data("item") == "edit"){
                   	window.location = "${ctx}/wechat/cmsActivity/form?id=" + row.id;
                   } else if($el.data("item") == "delete"){
                        jh.confirm('确认要删除该活动表记录吗？', function(){
                       	jh.loading();
                       	jh.get("${ctx}/wechat/cmsActivity/delete?id="+row.id, function(data){
                   	  		if(data.success){
                   	  			$('#cmsActivityTable').bootstrapTable('refresh');
                   	  			jh.success(data.msg);
                   	  		}else{
                   	  			jh.error(data.msg);
                   	  		}
                   	  	})
                   	   
                   	});
                      
                   } 
               },
              
               onClickRow: function(row, $el){
               },
               columns: [{
		        checkbox: true
		       
		    }
			,{
		        field: 'meetingName',
		        title: '会议名称',
		        sortable: true
		        ,formatter:function(value, row , index){
		        	return "<a href='${ctx}/wechat/cmsActivity/form?id="+row.id+"'>"+value+"</a>";
		         }
		       
		    }
			,{
		        field: 'actvName',
		        title: '活动名称',
		        sortable: true
		       
		    }
			
			,{
		        field: 'creatUser',
		        title: '创建人',
		        sortable: true
		       
		    }
			,{
		        field: 'creatTime',
		        title: '创建时间',
		        sortable: true
		       
		    }
			
			,/*{
		        field: 'actvTab',
		        title: '活动是否有效',
		        sortable: true,
		        formatter:function(value, row , index){
					   return value=="1" ? '<font color="red">无效</font>':'<font color="green">正常</font>';
				   }
		       
		    }*/
			{
		        field: 'startTime',
		        title: '抽奖开始时间',
		        sortable: true
		       
		    }
			,{
		        field: 'remark',
		        title: '活动备注',
		        sortable: true
		       
		    },{
		        field: '',
		        title: '操作',
		        sortable: true,
		        formatter:function(value, row , index){
		        	//return '<a href="signupdraw?actvId='+row.id +'">参与人员</a> '+' | <a href="windraw?actvId='+row.id +'">中奖人员</a>';
		        	//href="${ctx}/wechat/cmsSignupDraw/list?actvId='+row.id +'"
		        	//return '<a href="${ctx}/wechat/cmsSignupDraw/list?actvId='+row.id +'">参与人</a> '+' | <a href="${ctx}/wechat/cmsWinPrize/list?actvId='+row.id +'" >中奖人员</a>';
		        	//return "<a href='javascript:canyu(\""+row.id+"\")'>"+"参与人"+"</a> "+' | <a href='javascript:zhongjiang(\""+row.id+"\")'>"+"中奖人员"+"</a> ";
		        	return "<a href='javascript:canyu(\""+row.id+"\")'>"+"参与人"+"</a>"+" | "+"<a href='javascript:zhongjiang(\""+row.id+"\")'>"+"中奖人员"+"</a>";
				   }
		    
		    }
		     ]
		
		});
		
		  
	  if(navigator.userAgent.match(/(iPhone|iPod|Android|ios)/i)){//如果是移动端

		 
		  $('#cmsActivityTable').bootstrapTable("toggleView");
		}
	  
	  $('#cmsActivityTable').on('check.bs.table uncheck.bs.table load-success.bs.table ' +
                'check-all.bs.table uncheck-all.bs.table', function () {
            $('#remove').prop('disabled', ! $('#cmsActivityTable').bootstrapTable('getSelections').length);
            $('#edit').prop('disabled', $('#cmsActivityTable').bootstrapTable('getSelections').length!=1);
            $('#draw').prop('disabled', $('#cmsActivityTable').bootstrapTable('getSelections').length!=1);
        });
		  
		$("#btnImport").click(function(){
			jh.open({
			    type: 1, 
			    area: [500, 300],
			    title:"导入数据",
			    content:$("#importBox").html() ,
			    btn: ['下载模板','确定', '关闭'],
				    btn1: function(index, layero){
					  window.location='${ctx}/wechat/cmsActivity/import/template';
				  },
			    btn2: function(index, layero){
				        var inputForm =top.$("#importForm");
				        var top_iframe = top.getActiveTab().attr("name");//获取当前active的tab的iframe 
				        inputForm.attr("target",top_iframe);//表单提交成功后，从服务器返回的url在当前tab中展示
				        inputForm.onsubmit = function(){
				        	jh.loading('  正在导入，请稍等...');
				        }
				        inputForm.submit();
					    jh.close(index);
				  },
				 
				  btn3: function(index){ 
					  jh.close(index);
	    	       }
			}); 
		});
		    
	  $("#search").click("click", function() {// 绑定查询按扭
		  $('#cmsActivityTable').bootstrapTable('refresh');
		});
	 
	 $("#reset").click("click", function() {// 绑定查询按扭
		  $("#searchForm  input").val("");
		  $("#searchForm  select").val("");
		  $("#searchForm  .select-item").html("");
		  $('#cmsActivityTable').bootstrapTable('refresh');
		});
		
		$('#startTime').datetimepicker({
			 format: "YYYY-MM-DD HH:mm:ss"
		});
		
	});
		
  function getIdSelections() {
        return $.map($("#cmsActivityTable").bootstrapTable('getSelections'), function (row) {
           //debugger;
        	//alert(row.meetingId);
        	return row.id
        });
    }
  function getIdSelectionsmeetingid() {
      return $.map($("#cmsActivityTable").bootstrapTable('getSelections'), function (row) {
         //debugger;
      	//alert(row.meetingId);
      	return row.meetingId
      });
  }
  function deleteAll(){

		jh.confirm('确认要删除该活动表记录吗？此操作不可逆，请谨慎操作！', function(){
			jh.loading();  	
			jh.get("${ctx}/wechat/cmsActivity/deleteAll?ids=" + getIdSelections(), function(data){
         	  		if(data.success){
         	  			$('#cmsActivityTable').bootstrapTable('refresh');
         	  			jh.success(data.msg);
         	  		}else{
         	  			jh.error(data.msg);
         	  		}
         	  	})
          	   
		})
  }
  function edit(){
	  window.location = "${ctx}/wechat/cmsActivity/form?id=" + getIdSelections();
  }
  
  function targerdraw(){
	 // debugger;  http://b2b.haier.com/upload    test
	  window.open("http://b2b.haier.com/upload/312312/index.html?actvid=" + getIdSelections()+"&meetingid="+getIdSelectionsmeetingid());
  }
  
  function add(){
	  jh.openDialog('新增活动', "${ctx}/wechat/cmsActivity/form",'800px', '500px', $('#cmsActivityTable'));
  }
  function canyu(a){
	 // alert("canyu");
	  jh.openDialog('参与人员', "${ctx}/wechat/cmsSignupDraw/list?actvId="+a,'1300px', '500px', $('#cmsActivityTable'));
  }
  function zhongjiang(a){
	  //alert("zhongjiang");
	  jh.openDialog('中奖人员', "${ctx}/wechat/cmsWinPrize/list?actvId="+a,'1300px', '500px', $('#cmsActivityTable'));
  }
    

  
</script>