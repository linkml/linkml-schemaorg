

tmp/schemaorg-current-https.ttl:
	mkdir -p tmp && \
	curl -L -s https://schema.org/version/latest/schemaorg-current-https.ttl > $@.tmp && mv $@.tmp $@
.PRECIOUS: tmp/schemaorg-current-https.ttl

tmp/schemaorg.yaml: tmp/schemaorg-current-https.ttl
	$(RUN) schemauto import-rdfs --metamodel-mappings conf/mappings.yaml $< > $@.tmp && mv $@.tmp $@
