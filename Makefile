GitoliteTag := $(shell \
	cd share/gitolite.git; \
	git tag --sort=-v:refname | \
		head -n1 \
)
GitoliteVersion := $(shell \
	echo $(GitoliteTag) | \
		sed -e "s/^v//i" \
)

.DEFAULT_GOAL=gitolite

.PHONY: gitolite
gitolite: var/lib/gitolite-$(GitoliteVersion).tar.xz
	rm -f var/lib/gitolite-latest.tar.xz
	ln -s gitolite-$(GitoliteVersion).tar.xz var/lib/gitolite-latest.tar.xz
var/lib/gitolite-$(GitoliteVersion).tar.xz: var/build/VERSION
	tar -cf - --exclude=.git* -C $(<D) . | xz -9 > $@
var/build/VERSION: share/gitolite.git/install
	cd $(<D); git checkout $(GitoliteTag) 2> /dev/null
	$< -to $(PWD)/$(@D)
	cd $(<D); git checkout master > /dev/null 2>&1

.PHONY: clean
clean:
	rm -fr var/build/*

# vi:noet
