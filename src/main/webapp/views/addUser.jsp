<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<style>
<%@include file="/WEB-INF/assets/css/style.css"%>
<%@include file="/WEB-INF/assets/css/add.css"%>
</style>
<body>
<div class="content">
        <h4 class="app__validate">Form không hợp lệ</h4>
        <h2 class="content__message"><%= request.getAttribute("msg") != null ? request.getAttribute("msg"): " " %></h2>
        <c:if test="${inforUser == null }">
        	<form action="/UserManagementApp/insert" method="post" class="form__login" id="form-1">
        </c:if>
        
        <c:if test="${inforUser != null }">
        	<form action="/UserManagementApp/update" method="post" class="form__login" id="form-1">
        </c:if>
        	
            <h2 class="login__heading">Add New User</h2>
            <input name="id" style="display:none" value="<c:out value="${inforUser.id}" />">
            <div class="form__name">
                <span class="form__name-title">User Name</span>
                <input name="name" id="name" type="text" rule="isRequired" class="filed__name" value="<c:out value="${inforUser.name }" />">
                <span class="form__message"></span>
            </div>
            <div class="form__name">
                <span class="form__name-title">User Email</span>
                <input name="email" id="email" rule="isRequired|isEmail" type="email" class="filed__name" value="<c:out value="${inforUser.email }" />">
                <span class="form__message"></span>
            </div>

            <div class="form__name">
                <span class="form__name-title">User Country</span>
                <input name="country" id="country" rule="isRequired" type="text" class="filed__name" value="<c:out value="${inforUser.country }" />">
                <span class="form__message"></span>
            </div>

            <input class="form__submit" type="submit" value="Save">
        </form>
    </div>
    <script >
    function Validator(formSelector) {
        const _this = this;

        // tạo một đối tượng đưa ra các rules cho form
        var validatorRules = {
            isRequired: function(value) {
                return value ? undefined : 'Vui lòng nhập trường này'
            },
            isEmail: function(value) {
                var regex = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
                return regex.test(value) ? undefined : 'Vui lòng nhập đúng email'
            },
            min: function(min) {
                return function(value) {
                    return value.length >= min ? undefined : `Vui lòng nhập ít nhất ${min} kí tự`;
                }
            },
            isPassword: function(value) {
                const pass = document.querySelector('input[name="password"]:not(disabled)').value;
                return pass === value ? undefined : 'Vui lòng nhập đúng mật khẩu xác nhận';
            },
            max: function(max) {
                return function(value) {
                    return value.length <= max ? undefined : `Vui lòng nhập không vượt quá ${max} kí tự`;
                }
            }
        };
        // lấy cả form ra
        var formElement = document.querySelector(formSelector);
        // khi form tồn tại
        if (formElement) {
            var inputs = formElement.querySelectorAll('[name][rule]:not(disabled)');
            // tạo một object lấy name và rule của từng thẻ input
            var formRules = Array.from(inputs).reduce(function(callback, input) {
                var rules = input.getAttribute('rule').split('|'); // một mảng chứa các rule đối với một thẻ input
                for (var rule of rules) {
                    var ruleHasMin = rule.includes(':');
                    var ruleInfor;
                    if (ruleHasMin) {
                        ruleInfor = rule.split(':');
                        rule = ruleInfor[0];
                    }
                    var ruleFuc = validatorRules[rule];

                    if (ruleHasMin) {
                        ruleFuc = ruleFuc(ruleInfor[1]);
                    };

                    if (Array.isArray(callback[input.name])) { // khi có mảng thì thêm function rule vào
                        callback[input.name].push(ruleFuc);
                    } else {
                        callback[input.name] = [ruleFuc]; // tạo mảng 
                    }
                }
                // hàm validate để có các sự kiện change, blur
                input.onblur = validate;
                input.oninput = handlerClearError;
                return callback
            }, {});

            function validate(event) {
                const input = event.target;
                var messageError;
                for (var i = 0; i < formRules[input.name].length; i++) {
                    var arrRule = formRules[input.name][i];
                    var parentInput = findParent(input, formNameSelector);
                    switch (input.type) {
                        case 'radio':
                        case 'checkbox':
                            var getValue;
                            if (parentInput.querySelector('input[name]:checked:not(disabled)')) {
                                getValue = parentInput.querySelector('input[name]:checked:not(disabled)').value;
                            } else {
                                getValue = '';
                            }
                            messageError = arrRule(getValue);
                            break;
                        default:
                            messageError = arrRule(input.value);
                    }
                    if (parentInput) {
                        var textError = parentInput.querySelector(formMessage);
                        if (textError) {
                            if (messageError) {
                                parentInput.classList.add('invalid');
                                textError.innerHTML = messageError;
                                break;
                            } else {
                                parentInput.classList.remove('invalid');
                                textError.innerHTML = '';
                            }
                        }
                    }
                };
                return !messageError;
            }
            // hàm clear messError
            function handlerClearError(event) {
                const input = event.target;
                var messageError;
                var arrRule = formRules[input.name].find(function(rule) {
                        messageError = rule(input.value);
                        return rule;
                    })
                    // messageError = arrRule(input.value); // dư 

                var parentInput = findParent(event.target, formNameSelector);
                var textError = parentInput.querySelector(formMessage);
                if (parentInput.matches('.invalid')) {
                    parentInput.classList.remove('invalid');
                    if (!messageError) {
                        textError.innerHTML = '';
                    }
                }
            }

            function findParent(elementInput, selector) {
                while (elementInput) {
                    if (elementInput.parentElement.matches(selector)) {
                        return elementInput.parentElement;
                    }
                    elementInput = elementInput.parentElement;
                }
            }
        }
        formElement.onsubmit = function(e) {
            e.preventDefault();
            var inputs = formElement.querySelectorAll('[name][rule]:not(:disabled)');
            const formInvalid = document.querySelector(invalidForm);
            console.log(formInvalid)
            var isFormValid = true;
            for (var input of inputs) {
                var answer = validate({
                    target: input,
                });
                if (!answer) {
                    formInvalid.classList.add('form-invalid');
                    isFormValid = false;
                }
            }
            // khi mà form hợp lệ
            if (isFormValid) {
                formInvalid.classList.remove('form-invalid');

                if (typeof _this.onSubmit === 'function') {
                    var data = Array.from(inputs).reduce(function(callback, input) {
                        switch (input.type) {
                            case 'checkbox':
                                if (!Array.isArray(callback[input.name])) {
                                    callback[input.name] = [];
                                }
                                if (input.matches(':checked')) {

                                    callback[input.name].push(input.value);
                                }
                                break;
                            case 'radio':
                                var valueChecked = formElement.querySelector('[name="' + input.name + '"]:checked');
                                if (valueChecked) {
                                    callback[input.name] = valueChecked.value;
                                } else {
                                    callback[input.name] = '';
                                }
                                break;
                            case 'file':
                                callback[input.name] = input.files;
                                break;
                            default:
                                callback[input.name] = input.value;

                        }
                        return callback;
                    }, {});
                    _this.onSubmit(data);

                } else {
                    formElement.submit();
                }
            }
        }



    }
    </script>
    <script>
        const formNameSelector = '.form__name';
        const formMessage = '.form__message';
        const invalidForm = '.app__validate';
        var form1 = new Validator('#form-1');
    </script>
</body>
</html>