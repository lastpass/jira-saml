LastPass JIRA SAML Plugin
=========================

The LastPass JIRA SAML Plugin enables SAML 2.0 single-sign-on to
hosted JIRA applications.  This implements the Service Provider
interface for SAML Authentication.

What do I need to use it?
-------------------------

You will need a recent hosted Atlassian JIRA installation.  This
has been tested with version 6.4.

You will also need a SAML IdP provider.  If you do not have one,
we suggest our own IdP service, part of LastPass Enterprise,
at https://lastpass.com/.

Installing the Plugin from Source
----------------------------------

You must first install Atlassian JIRA, and set the jira.home.dir
in the build.xml to match its location.

Once done, build and install the application as follows:
```
    $ ant && sudo ant install
```

Optionally, you may instead build tar, rpm, and deb release
packages using the appropriate ant targets, and install them as
directed in the INSTALL file.

Please see INSTALL for additional instructions for setting up
the IdP and SP metadata.
