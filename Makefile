TEX_DIR=tex
BIB_DIR=bib
OUT_DIR=out
PDF_DIR=pdf

TARGET=report

define run_pdflatex
	@2>&1 pdflatex -shell-escape --output-directory=$(OUT_DIR) $<; \
    if [ $$? -ne 0 ]; then 2>&1 echo "pdflatex failed"; exit 1; fi
endef

define run_bibtex
	@mkdir -p $(OUT_DIR)/tex
	@cp $(BIB_DIR)/$(TARGET).bib $(OUT_DIR)/tex
	@cd $(OUT_DIR);
    @(cd $(OUT_DIR); \
      2>&1 bibtex $(TARGET) > bibtex.log; \
      if [ $$? -ne 0 ]; then 2>&1 echo "bibtex failed"; exit 1; fi)
    @rm -r $(OUT_DIR)/tex
endef

$(TARGET).pdf: $(TEX_DIR)/$(TARGET).tex
	@echo "building report..."
	$(call run_pdflatex)
	@echo "building bibliography..."
	$(call run_bibtex)
	@echo "correcting references..."
	$(call run_pdflatex)
	$(call run_pdflatex)
	@mv $(OUT_DIR)/$@ $(PDF_DIR)/$@

.PHONY: clean

clean:
	rm -rf $(OUT_DIR)/* $(PDF_DIR)/*
