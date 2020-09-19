SHELL := /bin/bash
BUILD = build
MAKEFILE = Makefile
OUTPUT_FILENAME = book
METADATA = metadata.yml
CHAPTERS = chapters/*.md
TOC = --toc --toc-depth=2
IMAGES_FOLDER = images
IMAGES = $(IMAGES_FOLDER)/*
COVER_IMAGE = $(IMAGES_FOLDER)/cover.jpg
MATH_FORMULAS = --webtex
CSS_FILE = style.css
CSS_ARG = --css=$(CSS_FILE)
METADATA_ARG = --metadata-file=$(METADATA)
ARGS = $(TOC) $(MATH_FORMULAS) $(CSS_ARG) $(METADATA_ARG)

all: book

book: epub html mobi pdf

clean:
	rm -r $(BUILD)

epub: $(BUILD)/epub/$(OUTPUT_FILENAME).epub

mobi: $(BUILD)/mobi/$(OUTPUT_FILENAME).mobi

html: $(BUILD)/html/$(OUTPUT_FILENAME).html

pdf: $(BUILD)/pdf/$(OUTPUT_FILENAME).pdf


$(BUILD)/epub/$(OUTPUT_FILENAME).epub: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(IMAGES) \
	$(COVER_IMAGE)
	mkdir -p $(BUILD)/epub
	pandoc $(ARGS) --epub-cover-image=$(COVER_IMAGE) -o $@ $(CHAPTERS)

$(BUILD)/mobi/$(OUTPUT_FILENAME).mobi: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(IMAGES) \
	$(COVER_IMAGE)
	mkdir -p $(BUILD)/mobi
	kindlegen build/epub/book.epub -c2 -verbose
	mv build/epub/book.mobi build/mobi

$(BUILD)/html/$(OUTPUT_FILENAME).html: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(IMAGES)
	rm -rf $(BUILD)/html
	mkdir -p $(BUILD)/html
	pandoc $(ARGS) --standalone --to=html5 -o $@ $(CHAPTERS)
	cp -R $(IMAGES_FOLDER)/ $(BUILD)/html/$(IMAGES_FOLDER)/
	cp $(CSS_FILE) $(BUILD)/html/$(CSS_FILE)

$(BUILD)/pdf/$(OUTPUT_FILENAME).pdf: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(IMAGES)
	./make_pdfs	


