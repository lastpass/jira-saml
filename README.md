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

Building the Plugin from Source
-------------------------------

You must first install Atlassian JIRA, and set the jira.home.dir
in the build.xml to match its location.

Run ant to generate a binary tarball with the proper libraries:

    $ ant

This will download dependencies with ivy and then build the class
files.  The resulting tarball will reside in the out/ directory.

Installing the Plugin
---------------------

Once built, extract the tarball somewhere and run the install.sh
script.  See the INSTALL file for details.
