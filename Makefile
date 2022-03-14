APP_NAME:=web-api
NAMESPACE:=application
VERSION:=1.0.0

distribute:
	python setup.py sdist

docker-login:
	docker login

docker-build:
	docker build -t ${APP_NAME}:${VERSION} .

docker-publish: docker-login
	docker tag ${APP_NAME}:${VERSION} joaopccosta/${APP_NAME}:${VERSION}
	docker push joaopccosta/${APP_NAME}:${VERSION}

launch:
	docker run -d -p 8080:8080 --name api template-web-api-k8s

publish: distribute docker-build docker-publish

monitor:
	make -C monitoring monitoring start

application:
	helm package template-web-api-k8s
	helm upgrade ${APP_NAME} ${APP_NAME}-${VERSION}.tgz --install -n ${NAMESPACE} --create-namespace 

deploy: monitor application

remove:
	helm uninstall ${APP_NAME} -n ${NAMESPACE}
	kubectl delete namespace ${NAMESPACE}
	helm uninstall loki-stack -n monitoring
	kubectl delete namespace monitoring
	rm monitoring/grafana-pass.txt
