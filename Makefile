EMCC=emcc
CC=gcc
CFLAGS=-O2 -flto
LEX=flex
YACC=bison
LFLAGS=-Ce
YFLAGS=-Wcounterexamples

BASE_DIR=backend
BUILD_DIR=$(BASE_DIR)/build
EXTENSION_DIR=unpacked
ORIG_SCANNER_V2=$(BASE_DIR)/scanners/python2_template.l   # 2.7.2 scanner
ORIG_SCANNER_V3=$(BASE_DIR)/scanners/python3_template.l   # 3.3.0 scanner
VERSIONS=2.0  2.2  2.3  2.4.3  2.4  2.5  2.6  2.7.2  2.7  3.0  3.1  3.2  3.3  3.5  3.6  3.7  3.8
MOST_RECENT=3.8
PARSERS=$(VERSIONS:%=$(BUILD_DIR)/%.tab.c)
SCANNERS=$(VERSIONS:%=$(BUILD_DIR)/%.lex.c)
TARGET=pyverchecker

.PHONY: all clean
.SILENT:

all: cli extension

cli: $(BUILD_DIR)/$(TARGET)

extension: $(EXTENSION_DIR)/scripts/$(TARGET).js $(EXTENSION_DIR)/scripts/tokens.js

$(EXTENSION_DIR)/scripts/tokens.js: $(BUILD_DIR)/$(MOST_RECENT).l
	echo "[GEN] $@"
	echo "const tokens = {" > $@
	sed -ne 's/^"\(.\+\)"\s\+{.*return\s\+PY[0-9]\+_\([A-Z_]\+\).*/"\2" : "`\1`",/p' $< >> $@
	echo "}" >> $@

$(EXTENSION_DIR)/scripts/$(TARGET).js: $(BUILD_DIR)/$(TARGET).js
	echo "[GEN] $@"
	sed -e "s/.$(TARGET)\.wasm./chrome.runtime.getURL('scripts\/$(TARGET).wasm\')/" $< > $@
	cp $(BUILD_DIR)/$(TARGET).wasm $(EXTENSION_DIR)/scripts/$(TARGET).wasm

$(BUILD_DIR)/pre.js:
	echo "[GEN] $@"
	echo "function check_compliance(e){var c=Module.lengthBytesUTF8(e)+1,n=Module._malloc(c);Module.stringToUTF8(e,n,c);var r=Module._check_compliance_wasm(n),o=Module.UTF8ToString(r);return Module._free(n),Module._free(r),o}" > $@

$(BUILD_DIR)/$(TARGET).js: $(BUILD_DIR)/pre.js $(BUILD_DIR)/main.c $(BASE_DIR)/scanner.c $(BUILD_DIR)/versions.h $(SCANNERS) $(PARSERS)
	echo "[EMCC] $@"
	$(EMCC) $(CFLAGS) -I $(BASE_DIR) -I $(BUILD_DIR) -o $@ $(filter %.c, $^) -DWASM -sEXPORTED_FUNCTIONS=_check_compliance_wasm,_malloc,_free -sMALLOC=emmalloc --extern-pre-js=$< -sEXPORTED_RUNTIME_METHODS=stringToUTF8,UTF8ToString,lengthBytesUTF8 -sDYNAMIC_EXECUTION=0

$(BUILD_DIR)/$(TARGET): $(BUILD_DIR)/main.c $(BASE_DIR)/scanner.c $(BUILD_DIR)/versions.h $(SCANNERS) $(PARSERS)
	echo "[CC] $@"
	$(CC) $(CFLAGS) -I $(BASE_DIR) -I $(BUILD_DIR) -o $@ $(filter %.c, $^)

$(BUILD_DIR)/main.c: $(BASE_DIR)/pyverchecker.c $(BUILD_DIR)/versions.h
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e '/^const int NUM_VERSIONS/cconst int NUM_VERSIONS=$(words $(VERSIONS));' $< > $@;
	sed -i '/^#include "scanner.h"/a#include "versions.h"' $@
	$(eval CHECKVER=$(shell echo $(VERSIONS) | tr -d "."))
	for version in $(CHECKVER) ; do  \
		sed -i "/^  \/\/>>> Insert CHECK_VERSION(XX)/a\ \ CHECK_VERSION($$version)" $@; \
	done

$(BUILD_DIR)/versions.h: $(SCANNERS) $(PARSERS)
	echo "[GEN] $@"
	echo $(patsubst %.c,%.h,$^) | tr " " "\n" | sed -e "s|$(dir $@)\(.*\)|#include \"\1\"|" > $@
	echo $(VERSIONS) | tr " " "\n" | tr -d "." | sed -e 's/\(.*\)/extern int py\1_next_token(void*);/' >> $@

$(BUILD_DIR)/%.tab.c: $(BASE_DIR)/parsers/%.y
	echo "[YACC] $@"
	mkdir -p $(dir $@)
	bison -o $@ --defines=$(patsubst %.c,%.h,$@) $(YFLAGS)  $<


$(BUILD_DIR)/%.lex.c: $(BUILD_DIR)/%.l
	echo "[LEX] $@"
	mkdir -p $(dir $@)
	flex -o $@ --header-file=$(patsubst %.c,%.h,$@) $(LFLAGS) $<

##### MANIPULATE THE SCANNERS AND GENERATE ALL THE VARIANTS #####

# 2.7.2 same as the v2 scanner:
$(BUILD_DIR)/2.7.2.l: $(ORIG_SCANNER_V2) 
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	cp $< $@

# 2.5 and after are just the same as the 2.7.2:
$(BUILD_DIR)/2.5.l: $(BUILD_DIR)/2.7.2.l
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e 's/\(py\|PY\)272/\125/g' $< | sed -e 's/2.7.2.tab.h/2.5.tab.h/' > $@
$(BUILD_DIR)/2.6.l: $(BUILD_DIR)/2.7.2.l
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e 's/\(py\|PY\)272/\126/g' $< | sed -e 's/2.7.2.tab.h/2.6.tab.h/' > $@
$(BUILD_DIR)/2.7.l: $(BUILD_DIR)/2.7.2.l
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e 's/\(py\|PY\)272/\127/g' $< | sed -e 's/2.7.2.tab.h/2.7.tab.h/' > $@

# 2.4, 2.4.3 missing as, with
$(BUILD_DIR)/2.4.l: $(ORIG_SCANNER_V2)
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	egrep -v '^"(as|with)"' $< | sed -e 's/\(py\|PY\)272/\124/g' | sed -e 's/2.7.2.tab.h/2.4.tab.h/' > $@
$(BUILD_DIR)/2.4.3.l: $(ORIG_SCANNER_V2)
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	egrep -v '^"(as|with)"' $< | sed -e 's/\(py\|PY\)272/\1243/g' | sed -e 's/2.7.2.tab.h/2.4.3.tab.h/' > $@

# 2.2, 2.3 also missing @
$(BUILD_DIR)/2.2.l: $(BUILD_DIR)/2.4.l
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	egrep -v '^"@"' $< | sed -e 's/\(py\|PY\)24/\122/g' | sed -e 's/2.4.tab.h/2.2.tab.h/' > $@
$(BUILD_DIR)/2.3.l: $(BUILD_DIR)/2.4.l
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	egrep -v '^"@"' $< | sed -e 's/\(py\|PY\)24/\123/g' | sed -e 's/2.4.tab.h/2.3.tab.h/' > $@

# 2.0 also missing yield, //, //=
$(BUILD_DIR)/2.0.l: $(BUILD_DIR)/2.2.l
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	egrep -v '^"(yield|//|//=)"' $< | sed -e 's/\(py\|PY\)22/\120/g' | sed -e 's/2.2.tab.h/2.0.tab.h/' > $@

# 3.1 and 3.2 mustn't allow u as unicode literal prefix:
$(BUILD_DIR)/3.1.l: $(ORIG_SCANNER_V3)
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e '/^stringprefix/cstringprefix  {rbprefix}' $< | sed -e 's/\(py\|PY\)33/\131/' | sed -e 's/3.3.tab.h/3.1.tab.h/' > $@
$(BUILD_DIR)/3.2.l: $(ORIG_SCANNER_V3)
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e '/^stringprefix/cstringprefix  {rbprefix}' $< | sed -e 's/\(py\|PY\)33/\132/' | sed -e 's/3.3.tab.h/3.2.tab.h/' > $@

# 3.0 is same as 3.1/3.2 except for <>:
$(BUILD_DIR)/3.0.l: $(BUILD_DIR)/3.1.l
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	egrep -v '^"(<>)"'  $< | sed -e 's/\(py\|PY\)31/\130/' | sed -e 's/3.1.tab.h/3.0.tab.h/' > $@

# 3.3 is the same as the v3 scanner:
$(BUILD_DIR)/3.3.l: $(ORIG_SCANNER_V3)
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	cp $< $@

# 3.5 and after add: @=, async, await
$(BUILD_DIR)/3.5.l: $(ORIG_SCANNER_V3)
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e '/^{name}/i"@="       { return PY35_ATEQ; }\n"await"    { return PY35_AWAIT; }\n"async"    { return PY35_ASYNC; }' $< | sed -e 's/\(py\|PY\)33/\135/' | sed -e 's/3.3.tab.h/3.5.tab.h/' > $@

# 3.6.0 allows 'f' as string prefix
$(BUILD_DIR)/3.6.l: $(BUILD_DIR)/3.5.l
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e '/^ruprefix/cruprefix      [rRuUfF]|[rRfF][rRfF]' $< | sed -e 's/\(py\|PY\)35/\136/' | sed -e 's/3.5.tab.h/3.6.tab.h/' > $@

# 3.7.0 has no new keywords features
$(BUILD_DIR)/3.7.l: $(BUILD_DIR)/3.6.l
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e 's/\(py\|PY\)36/\137/' $< | sed -e 's/3.6.tab.h/3.7.tab.h/' > $@

# 3.8.0 adds :=
$(BUILD_DIR)/3.8.l: $(BUILD_DIR)/3.7.l
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e '/^"<>"/i":="       { return PY38_WALRUS; }' $< | sed -e 's/\(py\|PY\)37/\138/' | sed -e 's/3.7.tab.h/3.8.tab.h/' > $@


clean:
	echo "[RM] $(BUILD_DIR)"
	$(RM) -fd $(BUILD_DIR)/*.l
	$(RM) -fd $(BUILD_DIR)/*.c
	$(RM) -fd $(BUILD_DIR)/*.h
	$(RM) -fd $(BUILD_DIR)/$(TARGET)
	$(RM) -fd $(BUILD_DIR)/$(TARGET).js
	$(RM) -fd $(BUILD_DIR)/$(TARGET).wasm
	$(RM) -fd $(BUILD_DIR)/pre.js
	echo "[RM] $(EXTENSION_DIR)/scripts/$(TARGET).{js,wasm}"
	$(RM) -fd $(EXTENSION_DIR)/scripts/$(TARGET).js
	$(RM) -fd $(EXTENSION_DIR)/scripts/$(TARGET).wasm
	echo "[RM] $(EXTENSION_DIR)/scripts/tokens.js"
	$(RM) -fd $(EXTENSION_DIR)/scripts/tokens.js
	$(RM) -fd $(BUILD_DIR)

