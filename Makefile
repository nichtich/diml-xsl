zip:
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
else
	rm -rf /tmp/diml-xsl-$(ZIPVER)
	mkdir /tmp/diml-xsl-$(ZIPVER)
	rm -f /tmp/tar.exclude
	touch /tmp/tar.exclude	
	echo tar.exclude >> /tmp/tar.exclude
	find . -print  | grep /CVS$$ | cut -c3- >> /tmp/tar.exclude
	find . -print  | grep /CVS/ | cut -c3- >> /tmp/tar.exclude
	find . -print  | grep .classes | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "*~"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".*~"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "*.bak"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "#*"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".#*"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".cvsignore"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name "README.CVS"  | cut -c3- >> /tmp/tar.exclude
	tar cf - * --exclude-from /tmp/tar.exclude | (cd /tmp/diml-xsl-$(ZIPVER); tar xf -)
	cd /tmp && tar cf - diml-xsl-$(ZIPVER) | gzip > diml-xsl-$(ZIPVER).tar.gz
	cd /tmp && zip -rpD diml-xsl-$(ZIPVER).zip diml-xsl-$(ZIPVER)
	rm -f /tmp/tar.exclude
endif

clean:
	find . -type f -name "*.bak" -exec rm '{}' ';'
	find . -type f -name "*~" -exec rm '{}' ';'
	find . -type f -name ".*~" -exec rm '{}' ';'