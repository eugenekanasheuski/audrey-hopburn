# linting
black --check audrey_hopburn tests/ --exclude '\./tests/data/' && \
mypy --config-file=mypy.ini audrey_hopburn && \
# docstrings checking.
# enable them when you wish
# darglint -s=sphinx -z=full -v=2 --message-template="{path}:{line} {msg_id} {msg}" audrey_hopburn && \
# pydocstyle --select=D101,D102,D103 audrey_hopburn && \
mkdir -p reports/flake8/html/ && \
coverage run -m pytest -s -v -o log_cli=true -o log_cli_level="INFO" -m "not benchmark" ./tests --html=./reports/junit/report.html --junitxml=./reports/junit/junit.xml ./tests && \
coverage report && \
coverage xml && \
coverage html && \
flake8 ./audrey_hopburn ./tests --exclude ./tests/data/ --exit-zero --format=html --htmldir ./reports/flake8/html/ --statistics --tee --output-file ./reports/flake8/flake8stats.txt && \
genbadge coverage && \
genbadge tests && \
genbadge flake8
