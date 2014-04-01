#!/bin/sh
ATLASSIAN_HOME=/opt/atlassian/jira

echo "Fixing up classpath..."
mv $ATLASSIAN_HOME/atlassian-jira/WEB-INF/lib/joda-time-2.3.jar $ATLASSIAN_HOME/atlassian-jira/WEB-INF/lib/joda-time-2.3.jar.orig 2>/dev/null || :
