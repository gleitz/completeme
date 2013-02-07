SHELL := /bin/bash

VERSION_FN := "VERSION"
CURRENT_VERSION := $(shell perl -pe 'chomp if eof' $(VERSION_FN))

default:
	@echo "Run make release to build and commit a new version of the library"

build_sdist:
	bash check_build.sh

	python setup.py sdist

	# bump version
	python -c "curr = map(int, open('$(VERSION_FN)').read().split('.')); curr[-1] += 1; open('$(VERSION_FN)', 'w').write('.'.join(map(str,curr)))"

	# add the new dist, commit, and add tag
	git add VERSION
	git commit -m "Releasing version $(CURRENT_VERSION)"
	git tag "v$(CURRENT_VERSION)"

release: build_sdist clean

clean:
	rm -rf build *.egg-info