#!/bin/bash
#
# This script (run from the tarball) installs the JIRA plugin.
# You may also consider using the rpm or deb package generated
# by the ant targets of the same name.
#

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

cd opt/atlassian/jira

echo "Copying files..."
cp -bvdpr -S .orig --no-preserve=ownership . $ATLASSIAN_HOME
install -S .orig -v . $ATLASSIAN_HOME/

# remove joda-time conflict (now in tomcat libdir)
mv -v $ATLASSIAN_HOME/atlassian-jira/WEB-INF/lib/joda-time-2.3.jar{,.orig}

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

If you are use the LastPass IdP service, you may
download the idp-metadata.xml file for your organization
here:

    https://lastpass.com/enterprise_saml.php?metadata

You will also need to configure the IdP with the service
provider entity ID and the URLs.

Once satisfied with the configuration, restart JIRA.

__EOM__

