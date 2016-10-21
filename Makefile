TAG := $(shell \
	cd share/gitolite.git; \
	git tag --sort=-v:refname | \
		head -n1 \
)
_GITOLITE_ILLEGAL := $(shell \
	cd share/gitolite.git; \
	git tag | \
		awk -v "tag=$(TAG)" -f ../../lib/match-tag.awk \
)
$(if $(_GITOLITE_ILLEGAL), \
	$(error $(TAG) not found) \
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

.DEFAULT_GOAL=docker

.PHONY: gitolite
gitolite: var/lib/gitolite-$(_GITOLITE_VERSION).tar.xz
	[ "x$(TAG)" != "x$(_GITOLITE_TAG)" ] || { \
		rm -f var/lib/gitolite-latest.tar.xz; \
		ln -s gitolite-$(_GITOLITE_VERSION).tar.xz var/lib/gitolite-latest.tar.xz; \
	}
var/lib/gitolite-$(_GITOLITE_VERSION).tar.xz: var/build/$(TAG)/srv/gitolite/VERSION
	find $(dir $(<D)).. -type f -name '.*' -delete
	tar -cf - -C $(dir $(<D)).. . | xz -9 > $@
var/build/$(TAG)/srv/gitolite/VERSION: share/gitolite.git/install
	[ -f "$@" ] || mkdir -p $(@D)
	[ -f "$@" ] || { cd share/gitolite.git; git checkout $(TAG) 2> /dev/null; }
	[ -f "$@" ] || share/gitolite.git/install -to $(PWD)/$(@D)
	cd share/gitolite.git; git checkout master 2> /dev/null

.PHONY: clean
clean:
	rm -fr var/build/*

.PHONY: docker
docker: gitolite
	docker build --build-arg version=$(_GITOLITE_VERSION) -t gitolite:$(_GITOLITE_VERSION) .
	[ "x$(TAG)" != "x$(_GITOLITE_TAG)" ] || docker tag gitolite:$(_GITOLITE_VERSION) gitolite:latest

# vi:noet
