import argparse
import logging
from rdflib import Graph, URIRef, BNode, Literal
from rdflib.namespace import VOID

LOG = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


parser = argparse.ArgumentParser(
    description="Generate statistics on number of instances of classes in a dataset. Output as RDF to STDOUT.")
parser.add_argument('--input',
                    help="Path to input RDF file.",
                    required=True
                    )
parser.add_argument('--base_uri',
                    help="Base URI of resources to include.",
                    required=True
                    )
parser.add_argument('--base_prefix',
                    help="Prefix to use for the base_uri",
                    required=True
                    )
parser.add_argument('--dataset_uri',
                    help="URI of the VOID dataset resource to which the statistics will be attached.",
                    required=True
                    )
args = parser.parse_args()

graph = Graph()
stats_graph = Graph()
stats_graph.bind(args.base_prefix, args.base_uri)
dataset_res = URIRef(args.dataset_uri)
LOG.info(f" loading dataset from {args.input}")
graph.parse(args.input)
LOG.info(" done")

stat_query = f'''
SELECT DISTINCT ?type (COUNT(?resource) as ?resource_count)
WHERE {{
    ?resource a ?type .
    FILTER(STRSTARTS(STR(?resource), "{args.base_uri}"))
}}
GROUP BY ?type
ORDER BY ?type
'''

LOG.info(" querying dataset")
results = graph.query(stat_query)
LOG.info(" done")

for result in results:
    partition_res = BNode()
    stats_graph.add( (dataset_res, VOID.classPartition, partition_res) )
    stats_graph.add( (partition_res, VOID['class'], URIRef(result.type)) )
    stats_graph.add( (partition_res, VOID.entities, Literal(result.resource_count)) )

print(stats_graph.serialize(format="turtle"))