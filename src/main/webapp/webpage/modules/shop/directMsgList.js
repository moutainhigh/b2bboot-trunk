<%@ page contentType="text/html;charset=UTF-8" %>
<script>
$(document).ready(function() {
	$('#directMsgTable').bootstrapTable({
		 
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
               url: "${ctx}/shop/directMsg/data",
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
                   	window.location = "${ctx}/shop/directMsg/form?id=" + row.id;
                   } else if($el.data("item") == "delete"){
                        jh.confirm('确认要删除该直采需求记录吗？', function(){
                       	jh.loading();
                       	jh.get("${ctx}/shop/directMsg/delete?id="+row.id, function(data){
                   	  		if(data.success){
                   	  			$('#directMsgTable').bootstrapTable('refresh');
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
		        field: 'id',
		        title: '直采需求id',
		        sortable: true
		        ,formatter:function(value, row , index){
		        	return "<a href='${ctx}/shop/directMsg/form?id="+row.id+"'>"+value+"</a>";
		         }
		       
		    }
			,{
		        field: 'order',
		        title: '直采需求单号',
		        sortable: true
		       
		    }
			,{
		        field: 'projectname',
		        title: '项目名称',
		        sortable: true
		       
		    }
			,{
		        field: 'firstCompanyName',
		        title: '甲方公司名称',
		        sortable: true
		       
		    }
			,{
		        field: 'firstContactName',
		        title: '甲方联系人姓名',
		        sortable: true
		       
		    }
			,{
		        field: 'phone',
		        title: '甲方联系人手机号',
		        sortable: true
		       
		    }
			,{
		        field: 'projectCreaterCode',
		        title: '项目录入人编码',
		        sortable: true
		       
		    }
			,{
		        field: 'shPartner',
		        title: '送达方',
		        sortable: true
		       
		    }
			,{
		        field: 'pyPartner',
		        title: '付款方',
		        sortable: true
		       
		    }
			,{
		        field: 'bpPartner',
		        title: '开票方',
		        sortable: true
		       
		    }
			,{
		        field: 'status',
		        title: '状态值(0待审核,1审核通过,2审核拒绝)',
		        sortable: true
		       
		    }
		     ]
		
		});
		
		  
	  if(navigator.userAgent.match(/(iPhone|iPod|Android|ios)/i)){//如果是移动端

		 
		  $('#directMsgTable').bootstrapTable("toggleView");
		}
	  
	  $('#directMsgTable').on('check.bs.table uncheck.bs.table load-success.bs.table ' +
                'check-all.bs.table uncheck-all.bs.table', function () {
            $('#remove').prop('disabled', ! $('#directMsgTable').bootstrapTable('getSelections').length);
            $('#edit').prop('disabled', $('#directMsgTable').bootstrapTable('getSelections').length!=1);
        });
		  
		$("#btnImport").click(function(){
			jh.open({
			    type: 1, 
			    area: [500, 300],
			    title:"导入数据",
			    content:$("#importBox").html() ,
			    btn: ['下载模板','确定', '关闭'],
				    btn1: function(index, layero){
					  window.location='${ctx}/shop/directMsg/import/template';
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
		  $('#directMsgTable').bootstrapTable('refresh');
		});
	 
	 $("#reset").click("click", function() {// 绑定查询按扭
		  $("#searchForm  input").val("");
		  $("#searchForm  select").val("");
		  $("#searchForm  .select-item").html("");
		  $('#directMsgTable').bootstrapTable('refresh');
		});
		
		
	});
		
  function getIdSelections() {
        return $.map($("#directMsgTable").bootstrapTable('getSelections'), function (row) {
            return row.id
        });
    }
  
  function deleteAll(){

		jh.confirm('确认要删除该直采需求记录吗？', function(){
			jh.loading();  	
			jh.get("${ctx}/shop/directMsg/deleteAll?ids=" + getIdSelections(), function(data){
         	  		if(data.success){
         	  			$('#directMsgTable').bootstrapTable('refresh');
         	  			jh.success(data.msg);
         	  		}else{
         	  			jh.error(data.msg);
         	  		}
         	  	})
          	   
		})
  }
  function edit(){
	  window.location = "${ctx}/shop/directMsg/form?id=" + getIdSelections();
  }
  
</script>