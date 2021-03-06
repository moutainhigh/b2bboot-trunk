<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/webpage/include/taglib.jsp" %>
<html>
<head>
    <title>表单管理</title>
    <meta name="decorator" content="ani"/>
    <script type="text/javascript" src="${ctxStatic}/plugin/jquery-combox/jquery.combox.js"></script>
    <link rel="stylesheet" href="${ctxStatic}/plugin/jquery-combox/styles/style.css" type="text/css"/>
    <script type="text/javascript" src="${ctxStatic}/plugin/TableDnD/jquery.tablednd.js"></script>
    <link rel="stylesheet" href="${ctxStatic}/plugin/TableDnD/tablednd.css" type="text/css"/>
    <script type="text/javascript">
        Window.dd = [${fns:getFieldArray()}];
        Window.zz = {
            checkboxClass: 'icheckbox_square-${cookie.theme.value==null?"blue":cookie.theme.value}',
            radioClass: 'iradio_square-${cookie.theme.value==null?"blue":cookie.theme.value}',
            increaseArea: '20%'
        };
        var datas = Window.dd;
        var ckcss = Window.zz;
        var validateForm;
        var $table;
        var $topIndex;

        function doSubmit(table, index) {
            if (validateForm.form()) {
                $table = table;
                $topIndex = index;
                jh.loading();
                $("#inputForm").submit();
                return true
            }
            return false
        };
        $(document).ready(function () {
            validateForm = $("#inputForm").validate({
                ignore: "",
                submitHandler: function (form) {
                    $("input[type=checkbox]").each(function () {
                        $(this).after("<input type=\"hidden\" name=\"" + $(this).attr("name") + "\" value=\"" + ($(this).is(':checked') ? "1" : "0") + "\"/>");
                        $(this).attr("name", "_" + $(this).attr("name"))
                    });
                    $.ajax({
                        url: ctx + "/gen/genTable/save",
                        method: "POST",
                        data: $('#inputForm').serialize(),
                        error: function (data) {
                            jh.error('操作失败!')
                        },
                        success: function (data) {
                            if (data.success) {
                                $table.bootstrapTable('refresh');
                                jh.success(data.msg);
                                jh.close($topIndex)
                            } else {
                                jh.alert(data.msg)
                            }
                        }
                    })
                },
                errorContainer: "#messageBox",
                errorPlacement: function (error, element) {
                    $("#messageBox").text("输入有误，请先更正。");
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
                        error.appendTo(element.parent().parent())
                    } else {
                        error.insertAfter(element)
                    }
                }
            });
            resetColumnNo();
            $("#tableType").change(function () {
                if ($("#tableType").val() == "3" || $("#tableType").val() == "4") {
                    addForTreeTable()
                } else {
                    removeForTreeTable()
                }
            });
            var fromIndex,
                toIndex;
            $("#contentTable1").tableDnD({
                onDragClass: "myDragClass",
                onDrop: function (table, row) {
                    toIndex = $(row).index();
                    var targetTR2 = $("#tab-2 #contentTable2 tbody tr:eq(" + toIndex + ")");
                    var objTR2 = $("#tab-2 #contentTable2 tbody tr:eq(" + fromIndex + ")");
                    if (fromIndex < toIndex) {
                        objTR2.insertAfter(targetTR2)
                    } else {
                        objTR2.insertBefore(targetTR2)
                    }
                    var targetTR3 = $("#tab-3 #contentTable3 tbody tr:eq(" + toIndex + ")");
                    var objTR3 = $("#tab-3 #contentTable3 tbody tr:eq(" + fromIndex + ")");
                    if (fromIndex < toIndex) {
                        objTR3.insertAfter(targetTR3)
                    } else {
                        objTR3.insertBefore(targetTR3)
                    }
                    var targetTR4 = $("#tab-4 #contentTable4 tbody tr:eq(" + toIndex + ")");
                    var objTR4 = $("#tab-4 #contentTable4 tbody tr:eq(" + fromIndex + ")");
                    if (fromIndex < toIndex) {
                        objTR4.insertAfter(targetTR4)
                    } else {
                        objTR4.insertBefore(targetTR4)
                    }
                    resetColumnNo()
                },
                onDragStart: function (table, row) {
                    fromIndex = $(row).index()
                }
            })
        });

        function resetColumnNo() {
            $("#tab-4 #contentTable4 tbody tr").each(function (index, element) {
                $(this).find("span[name*=columnList],select[name*=columnList],input[name*=columnList]").each(function () {
                    var name = $(this).attr("name");
                    var attr_name = name.split(".")[1];
                    var newName = "columnList[" + index + "]." + attr_name;
                    $(this).attr("name", newName);
                    if (name.indexOf(".sort") >= 0) {
                        $(this).val(index);
                        $(this).next().text(index)
                    }
                });
                $(this).find("label[id*=columnList]").each(function () {
                    var id = $(this).attr("id");
                    var attr_id = id.split(".")[1];
                    var newId = "columnList[" + index + "]." + attr_id;
                    $(this).attr("id", newId);
                    $(this).attr("for", "columnList[" + index + "].jdbcType")
                });
                $(this).find("input[name*=name]").each(function () {
                    var name = $(this).attr("name");
                    var attr_name = name.split(".")[1];
                    var newName = "page-columnList[" + index + "]." + attr_name;
                    $(this).attr("name", newName)
                });
                $(this).find("input[name*=comments]").each(function () {
                    var name = $(this).attr("name");
                    var attr_name = name.split(".")[1];
                    var newName = "page-columnList[" + index + "]." + attr_name;
                    $(this).attr("name", newName)
                })
            });
            $("#tab-3 #contentTable3 tbody tr").each(function (index, element) {
                $(this).find("span[name*=columnList],select[name*=columnList],input[name*=columnList]").each(function () {
                    var name = $(this).attr("name");
                    var attr_name = name.split(".")[1];
                    var newName = "columnList[" + index + "]." + attr_name;
                    $(this).attr("name", newName);
                    if (name.indexOf(".sort") >= 0) {
                        $(this).val(index);
                        $(this).next().text(index)
                    }
                });
                $(this).find("label[id*=columnList]").each(function () {
                    var id = $(this).attr("id");
                    var attr_id = id.split(".")[1];
                    var newId = "columnList[" + index + "]." + attr_id;
                    $(this).attr("id", newId);
                    $(this).attr("for", "columnList[" + index + "].jdbcType")
                });
                $(this).find("input[name*=name]").each(function () {
                    var name = $(this).attr("name");
                    var attr_name = name.split(".")[1];
                    var newName = "page-columnList[" + index + "]." + attr_name;
                    $(this).attr("name", newName)
                });
                $(this).find("input[name*=comments]").each(function () {
                    var name = $(this).attr("name");
                    var attr_name = name.split(".")[1];
                    var newName = "page-columnList[" + index + "]." + attr_name;
                    $(this).attr("name", newName)
                })
            });
            $("#tab-2 #contentTable2 tbody tr").each(function (index, element) {
                $(this).find("span[name*=columnList],select[name*=columnList],input[name*=columnList]").each(function () {
                    var name = $(this).attr("name");
                    var attr_name = name.split(".")[1];
                    var newName = "columnList[" + index + "]." + attr_name;
                    $(this).attr("name", newName);
                    if (name.indexOf(".sort") >= 0) {
                        $(this).val(index);
                        $(this).next().text(index)
                    }
                });
                $(this).find("label[id*=columnList]").each(function () {
                    var id = $(this).attr("id");
                    var attr_id = id.split(".")[1];
                    var newId = "columnList[" + index + "]." + attr_id;
                    $(this).attr("id", newId);
                    $(this).attr("for", "columnList[" + index + "].jdbcType")
                });
                $(this).find("input[name*=name]").each(function () {
                    var name = $(this).attr("name");
                    var attr_name = name.split(".")[1];
                    var newName = "page-columnList[" + index + "]." + attr_name;
                    $(this).attr("name", newName)
                });
                $(this).find("input[name*=comments]").each(function () {
                    var name = $(this).attr("name");
                    var attr_name = name.split(".")[1];
                    var newName = "page-columnList[" + index + "]." + attr_name;
                    $(this).attr("name", newName)
                })
            });
            $("#tab-1 #contentTable1 tbody tr").each(function (index, element) {
                $(this).find("span[name*=columnList],select[name*=columnList],input[name*=columnList]").each(function () {
                    var name = $(this).attr("name");
                    var attr_name = name.split(".")[1];
                    var newName = "columnList[" + index + "]." + attr_name;
                    $(this).attr("name", newName);
                    if (name.indexOf(".sort") >= 0) {
                        $(this).val(index);
                        $(this).next().text(index)
                    }
                });
                $(this).find("label[id*=columnList]").each(function () {
                    var id = $(this).attr("id");
                    var attr_id = id.split(".")[1];
                    var newId = "columnList[" + index + "]." + attr_id;
                    $(this).attr("id", newId);
                    $(this).attr("for", "columnList[" + index + "].jdbcType")
                });
                $(this).find("input[name*=name]").change(function () {
                    var name = $(this).attr("name");
                    var newName = "page-" + name;
                    $("#tab-2 #contentTable2 tbody tr input[name='" + newName + "']").val($(this).val());
                    $("#tab-3 #contentTable3 tbody tr input[name='" + newName + "']").val($(this).val());
                    $("#tab-4 #contentTable4 tbody tr input[name='" + newName + "']").val($(this).val())
                });
                $(this).find("input[name*=comments]").change(function () {
                    var name = $(this).attr("name");
                    var newName = "page-" + name;
                    $("#tab-2 #contentTable2 tbody tr input[name='" + newName + "']").val($(this).val());
                    $("#tab-3 #contentTable3 tbody tr input[name='" + newName + "']").val($(this).val());
                    $("#tab-4 #contentTable4 tbody tr input[name='" + newName + "']").val($(this).val())
                })
            });
            $('#contentTable1 tbody tr span[name*=jdbcType]').combox({
                datas: datas
            })
        }

        function addColumn() {
            var column1 = $("#template1").clone();
            column1.removeAttr("style");
            column1.removeAttr("id");
            var column2 = $("#template2").clone();
            column2.removeAttr("style");
            column2.removeAttr("id");
            var column3 = $("#template3").clone();
            column3.removeAttr("style");
            column3.removeAttr("id");
            var column4 = $("#template4").clone();
            column4.removeAttr("style");
            column4.removeAttr("id");
            $("#tab-1 #contentTable1 tbody").append(column1);
            $("#tab-2 #contentTable2 tbody").append(column2);
            $("#tab-3 #contentTable3 tbody").append(column3);
            $("#tab-4 #contentTable4 tbody").append(column4);
            column1.find('input').iCheck(ckcss);
            column2.find('input').iCheck(ckcss);
            column3.find('input').iCheck(ckcss);
            column4.find('input').iCheck(ckcss);
            resetColumnNo();
            $("#contentTable1").tableDnD({
                onDragClass: "myDragClass",
                onDrop: function (table, row) {
                    toIndex = $(row).index();
                    var targetTR2 = $("#tab-2 #contentTable2 tbody tr:eq(" + toIndex + ")");
                    var objTR2 = $("#tab-2 #contentTable2 tbody tr:eq(" + fromIndex + ")");
                    if (fromIndex < toIndex) {
                        objTR2.insertAfter(targetTR2)
                    } else {
                        objTR2.insertBefore(targetTR2)
                    }
                    var targetTR3 = $("#tab-3 #contentTable3 tbody tr:eq(" + toIndex + ")");
                    var objTR3 = $("#tab-3 #contentTable3 tbody tr:eq(" + fromIndex + ")");
                    if (fromIndex < toIndex) {
                        objTR3.insertAfter(targetTR3)
                    } else {
                        objTR3.insertBefore(targetTR3)
                    }
                    var targetTR4 = $("#tab-4 #contentTable4 tbody tr:eq(" + toIndex + ")");
                    var objTR4 = $("#tab-4 #contentTable4 tbody tr:eq(" + fromIndex + ")");
                    if (fromIndex < toIndex) {
                        objTR4.insertAfter(targetTR4)
                    } else {
                        objTR4.insertBefore(targetTR4)
                    }
                    resetColumnNo()
                },
                onDragStart: function (table, row) {
                    fromIndex = $(row).index()
                }
            });
            return false
        }

        function removeForTreeTable() {
            $("#tab-1 #contentTable1 tbody").find("#tree_11,#tree_12,#tree_13,#tree_14").remove();
            $("#tab-2 #contentTable2 tbody").find("#tree_21,#tree_22,#tree_23,#tree_24").remove();
            $("#tab-3 #contentTable3 tbody").find("#tree_31,#tree_32,#tree_33,#tree_34").remove();
            $("#tab-4 #contentTable4 tbody").find("#tree_41,#tree_42,#tree_43,#tree_44").remove();
            resetColumnNo();
            return false
        }

        function addForTreeTable() {
            if (!$("#tab-1 #contentTable1 tbody").find("input[name*=name][value=parent_id]").val()) {
                var column11 = $("#template1").clone();
                column11.removeAttr("style");
                column11.attr("id", "tree_11");
                column11.find("input[name*=name]").val("parent_id");
                column11.find("input[name*=comments]").val("父级编号");
                column11.find("span[name*=jdbcType]").val("varchar(64)");
                var column21 = $("#template2").clone();
                column21.removeAttr("style");
                column21.attr("id", "tree_21");
                column21.find("input[name*=name]").val("parent_id");
                column21.find("input[name*=comments]").val("父级编号");
                column21.find("select[name*=javaType]").val("This");
                column21.find("input[name*=javaField]").val("parent.id|name");
                column21.find("input[name*=isList]").removeAttr("checked");
                column21.find("select[name*=showType]").val("treeselect");
                var column31 = $("#template3").clone();
                column31.removeAttr("style");
                column31.attr("id", "tree_31");
                column31.find("input[name*=name]").val("parent_id");
                column31.find("input[name*=comments]").val("父级编号");
                var column41 = $("#template4").clone();
                column41.removeAttr("style");
                column41.attr("id", "tree_41");
                column41.find("input[name*=name]").val("parent_id");
                column41.find("input[name*=comments]").val("父级编号");
                $("#tab-1 #contentTable1 tbody").append(column11);
                $("#tab-2 #contentTable2 tbody").append(column21);
                $("#tab-3 #contentTable3 tbody").append(column31);
                $("#tab-4 #contentTable4 tbody").append(column41);
                column11.find('input:checkbox').iCheck(ckcss);
                column21.find('input:checkbox').iCheck(ckcss);
                column31.find('input:checkbox').iCheck(ckcss);
                column41.find('input:checkbox').iCheck(ckcss)
            }
            if (!$("#tab-1 #contentTable1 tbody").find("input[name*=name][value=parent_ids]").val()) {
                var column12 = $("#template1").clone();
                column12.removeAttr("style");
                column12.attr("id", "tree_12");
                column12.find("input[name*=name]").val("parent_ids");
                column12.find("input[name*=comments]").val("所有父级编号");
                column12.find("span[name*=jdbcType]").attr('value', "varchar(2000)");
                var column22 = $("#template2").clone();
                column22.removeAttr("style");
                column22.attr("id", "tree_22");
                column22.find("input[name*=name]").val("parent_ids");
                column22.find("select[name*=javaType]").val("String");
                column22.find("input[name*=javaField]").val("parentIds");
                column22.find("input[name*=comments]").val("所有父级编号");
                column22.find("select[name*=queryType]").val("like");
                column22.find("input[name*=isForm]").removeAttr("checked");
                column22.find("input[name*=isList]").removeAttr("checked");
                var column32 = $("#template3").clone();
                column32.removeAttr("style");
                column32.attr("id", "tree_32");
                column32.find("input[name*=name]").val("parent_ids");
                column32.find("input[name*=comments]").val("所有父级编号");
                var column42 = $("#template4").clone();
                column42.removeAttr("style");
                column42.attr("id", "tree_42");
                column42.find("input[name*=name]").val("parent_ids");
                column42.find("input[name*=comments]").val("所有父级编号");
                column42.find("input[name*=isNull]").removeAttr("checked");
                $("#tab-1 #contentTable1 tbody").append(column12);
                $("#tab-2 #contentTable2 tbody").append(column22);
                $("#tab-3 #contentTable3 tbody").append(column32);
                $("#tab-4 #contentTable4 tbody").append(column42);
                column12.find('input:checkbox').iCheck(ckcss);
                column22.find('input:checkbox').iCheck(ckcss);
                column32.find('input:checkbox').iCheck(ckcss);
                column42.find('input:checkbox').iCheck(ckcss)
            }
            if (!$("#tab-1 #contentTable1 tbody").find("input[name*=name][value=name]").val()) {
                var column13 = $("#template1").clone();
                column13.removeAttr("style");
                column13.attr("id", "tree_13");
                column13.find("input[name*=name]").val("name");
                column13.find("input[name*=comments]").val("名称");
                column13.find("span[name*=jdbcType]").attr("value", "varchar(100)");
                var column23 = $("#template2").clone();
                column23.removeAttr("style");
                column23.attr("id", "tree_23");
                column23.find("input[name*=name]").val("name");
                column23.find("select[name*=javaType]").val("String");
                column23.find("input[name*=javaField]").val("name");
                column23.find("input[name*=comments]").val("名称");
                column23.find("input[name*=isQuery]").attr("checked", "checked");
                column23.find("select[name*=queryType]").val("like");
                var column33 = $("#template3").clone();
                column33.removeAttr("style");
                column33.attr("id", "tree_33");
                column33.find("input[name*=name]").val("name");
                column33.find("input[name*=comments]").val("名称");
                var column43 = $("#template4").clone();
                column43.removeAttr("style");
                column43.attr("id", "tree_43");
                column43.find("input[name*=name]").val("name");
                column43.find("input[name*=comments]").val("名称");
                column43.find("input[name*=isNull]").removeAttr("checked");
                $("#tab-1 #contentTable1 tbody").append(column13);
                $("#tab-2 #contentTable2 tbody").append(column23);
                $("#tab-3 #contentTable3 tbody").append(column33);
                $("#tab-4 #contentTable4 tbody").append(column43);
                column13.find('input:checkbox').iCheck(ckcss);
                column23.find('input:checkbox').iCheck(ckcss);
                column33.find('input:checkbox').iCheck(ckcss);
                column43.find('input:checkbox').iCheck(ckcss)
            }
            if (!$("#tab-1 #contentTable1 tbody").find("input[name*=name][value=sort]").val()) {
                var column14 = $("#template1").clone();
                column14.removeAttr("style");
                column14.attr("id", "tree_14");
                column14.find("input[name*=name]").val("sort");
                column14.find("input[name*=comments]").val("排序");
                column14.find("span[name*=jdbcType]").val("decimal(10,0)");
                var column24 = $("#template2").clone();
                column24.removeAttr("style");
                column24.attr("id", "tree_24");
                column24.find("input[name*=name]").val("sort");
                column24.find("input[name*=comments]").val("排序");
                column24.find("select[name*=javaType]").val("Integer");
                column24.find("input[name*=javaField]").val("sort");
                column24.find("input[name*=isList]").removeAttr("checked");
                var column34 = $("#template3").clone();
                column34.removeAttr("style");
                column34.attr("id", "tree_34");
                column34.find("input[name*=name]").val("sort");
                column34.find("input[name*=comments]").val("排序");
                var column44 = $("#template4").clone();
                column44.removeAttr("style");
                column44.attr("id", "tree_44");
                column44.find("input[name*=name]").val("sort");
                column44.find("input[name*=comments]").val("排序");
                column44.find("input[name*=isNull]").removeAttr("checked");
                $("#tab-1 #contentTable1 tbody").append(column14);
                $("#tab-2 #contentTable2 tbody").append(column24);
                $("#tab-3 #contentTable3 tbody").append(column34);
                $("#tab-4 #contentTable4 tbody").append(column44);
                column14.find('input:checkbox').iCheck(ckcss);
                column24.find('input:checkbox').iCheck(ckcss);
                column34.find('input:checkbox').iCheck(ckcss);
                column44.find('input:checkbox').iCheck(ckcss)
            }
            resetColumnNo();
            $("#contentTable1").tableDnD({
                onDragClass: "myDragClass",
                onDrop: function (table, row) {
                    toIndex = $(row).index();
                    var targetTR2 = $("#tab-2 #contentTable2 tbody tr:eq(" + toIndex + ")");
                    var objTR2 = $("#tab-2 #contentTable2 tbody tr:eq(" + fromIndex + ")");
                    if (fromIndex < toIndex) {
                        objTR2.insertAfter(targetTR2)
                    } else {
                        objTR2.insertBefore(targetTR2)
                    }
                    ;
                    var targetTR3 = $("#tab-3 #contentTable3 tbody tr:eq(" + toIndex + ")");
                    var objTR3 = $("#tab-3 #contentTable3 tbody tr:eq(" + fromIndex + ")");
                    if (fromIndex < toIndex) {
                        objTR3.insertAfter(targetTR3)
                    } else {
                        objTR3.insertBefore(targetTR3)
                    }
                    ;
                    var targetTR4 = $("#tab-4 #contentTable4 tbody tr:eq(" + toIndex + ")");
                    var objTR4 = $("#tab-4 #contentTable4 tbody tr:eq(" + fromIndex + ")");
                    if (fromIndex < toIndex) {
                        objTR4.insertAfter(targetTR4)
                    } else {
                        objTR4.insertBefore(targetTR4)
                    }
                    ;
                    resetColumnNo()
                },
                onDragStart: function (table, row) {
                    fromIndex = $(row).index()
                }
            });
            return false
        };

        function delColumn() {
            $("input[name='ck']:checked").closest("tr").each(function () {
                var name = $(this).find("input[name*=name]").attr("name");
                $(this).remove();
                $("#tab-2 #contentTable2 tbody tr input[name='page-" + name + "']").closest("tr").remove();
                $("#tab-3 #contentTable3 tbody tr input[name='page-" + name + "']").closest("tr").remove();
                $("#tab-4 #contentTable4 tbody tr input[name='page-" + name + "']").closest("tr").remove()
            });
            resetColumnNo();
            return false
        };
    </script>
</head>
<body id="" class="bg-white" style="">
<div class="wrapper wrapper-content">

    <table style="display:none">
        <tr id="template1" style="display:none">
            <td>
                <input type="hidden" name="columnList[0].sort" value="0" maxlength="200"
                       class="form-control required   digits"/>
                <label>0</label>
                <input type="hidden" class="form-control" name="columnList[0].isInsert" value="1"/>
                <input type="hidden" class="form-control" name="columnList[0].isEdit" value="1"/>
            </td>
            <td>
                <input type="checkbox" class="form-control  " name="ck" value="1"/>
            </td>
            <td>
                <input type="text" class="form-control required" name="columnList[0].name" value=""/>
            </td>
            <td>
                <input type="text" class="form-control required" name="columnList[0].comments" value="" maxlength="200"
                       class="required"/>
            </td>
            <td>
                <span name="template_columnList[0].jdbcType" class="required" value="varchar(64)"/>
            </td>
            <td>
                <input type="checkbox" class="form-control" name="columnList[0].isPk" value="1"/>
            </td>
        </tr>
        <tr id="template2" style="display:none">
            <td>
                <input type="text" class="form-control" readOnly="readonly" name="page-columnList[0].name" value=""/>
            </td>
            <td>
                <input type="text" class="form-control" name="page-columnList[0].comments" value="" maxlength="200"
                       readonly="readonly"/>
            </td>
            <td>
                <select name="columnList[0].javaType" class="form-control required m-b">
                    <c:forEach var="dict" items="${config.javaTypeList}">
                        <option value="${dict.value}" ${dict.value=='String'?'selected':''}
                                title="${dict.description}">${dict.label}</option>
                    </c:forEach>
                </select>
            </td>
            <td>
                <input type="text" name="columnList[0].javaField" value="" maxlength="200"
                       class="form-control required "/>
            </td>
            <td>
                <input type="checkbox" class="form-control  " name="columnList[0].isForm" value="1" checked/>
            </td>
            <td>
                <input type="checkbox" class="form-control  " name="columnList[0].isList" value="1" checked/>
            </td>
            <td>
                <input type="checkbox" class="form-control  " name="columnList[0].isQuery" value="1"/>
            </td>
            <td>
                <select name="columnList[0].queryType" class="form-control required  m-b">
                    <c:forEach var="dict" items="${config.queryTypeList}">
                        <option value="${fns:escapeHtml(dict.value)}" ${fns:escapeHtml(dict.value)==column.queryType?'selected':''}
                                title="${dict.description}">${fns:escapeHtml(dict.label)}</option>
                    </c:forEach>
                </select>
            </td>
            <td>
                <select name="columnList[0].showType" class="form-control required  m-b">
                    <c:forEach var="dict" items="${config.showTypeList}">
                        <option value="${dict.value}" ${dict.value==column.showType?'selected':''}
                                title="${dict.description}">${dict.label}</option>
                    </c:forEach>
                </select>
            </td>
            <td>
                <input type="text" name="columnList[0].dictType" value="${column.dictType}" maxlength="200"
                       class="form-control   "/>
            </td>
        </tr>
        <tr id="template3" style="display:none">
            <td>
                <input type="text" class="form-control" readOnly="readonly" name="page-columnList[0].name" value=""/>
            </td>
            <td>
                <input type="text" class="form-control" name="page-columnList[0].comments" value="" maxlength="200"
                       readonly="readonly"/>
            </td>
            <td>
                <input type="text" name="columnList[0].fieldLabels" value="" maxlength="200" class="form-control  "/>
            </td>
            <td>
                <input type="text" name="columnList[0].fieldKeys" value="" maxlength="200" class="form-control  "/>
            </td>
            <td>
                <input type="text" name="columnList[0].searchLabel" value="" maxlength="200" class="form-control  "/>
            </td>
            <td>
                <input type="text" name="columnList[0].searchKey" value="" maxlength="200" class="form-control  "/>
            </td>
        </tr>
        <tr id="template4" style="display:none">
            <td>
                <input type="text" class="form-control" readOnly="readonly" name="page-columnList[0].name" value=""/>
            </td>
            <td>
                <input type="text" class="form-control" name="page-columnList[0].comments" value="" maxlength="200"
                       readonly="readonly"/>
            </td>
            <td>
                <input type="checkbox" class="form-control " name="columnList[0].isNull" value="1" checked/>
            </td>
            <td>
                <select name="columnList[0].validateType" class="form-control  m-b">
                    <c:forEach var="dict" items="${config.validateTypeList}">
                        <option value="${dict.value}" ${dict.value==column.validateType?'selected':''}
                                title="${dict.description}">${dict.label}</option>
                    </c:forEach>
                </select>
            </td>
            <td>
                <input type="text" name="columnList[0].minLength" value="" maxlength="200" class="form-control  "/>
            </td>
            <td>
                <input type="text" name="columnList[0].maxLength" value="" maxlength="200" class="form-control  "/>
            </td>
            <td>
                <input type="text" name="columnList[0].minValue" value="" maxlength="200" class="form-control  "/>
            </td>
            <td>
                <input type="text" name="columnList[0].maxValue" value="" maxlength="200" class="form-control  "/>
            </td>
        </tr>
    </table>
    <!-- 业务表添加 -->
    <form:form id="inputForm" modelAttribute="genTable" action="${ctx}/gen/genTable/save" method="post"
               class="form-horizontal">
        <form:hidden path="id"/>
        <form:hidden path="isSync"/>
        <sys:message content="${message}"/>
    <table class="table table-bordered  table-condensed dataTables-example dataTable no-footer">
        <tbody>
        <tr>
            <td class="width-15 active"><label class="pull-right"><font color="red">*</font>表名:</label></td>
            <td class="width-35">
                <form:input path="name" htmlEscape="false" class="form-control required isRightfulString"
                            maxlength="200"/>
            </td>
            <td class="width-15 active"><label class="pull-right"><font color="red">*</font>说明:</label></td>
            <td class="width-35">
                <form:input path="comments" htmlEscape="false" class="form-control required" maxlength="200"/>
            </td>
        </tr>
        <tr>
            <td class="width-15 active"><label class="pull-right"><font color="red">*</font>主键策略:</label></td>
            <td class="width-35">
                <form:select path="genIdType" class="form-control m-b">
                    <form:options items="${fns:getDictList('gen_id_type')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
            </td>
            <td class="width-15 active"></td>
            <td class="width-35">
            </td>
        </tr>
        <tr>
            <td class="width-15 active"><label class="pull-right">表类型</label></td>
            <td class="width-35">
                <form:select path="tableType" class="form-control m-b">
                    <form:options items="${fns:getDictList('table_type')}" itemLabel="label" itemValue="value"
                                  htmlEscape="false"/>
                </form:select>
                <span class="help-inline">如果是附表，请指定主表表名和当前表的外键</span>
            </td>
            <td class="width-15 active"><label class="pull-right"><font color="red">*</font>类名:</label></td>
            <td class="width-35">
                <form:input path="className" htmlEscape="false" class="form-control required" maxlength="200"/>
            </td>
        </tr>
        <tr>
            <td class="width-15 active"><label class="pull-right">主表表名:</label></td>
            <td class="width-35">
                <form:select path="parentTable" class="form-control">
                    <form:option value="" label="无"/>
                    <form:options items="${tableList}" itemLabel="nameAndComments" itemValue="name" htmlEscape="false"/>
                </form:select>
            </td>
            <td class="width-15 active"><label class="pull-right">当前表外键：</label></td>
            <td class="width-35">
                <form:input path="parentTableFk" class="form-control" maxlength="200"/>
            </td>
        </tr>
        </tbody>
    </table>
    <button class="btn btn-white btn-sm" onclick="return addColumn()"><i class="fa fa-plus"> 增加</i></button>
    <button class="btn btn-white btn-sm" onclick="return delColumn()"><i class="fa fa-minus"> 删除</i></button>
    <br/>
    <div class="tabs-container">
        <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#tab-1" aria-expanded="true"> 数据库属性</a>
            </li>
            <li class=""><a data-toggle="tab" href="#tab-2" aria-expanded="false">页面属性</a>
            </li>
            <li class=""><a data-toggle="tab" href="#tab-3" aria-expanded="false">页面校验</a>
            </li>
            <li class=""><a data-toggle="tab" href="#tab-4" aria-expanded="false">grid选择框（自定义java对象）</a>
            </li>

        </ul>
        <div class="tab-content">
            <div id="tab-1" class="tab-pane active">
                <div class="panel-body">
                    <table id="contentTable1"
                           class="table table-striped table-bordered table-hover  dataTables-example dataTable">
                        <thead>
                        <tr>
                            <th width="40px">序号</th>
                            <th>操作</th>
                            <th title="数据库字段名">列名</th>
                            <th title="默认读取数据库字段备注">说明</th>
                            <th title="数据库中设置的字段类型及长度">物理类型</th>
                            <th title="是否是数据库主键">主键</th>
                            <!-- <th title="字段是否可为空值，不可为空字段自动进行空值验证">可空</th> -->
                            <!--<th title="选中后该字段被加入到insert语句里">插入</th>
                            <th title="选中后该字段被加入到update语句里">编辑</th>  -->
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty genTable.name }">
                            <!-- id -->
                            <tr>
                                <td>
                                    <input type="hidden" name="columnList[0].sort" value="0" maxlength="200"
                                           class="form-control required   digits"/>
                                    <label>0</label>
                                    <input type="hidden" name="columnList[0].isInsert" value="1"/>
                                    <input type="hidden" name="columnList[0].isEdit" value="0"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks " name="ck" value="1"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[0].name" value="id"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[0].comments" value="主键"
                                           maxlength="200" class="required"/>
                                </td>
                                <td>
                                    <span name="columnList[0].jdbcType" class="required " value="varchar(64)"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[0].isPk" value="1"
                                           checked/>
                                </td>
                            </tr>
                            <!-- create_by -->
                            <tr>
                                <td>
                                    <input type="hidden" name="columnList[1].sort" value="1" maxlength="200"
                                           class="form-control required   digits"/>
                                    <label>1</label>
                                    <input type="hidden" name="columnList[1].isInsert" value="1"/>
                                    <input type="hidden" name="columnList[1].isEdit" value="0"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks " name="ck" value="1"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[1].name"
                                           value="create_by"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[1].comments" value="创建者"
                                           maxlength="200" class="required"/>
                                </td>
                                <td>
                                    <span name="columnList[1].jdbcType" class="required " value="varchar(64)"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[1].isPk" value="1"/>
                                </td>

                            </tr>

                            <!-- create_date -->
                            <tr>
                                <td>
                                    <input type="hidden" name="columnList[2].sort" value="2" maxlength="200"
                                           class="form-control required   digits"/>
                                    <label>2</label>
                                    <input type="hidden" name="columnList[2].isInsert" value="1"/>
                                    <input type="hidden" name="columnList[2].isEdit" value="0"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks " name="ck" value="1"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[2].name"
                                           value="create_date"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[2].comments" value="创建时间"
                                           maxlength="200" class="required"/>
                                </td>
                                <td>
                                    <span name="columnList[2].jdbcType" class="required " value="datetime"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[2].isPk" value="1"/>
                                </td>

                            </tr>

                            <!-- update_by -->
                            <tr>
                                <td>
                                    <input type="hidden" name="columnList[3].sort" value="3" maxlength="200"
                                           class="form-control required   digits"/>
                                    <label>3</label>
                                    <input type="hidden" name="columnList[3].isInsert" value="1"/>
                                    <input type="hidden" name="columnList[3].isEdit" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks " name="ck" value="1"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[3].name"
                                           value="update_by"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[3].comments" value="更新者"
                                           maxlength="200" class="required"/>
                                </td>
                                <td>
                                    <span name="columnList[3].jdbcType" class="required " value="varchar(64)"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[3].isPk" value="1"/>
                                </td>
                            </tr>

                            <!-- update_date -->
                            <tr>
                                <td>
                                    <input type="hidden" name="columnList[4].sort" value="4" maxlength="200"
                                           class="form-control required   digits"/>
                                    <label>4</label>
                                    <input type="hidden" name="columnList[4].isInsert" value="1"/>
                                    <input type="hidden" name="columnList[4].isEdit" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks " name="ck" value="1"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[4].name"
                                           value="update_date"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[4].comments" value="更新时间"
                                           maxlength="200" class="required"/>
                                </td>
                                <td>
                                    <span name="columnList[4].jdbcType" class="required " value="datetime"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[4].isPk" value="1"/>
                                </td>
                            </tr>

                            <!-- remarks -->
                            <tr>
                                <td>
                                    <input type="hidden" name="columnList[5].sort" value="5" maxlength="200"
                                           class="form-control required   digits"/>
                                    <label>5</label>
                                    <input type="hidden" name="columnList[5].isInsert" value="1"/>
                                    <input type="hidden" name="columnList[5].isEdit" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks " name="ck" value="1"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[5].name" value="remarks"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[5].comments" value="备注信息"
                                           maxlength="200" class="required"/>
                                </td>
                                <td>
                                    <span name="columnList[5].jdbcType" class="required " value="nvarchar(255)"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[5].isPk" value="1"/>
                                </td>

                            </tr>

                            <!-- del_flag -->
                            <tr>
                                <td>
                                    <input type="hidden" name="columnList[6].sort" value="0" maxlength="200"
                                           class="form-control required   digits"/>
                                    <label>6</label>
                                    <input type="hidden" name="columnList[6].isInsert" value="1"/>
                                    <input type="hidden" name="columnList[6].isEdit" value="0"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks " name="ck" value="1"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[6].name" value="del_flag"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="columnList[6].comments"
                                           value="逻辑删除标记（0：显示；1：隐藏）" maxlength="200" class="required"/>
                                </td>
                                <td>
                                    <span name="columnList[6].jdbcType" class="required " value="varchar(64)"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[6].isPk" value="1"/>
                                </td>
                            </tr>
                        </c:if>
                        <c:forEach var="column" items="${genTable.columnList}" varStatus="vs">
                            <tr ${column.delFlag eq '1'?' class="error" title="已删除的列，保存之后消失！"':''}>
                                <td>
                                    <input type="hidden" name="columnList[${vs.index}].sort" value="${column.sort}">
                                    <label>${column.sort}</label>
                                    <input type="hidden" name="columnList[${vs.index}].isInsert"
                                           value="${column.isInsert}">
                                    <input type="hidden" name="columnList[${vs.index}].isEdit" value="${column.isEdit}">
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="ck" value="1"/>
                                </td>
                                <td>
                                    <input type="hidden" name="columnList[${vs.index}].id" value="${column.id}">
                                    <input type="hidden" name="columnList[${vs.index}].delFlag"
                                           value="${column.delFlag}">
                                    <input type="hidden" name="columnList[${vs.index}].genTable.id"
                                           value="${column.genTable.id}">
                                    <input type="text" name="columnList[${vs.index}].name" value="${column.name}"
                                           class="form-control required">
                                </td>
                                <td>
                                    <input type="text" name="columnList[${vs.index}].comments"
                                           value="${column.comments}" class="form-control required">
                                </td>
                                <td>
                                    <span name="columnList[${vs.index}].jdbcType" class="required"
                                          value="${column.jdbcType}"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[${vs.index}].isPk"
                                           value="1" ${column.isPk eq '1' ? 'checked' : ''}/>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <div id="tab-2" class="tab-pane">
                <div class="panel-body">
                    <table id="contentTable2"
                           class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
                        <thead>
                        <tr>
                            <th title="数据库字段名" width="15%">列名</th>
                            <th title="默认读取数据库字段备注">说明</th>
                            <th title="实体对象的属性字段类型" width="15%">Java类型</th>
                            <th title="实体对象的属性字段（对象名.属性名|属性名2|属性名3，例如：用户user.id|name|loginName，属性名2和属性名3为Join时关联查询的字段）">
                                Java属性名称 <i class="icon-question-sign"></i></th>
                            <th title="选中后该字段被加入到查询列表里">表单</th>
                            <th title="选中后该字段被加入到查询列表里">列表</th>
                            <th title="选中后该字段被加入到查询条件里">查询</th>
                            <th title="该字段为查询字段时的查询匹配放松" width="15%">查询匹配方式</th>
                            <th title="字段在表单中显示的类型" width="15%">显示表单类型</th>
                            <th title="显示表单类型设置为“下拉框、复选框、点选框”时，需设置字典的类型">字典类型</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty genTable.name }">
                            <!-- id -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[0].name" value="id"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[0].comments"
                                           value="主键" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <select name="columnList[0].javaType" class="form-control required m-b">

                                        <c:forEach var="dict" items="${config.javaTypeList}">
                                            <option value="${dict.value}" ${dict.value=='String'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].javaField" value="id" maxlength="200"
                                           class="form-control required "/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[0].isForm" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[0].isList" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[0].isQuery" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[0].queryType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.queryTypeList}">
                                            <option value="${fns:escapeHtml(dict.value)}"
                                                    title="${dict.description}">${fns:escapeHtml(dict.label)}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <select name="columnList[0].showType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.showTypeList}">
                                            <option value="${dict.value}" ${dict.value=='input'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].dictType" value="${column.dictType}"
                                           maxlength="200" class="form-control"/>
                                </td>

                            </tr>
                            <!-- create_by -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[1].name" value="create_by"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[1].comments"
                                           value="创建者" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <select name="columnList[1].javaType" class="form-control required m-b">

                                        <c:forEach var="dict" items="${config.javaTypeList}">
                                            <option value="${dict.value}" ${dict.value=='String'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[1].javaField" value="createBy.id"
                                           maxlength="200" class="form-control required "/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[1].isForm" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[1].isList" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[1].isQuery" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[1].queryType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.queryTypeList}">
                                            <option value="${fns:escapeHtml(dict.value)}"
                                                    title="${dict.description}">${fns:escapeHtml(dict.label)}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <select name="columnList[1].showType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.showTypeList}">
                                            <option value="${dict.value}" ${dict.value=='input'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[1].dictType" value="${column.dictType}"
                                           maxlength="200" class="form-control"/>
                                </td>
                            </tr>

                            <!-- create_date -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[2].name" value="create_date"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[2].comments"
                                           value="创建日期" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <select name="columnList[2].javaType" class="form-control required m-b">

                                        <c:forEach var="dict" items="${config.javaTypeList}">
                                            <option value="${dict.value}" ${dict.value=='java.util.Date'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[2].javaField" value="createDate" maxlength="200"
                                           class="form-control required "/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[2].isForm" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[2].isList" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[2].isQuery" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[2].queryType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.queryTypeList}">
                                            <option value="${fns:escapeHtml(dict.value)}"
                                                    title="${dict.description}">${fns:escapeHtml(dict.label)}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <select name="columnList[2].showType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.showTypeList}">
                                            <option value="${dict.value}" ${dict.value=='dateselect'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[2].dictType" value="${column.dictType}"
                                           maxlength="200" class="form-control"/>
                                </td>
                            </tr>

                            <!-- update_by -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[3].name" value="update_by"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[3].comments"
                                           value="更新者" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <select name="columnList[3].javaType" class="form-control required m-b">

                                        <c:forEach var="dict" items="${config.javaTypeList}">
                                            <option value="${dict.value}" ${dict.value=='String'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[3].javaField" value="updateBy.id"
                                           maxlength="200" class="form-control required "/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[3].isForm" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[3].isList" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[3].isQuery" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[3].queryType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.queryTypeList}">
                                            <option value="${fns:escapeHtml(dict.value)}"
                                                    title="${dict.description}">${fns:escapeHtml(dict.label)}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <select name="columnList[3].showType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.showTypeList}">
                                            <option value="${dict.value}" ${dict.value=='input'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[3].dictType" value="${column.dictType}"
                                           maxlength="200" class="form-control"/>
                                </td>
                            </tr>

                            <!-- update_date -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[4].name" value="update_date"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[4].comments"
                                           value="更新日期" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <select name="columnList[4].javaType" class="form-control required m-b">

                                        <c:forEach var="dict" items="${config.javaTypeList}">
                                            <option value="${dict.value}" ${dict.value=='java.util.Date'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[4].javaField" value="updateDate" maxlength="200"
                                           class="form-control required "/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[4].isForm" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[4].isList" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[4].isQuery" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[4].queryType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.queryTypeList}">
                                            <option value="${fns:escapeHtml(dict.value)}"
                                                    title="${dict.description}">${fns:escapeHtml(dict.label)}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <select name="columnList[4].showType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.showTypeList}">
                                            <option value="${dict.value}" ${dict.value=='dateselect'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[4].dictType" value="${column.dictType}"
                                           maxlength="200" class="form-control"/>
                                </td>
                            </tr>

                            <!-- remarks -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[5].name" value="remarks"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[5].comments"
                                           value="备注信息" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <select name="columnList[5].javaType" class="form-control required m-b">

                                        <c:forEach var="dict" items="${config.javaTypeList}">
                                            <option value="${dict.value}" ${dict.value=='String'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[5].javaField" value="remarks" maxlength="255"
                                           class="form-control required "/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[5].isForm" value="1"
                                           checked/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[5].isList" value="1"
                                           checked/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[5].isQuery" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[5].queryType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.queryTypeList}">
                                            <option value="${fns:escapeHtml(dict.value)}"
                                                    title="${dict.description}">${fns:escapeHtml(dict.label)}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <select name="columnList[5].showType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.showTypeList}">
                                            <option value="${dict.value}" ${dict.value=='textarea'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[5].dictType" value="${column.dictType}"
                                           maxlength="200" class="form-control"/>
                                </td>
                            </tr>

                            <!-- del_flag -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[6].name" value="del_flag"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[6].comments"
                                           value="逻辑删除标记（0：显示；1：隐藏）" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <select name="columnList[6].javaType" class="form-control required m-b">

                                        <c:forEach var="dict" items="${config.javaTypeList}">
                                            <option value="${dict.value}" ${dict.value=='String'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[6].javaField" value="delFlag" maxlength="255"
                                           class="form-control required "/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[6].isForm" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[6].isList" value="1"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[6].isQuery" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[6].queryType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.queryTypeList}">
                                            <option value="${fns:escapeHtml(dict.value)}"
                                                    title="${dict.description}">${fns:escapeHtml(dict.label)}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <select name="columnList[6].showType" class="form-control required  m-b">

                                        <c:forEach var="dict" items="${config.showTypeList}">
                                            <option value="${dict.value}" ${dict.value=='radiobox'?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[6].dictType" value="del_flag" maxlength="200"
                                           class="form-control"/>
                                </td>
                            </tr>
                        </c:if>
                        <c:forEach var="column" items="${genTable.columnList}" varStatus="vs">
                            <tr ${column.delFlag eq '1'?' class="error" title="已删除的列，保存之后消失！"':''}>
                                <td>
                                    <input type="text" readonly="readonly" name="page-columnList[${vs.index}].name"
                                           value="${column.name}" class="form-control required">
                                </td>
                                <td>
                                    <input type="text" readonly="readonly" name="page-columnList[${vs.index}].comments"
                                           value="${column.comments}" maxlength="200" class="form-control">
                                </td>
                                <td>
                                    <select name="columnList[${vs.index}].javaType" class="form-control required">
                                        <c:forEach var="dict" items="${config.javaTypeList}">
                                            <option value="${dict.value}" ${dict.value==column.javaType?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[${vs.index}].javaField"
                                           value="${column.javaField}" maxlength="200" class="form-control">
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[${vs.index}].isForm"
                                           value="1" ${column.isForm eq '1' ? 'checked' : ''}/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[${vs.index}].isList"
                                           value="1" ${column.isList eq '1' ? 'checked' : ''}/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[${vs.index}].isQuery"
                                           value="1" ${column.isQuery eq '1' ? 'checked' : ''}/>
                                </td>
                                <td>
                                    <select name="columnList[${vs.index}].queryType" class="required form-control m-b">
                                        <c:forEach var="dict" items="${config.queryTypeList}">
                                            <option value="${fns:escapeHtml(dict.value)}" ${fns:escapeHtml(dict.value)==column.queryType?'selected':''}
                                                    title="${dict.description}">${fns:escapeHtml(dict.label)}</option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    <select name="columnList[${vs.index}].showType" class="required form-control m-b">

                                        <c:forEach var="dict" items="${config.showTypeList}">
                                            <option value="${dict.value}" ${dict.value==column.showType?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].dictType" value="${column.dictType}"
                                           maxlength="200" class="form-control "/>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <div id="tab-3" class="tab-pane">
                <div class="panel-body">
                    <table id="contentTable3"
                           class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
                        <thead>
                        <tr>
                            <th title="数据库字段名" width="15%">列名</th>
                            <th title="默认读取数据库字段备注">说明</th>
                            <th title="字段是否可为空值，不可为空字段自动进行空值验证">可空</th>
                            <th title="校验类型">校验类型<i class="icon-question-sign"></i></th>
                            <th title="最小长度">最小长度</th>
                            <th title="最大长度">最大长度</th>
                            <th title="最小值">最小值</th>
                            <th title="最大值">最大值</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty genTable.name }">
                            <!-- id -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[0].name" value="id"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[0].comments"
                                           value="主键" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[0].isNull" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[0].validateType" class="form-control m-b">

                                        <c:forEach var="dict" items="${config.validateTypeList}">
                                            <option value="${dict.value}" ${dict.value==column.validateType?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].minLength" value="${column.minLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].maxLength" value="${column.maxLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].minValue" value="${column.minValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].maxValue" value="${column.maxValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>

                            </tr>
                            <!-- create_by -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[1].name" value="create_by"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[1].comments"
                                           value="创建者" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[1].isNull" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[1].validateType" class="form-control m-b">

                                        <c:forEach var="dict" items="${config.validateTypeList}">
                                            <option value="${dict.value}" ${dict.value==column.validateType?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[1].minLength" value="${column.minLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[1].maxLength" value="${column.maxLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[1].minValue" value="${column.minValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[1].maxValue" value="${column.maxValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>

                            <!-- create_date -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[2].name" value="create_date"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[2].comments"
                                           value="创建时间" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[2].isNull" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[2].validateType" class="form-control m-b">

                                        <c:forEach var="dict" items="${config.validateTypeList}">
                                            <option value="${dict.value}" ${dict.value==column.validateType?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[2].minLength" value="${column.minLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[2].maxLength" value="${column.maxLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[2].minValue" value="${column.minValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[2].maxValue" value="${column.maxValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>

                            <!-- update_by -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[3].name" value="update_by"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[3].comments"
                                           value="更新者" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[3].isNull" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[3].validateType" class="form-control m-b">

                                        <c:forEach var="dict" items="${config.validateTypeList}">
                                            <option value="${dict.value}" ${dict.value==column.validateType?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[3].minLength" value="${column.minLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[3].maxLength" value="${column.maxLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[3].minValue" value="${column.minValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[3].maxValue" value="${column.maxValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>

                            <!-- update_date -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[4].name" value="update_date"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[4].comments"
                                           value="更新时间" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[4].isNull" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[4].validateType" class="form-control m-b">

                                        <c:forEach var="dict" items="${config.validateTypeList}">
                                            <option value="${dict.value}" ${dict.value==column.validateType?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[4].minLength" value="${column.minLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[4].maxLength" value="${column.maxLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[4].minValue" value="${column.minValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[4].maxValue" value="${column.maxValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>

                            <!-- remarks -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[5].name" value="remarks"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[5].comments"
                                           value="备注信息" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[5].isNull" value="1"
                                           checked/>
                                </td>
                                <td>
                                    <select name="columnList[5].validateType" class="form-control m-b">

                                        <c:forEach var="dict" items="${config.validateTypeList}">
                                            <option value="${dict.value}" ${dict.value==column.validateType?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[5].minLength" value="${column.minLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[5].maxLength" value="${column.maxLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[5].minValue" value="${column.minValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[5].maxValue" value="${column.maxValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>

                            <!-- del_flag -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[6].name" value="del_flag"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[6].comments"
                                           value="逻辑删除标记（0：显示；1：隐藏）" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[6].isNull" value="1"/>
                                </td>
                                <td>
                                    <select name="columnList[6].validateType" class="form-control m-b">

                                        <c:forEach var="dict" items="${config.validateTypeList}">
                                            <option value="${dict.value}" ${dict.value==column.validateType?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[6].minLength" value="${column.minLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[6].maxLength" value="${column.maxLength}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[6].minValue" value="${column.minValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[6].maxValue" value="${column.maxValue}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>
                        </c:if>
                        <c:forEach var="column" items="${genTable.columnList}" varStatus="vs">
                            <tr ${column.delFlag eq '1'?' class="error" title="已删除的列，保存之后消失！"':''}>
                                <td>
                                    <input type="text" readonly="readonly" name="page-columnList[${vs.index}].name"
                                           value="${column.name}" class="form-control required">
                                </td>
                                <td>
                                    <input type="text" readonly="readonly" name="page-columnList[${vs.index}].comments"
                                           value="${column.comments}" maxlength="200" class="form-control">
                                </td>
                                <td>
                                    <input type="checkbox" class="i-checks" name="columnList[${vs.index}].isNull"
                                           value="1" ${column.isNull eq '1' ? 'checked' : ''}>
                                </td>
                                <td>
                                    <select name="columnList[${vs.index}].validateType" class="form-control m-b">

                                        <c:forEach var="dict" items="${config.validateTypeList}">
                                            <option value="${dict.value}" ${dict.value==column.validateType?'selected':''}
                                                    title="${dict.description}">${dict.label}</option>
                                        </c:forEach>

                                    </select>
                                </td>
                                <td>
                                    <input type="text" name="columnList[${vs.index}].minLength"
                                           value="${column.minLength}" maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[${vs.index}].maxLength"
                                           value="${column.maxLength}" maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[${vs.index}].minValue"
                                           value="${column.minValue}" maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[${vs.index}].maxValue"
                                           value="${column.maxValue}" maxlength="200" class="form-control  "/>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            <div id="tab-4" class="tab-pane">
                <div class="panel-body">
                    <table id="contentTable4"
                           class="table table-striped table-bordered table-hover table-condensed dataTables-example dataTable">
                        <thead>
                        <tr>
                            <th title="数据库字段名" width="15%">列名</th>
                            <th title="默认读取数据库字段备注">说明</th>
                            <th title="实体对象的属性字段说明">JAVA属性标签(例如：名字|年龄|备注)<i class="icon-question-sign"></i></th>
                            <th title="选中后该字段被加入到查询列表里">JAVA属性名称(例如：name|age|remarks)</th>
                            <th title="选中后该字段被加入到查询列表里">检索标签(例如：名字|年龄)</th>
                            <th title="选中后该字段被加入到查询条件里">检索key(例如：name|age)</th>

                        </tr>
                        </thead>
                        <tbody>
                        <c:if test="${empty genTable.name }">
                            <!-- id -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[0].name" value="id"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[0].comments"
                                           value="主键" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].fieldLabels" value="${column.fieldLabels}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].fieldKeys" value="${column.fieldKeys}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].searchLabel" value="${column.searchLabel}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[0].searchKey" value="${column.searchKey}"
                                           maxlength="200" class="form-control  "/>
                                </td>


                            </tr>
                            <!-- create_by -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[1].name" value="create_by"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[1].comments"
                                           value="创建者" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[1].fieldLabels" value="${column.fieldLabels}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[1].fieldKeys" value="${column.fieldKeys}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[1].searchLabel" value="${column.searchLabel}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[1].searchKey" value="${column.searchKey}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>

                            <!-- create_date -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[2].name" value="create_date"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[2].comments"
                                           value="创建时间" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[2].fieldLabels" value="${column.fieldLabels}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[2].fieldKeys" value="${column.fieldKeys}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[2].searchLabel" value="${column.searchLabel}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[2].searchKey" value="${column.searchKey}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>

                            <!-- update_by -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[3].name" value="update_by"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[3].comments"
                                           value="更新者" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[3].fieldLabels" value="${column.fieldLabels}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[3].fieldKeys" value="${column.fieldKeys}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[3].searchLabel" value="${column.searchLabel}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[3].searchKey" value="${column.searchKey}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>

                            <!-- update_date -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[4].name" value="update_date"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[4].comments"
                                           value="更新时间" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[4].fieldLabels" value="${column.fieldLabels}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[4].fieldKeys" value="${column.fieldKeys}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[4].searchLabel" value="${column.searchLabel}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[4].searchKey" value="${column.searchKey}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>

                            <!-- remarks -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[5].name" value="remarks"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[5].comments"
                                           value="备注信息" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[5].fieldLabels" value="${column.fieldLabels}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[5].fieldKeys" value="${column.fieldKeys}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[5].searchLabel" value="${column.searchLabel}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[5].searchKey" value="${column.searchKey}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>

                            <!-- del_flag -->
                            <tr>
                                <td>
                                    <input type="text" class="form-control" readonly="readonly"
                                           name="page-columnList[6].name" value="del_flag"/>
                                </td>
                                <td>
                                    <input type="text" class="form-control" name="page-columnList[6].comments"
                                           value="逻辑删除标记（0：显示；1：隐藏）" maxlength="200" readonly="readonly"/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[6].fieldLabels" value="${column.fieldLabels}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[6].fieldKeys" value="${column.fieldKeys}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[6].searchLabel" value="${column.searchLabel}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                                <td>
                                    <input type="text" name="columnList[6].searchKey" value="${column.searchKey}"
                                           maxlength="200" class="form-control  "/>
                                </td>
                            </tr>
                        </c:if>
                        <c:forEach var="column" items="${genTable.columnList}" varStatus="vs">
                            <tr ${column.delFlag eq '1'?' class="error" title="已删除的列，保存之后消失！"':''}>
                                <td>
                                    <input type="text" readonly="readonly" name="page-columnList[${vs.index}].name"
                                           value="${column.name}" class="form-control required">
                                </td>
                                <td>
                                    <input type="text" readonly="readonly" name="page-columnList[${vs.index}].comments"
                                           value="${column.comments}" maxlength="200" class="form-control">
                                </td>
                                <td>
                                    <input type="text" name="columnList[${vs.index}].fieldLabels"
                                           value="${column.fieldLabels}" maxlength="200" class="form-control">
                                </td>
                                <td>
                                    <input type="text" name="columnList[${vs.index}].fieldKeys"
                                           value="${column.fieldKeys}" maxlength="200" class="form-control">
                                </td>
                                <td>
                                    <input type="text" name="columnList[${vs.index}].searchLabel"
                                           value="${column.searchLabel}" maxlength="200" class="form-control">
                                </td>
                                <td>
                                    <input type="text" name="columnList[${vs.index}].searchKey"
                                           value="${column.searchKey}" maxlength="200" class="form-control">
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
            </form:form>
</body>
</html>
