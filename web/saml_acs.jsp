<%--
  -- saml_acs - assertion consumer service page
  --
  -- Licensed under the Apache License, Version 2.0 (the "License"); you may not
  -- use this file except in compliance with the License. You may obtain a copy
  -- of the License at
  --
  --     http://www.apache.org/licenses/LICENSE-2.0
  --
  -- Unless required by applicable law or agreed to in writing, software
  -- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  -- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
  -- License for the specific language governing permissions and limitations
  -- under the License.
  --
  -- Copyright (c) 2014 LastPass, Inc.
  --
  --%>
<%@ page import="com.atlassian.jira.ComponentManager" %>
<%@ page import="com.atlassian.jira.security.JiraAuthenticationContext" %>
<%
    // this page is where SAML authentication returns.
    // if auth is successful, user is added to session and
    // we redirect to the url in RelayState.  Otherwise, we
    // display an error page.
    final JiraAuthenticationContext jiraAuthenticationContext = ComponentManager.getComponentInstanceOfType(JiraAuthenticationContext.class);

    // verify SAMLResponse
    if (jiraAuthenticationContext.getLoggedInUser() != null) {
        // great, go back to wherever we started.
        request.setAttribute("loggedInUser", jiraAuthenticationContext.getLoggedInUser() == null ? null : jiraAuthenticationContext.getLoggedInUser().getDisplayName());
        String originalUrl = request.getParameter("RelayState");
        if (originalUrl == null)
            originalUrl = "/";

        response.sendRedirect(response.encodeRedirectURL(originalUrl));
    } else {
        // SAML login failed.
        %>
        Sorry, we were unable to validate your account.
        <%
    }
%>
