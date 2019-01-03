# Targets:
#   all               Build everything
#   test              Build and test everyything (implies all_check)
#   install           Build and install all OTF files. (currently Mac-only)
#   zip               Build a complete release-grade ZIP archive of all fonts.
#   dist              Create a new release distribution. Does everything.
#
#   all_const         Build all non-variable files
#   all_const_hinted  Build all non-variable files with hints
#   all_var           Build all variable files
#   all_var_hinted    Build all variable files with hints (disabled)
#
#   all_otf					  Build all OTF files into FONTDIR/const
#   all_ttf					  Build all TTF files into FONTDIR/const
#   all_ttf_hinted	  Build all TTF files with hints into FONTDIR/const-hinted
#   all_web					  Build all WOFF files into FONTDIR/const
#   all_web_hinted	  Build all WOFF files with hints into FONTDIR/const-hinted
#   all_var           Build all variable font files into FONTDIR/var
#   all_var_hinted    Build all variable font files with hints into
#                     FONTDIR/var-hinted
#
#   designspace       Build src/Inter-UI.designspace from src/Inter-UI.glyphs
#
# Style-specific targets:
#   STYLE_otf         Build OTF file for STYLE into FONTDIR/const
#   STYLE_ttf         Build TTF file for STYLE into FONTDIR/const
#   STYLE_ttf_hinted  Build TTF file for STYLE with hints into
#                     FONTDIR/const-hinted
#   STYLE_web         Build WOFF files for STYLE into FONTDIR/const
#   STYLE_web_hinted  Build WOFF files for STYLE with hints into
#                     FONTDIR/const-hinted
#   STYLE_check       Build & check OTF and TTF files for STYLE
#
# "build" directory output structure:
# 	fonts
# 		const
# 		const-hinted
# 		var
# 		var-hinted  (disabled)
#
FONTDIR = build/fonts

all: all_const  all_const_hinted  all_var

all_const: all_otf  all_ttf  all_web
all_const_hinted: all_ttf_hinted  all_web_hinted
var: \
	$(FONTDIR)/var/Inter-UI.var.woff2 \
	$(FONTDIR)/var/Inter-UI.var.ttf
all_var: \
	$(FONTDIR)/var/Inter-UI.var.woff2 \
	$(FONTDIR)/var/Inter-UI-upright.var.woff2 \
	$(FONTDIR)/var/Inter-UI-italic.var.woff2 \
	$(FONTDIR)/var/Inter-UI.var.ttf \
	$(FONTDIR)/var/Inter-UI-upright.var.ttf \
	$(FONTDIR)/var/Inter-UI-italic.var.ttf

# Disabled. See https://github.com/rsms/inter/issues/75
# all_var_hinted: $(FONTDIR)/var-hinted/Inter-UI.var.ttf $(FONTDIR)/var-hinted/Inter-UI.var.woff2
# .PHONY: all_var_hinted

.PHONY: all_const  all_const_hinted  var  all_var

export PATH := $(PWD)/build/venv/bin:$(PATH)

# generated.make is automatically generated by init.sh and defines depenencies for
# all styles and alias targets
include build/etc/generated.make


# TTF -> WOFF2
build/%.woff2: build/%.ttf
	woff2_compress "$<"

# TTF -> WOFF
build/%.woff: build/%.ttf
	ttf2woff -O -t woff "$<" "$@"

# make sure intermediate TTFs are not gc'd by make
.PRECIOUS: build/%.ttf

# TTF -> EOT (disabled)
# build/%.eot: build/%.ttf
# 	ttf2eot "$<" > "$@"


# Master UFO -> OTF, TTF

all_ufo_masters = $(Thin_ufo_d) \
                  $(ThinItalic_ufo_d) \
                  $(Regular_ufo_d) \
                  $(Italic_ufo_d) \
                  $(Black_ufo_d) \
                  $(BlackItalic_ufo_d)

$(FONTDIR)/var/%.var.ttf: src/%.designspace $(all_ufo_masters)
	misc/fontbuild compile-var -o $@ $<


# ---------- begin workaround for issue #110 -----------

# $(FONTDIR)/const/Inter-UI-Thin.%: src/Inter-UI.designspace $(Thin_ufo_d)
# 	misc/fontbuild compile -o $@ src/Inter-UI-Thin.ufo

# $(FONTDIR)/const/Inter-UI-ThinItalic.%: src/Inter-UI.designspace $(ThinItalic_ufo_d)
# 	misc/fontbuild compile -o $@ src/Inter-UI-ThinItalic.ufo

# $(FONTDIR)/const/Inter-UI-Regular.%: src/Inter-UI.designspace $(Regular_ufo_d)
# 	misc/fontbuild compile -o $@ src/Inter-UI-Regular.ufo

# $(FONTDIR)/const/Inter-UI-Italic.%: src/Inter-UI.designspace $(Italic_ufo_d)
# 	misc/fontbuild compile -o $@ src/Inter-UI-Italic.ufo

# $(FONTDIR)/const/Inter-UI-Black.%: src/Inter-UI.designspace $(Black_ufo_d)
# 	misc/fontbuild compile -o $@ src/Inter-UI-Black.ufo

# $(FONTDIR)/const/Inter-UI-BlackItalic.%: src/Inter-UI.designspace $(BlackItalic_ufo_d)
# 	misc/fontbuild compile -o $@ src/Inter-UI-BlackItalic.ufo


$(FONTDIR)/const/Inter-UI-Thin.ttf: src/Inter-UI.designspace $(Thin_ufo_d)
	misc/fontbuild compile -o $@ src/Inter-UI-Thin.ufo

$(FONTDIR)/const/Inter-UI-ThinItalic.ttf: src/Inter-UI.designspace $(ThinItalic_ufo_d)
	misc/fontbuild compile -o $@ src/Inter-UI-ThinItalic.ufo

$(FONTDIR)/const/Inter-UI-Regular.ttf: src/Inter-UI.designspace $(Regular_ufo_d)
	misc/fontbuild compile -o $@ src/Inter-UI-Regular.ufo

$(FONTDIR)/const/Inter-UI-Italic.ttf: src/Inter-UI.designspace $(Italic_ufo_d)
	misc/fontbuild compile -o $@ src/Inter-UI-Italic.ufo

$(FONTDIR)/const/Inter-UI-Black.ttf: src/Inter-UI.designspace $(Black_ufo_d)
	misc/fontbuild compile -o $@ src/Inter-UI-Black.ufo

$(FONTDIR)/const/Inter-UI-BlackItalic.ttf: src/Inter-UI.designspace $(BlackItalic_ufo_d)
	misc/fontbuild compile -o $@ src/Inter-UI-BlackItalic.ufo


$(FONTDIR)/const/Inter-UI-Thin.otf: src/Inter-UI.designspace $(Thin_ufo_d)
	misc/fontbuild2 compile -o $@ src/Inter-UI-Thin.ufo

$(FONTDIR)/const/Inter-UI-ThinItalic.otf: src/Inter-UI.designspace $(ThinItalic_ufo_d)
	misc/fontbuild2 compile -o $@ src/Inter-UI-ThinItalic.ufo

$(FONTDIR)/const/Inter-UI-Regular.otf: src/Inter-UI.designspace $(Regular_ufo_d)
	misc/fontbuild2 compile -o $@ src/Inter-UI-Regular.ufo

$(FONTDIR)/const/Inter-UI-Italic.otf: src/Inter-UI.designspace $(Italic_ufo_d)
	misc/fontbuild2 compile -o $@ src/Inter-UI-Italic.ufo

$(FONTDIR)/const/Inter-UI-Black.otf: src/Inter-UI.designspace $(Black_ufo_d)
	misc/fontbuild2 compile -o $@ src/Inter-UI-Black.ufo

$(FONTDIR)/const/Inter-UI-BlackItalic.otf: src/Inter-UI.designspace $(BlackItalic_ufo_d)
	misc/fontbuild2 compile -o $@ src/Inter-UI-BlackItalic.ufo

# ---------- end workaround for issue #110 -----------


# Instance UFO -> OTF, TTF

$(FONTDIR)/const/Inter-UI-%.otf: build/ufo/Inter-UI-%.ufo
	misc/fontbuild2 compile -o $@ $<

$(FONTDIR)/const/Inter-UI-%.ttf: build/ufo/Inter-UI-%.ufo
	misc/fontbuild compile -o $@ $<


# designspace <- glyphs file
src/Inter-UI-*.designspace: src/Inter-UI.designspace
src/Inter-UI.designspace: src/Inter-UI.glyphs
	misc/fontbuild glyphsync $<

# make sure intermediate files are not gc'd by make
.PRECIOUS: src/Inter-UI-*.designspace

designspace: src/Inter-UI.designspace
.PHONY: designspace

# short-circuit Make for performance
src/Inter-UI.glyphs:
	@true

# instance UFOs <- master UFOs
build/ufo/Inter-UI-%.ufo: src/Inter-UI.designspace $(all_ufo_masters)
	misc/fontbuild instancegen src/Inter-UI.designspace $*

# make sure intermediate UFOs are not gc'd by make
.PRECIOUS: build/ufo/Inter-UI-%.ufo

# Note: The seemingly convoluted dependency graph above is required to
# make sure that glyphsync and instancegen are not run in parallel.


# hinted TTF files via autohint
$(FONTDIR)/const-hinted/%.ttf: $(FONTDIR)/const/%.ttf
	mkdir -p "$(dir $@)"
	ttfautohint --fallback-stem-width=256 --no-info "$<" "$@"

# $(FONTDIR)/var-hinted/%.ttf: $(FONTDIR)/var/%.ttf
# 	mkdir -p "$(dir $@)"
# 	ttfautohint --fallback-stem-width=256 --no-info "$<" "$@"

# make sure intermediate TTFs are not gc'd by make
.PRECIOUS: $(FONTDIR)/const/%.ttf $(FONTDIR)/const-hinted/%.ttf $(FONTDIR)/var/%.var.ttf




# check var
all_check_var: $(FONTDIR)/var/Inter-UI.var.ttf
	misc/fontbuild checkfont $(FONTDIR)/var/*.*

# test runs all tests
# Note: all_check_const is generated by init.sh and runs "fontbuild checkfont"
# on all otf and ttf files.
test: all_check_const  all_check_var
	@echo "test: all ok"

# check does the same thing as test, but without any dependency checks, meaning
# it will check whatever font files are already built.
check:
	misc/fontbuild checkfont $(FONTDIR)/const/*.* $(FONTDIR)/var/*.*
	@echo "check: all ok"

.PHONY: test check




# samples renders PDF and PNG samples
samples: $(FONTDIR)/samples all_samples_pdf all_samples_png

$(FONTDIR)/samples/%.pdf: $(FONTDIR)/const/%.otf
	misc/tools/fontsample/fontsample -o "$@" "$<"

$(FONTDIR)/samples/%.png: $(FONTDIR)/const/%.otf
	misc/tools/fontsample/fontsample -o "$@" "$<"

$(FONTDIR)/samples:
	mkdir -p $@




# load version, used by zip and dist
VERSION := $(shell cat version.txt)

# distribution zip files
ZIP_FILE_DIST := build/release/Inter-UI-${VERSION}.zip
ZIP_FILE_DEV  := build/release/Inter-UI-${VERSION}-$(shell git rev-parse --short=10 HEAD).zip

ZD = build/tmp/zip
# intermediate zip target that creates a zip file at build/tmp/a.zip
build/tmp/a.zip:
	@rm -rf "$(ZD)"
	@rm -f  build/tmp/a.zip
	@mkdir -p \
	  "$(ZD)/Inter UI (web)" \
	  "$(ZD)/Inter UI (web hinted)" \
	  "$(ZD)/Inter UI (TTF)" \
	  "$(ZD)/Inter UI (TTF hinted)" \
	  "$(ZD)/Inter UI (TTF variable)" \
	  "$(ZD)/Inter UI (OTF)"
	@#
	@# copy font files
	cp -a $(FONTDIR)/const/*.woff \
	      $(FONTDIR)/const/*.woff2 \
	      $(FONTDIR)/var/*.woff2        "$(ZD)/Inter UI (web)/"
	cp -a $(FONTDIR)/const-hinted/*.woff \
	      $(FONTDIR)/const-hinted/*.woff2 \
	      													    "$(ZD)/Inter UI (web hinted)/"
	cp -a $(FONTDIR)/const/*.ttf        "$(ZD)/Inter UI (TTF)/"
	cp -a $(FONTDIR)/const-hinted/*.ttf "$(ZD)/Inter UI (TTF hinted)/"
	cp -a $(FONTDIR)/var/*.ttf          "$(ZD)/Inter UI (TTF variable)/"
	cp -a $(FONTDIR)/const/*.otf        "$(ZD)/Inter UI (OTF)/"
	@#
	@# copy misc stuff
	cp -a misc/dist/inter-ui.css        "$(ZD)/Inter UI (web)/"
	cp -a misc/dist/inter-ui.css        "$(ZD)/Inter UI (web hinted)/"
	cp -a misc/dist/*.txt               "$(ZD)/"
	cp -a LICENSE.txt                   "$(ZD)/"
	@#
	@# Add "beta" to Light and Thin filenames.
	@# Requires "rename" tool in PATH (`brew install rename` on macOS)
	rename 's/(Light.*|Thin.*)\./$$1-BETA./' "$(ZD)/Inter UI"*/*.*
	@#
	@# zip
	cd "$(ZD)" && zip -q -X -r "../../../$@" * && cd ../..
	@rm -rf "$(ZD)"

# zip
build/release/Inter-UI-%.zip: build/tmp/a.zip
	@mkdir -p "$(shell dirname "$@")"
	@mv -f "$<" "$@"
	@echo write "$@"
	@sh -c "if [ -f /usr/bin/open ]; then /usr/bin/open --reveal '$@'; fi"

zip: all
	$(MAKE) check
	$(MAKE) ${ZIP_FILE_DEV}

zip_dist: pre_dist all
	$(MAKE) check
	$(MAKE) ${ZIP_FILE_DIST}

.PHONY: zip zip_dist

# distribution
pre_dist:
	@echo "Creating distribution for version ${VERSION}"
	@if [ -f "${ZIP_FILE_DIST}" ]; \
		then echo "${ZIP_FILE_DIST} already exists. Bump version or remove the zip file to continue." >&2; \
		exit 1; \
  fi

dist: zip_dist
	$(MAKE) -j docs
	misc/tools/versionize-css.py
	@echo "——————————————————————————————————————————————————————————————————"
	@echo ""
	@echo "Next steps:"
	@echo ""
	@echo "1) Commit & push changes"
	@echo ""
	@echo "2) Create new release with ${ZIP_FILE_DIST} at"
	@echo "   https://github.com/rsms/inter/releases/new?tag=v${VERSION}"
	@echo ""
	@echo "3) Bump version in version.txt (to the next future version)"
	@echo ""
	@echo "——————————————————————————————————————————————————————————————————"

docs: docs_fonts
	$(MAKE) -j docs_info

docs_info: docs/_data/fontinfo.json docs/lab/glyphinfo.json docs/glyphs/metrics.json

docs_fonts:
	rm -rf docs/font-files
	mkdir docs/font-files
	cp -a $(FONTDIR)/const/*.woff \
	      $(FONTDIR)/const/*.woff2 \
	      $(FONTDIR)/const/*.otf \
	      $(FONTDIR)/var/*.* \
	      docs/font-files/

.PHONY: docs docs_info docs_fonts

docs/_data/fontinfo.json: docs/font-files/Inter-UI-Regular.otf misc/tools/fontinfo.py
	misc/tools/fontinfo.py -pretty $< > docs/_data/fontinfo.json

docs/lab/glyphinfo.json: build/UnicodeData.txt misc/tools/gen-glyphinfo.py $(all_ufo_masters)
	misc/tools/gen-glyphinfo.py -ucd $< src/Inter-UI-*.ufo > $@

docs/glyphs/metrics.json: $(Regular_ufo_d) misc/tools/gen-metrics-and-svgs.py
	misc/tools/gen-metrics-and-svgs.py src/Inter-UI-Regular.ufo

# Download latest Unicode data
build/UnicodeData.txt:
	@echo fetch http://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt
	@curl '-#' -o "$@" http://www.unicode.org/Public/UCD/latest/ucd/UnicodeData.txt


# install targets
install_ttf: all_ttf_const
	$(MAKE) all_web -j
	@echo "Installing TTF files locally at ~/Library/Fonts/Inter UI"
	rm -rf ~/'Library/Fonts/Inter UI'
	mkdir -p ~/'Library/Fonts/Inter UI'
	cp -va $(FONTDIR)/const/*.ttf ~/'Library/Fonts/Inter UI'

install_ttf_hinted: all_ttf
	$(MAKE) all_web -j
	@echo "Installing autohinted TTF files locally at ~/Library/Fonts/Inter UI"
	rm -rf ~/'Library/Fonts/Inter UI'
	mkdir -p ~/'Library/Fonts/Inter UI'
	cp -va $(FONTDIR)/const-hinted/*.ttf ~/'Library/Fonts/Inter UI'

install_otf: all_otf
	$(MAKE) all_web -j
	@echo "Installing OTF files locally at ~/Library/Fonts/Inter UI"
	rm -rf ~/'Library/Fonts/Inter UI'
	mkdir -p ~/'Library/Fonts/Inter UI'
	cp -va $(FONTDIR)/const/*.otf ~/'Library/Fonts/Inter UI'

install: install_otf

# clean removes generated and built fonts in the build directory
clean:
	rm -rvf build/tmp build/fonts

.PHONY: all web clean install install_otf install_ttf deploy pre_dist dist geninfo glyphsync
