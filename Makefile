build-docker:
	docker build -t template-web-api-k8s .

launch:
	docker run -d -p 8080:8080 --name api template-web-api-k8s

distribute:
	python setup.py sdist
