
generate: data/temp/all.nt
	python bin/generate.py

generate+serve_locally: data/temp/all.nt
	python bin/generate.py --site_url http://localhost:8000 --serve

void.ttl: data/static/void.ttl data/temp/stats_berorgs.nt
	@echo "generating public VOID file at $@ by combining: $^"
	@rdfpipe -o turtle $^ > $@

data/temp/stats_berorgs.nt: data/temp
	@echo "generating VOID statistics for Berorgs vocab ..."
	@echo "writing to $@ ..."
	@python bin/void_statistics.py \
		--input "data/static/berorgs.ttl" \
		--base_uri "https://berlin.github.io/lod-vocabulary/berorgs/" \
		--dataset_uri "https://berlin.github.io/lod-vocabulary/berorgs/" > $@

# This target creates the RDF file that serves as the input to the static site generator.
# All data should be merged in this file. This should include at least the VOID dataset
# description and the actual data.
# The target works by merging all prerequisites.
data/temp/all.nt: data/temp void.ttl data/static/berorgs.ttl
	@echo "combining $(filter-out $<,$^) to $@ ..."
	@rdfpipe -o ntriples $(filter-out $<,$^) > $@

install_templates:
	python bin/install_templates.py

clean: clean-temp

clean-temp:
	@echo "deleting temp folder ..."
	@rm -rf data/temp

data/temp:
	@echo "creating temp directory ..."
	@mkdir -p $@


