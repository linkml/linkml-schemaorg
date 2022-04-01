## CHANGE THIS
SCHEMA_NAME = schemaorg

RUN = poetry run
SRC = src
SCHEMA_DIR = $(SRC)/linkml
SCHEMA_ROOT = $(SCHEMA_DIR)/$(SCHEMA_NAME).yaml
DEST = project
PYMODEL = $(SRC)/$(SCHEMA_NAME)/datamodel
DOCDIR = docs

# basename of a YAML file in model/
.PHONY: all clean

help:
	@echo "make all -- makes site locally"
	@echo "make deploy -- deploys site"
	@echo "make help -- this"
	@echo ""
all: gen-project gendoc
%.yaml: gen-project
deploy: all mkd-gh-deploy

# generates all project files
gen-project: $(PYMODEL)
	$(RUN) gen-project -d $(DEST) $(SCHEMA_ROOT) && mv $(DEST)/*.py $(PYMODEL)

test: 
	$(RUN) gen-project -d tmp $(SCHEMA_ROOT) 

upgrade:
	poetry add -D linkml@latest

# Test documentation locally
serve: mkd-serve

# Python datamodel
$(PYMODEL):
	mkdir -p $@


$(DOCDIR):
	mkdir -p $@

gendoc: $(DOCDIR)
	cp $(SRC)/docs/*md $(DOCDIR) ; \
	$(RUN) gen-doc -d $(DOCDIR) $(SCHEMA_ROOT)

MKDOCS = $(RUN) mkdocs
mkd-%:
	$(MKDOCS) $*

PROJECT_FOLDERS = sqlschema shex shacl protobuf prefixmap owl jsonschema jsonld graphql excel
git-add:
	git add .gitignore Makefile LICENSE README.md mkdocs.yml poetry.lock project.Makefile pyproject.toml src/linkml/*yaml src/*/datamodel/*py
	git add $(patsubst %, project/%, $(PROJECT_FOLDERS))


clean:
	rm -rf $(DEST)
	rm -rf tmp

include project.Makefile

