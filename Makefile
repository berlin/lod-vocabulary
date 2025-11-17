
generate: data/temp/all.nt
	python bin/generate.py

generate+serve_locally: data/temp/all.nt
	python bin/generate.py --site_url http://localhost:8000 --serve

data/berorgs/stats.ttl: data/berorgs/berorgs.ttl
	@echo "generating VOID statistics for Berorgs vocab from $^..."
	@echo "writing to $@ ..."
	@python bin/void_statistics.py \
		--input $^ \
		--base_uri "https://berlin.github.io/lod-vocabulary/berorgs/" \
		--base_prefix "berorgs" \
		--dataset_uri "https://berlin.github.io/lod-vocabulary/berorgs/" > $@

data/lorunits/stats.ttl: data/lorunits/units.ttl
	@echo "generating VOID statistics for LOR Units vocab from $^..."
	@echo "writing to $@ ..."
	@python bin/void_statistics.py \
		--input $^ \
		--base_uri "https://berlin.github.io/lod-vocabulary/lorunits/" \
		--base_prefix "lorunits" \
		--dataset_uri "https://berlin.github.io/lod-vocabulary/lorunits/" > $@

# This target creates the RDF file that serves as the input to the static site generator.
# All data should be merged in this file. This should include at least the VOID dataset
# description and the actual data.
# The target works by merging all prerequisites.
data/temp/all.nt: data/temp void.ttl data/berorgs/berorgs.ttl data/berorgs/stats.ttl data/lorunits/units.ttl data/lorunits/stats.ttl
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


