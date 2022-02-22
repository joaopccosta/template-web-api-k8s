from distutils.core import setup

setup(
    # Application name:
    name="template-web-api-k8s",

    # Version number (initial):
    version="1.0.0",

    # Application author details:
    author="Joao Costa",
    author_email="joaopccosta@gmail.com",

    # Packages
    packages=["src"],

    # Include additional files into the package
    include_package_data=True,

    # Details
    # url="http://pypi.python.org/pypi/MyApplication_v010/",

    #
    # license="LICENSE.txt",
    # description="Useful towel-related stuff.",

    long_description=open("README.md").read(),

    # Dependent packages (distributions)
    # install_requires=[
    #     "flask",
    # ],
)
