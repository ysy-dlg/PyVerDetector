CC=gcc
CFLAGS=-O0
LEX=flex
YACC=bison
LFLAGS=
YFLAGS=

BASE_DIR=backend
BUILD_DIR=$(BASE_DIR)/build
ORIG_SCANNER_V2=$(BASE_DIR)/scanners/python2_template.l   # 2.7.2 scanner
ORIG_SCANNER_V3=$(BASE_DIR)/scanners/python3_template.l   # 3.3.0 scanner
VERSIONS=2.0  2.2  2.3  2.4.3  2.4  2.5  2.6  2.7.2  2.7  3.0  3.1  3.2  3.3  3.5  3.6
PARSERS=$(VERSIONS:%=$(BUILD_DIR)/%.tab.c)
SCANNERS=$(VERSIONS:%=$(BUILD_DIR)/%.lex.c)
TARGET=pycomply

.PHONY: all clean
.SILENT:

all: $(BUILD_DIR)/$(TARGET)

$(BUILD_DIR)/$(TARGET): $(BUILD_DIR)/main.c $(BASE_DIR)/scanner.c $(BUILD_DIR)/versions.h $(SCANNERS) $(PARSERS)
	echo "[CC] $@"
	$(CC) $(CFLAGS) -I $(BASE_DIR) -I $(BUILD_DIR) -o $@ $(filter %.c, $^)

$(BUILD_DIR)/main.c: $(BASE_DIR)/pycomply.c $(BUILD_DIR)/versions.h
	echo "[GEN] $@"
	mkdir -p $(dir $@)
	sed -e '/^const int NUM_VERSIONS/cconst int NUM_VERSIONS=$(words $(VERSIONS));' $< > $@;
	$(eval CHECKVER=$(shell echo $(VERSIONS) | tr -d "."))
	for version in $(CHECKVER) ; do  \
		sed -i "/^  CHECK_VERSION(0)/i\ \ CHECK_VERSION($$version)" $@; \
	done
	sed -i '/^  CHECK_VERSION(0)/d' $@

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

clean:
	echo [RM] $(BUILD_DIR)
	$(RM) -fd $(BUILD_DIR)/*.l
	$(RM) -fd $(BUILD_DIR)/*.c
	$(RM) -fd $(BUILD_DIR)/*.h
	$(RM) -fd $(BUILD_DIR)/$(TARGET)
	$(RM) -fd $(BUILD_DIR)

