#!/bin/bash
#
# This script (run from the tarball) installs the JIRA plugin.
# You may also consider using the rpm or deb package generated
# by the ant targets of the same name.
#

function remove_servlet_mapping
{
    local jsp_name=$1
    local web_xml=$ATLASSIAN_HOME/atlassian-jira/WEB-INF/web.xml

    cp $web_xml{,~}

    # This sed script does:
    #
    #  1) on each line matching jsp_name, copy pattern and subsequent two
    #     lines into hold buffer, and print the lot surrounded by xml
    #     comments
    #
    #  2) on every other line, and twice on last line, swap pattern and
    #     hold buffer and print hold buffer (i.e. print previous line,
    #     keeping current line in hold buffer so that we can back up by one
    #     line)
    #
    cat $web_xml~ | \
        sed -n '/<servlet-name>'$jsp_name'/{i <!--
                N;N;H;g;a -->
                p;s/.*//;h;d};x;1!p;${x;p}' > $web_xml
}

defroot=/opt/atlassian/jira

if [[ $UID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 0
fi

done=0
while [[ $done -eq 0 ]]; do
    echo -n "Root of your Atlassian JIRA install [$defroot]? "
    read answer

    ATLASSIAN_HOME=${answer:-$defroot}
    if [[ ! -e $ATLASSIAN_HOME ]]; then
        echo "Unable to find directory '$ATLASSIAN_HOME'; please recheck"
    else
        let done=1
    fi
done

cat<<__EOM__

This script will update your login configuration in place.
Backups of existing files will be saved with the '.orig'
suffix appended.

__EOM__

echo -n "Continue installation to '$ATLASSIAN_HOME'? [Y/n] "
read keep_going

if [[ $keep_going == 'N' || $keep_going == 'n' ]]; then
    echo "Install aborted"
    exit 1
fi

cd ${defroot:1}

echo "Removing existing plugin jars..."
rm -vf $ATLASSIAN_HOME/atlassian-jira/WEB-INF/lib/lastpass-jira-saml-*

echo "Copying files..."
cp -bvdpr -S .orig --no-preserve=ownership . $ATLASSIAN_HOME

# remove joda-time conflict (now in tomcat libdir)
mv -v $ATLASSIAN_HOME/atlassian-jira/WEB-INF/lib/joda-time-2.3.jar{,.orig}

# append "Login with SAML" button
cp $ATLASSIAN_HOME/atlassian-jira/includes/loginform.jsp{,.orig}
cat $ATLASSIAN_HOME/atlassian-jira/includes/loginform.append.jsp >> $ATLASSIAN_HOME/atlassian-jira/includes/loginform.jsp
rm -vf $ATLASSIAN_HOME/atlassian-jira/includes/loginform.append.jsp

# Starting with Jira 7+, we have to remove from web.xml any servlet stanzas
# that refer to scripts that include the modified loginform.jsp
cp $ATLASSIAN_HOME/atlassian-jira/includes/web.xml{,.orig}
remove_servlet_mapping jsp.includes.loginform_jsp
remove_servlet_mapping jsp.includes.loginpage_jsp
remove_servlet_mapping jsp.login_jsp

cd -

cat<<__EOM__

Installation is complete.  You will need to configure the
Service Provider and Identity Provider settings in the
jira directory.

First rename them appropriately:

    cd $ATLASSIAN_HOME
    mv idp-metadata.xml.sample idp-metadata.xml
    mv sp-metadata.xml.sample sp-metadata.xml

And then edit the xml files to reflect your entity ID
and URLs.

If you are using the LastPass IdP service, you may
download the idp-metadata.xml file for your organization
here:

    https://lastpass.com/enterprise_saml.php?metadata

You will also need to configure the IdP with the service
provider entity ID and the URLs.

Once satisfied with the configuration, restart JIRA.

__EOM__

