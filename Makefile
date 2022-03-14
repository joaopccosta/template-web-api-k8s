APP_NAME:=web-api
NAMESPACE:=application
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

publish: distribute build-docker publish-docker

# ============== HELM SECTION

add-helm-repos:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update

monitoring: add-helm-repos
	helm upgrade loki-stack grafana/loki-stack --install -n monitoring --create-namespace --values loki-values.yaml
	kubectl get secret --namespace monitoring loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode | tee grafana-pass.txt

helm:
	helm package template-web-api-k8s
	helm upgrade ${APP_NAME} ${APP_NAME}-${VERSION}.tgz --install -n ${NAMESPACE} --create-namespace 

deploy: dependencies monitoring helm

# A shortcoming of using minikube is that you must access node_ip:external_svc_port as
# no actual loadbalancer exists to assign external ips.
# https://kubernetesquestions.com/questions/61021389
# https://docs.dapr.io/operations/hosting/kubernetes/cluster/setup-minikube/#troubleshooting
start:
#minikube service ${APP_NAME} -n ${NAMESPACE}
	minikube service loki-stack-grafana -n monitoring
	minikube service list

remove:
#helm uninstall ${APP_NAME} -n ${NAMESPACE}
#kubectl delete namespace ${NAMESPACE}
	helm uninstall loki-stack -n monitoring
	kubectl delete namespace monitoring
	rm grafana-pass.txt

