<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp"%>
<html>
<head>
	<title>修改密码</title>
	<meta name="decorator" content="ani"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#oldPassword").focus();
		});
	</script>
</head>
<body class="bg-white">
	<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/modifyPwd"  method="post" class="form-horizontal form-group">
		<form:hidden path="id"/>
		<sys:message  content="${message}"/>
		<div class="control-group">
		</div>
		
		<div class="control-group">
			<label class="col-sm-3 control-label"><font color="red">*</font>旧密码:</label>
			<div class="controls">
				<input id="oldPassword" name="oldPassword" type="password" value="" maxlength="50" minlength="3"  class="form-control  max-width-250 required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="col-sm-3 control-label"><font color="red">*</font>新密码:密码要求，大写+小写+数字+字符（至少包含2种），且至少8位</label>
			<div class="controls">
				<input id="newPassword" name="newPassword" type="password" value="" maxlength="50" minlength="3" class="form-control  max-width-250 required"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label"><font color="red">*</font>确认新密码:</label>
			<div class="controls">
				<input id="confirmNewPassword" name="confirmNewPassword" type="password" value="" maxlength="50" minlength="3" class="form-control  max-width-250 required"></input>
			</div>
		</div>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" style="display:none" value="保 存"/>
		</div>
	</form:form>
</body>
</html>