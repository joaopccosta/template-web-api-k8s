build-docker:
	docker build -t template-web-api-k8s .

distribute:
	python setup.py sdist
