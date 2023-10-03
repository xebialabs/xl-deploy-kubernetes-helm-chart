helm delete ${DAI_RELEASE} -n $DAI_NAMESPACE
kubectl delete pvc data-${DAI_RELEASE}-postgresql-0 -n $DAI_NAMESPACE --ignore-not-found=true
kubectl delete pvc data-${DAI_RELEASE}-rabbitmq-0 -n $DAI_NAMESPACE --ignore-not-found=true
kubectl delete pvc data-${DAI_RELEASE}-rabbitmq-1 -n $DAI_NAMESPACE --ignore-not-found=true
kubectl delete pvc data-${DAI_RELEASE}-rabbitmq-2 -n $DAI_NAMESPACE --ignore-not-found=true
kubectl delete pvc data-dir-${DAI_RELEASE}-digitalai-deploy-cc-server-0 -n $DAI_NAMESPACE --ignore-not-found=true
kubectl delete pvc data-dir-${DAI_RELEASE}-digitalai-deploy-master-0 -n $DAI_NAMESPACE --ignore-not-found=true
kubectl delete pvc data-dir-${DAI_RELEASE}-digitalai-deploy-master-1 -n $DAI_NAMESPACE --ignore-not-found=true
kubectl delete pvc data-dir-${DAI_RELEASE}-digitalai-deploy-master-2 -n $DAI_NAMESPACE --ignore-not-found=true
kubectl delete pvc data-dir-${DAI_RELEASE}-digitalai-deploy-worker-0 -n $DAI_NAMESPACE --ignore-not-found=true
kubectl delete pvc data-dir-${DAI_RELEASE}-digitalai-deploy-worker-1 -n $DAI_NAMESPACE --ignore-not-found=true
kubectl delete pvc data-dir-${DAI_RELEASE}-digitalai-deploy-worker-2 -n $DAI_NAMESPACE --ignore-not-found=true
