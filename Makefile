SECTION=8
SOURCES=src/strfile/__init__.py src/strfile/main.py

# Default action is to show this help message:
.help:
	@echo "Possible targets:"
	@echo "  check-code     Verify PEP 8 compliance (lint)"
	@echo "  check-security Verify security issues (audit)"
	@echo "  check-unused   Find unused code"
	@echo "  check-version  Find required Python version"
	@echo "  check-sloc     Count Single Lines of Code"
	@echo "  checks         Make all the previous tests"
	@echo "  format         Format code"
	@echo "  package        Build package"
	@echo "  upload-test    Upload the package to TestPyPi"
	@echo "  upload         Upload the package to PyPi"
	@echo "  distclean      Remove all generated files"

check-code: /usr/local/bin/pylint
	-pylint ${SOURCES}

lint: check-code

check-security: /usr/local/bin/bandit
	-bandit -r ${SOURCES}

audit: check-security

check-unused: /usr/local/bin/vulture
	-vulture --sort-by-size ${SOURCES}

check-version: /usr/local/bin/vermin
	-vermin ${SOURCES}

check-sloc: /usr/local/bin/pygount
	-pygount --format=summary .

checks: check-code check-security check-unused check-version check-sloc

format: /usr/local/bin/black
	black ${SOURCES}

love:
	@echo "Not war!"

man/strfile.${SECTION}.gz: man/strfile.${SECTION}
	@gzip -k9c man/strfile.${SECTION} > man/strfile.${SECTION}.gz

man/unstr.${SECTION}.gz: man/unstr.${SECTION}
	@gzip -k9c man/unstr.${SECTION} > man/unstr.${SECTION}.gz

package: man/strfile.${SECTION}.gz man/unstr.${SECTION}.gz
	python -m build

upload-test:
	python -m twine upload --repository testpypi dist/*

upload:
	python -m twine upload dist/*

distclean:
	rm -rf build dist man/strfile.${SECTION}.gz man/unstr.${SECTION}.gz src/*.egg-info

