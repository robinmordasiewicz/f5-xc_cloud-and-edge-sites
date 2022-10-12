import codecs

from setuptools import setup, find_packages

setup(
    name='r-mordasiewicz',
    version='2.1.9',
    author='Read the Docs, Inc',
    author_email='robin@mordasiewicz.com',
    url='http://github.com/robinmordasiewicz/r-mordasiewicz',
    license='MIT',
    description='As Built Docs',
    install_requires=['requests', 'Jinja2>=2.9', 'packaging'],
    package_dir={'': '.'},
    packages=find_packages('.', exclude=['tests']),
    long_description=codecs.open("README.rst", "r", "utf-8").read(),
    # trying to add files...
    include_package_data=True,
    package_data={
        '': ['_static/*.js', '_static/*.js_t', '_static/*.css', '_templates/*.tmpl'],
    },
)
