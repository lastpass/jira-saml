<!-- added by LastPass -->
<page:applyDecorator id="saml-login-form" name="auiform">
    <page:param name="action"><%= request.getContextPath() %>/saml_login.jsp</page:param>
    <page:param name="method">post</page:param>
    <page:param name="submitButtonName">login</page:param>
    <page:param name="submitButtonText">Log In with SAML</page:param>
</page:applyDecorator>
