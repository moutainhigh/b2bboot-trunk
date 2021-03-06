<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>信息量统计</title>
	<meta name="decorator" content="default"/>
	<%@ include file="/webpage/include/bootstraptable.jsp"%>
	<script type="text/javascript">
		function autoRowSpan(tb,row,col){
	        var lastValue="",value="",pos=1;  
	        for(var i=row;i<tb.rows.length;i++){
	            value = tb.rows[i].cells[col].innerText;  
	            if(lastValue == value){
	                tb.rows[i].deleteCell(col); 
	                tb.rows[i-pos].cells[col].rowSpan = tb.rows[i-pos].cells[col].rowSpan+1;
	                pos++;
	            }else{
	                lastValue = value;
	                pos=1;
	            }
	        }
	    }
		$(document).ready(function(){
			autoRowSpan(contentTable,0,0);
	        $("td,th").css({"text-align":"center","vertical-align":"middle"});
	        $('#beginDate').datetimepicker({
				 format: "YYYY-MM-DD"
		    });
		  	$('#endDate').datetimepicker({
				 format: "YYYY-MM-DD"
		    });
		});
	</script>
</head>
<body>
<div class="wrapper wrapper-content">
<div class="panel panel-primary">
	<div class="panel-body">
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/cms/stats/article">信息量统计</a></li>
	</ul>
	<form:form id="searchForm" modelAttribute="article" action="${ctx}/cms/stats/article" method="post" class="form form-horizontal well clearfix">
					<div class="col-xs-12 col-sm-6 col-md-3">
				    	<label class="label-item single-overflow pull-left" title="归属栏目：">归属栏目：</label>
				   		<sys:treeselect id="category" name="categoryId" value="${paramMap.id}" labelName="categoryName" labelValue="${paramMap.name}"
				title="栏目" url="/cms/category/treeData" module="article" cssClass="form-control" allowClear="true"/>
				    </div>
				    <div class="col-xs-12 col-sm-6 col-md-3">
				    	<label class="label-item single-overflow pull-left" title="归属机构：">归属机构：</label>
				   		<sys:treeselect id="office" name="officeId" value="${paramMap.office.id}" labelName="officeName" labelValue="${paramMap.office.name}" 
				title="机构" url="/sys/office/treeData" cssClass="form-control" allowClear="true"/>
				    </div>
				    <div class="col-xs-12 col-sm-6 col-md-4">
					    	<label class="label-item single-overflow pull-left" title="日期范围：">日期范围：</label>
					    		<div class="col-xs-12">
								        <div class="col-xs-12 col-sm-5">
								        	<div class='input-group date' id='beginDate' style="left: -10px;" >
								                   <input type='text'  name="beginDate" class="form-control" value="${paramMap.beginDate}" />
								                   <span class="input-group-addon">
								                       <span class="glyphicon glyphicon-calendar"></span>
								                   </span>
								             </div>	
								        </div>
								        <div class="col-xs-12 col-sm-1">
								        		~
								       	</div>
								        <div class="col-xs-12 col-sm-5">
									          <div class='input-group date' id='endDate' style="left: -10px;" >
									                   <input type='text'  name="endDate" class="form-control" value="${paramMap.endDate}"/>
									                   <span class="input-group-addon">
									                       <span class="glyphicon glyphicon-calendar"></span>
									                   </span>
									           </div>	
								        </div>
								</div>
					   </div>
				    <div class="col-xs-12 col-sm-6 col-md-2">
						 <div style="margin-top:26px">
						 <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
						 <input id="btnSubmit" class="btn btn-primary" type="reset" value="重置"/>
						</div>
				    </div>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead><tr><th>父级栏目</th><th>栏目名称</th><th>信息量</th><th>点击量</th><th>最后更新时间</th><th>归属机构</th>
		<tbody>
		<c:forEach items="${list}" var="stats">
			<tr>
				<td><a href="javascript:" onclick="$('#categoryId').val('${stats.parent.id}');$('#categoryName').val('${stats.parent.name}');$('#searchForm').submit();return false;">${stats.parent.name}</a></td>
				<td><a href="javascript:" onclick="$('#categoryId').val('${stats.id}');$('#categoryName').val('${stats.name}');$('#searchForm').submit();return false;">${stats.name}</a></td>
				<td>${stats.cnt}</td>
				<td>${stats.hits}</td>
				<td><fmt:formatDate value="${stats.updateDate}" type="both"/></td>
				<td><a href="javascript:" onclick="$('#officeId').val('${stats.office.id}');$('#officeName').val('${stats.office.name}');$('#searchForm').submit();return false;">${stats.office.name}</a></td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	${page}
	<div class="clearfix"></div>
</div>
</div>
</div>
</body>
</html>