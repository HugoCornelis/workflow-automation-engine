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


SUBDIRS = perl

HTML_UPLOAD_DIR = html/htdocs/neurospaces_project/$(PACKAGE)
HTML_SOURCE_DIR = vigilia/html

dist_bin_SCRIPTS = \
	bin/vigilia \
	bin/workflow

workflowautomationtestdir=$(prefix)/neurospaces/workflow-automation
nobase_dist_workflowautomationtest_DATA=@TEST_SPECIFICATION_FILES@

workflowautomationimagesdir=$(prefix)/neurospaces/images
nobase_dist_workflowautomationimages_DATA = images/ns-main-logo-dark2.jpg logos/cables-bw-final-comp-1-shrunk-cropped-reduced-bottom-640x170.png

if INSTALL_BASH_COMPLETION
bashcompdir = @bashcompdir@
dist_bashcomp_DATA = bin/workflow-files/workflow.bash
endif

# the tests are copied overhere.
#
# The variable EXTRA_DIST could also be used here.

EXTRA_DIST = \
	vigilia.config \
	bin/workflow-files/conf.neurospaces-configuration \
	bin/workflow-files/conf.neurospaces-workflow \
	bin/workflow-files/conf.workflow \
	bin/workflow-files/neurospaces-configuration \
	cpan \
	vigilia \
	license.txt

am__tar = ${AMTAR} chf - --format=posix "$$tardir"


maintainer-clean-local:
	$(RM) -r $(top_srcdir)/$(PACKAGE)-$(VERSION)
	$(RM) -f $(top_srcdir)/$(PACKAGE)-$(VERSION).tar.gz

clean-local:
	rm -rf $(top_srcdir)/neurospaces_cpan_modules
	rm -rf $(TMP_DIR)
	$(RM) -rf $(top_srcdir)/*.deb
	$(RM) -f $(top_srcdir)/*.changes
	$(RM) -f $(top_srcdir)/*.dsc
	$(RM) -f $(top_srcdir)/build_*.log
	$(RM) -rf $(top_srcdir)/*_BUILD/

dist-hook:
	test -n "$(HTML_UPLOAD_DIR)"
	case "$(HTML_UPLOAD_DIR)" in /*|*..*) false ;; *) true ;; esac
	$(srcdir)/install-sh -d $(distdir)/$(HTML_SOURCE_DIR)
	( cd $(distdir) && chmod -R u+w vigilia && bin/vigilia --output-html )
	rm -fr $(distdir)/$(HTML_UPLOAD_DIR)
	$(srcdir)/install-sh -d $(distdir)/$(HTML_UPLOAD_DIR)
	cp -R $(distdir)/$(HTML_SOURCE_DIR)/. $(distdir)/$(HTML_UPLOAD_DIR)/
	rm -rf $(distdir)/$(HTML_SOURCE_DIR)

install-data-local: neurospaces_cpan_modules

install-data-hook:
	@echo "workflow and vigilia installation finished"

neurospaces_cpan_modules:
	@echo "======================== Installing CPAN modules"
	( cd cpan ; ./cpan_install [0-9][0-9]*.gz )
	touch $(top_srcdir)/neurospaces_cpan_modules

test: check

TESTS = run_harness.sh

vigilia-html:
	( cd $(top_srcdir) && bin/vigilia --output-html )

html-upload-prepare: vigilia-html
	rm -fr $(HTML_UPLOAD_DIR)
	mkdir -p $(HTML_UPLOAD_DIR)
	cp -R $(top_srcdir)/$(HTML_SOURCE_DIR)/. $(HTML_UPLOAD_DIR)/

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

APP_NAME=workflow

# the pkg-src target must create pkg/$(APP_NAME)-$(VERSION).tar.gz
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
