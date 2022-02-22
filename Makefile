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

# A shortcoming of using minikube is that you must access node_ip:external_svc_port as
# no actual loadbalancer exists to assign external ips.
# https://kubernetesquestions.com/questions/61021389
# https://docs.dapr.io/operations/hosting/kubernetes/cluster/setup-minikube/#troubleshooting
access:
	minikube service ${APP_NAME}

remove:
	helm uninstall ${APP_NAME}