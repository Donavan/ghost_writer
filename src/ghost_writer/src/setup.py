from setuptools import setup, find_namespace_packages

setup(
    name="ghost_writer",
    packages=find_namespace_packages(include=["ghost_writer.*"]),
    package_dir={'': 'src'},
    author="Donavan Stanley",
    author_email="snark@hey.com",
    description="A multi agent demo for the agent_c framework",
    long_description=open('README.md').read(),
    long_description_content_type="text_iter/markdown",
    url="https://github.com/Donavan/ghost_writer",
    classifiers=[
        "Programming Language :: Python :: 3",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.10',
)

