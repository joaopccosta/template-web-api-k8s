APP_NAME:=web-api
VERSION:=1.0.0
REGISTRY_PORT:=5000

login:
	docker login

build-docker:
	docker build -t ${APP_NAME}:${VERSION} .

publish-docker: login
	docker tag ${APP_NAME}:${VERSION} joaopccosta/${APP_NAME}:${VERSION}
	docker push joaopccosta/${APP_NAME}:${VERSION}

launch:
	docker run -d -p 8080:8080 --name api template-web-api-k8s

distribute:
	python setup.py sdist

helm:
	helm package template-web-api-k8s
	helm upgrade ${APP_NAME} ${APP_NAME}-${VERSION}.tgz --install

publish: distribute build-docker publish-docker

deploy: helm