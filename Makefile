TAG := $(shell \
	cd share/gitolite.git; \
	git tag --sort=-v:refname | \
		head -n1 \
)
_GITOLITE_TAG := $(shell \
	cd share/gitolite.git; \
	git tag --sort=-v:refname | \
		head -n1 \
)
_GITOLITE_VERSION := $(shell \
	echo $(TAG) | \
		sed -e "s/^v//i" \
)

.DEFAULT_GOAL=gitolite

.PHONY: gitolite
gitolite: var/lib/gitolite-$(_GITOLITE_VERSION).tar.xz
	[ "x$(TAG)" != "x$(_GITOLITE_TAG)" ] || { \
		rm -f var/lib/gitolite-latest.tar.xz; \
		ln -s gitolite-$(_GITOLITE_VERSION).tar.xz var/lib/gitolite-latest.tar.xz; \
	}
var/lib/gitolite-$(_GITOLITE_VERSION).tar.xz: var/build/$(TAG)/VERSION
	tar -cf - --exclude=.git* -C $(<D) . | xz -9 > $@
var/build/$(TAG)/VERSION: share/gitolite.git/install
	[ -f "$@" ] || mkdir $(@D)
	[ -f "$@" ] || { cd share/gitolite.git; git checkout $(TAG) 2> /dev/null; }
	[ -f "$@" ] || share/gitolite.git/install -to $(PWD)/$(@D)
	[ -f "$@" ] || { cd share/gitolite.git; git checkout master 2> /dev/null; }

.PHONY: clean
clean:
	rm -fr var/build/*

# vi:noet
