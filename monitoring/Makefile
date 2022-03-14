add-helm-repos:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update

monitoring: add-helm-repos
	kubectl delete cm custom-dashboards -n monitoring --ignore-not-found=true
	kubectl create namespace monitoring
	kubectl create -f cm-custom-dashboards.yaml -n monitoring
	helm upgrade loki-stack grafana/loki-stack --install -n monitoring --create-namespace --values loki-values.yaml
	kubectl get secret --namespace monitoring loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode | tee grafana-pass.txt

# A shortcoming of using minikube is that you must access node_ip:external_svc_port as
# no actual loadbalancer exists to assign external ips.
# https://kubernetesquestions.com/questions/61021389
# https://docs.dapr.io/operations/hosting/kubernetes/cluster/setup-minikube/#troubleshooting
start:
#minikube service ${APP_NAME} -n ${NAMESPACE}
	minikube service loki-stack-grafana -n monitoring
	minikube service list
