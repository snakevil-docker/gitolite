TAG := $(shell \
	cd share/gitolite.git; \
	git tag --sort=-v:refname | \
		head -n1 \
)
.GITOLITE_TAG := $(shell \
	cd share/gitolite.git; \
	git tag --sort=-v:refname | \
		head -n1 \
)
.GITOLITE_VERSION := $(shell \
	echo $(TAG) | \
		sed -e "s/^v//i" \
)

.DEFAULT_GOAL=gitolite

.PHONY: gitolite
gitolite: var/lib/gitolite-$(.GITOLITE_VERSION).tar.xz
	[ "x$(TAG)" != "x$(.GITOLITE_TAG)" ] || { \
		rm -f var/lib/gitolite-latest.tar.xz; \
		ln -s gitolite-$(.GITOLITE_VERSION).tar.xz var/lib/gitolite-latest.tar.xz; \
	}
var/lib/gitolite-$(.GITOLITE_VERSION).tar.xz: var/build/VERSION
	tar -cf - --exclude=.git* -C $(<D) . | xz -9 > $@
var/build/VERSION: share/gitolite.git/install
	cd $(<D); git checkout $(TAG) 2> /dev/null
	$< -to $(PWD)/$(@D)
	cd $(<D); git checkout master > /dev/null 2>&1

.PHONY: clean
clean:
	rm -fr var/build/*

# vi:noet
