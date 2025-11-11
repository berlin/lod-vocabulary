import logging
from posixpath import dirname

from berlinonline.jinjardf.theme import Theme

logging.basicConfig(level=logging.DEBUG)

theme_names = [
    'berlin.lod.basetheme',
    'berlin.lod.vocabtheme'
]

for theme_name in theme_names:
    theme = Theme(theme_name)
    theme.copy_templates(target_folder='templates')
    theme.copy_assets(target_folder='assets')
    theme.copy_config(target_folder='config')
