##
## The neurospaces project : modeling tools for computational
## neuroscience.
##

##############################################################################
##'
##' The neurospaces project
##'
##' Copyright (C) 2007-2008 Hugo Cornelis
##'
##' Hugo Cornelis, hugo.cornelis@gmail.com
##'
##############################################################################


SUBDIRS =

dist_bin_SCRIPTS = \
	bin/workflow

# the tests are copied overhere.
#
# The variable EXTRA_DIST could also be used here.

EXTRA_DIST = \
	bin/workflow-files/conf.neurospaces-configuration \
	bin/workflow-files/conf.neurospaces-workflow \
	bin/workflow-files/conf.workflow \
	bin/workflow-files/neurospaces-configuration \
	cpan \
	docs \
	tests \
	license.txt

am__tar = ${AMTAR} chf - --format=posix "$$tardir"


clean-local:
	rm -rf $(top_srcdir)/neurospaces_cpan_modules
	rm -rf $(TMP_DIR)
	$(RM) -rf $(top_srcdir)/*.deb
	$(RM) -f $(top_srcdir)/*.changes
	$(RM) -f $(top_srcdir)/*.dsc
	$(RM) -f $(top_srcdir)/build_*.log
	$(RM) -rf $(top_srcdir)/*_BUILD/
	$(RM) $(top_srcdir)/workflow-automation-*.tar.gz
	$(RM) -rf $(top_srcdir)/workflow-automation-*

dist-hook:
	$(srcdir)/install-sh -d $(distdir)/tests
	$(srcdir)/install-sh -d $(distdir)/tests/html
	( cd $(distdir)/tests && chmod -R u+w . && neurospaces_harness_2_html --introduction introduction.html )

install-data-local: neurospaces_cpan_modules

neurospaces_cpan_modules:
	@echo "======================== Installing CPAN modules"
	( cd cpan ; ./cpan_install *.gz )
	touch $(top_srcdir)/neurospaces_cpan_modules

test: check

TESTS = run_harness.sh

html-upload-prepare:
	rm -fr html/htdocs/neurospaces_project/$(PACKAGE)
	mkdir -p html/htdocs/neurospaces_project/$(PACKAGE)
# $Format: "	( cd tests && neurospaces_harness_2_html --header '<img src=\"ns-main-logo-dark2-notext-32x32.jpg\" alt=\"Main Neurospaces logo\"> ${package}, ${label}, ${email} <hr>' --introduction introduction.html )" $
	( cd tests && neurospaces_harness_2_html --header '<img src="ns-main-logo-dark2-notext-32x32.jpg" alt="Main Neurospaces logo"> neurospaces 0.1675 Thu, 27 Dec 2007 15:58:18 -0600 hugo<hr>' --introduction introduction.html )

#t perhaps also add a target to check the syntax of all the html ?

html-upload: html-upload-prepare

website-clean:

website-prepare:

website-prepare-local:

website-upload: website-clean website-prepare html-upload

webcheck:

docs-level1:

docs-level2:

docs-level3: html-upload-prepare
	echo "Converted the regression tests to HTML"

docs-level4:

docs-level5:

docs-level6:

docs-level7:

docs: docs-level1 docs-level2 docs-level3 docs-level4 docs-level5 docs-level6 docs-level7

pkg-src: dist
	mkdir -p pkg
	cp $(PACKAGE)-$(VERSION).tar.gz pkg/$(PACKAGE)-$(VERSION).tar.gz


# Create a deb package
pkg-deb: dist
	nspkg-deb $(PACKAGE) $(VERSION)

pkg-rpm: dist
	nspkg-rpm $(PACKAGE) $(VERSION)

pkg-osx:
	nspkg-osx
