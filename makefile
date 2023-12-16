lint:
	bash .github/checks.sh

format:
	black ./audrey_hopburn ./tests  --exclude '\./tests/data/'

reports-paths:
	mkdir -p reports/flake8/html/

test: reports-paths
	pytest --html=./reports/junit/report.html --junitxml=./reports/junit/junit.xml ./tests

coverage: reports-paths
	coverage run -m pytest ./tests --html=./reports/junit/report.html --junitxml=./reports/junit/junit.xml ./tests

flake8: reports-paths
	flake8 ./audrey_hopburn ./tests --exclude ./tests/data/ --exit-zero --format=html --htmldir ./reports/flake8/html/ --statistics --tee --output-file ./reports/flake8/flake8stats.txt

coverage-report: reports-paths
	coverage report
	coverage xml
	coverage html

badges:
	genbadge coverage
	genbadge tests
	genbadge flake8

checks: coverage flake8 coverage-report badges

install-test:
	pip install -e ".[test]" && \
	pre-commit install

install:
	pip install .

install-nbooks:
	pip install -e ".[notebooks]" && \
	python -m ipykernel install --user --name=audrey_hopburn

build-test:
	docker build -t audrey_hopburn-tests -f Dockerfile.test .

run-test:
	docker run audrey_hopburn-tests

docker-test: build-test run-test

build:
	docker build -t audrey_hopburn -f Dockerfile .

run:
	docker run audrey_hopburn

build-and-run: build run

build-notebooks:
	docker build -t audrey_hopburn-notebooks -f Dockerfile.notebooks .

run-notebooks:
	docker run -p 8989:8989 -v $(shell pwd):/opt/audrey_hopburn audrey_hopburn-notebooks

docker-notebooks: build-notebooks run-notebooks

## release automation with zest.release
postrelease:
	postrelease

release-branch:
	$(shell ./release_branch.sh)
