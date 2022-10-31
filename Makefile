LEX=flex
YACC=bison
LFLAGS=
YFLAGS=

BUILD_DIR=build
ORIG_SCANNER_V2=scanners/orig-scan-v2.l   # 2.7.2 scanner
ORIG_SCANNER_V3=scanners/orig-scan-v3.l   # 3.3.0 scanner
VERSIONS=2.0  2.2  2.3  2.4.3  2.4  2.5  2.6  2.7.2  2.7  3.0  3.1  3.2  3.3  3.5  3.6
PARSERS=$(VERSIONS:%=$(BUILD_DIR)/%.tab.c)
SCANNERS=$(VERSIONS:%=$(BUILD_DIR)/%.lex.c)

.PHONY: all clean

all: $(SCANNERS) $(PARSERS)

$(BUILD_DIR)/%.tab.c: parsers/%.y
	@echo "[YACC] $@"
	@mkdir -p $(dir $@)
	@bison -o $@ -d $(LFLAGS)  $<

$(BUILD_DIR)/%.lex.c: $(BUILD_DIR)/%.l
	@echo "[LEX] $@"
	@mkdir -p $(dir $@)
	@flex -o $@ $(YFLAGS) $<

##### MANIPULATE THE SCANNERS AND GENERATE ALL THE VARIANTS #####

# 2.7.2 same as the v2 scanner:
$(BUILD_DIR)/2.7.2.l: $(ORIG_SCANNER_V2)
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@cp $< $@

# 2.5 and after are just the same as the 2.7.2:
$(BUILD_DIR)/2.5.l: $(BUILD_DIR)/2.7.2.l
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@sed -e 's/py272/py25/' $< | sed -e 's/2.7.2.tab.h/2.5.tab.h/' > $@ 
$(BUILD_DIR)/2.6.l: $(BUILD_DIR)/2.7.2.l
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@sed -e 's/py272/py26/' $< | sed -e 's/2.7.2.tab.h/2.6.tab.h/' > $@ 
$(BUILD_DIR)/2.7.l: $(BUILD_DIR)/2.7.2.l
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@sed -e 's/py272/py27/' $< | sed -e 's/2.7.2.tab.h/2.7.tab.h/' > $@ 

# 2.4, 2.4.3 missing as, with
$(BUILD_DIR)/2.4.l: $(ORIG_SCANNER_V2)
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@egrep -v '^"(as|with)"' $< | sed -e 's/py272/py24/' | sed -e 's/2.7.2.tab.h/2.4.tab.h/' > $@ 
$(BUILD_DIR)/2.4.3.l: $(ORIG_SCANNER_V2)
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@egrep -v '^"(as|with)"' $< | sed -e 's/py272/py243/' | sed -e 's/2.7.2.tab.h/2.4.3.tab.h/' > $@ 

# 2.2, 2.3 also missing @
$(BUILD_DIR)/2.2.l: $(BUILD_DIR)/2.4.l
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@egrep -v '^"@"' $< | sed -e 's/py24/py22/' | sed -e 's/2.4.tab.h/2.2.tab.h/' > $@ 
$(BUILD_DIR)/2.3.l: $(BUILD_DIR)/2.4.l
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@egrep -v '^"@"' $< | sed -e 's/py24/py22/' | sed -e 's/2.4.tab.h/2.3.tab.h/' > $@ 

# 2.0 also missing yield, //, //= 
$(BUILD_DIR)/2.0.l: $(BUILD_DIR)/2.2.l
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@egrep -v '^"(yield|//|//=)"' $< | sed -e 's/py22/py20/' | sed -e 's/2.2.tab.h/2.0.tab.h/' > $@ 

# 3.1 and 3.2 mustn't allow u as unicode literal prefix:
$(BUILD_DIR)/3.1.l: $(ORIG_SCANNER_V3)
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@sed -e '/^stringprefix/cstringprefix  {rbprefix}' $< | sed -e 's/py33/py31/' | sed -e 's/3.3.tab.h/3.1.tab.h/' > $@ 
$(BUILD_DIR)/3.2.l: $(ORIG_SCANNER_V3)
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@sed -e '/^stringprefix/cstringprefix  {rbprefix}' $< | sed -e 's/py33/py32/' | sed -e 's/3.3.tab.h/3.2.tab.h/' > $@ 

# 3.0 is same as 3.1/3.2 except for <>:
$(BUILD_DIR)/3.0.l: $(BUILD_DIR)/3.1.l
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@egrep -v '^"(<>)"'  $< | sed -e 's/py31/py30/' | sed -e 's/3.1.tab.h/3.0.tab.h/' > $@ 

# 3.3 is the same as the v3 scanner:
$(BUILD_DIR)/3.3.l: $(ORIG_SCANNER_V3)
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@cp $< $@

# 3.5 and after add: @=, async, await
$(BUILD_DIR)/3.5.l: $(ORIG_SCANNER_V3)
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@sed -e '/^{name}/i"@="       { return ATEQ; } "await"    { return AWAIT; } "async"    { return ASYNC; }' $< | sed -e 's/py33/py35/' | sed -e 's/3.3.tab.h/3.5.tab.h/' > $@ 

# 3.6.0 allows 'f' as string prefix
$(BUILD_DIR)/3.6.l: $(BUILD_DIR)/3.5.l
	@echo "[GEN] $@"
	@mkdir -p $(dir $@)
	@sed -e '/^ruprefix/cruprefix      [rRuUfF]|[rRfF][rRfF]' $< | sed -e 's/py35/py36/' | sed -e 's/3.5.tab.h/3.6.tab.h/' > $@ 

clean:
	@echo [RM] $(BUILD_DIR)
	@$(RM) -fd $(BUILD_DIR)/*.l
	@$(RM) -fd $(BUILD_DIR)/*.c
	@$(RM) -fd $(BUILD_DIR)/*.h
	@$(RM) -fd $(BUILD_DIR)


