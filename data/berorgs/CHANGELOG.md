# Changelog for BerOrgs Vocabulary

## Development

## [0.1.0](https://github.com/berlin/lod-vocabulary/blob/berorgs_0.1.0/data/berorgs/berorgs.ttl)

_(2025-11-13)_

- Roles are no longer `a owl:Class`, but `a org:Role`.
- The relationship between specific roles and institutions cannot be expressed like `berorgs:SenatorIn org:headOf berorgs:senatsverwaltung`. These statements have been removed. The indented meaning (certain roles have meaning for specific institutions) can probably expressed with SHACL.
- Add more org types and roles.
- Remove empty labels.
- Add more English labels.
- Introduce vocabulary version.
  
## [0.0.1](https://github.com/berlin/lod-vocabulary/blob/berorgs_0.0.1/data/static/berorgs.ttl)

_(2023-09-25)_

- Initial release