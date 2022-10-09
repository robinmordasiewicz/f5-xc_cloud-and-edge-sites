import os
import sys
import time
import re
import pkgutil
import string
import f5_sphinx_theme

CURDIR = os.path.abspath(os.path.dirname(__file__))
# -*- coding: utf-8 -*-
#
#
# BEGIN CONFIG
# ------------
#
# REQUIRED: Your class/lab name
classname = "F5 Distributed Cloud"

# OPTIONAL: The URL to the GitHub Repository for this class
github_repo = "https://github.com/f5devcentral/f5-agility-labs-xc"

show_source = False
html_show_sourcelink = False
html_copy_source = False
html_permalinks = False
html_show_sphinx = False
hoverxref_auto_ref = True
autosectionlabel_prefix_document = True
copybutton_prompt_text = "$ "
copybutton_only_copy_prompt_lines = True
copybutton_remove_prompts = True
extlinks_detect_hardcoded_links = True
sphinx_tabs_disable_css_loading = False
nitpicky = True

hoverxref_roles = [
    'numref',
    'confval',
    'setting',
    'term',
]


#
# END CONFIG
# ----------

sys.path.insert(0, os.path.abspath("."))

year = time.strftime("%Y")
eventname = "Agility %s Hands-on Lab Guide" % (year)

rst_prolog = """
.. |classname| replace:: %s
.. |classbold| replace:: **%s**
.. |classitalic| replace:: *%s*
.. |ltm| replace:: Local Traffic Manager
.. |adc| replace:: Application Delivery Controller
.. |gtm| replace:: Global Traffic Manager
.. |dns| replace:: DNS
.. |asm| replace:: Application Security Manager
.. |afm| replace:: Advanced Firewall Manager
.. |apm| replace:: Access Policy Manager
.. |pem| replace:: Policy Enforcement Manager
.. |ipi| replace:: IP Intelligence
.. |iwf| replace:: iWorkflow
.. |biq| replace:: BIG-IQ
.. |bip| replace:: BIG-IP
.. |aiq| replace:: APP-IQ
.. |ve|  replace:: Virtual Edition
.. |icr| replace:: iControl REST API
.. |ics| replace:: iControl SOAP API
.. |f5|  replace:: F5 Networks
.. |f5i| replace:: F5 Networks, Inc.
.. |year| replace:: %s
.. |github_repo| replace:: %s
""" % (
    classname,
    classname,
    classname,
    year,
    github_repo,
)

if "github_repo" in locals() and len(github_repo) > 0:
    rst_prolog += """
.. |repoinfo| replace:: The content contained here leverages a full DevOps CI/CD
              pipeline and is sourced from the GitHub repository at %s.
              Bugs and Requests for enhancements can be made by
              opening an Issue within the repository.
""" % (
        github_repo
    )
else:
    rst_prolog += ".. |repoinfo| replace:: \\n"

# rst_epilog = open(os.path.join(CURDIR, 'epilog.inc'),'r').read().decode('utf8')
#rst_epilog = open('epilog.inc', 'r').read()
rst_epilog = open(os.path.join(CURDIR, 'epilog.inc'),'r').read()

# -- General configuration ------------------------------------------------

# If your documentation needs a minimal Sphinx version, state it here.
#
# needs_sphinx = '1.0'

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.

extensions = [
    "sphinx.ext.todo",
    "sphinx.ext.extlinks",
    "sphinx.ext.graphviz",
    "sphinxcontrib.nwdiag",
    "sphinx_copybutton",
    "sphinxcontrib.blockdiag",
    "sphinxcontrib.youtube",
    "sphinxcontrib.details.directive",
    "hoverxref.extension",
    "sphinx_toolbox.collapse",
    "sphinx_toolbox.code",
    "sphinx.ext.autosectionlabel",
    "sphinx_tabs.tabs",
    "sphinx_design"
]

graphviz_output_format = "svg"
graphviz_font = "DejaVu Sans:style=Book"
graphviz_dot_args = [
    "-Gfontname='%s'" % graphviz_font,
    "-Nfontname='%s'" % graphviz_font,
    "-Efontname='%s'" % graphviz_font,
]

diag_fontpath = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
diag_html_image_format = "SVG"
diag_latex_image_format = "PNG"
diag_antialias = False

blockdiag_fontpath = nwdiag_fontpath = diag_fontpath
blockdiag_html_image_format = nwdiag_html_image_format = diag_html_image_format
blockdiag_latex_image_format = nwdiag_latex_image_format = diag_latex_image_format
blockdiag_antialias = nwdiag_antialias = diag_antialias

eggs_loader = pkgutil.find_loader("sphinxcontrib.spelling")
found = eggs_loader is not None

if found:
    extensions += ["sphinxcontrib.spelling"]
    spelling_lang = "en_US"
    spelling_word_list_filename = "../wordlist"
    spelling_show_suggestions = True
    spelling_ignore_pypi_package_names = False
    spelling_ignore_wiki_words = True
    spelling_ignore_acronyms = True
    spelling_ignore_python_builtins = True
    spelling_ignore_importable_modules = True
    spelling_filters = []

source_parsers = {
    ".md": "recommonmark.parser.CommonMarkParser",
}

# Add any paths that contain templates here, relative to this directory.
templates_path = ["_templates"]

# The suffix(es) of source filenames.
# You can specify multiple suffix as a list of string:
#
source_suffix = [".rst", ".md"]

# The master toctree document.
master_doc = "index"

# General information about the project.
project = classname
copyright = "2022, F5 Networks, Inc."
author = "F5 Networks, Inc."

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = ""
# The full version, including alpha/beta/rc tags.
release = ""

# The language for content autogenerated by Sphinx. Refer to documentation
# for a list of supported languages.
#
# This is also used if you do content translation via gettext catalogs.
# Usually you set "language" from the command line for these cases.
language = "en"

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This patterns also effect to html_static_path and html_extra_path
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store", "links.rst"]

# The name of the Pygments (syntax highlighting) style to use.
pygments_style = "sphinx"
#pygments_style = 'github-dark'


# If true, `todo` and `todoList` produce output, else they produce nothing.
todo_emit_warnings = True
todo_include_todos = True

# -- Options for HTML output ----------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.

# html4_writer = True
html_title = project
html_theme = "f5_sphinx_theme"
html_theme_path = f5_sphinx_theme.get_html_theme_path()
html_sidebars = {"**": ["searchbox.html", "localtoc.html", "globaltoc.html"]}
html_theme_options = {
    "site_name": "Community Training Classes & Labs",
    "next_prev_link": True,
}
html_codeblock_linenos_style = 'table'
html_context = {"github_url": github_repo}

html_last_updated_fmt = "%Y-%m-%d %H:%M:%S"

extlinks = {
   'issue': ('https://github.com/f5devcentral/f5-agility-labs-xc/issues/%s','issue %s'),
   'vk8s howto': ('https://docs.cloud.f5.com/docs/how-to/app-management/create-vk8s-obj','VK8s How-to'),
}


# Theme options are theme-specific and customize the look and feel of a theme
# further.  For a list of options available for each theme, see the
# documentation.
#

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ["_static"]

# or fully qualified paths (eg. https://...)
html_css_files = [
    'css/custom.css',
    "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"
]

# -- Options for HTMLHelp output ------------------------------------------

cleanname = re.sub("\\W+", "", classname)

# Output file base name for HTML help builder.
htmlhelp_basename = cleanname + "doc"

# -- Options for LaTeX output ---------------------------------------------

front_cover_image = "front_cover"
back_cover_image = "back_cover"

front_cover_image_path = os.path.join("_static", front_cover_image + ".png")
back_cover_image_path = os.path.join("_static", back_cover_image + ".png")

latex_additional_files = [front_cover_image_path, back_cover_image_path]

template = string.Template(open("preamble.tex").read())

latex_contents = r"""
\frontcoverpage
\contentspage
"""

backcover_latex_contents = r"""
\backcoverpage
"""

latex_elements = {
    "papersize": "letterpaper",
    "pointsize": "10pt",
    "fncychap": r"\usepackage[Bjornstrup]{fncychap}",
    "preamble": template.substitute(
        eventname=eventname,
        project=project,
        author=author,
        frontcoverimage=front_cover_image,
        backcoverimage=back_cover_image,
    ),
    "tableofcontents": latex_contents,
    "printindex": backcover_latex_contents,
}

# Grouping the document tree into LaTeX files. List of tuples
# (source start file, target name, title,
#  author, documentclass [howto, manual, or own class]).
latex_documents = [
    (
        master_doc,
        "%s.tex" % cleanname,
        "%s Documentation" % classname,
        "F5 Networks, Inc.",
        "manual",
        True,
    ),
]

# -- Options for manual page output ---------------------------------------

# One entry per manual page. List of tuples
# (source start file, name, description, authors, manual section).
man_pages = [
    (master_doc, cleanname.lower(), "%s Documentation" % classname, [author], 1)
]


# -- Options for Texinfo output -------------------------------------------

# Grouping the document tree into Texinfo files. List of tuples
# (source start file, target name, title, author,
#  dir menu entry, description, category)
texinfo_documents = [
    (
        master_doc,
        classname,
        "%s Documentation" % classname,
        author,
        classname,
        classname,
        "Training",
    ),
]
