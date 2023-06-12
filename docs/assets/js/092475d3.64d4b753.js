"use strict";(self.webpackChunkdocumentation=self.webpackChunkdocumentation||[]).push([[32],{3905:function(e,t,r){r.d(t,{Zo:function(){return u},kt:function(){return g}});var i=r(7294);function o(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function a(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);t&&(i=i.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,i)}return r}function n(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?a(Object(r),!0).forEach((function(t){o(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function l(e,t){if(null==e)return{};var r,i,o=function(e,t){if(null==e)return{};var r,i,o={},a=Object.keys(e);for(i=0;i<a.length;i++)r=a[i],t.indexOf(r)>=0||(o[r]=e[r]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(i=0;i<a.length;i++)r=a[i],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var s=i.createContext({}),p=function(e){var t=i.useContext(s),r=t;return e&&(r="function"==typeof e?e(t):n(n({},t),e)),r},u=function(e){var t=p(e.components);return i.createElement(s.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return i.createElement(i.Fragment,{},t)}},m=i.forwardRef((function(e,t){var r=e.components,o=e.mdxType,a=e.originalType,s=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),m=p(r),g=o,d=m["".concat(s,".").concat(g)]||m[g]||c[g]||a;return r?i.createElement(d,n(n({ref:t},u),{},{components:r})):i.createElement(d,n({ref:t},u))}));function g(e,t){var r=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var a=r.length,n=new Array(a);n[0]=m;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l.mdxType="string"==typeof e?e:o,n[1]=l;for(var p=2;p<a;p++)n[p]=r[p];return i.createElement.apply(null,n)}return i.createElement.apply(null,r)}m.displayName="MDXCreateElement"},6063:function(e,t,r){r.r(t),r.d(t,{frontMatter:function(){return l},contentTitle:function(){return s},metadata:function(){return p},toc:function(){return u},default:function(){return m}});var i=r(7462),o=r(3366),a=(r(7294),r(3905)),n=["components"],l={sidebar_position:20},s="Deploy Installation on a Air-gapped K8S Cluster",p={unversionedId:"air-gapped-installation",id:"air-gapped-installation",isDocsHomePage:!1,title:"Deploy Installation on a Air-gapped K8S Cluster",description:"This is internal documentation. This document can be used only if it was recommended by the Support Team.",source:"@site/docs/air-gapped-installation.md",sourceDirName:".",slug:"/air-gapped-installation",permalink:"/xl-deploy-kubernetes-helm-chart/docs/air-gapped-installation",tags:[],version:"current",sidebarPosition:20,frontMatter:{sidebar_position:20},sidebar:"tutorialSidebar",previous:{title:"Manual integration with the Identity Service",permalink:"/xl-deploy-kubernetes-helm-chart/docs/integrating-with-identity-service"},next:{title:"RBAC rules for the Deploy installation",permalink:"/xl-deploy-kubernetes-helm-chart/docs/operator-rbac"}},u=[{value:"Requirements",id:"requirements",children:[],level:2},{value:"Installation steps",id:"installation-steps",children:[{value:"Download matching version of the xl-op-blueprints",id:"download-matching-version-of-the-xl-op-blueprints",children:[],level:3},{value:"Get the operator related images to your image registry",id:"get-the-operator-related-images-to-your-image-registry",children:[{value:"Prerequisite Images",id:"prerequisite-images",children:[],level:4},{value:"If you are using nginx include",id:"if-you-are-using-nginx-include",children:[],level:4},{value:"If you are using haproxy include",id:"if-you-are-using-haproxy-include",children:[],level:4},{value:"If you are using embedded keycloak include",id:"if-you-are-using-embedded-keycloak-include",children:[],level:4},{value:"If you are using embedded postgresql include",id:"if-you-are-using-embedded-postgresql-include",children:[],level:4},{value:"If you are using embedded rabbitmq include",id:"if-you-are-using-embedded-rabbitmq-include",children:[],level:4}],level:3},{value:"How to push image to internally accessible docker registry",id:"how-to-push-image-to-internally-accessible-docker-registry",children:[],level:3},{value:"Create registry secret if using a private image registry protected by password",id:"create-registry-secret-if-using-a-private-image-registry-protected-by-password",children:[],level:3},{value:"Use <code>xl kube install</code> to install using custom docker image registry option",id:"use-xl-kube-install-to-install-using-custom-docker-image-registry-option",children:[],level:3}],level:2},{value:"Upgrade steps",id:"upgrade-steps",children:[{value:"Example of running upgrade using custom docker image registry option",id:"example-of-running-upgrade-using-custom-docker-image-registry-option",children:[],level:3},{value:"For Default image registry",id:"for-default-image-registry",children:[],level:3},{value:"For custom docker registry (public)",id:"for-custom-docker-registry-public",children:[],level:3},{value:"For custom docker registry (private)",id:"for-custom-docker-registry-private",children:[],level:3}],level:2},{value:"Image repository related fields that are getting updated in Installation and Upgrade process by xl cli when using custom image registry",id:"image-repository-related-fields-that-are-getting-updated-in-installation-and-upgrade-process-by-xl-cli-when-using-custom-image-registry",children:[{value:"kubernetes/dai-deploy_cr.yaml",id:"kubernetesdai-deploy_cryaml",children:[],level:4},{value:"If you are using nginx",id:"if-you-are-using-nginx",children:[],level:4},{value:"If you are using haproxy",id:"if-you-are-using-haproxy",children:[],level:4},{value:"If you are using embedded keycloak",id:"if-you-are-using-embedded-keycloak",children:[],level:4},{value:"If you are using embedded postgresql",id:"if-you-are-using-embedded-postgresql",children:[],level:4},{value:"If you are using embedded rabbitmq",id:"if-you-are-using-embedded-rabbitmq",children:[],level:4},{value:"kubernetes/template/deployment.yaml",id:"kubernetestemplatedeploymentyaml",children:[],level:4},{value:"kubernetes/template/postgresql-init-keycloak-db.yaml",id:"kubernetestemplatepostgresql-init-keycloak-dbyaml",children:[],level:4}],level:2}],c={toc:u};function m(e){var t=e.components,r=(0,o.Z)(e,n);return(0,a.kt)("wrapper",(0,i.Z)({},c,r,{components:t,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"deploy-installation-on-a-air-gapped-k8s-cluster"},"Deploy Installation on a Air-gapped K8S Cluster"),(0,a.kt)("div",{className:"admonition admonition-caution alert alert--warning"},(0,a.kt)("div",{parentName:"div",className:"admonition-heading"},(0,a.kt)("h5",{parentName:"div"},(0,a.kt)("span",{parentName:"h5",className:"admonition-icon"},(0,a.kt)("svg",{parentName:"span",xmlns:"http://www.w3.org/2000/svg",width:"16",height:"16",viewBox:"0 0 16 16"},(0,a.kt)("path",{parentName:"svg",fillRule:"evenodd",d:"M8.893 1.5c-.183-.31-.52-.5-.887-.5s-.703.19-.886.5L.138 13.499a.98.98 0 0 0 0 1.001c.193.31.53.501.886.501h13.964c.367 0 .704-.19.877-.5a1.03 1.03 0 0 0 .01-1.002L8.893 1.5zm.133 11.497H6.987v-2.003h2.039v2.003zm0-3.004H6.987V5.987h2.039v4.006z"}))),"caution")),(0,a.kt)("div",{parentName:"div",className:"admonition-content"},(0,a.kt)("p",{parentName:"div"},"This is internal documentation. This document can be used only if it was recommended by the Support Team."))),(0,a.kt)("h2",{id:"requirements"},"Requirements"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"Running k8s cluster"),(0,a.kt)("li",{parentName:"ul"},(0,a.kt)("inlineCode",{parentName:"li"},"kubectl")," connected to the cluster"),(0,a.kt)("li",{parentName:"ul"},(0,a.kt)("inlineCode",{parentName:"li"},"xl-cli")," installed - version 23.3.x (any version above 23.1.x)"),(0,a.kt)("li",{parentName:"ul"},"Deploy operator - version 23.3.x (any version above 23.1.x)")),(0,a.kt)("h2",{id:"installation-steps"},"Installation steps"),(0,a.kt)("h3",{id:"download-matching-version-of-the-xl-op-blueprints"},"Download matching version of the xl-op-blueprints"),(0,a.kt)("p",null,"Check what you need with ",(0,a.kt)("inlineCode",{parentName:"p"},"xl kube help"),", for example:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},"\u276f xl kube help\n\nInstall, upgrade or clean Digital.ai Deploy or Digital.ai Release on a Kubernetes cluster using operator technology.\n\nInstallation blueprint files are used from https://dist.xebialabs.com/public/xl-op-blueprints/23.3.x/\n\nYou need to have kubectl installed and configured for the target Kubernetes cluster.\n")),(0,a.kt)("p",null,"You can see from here that ",(0,a.kt)("inlineCode",{parentName:"p"},"xl kube")," needs blueprints from location ",(0,a.kt)("a",{parentName:"p",href:"https://dist.xebialabs.com/public/xl-op-blueprints/23.3.x/"},"https://dist.xebialabs.com/public/xl-op-blueprints/23.3.x/"),"\n(Note: 23.3.x denotes the appropriate version of ",(0,a.kt)("inlineCode",{parentName:"p"},"xl-op-blueprints")," pointed by ",(0,a.kt)("inlineCode",{parentName:"p"},"xl"),". Use the specific version in your case.)"),(0,a.kt)("p",null,"You need to download and put all files from that location to the server where you will execute ",(0,a.kt)("inlineCode",{parentName:"p"},"xl kube"),"."),(0,a.kt)("p",null,":::TIP\nYou can download zipped version of the xl-op-blueprints from here:\n",(0,a.kt)("a",{parentName:"p",href:"https://nexus.xebialabs.com/nexus/content/repositories/digitalai-public/ai/digital/xlclient/blueprints/xl-op-blueprints/"},"https://nexus.xebialabs.com/nexus/content/repositories/digitalai-public/ai/digital/xlclient/blueprints/xl-op-blueprints/")),(0,a.kt)("p",null,"Unzip it to the server where you will execute ",(0,a.kt)("inlineCode",{parentName:"p"},"xl kube"),".\n:::"),(0,a.kt)("h3",{id:"get-the-operator-related-images-to-your-image-registry"},"Get the operator related images to your image registry"),(0,a.kt)("p",null,"The kubernetes cluster running in airgapped environment cannot download any image from public registry (such as docker.io, gcr.io, quay.io). The images need to be pushed to a image registry accessible to the kubernetes cluster. Create either a private image repository on your cloud provider or a local image repository that is accessible to the kubernetes cluster."),(0,a.kt)("h4",{id:"prerequisite-images"},"Prerequisite Images"),(0,a.kt)("p",null,"Push the images according to your planned installation to your image repository.\nFor example, for version 23.3.x, following is the list of the images that you will need:"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"docker.io/xebialabs/xl-deploy:23.3.x"),(0,a.kt)("li",{parentName:"ul"},"docker.io/xebialabs/deploy-task-engine:23.3.x"),(0,a.kt)("li",{parentName:"ul"},"docker.io/xebialabs/central-configuration:23.3.x"),(0,a.kt)("li",{parentName:"ul"},"docker.io/xebialabs/tiny-tools:22.2.0"),(0,a.kt)("li",{parentName:"ul"},"docker.io/xebialabs/deploy-operator:23.3.x"),(0,a.kt)("li",{parentName:"ul"},"gcr.io/kubebuilder/kube-rbac-proxy:v0.8.0")),(0,a.kt)("h4",{id:"if-you-are-using-nginx-include"},"If you are using nginx include"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"docker.io/bitnami/nginx:1.22.1-debian-11-r44"),(0,a.kt)("li",{parentName:"ul"},"docker.io/bitnami/nginx-ingress-controller:1.6.4-debian-11-r5")),(0,a.kt)("h4",{id:"if-you-are-using-haproxy-include"},"If you are using haproxy include"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"quay.io/jcmoraisjr/haproxy-ingress:v0.14.2")),(0,a.kt)("h4",{id:"if-you-are-using-embedded-keycloak-include"},"If you are using embedded keycloak include"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"docker.io/jboss/keycloak:17.0.1")),(0,a.kt)("h4",{id:"if-you-are-using-embedded-postgresql-include"},"If you are using embedded postgresql include"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"docker.io/bitnami/postgresql:14.5.0-debian-11-r35")),(0,a.kt)("h4",{id:"if-you-are-using-embedded-rabbitmq-include"},"If you are using embedded rabbitmq include"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"docker.io/bitnami/rabbitmq:3.11.10-debian-11-r0"),(0,a.kt)("li",{parentName:"ul"},"docker.io/bitnami/bitnami-shell:11-debian-11-r92")),(0,a.kt)("h3",{id:"how-to-push-image-to-internally-accessible-docker-registry"},"How to push image to internally accessible docker registry"),(0,a.kt)("p",null,"You need to pull the required images first on a bastion instance where public internet connectivity is there, then tag it and push it to your internally accessible docker image registry. Your kubernetes cluster will pull images from the docker registry."),(0,a.kt)("p",null,"For example with a docker registry at ",(0,a.kt)("inlineCode",{parentName:"p"},"myrepo_host"),", the steps to push a docker image(for eg. xl-deploy) to the repository ",(0,a.kt)("inlineCode",{parentName:"p"},"myrepo")," would be as follows."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},"docker pull docker.io/xebialabs/xl-deploy:22.3.1\ndocker tag docker.io/xebialabs/xl-deploy:22.3.1 myrepo_host/myrepo/xl-deploy:22.3.1\ndocker push myrepo_host/myrepo/xl-deploy:22.3.1\n")),(0,a.kt)("blockquote",null,(0,a.kt)("p",{parentName:"blockquote"},"Make sure, you're logged in to the docker registry before pushing the docker image.")),(0,a.kt)("h3",{id:"create-registry-secret-if-using-a-private-image-registry-protected-by-password"},"Create registry secret if using a private image registry protected by password"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},"kubectl create secret docker-registry regcred \\\n  --docker-server=myrepo_host \\\n  --docker-username=<reg-user> \\\n  --docker-password=<reg-password> \\\n  -n digitalai\n")),(0,a.kt)("p",null,"This example creates a secret ",(0,a.kt)("inlineCode",{parentName:"p"},"regcred")," which will be used for pull secrets for pulling image when using custom private image registry."),(0,a.kt)("h3",{id:"use-xl-kube-install-to-install-using-custom-docker-image-registry-option"},"Use ",(0,a.kt)("inlineCode",{parentName:"h3"},"xl kube install")," to install using custom docker image registry option"),(0,a.kt)("p",null,"When using custom docker registry, the operator image will be in the format ",(0,a.kt)("inlineCode",{parentName:"p"},"myrepo_host/myrepo/deploy-operator:image_tag")),(0,a.kt)("p",null,"Here is example of the installation on minikube with a local docker registry running at ",(0,a.kt)("inlineCode",{parentName:"p"},"localhost:5000")),(0,a.kt)("p",null,"In the below example the registry name is ",(0,a.kt)("inlineCode",{parentName:"p"},"localhost:5000"),", the repository name is ",(0,a.kt)("inlineCode",{parentName:"p"},"myrepo"),", so operator image would be like ",(0,a.kt)("inlineCode",{parentName:"p"},"localhost:5000/myrepo/deploy-operator:23.3.x"),". Remember to override default answer and specify in this format. And also use the actual image tag version in place of ",(0,a.kt)("inlineCode",{parentName:"p"},"23.3.x")),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},"\u276f xl kube install -l c:\\proj\\xl-op-blueprints\n? Following kubectl context will be used during execution: `minikube`? Yes\n? Select the Kubernetes setup where the Digital.ai Devops Platform will be installed, updated or cleaned: PlainK8s [Plain multi-node K8s cluster]\n? Do you want to use an custom Kubernetes namespace (current default is 'digitalai'): No\n? Product server you want to perform install for: dai-deploy [Digital.ai Deploy]\n? Select type of image registry: public [Custom Public Registry (Uses a specific custom registry)]\n? Enter the custom docker image registry name: localhost:5000\n? Enter the repository name (eg: <repositoryName> from <repositoryName>/<imageName>:<tagName>): myrepo\n? Enter the deploy server image name (eg: <imageName> from <repositoryName>/<imageName>:<tagName>): xl-deploy\n? Enter the image tag (eg: <tagName> from <repositoryName>/<imageName>:<tagName>): 23.3.x\n? Enter the deploy task engine image name for version 22 and above (eg: <imageName> from <repositoryName>/<imageName>:<tagName>): deploy-task-engine\n? Enter the central configuration image name for version 22 and above (eg: <imageName> from <repositoryName>/<imageName>:<tagName>): central-configuration\n? Enter the deploy master server replica count: 1\n? Enter PVC size for Deploy master (Gi): 1\n? Select between supported Access Modes: ReadWriteOnce [ReadWriteOnce]\n? Enter the deploy worker replica count: 1\n? Enter PVC size for Deploy worker (Gi): 1\n? Enter PVC size for Central Configuration (Gi): 0.500000\n? Select between supported ingress types: haproxy [HAProxy]\n? Do you want to enable an TLS/SSL configuration (if yes, requires existing TLS secret in the namespace): No\n? Provide DNS name for accessing UI of the server: test.com\n? Provide administrator password: 30Q5utfMV6O9wnHF\n? Type of the OIDC configuration: embedded [Embedded Keycloak Configuration]\n? Use embedded DB for keycloak: Yes\n? Enter Keycloak public URL: k.test.com\n? Enter the operator image to use (eg: <imageRegistryName>/<repositoryName>/<imageName>:<tagName>): localhost:5000/myrepo/deploy-operator:23.3.x\n? Select source of the license: file [Path to the license file (the file can be in clean text or base64 encoded)]\n? Provide license file for the server: c:\\downloads\\xld-license.lic\n? Select source of the repository keystore: generate [Generate the repository keystore during installation (you need to have keytool utility installed in your path)]\n? Provide keystore passphrase: 1uwAFCtUJEdwmaDi\n? Provide storage class for the server: standard\n? Do you want to install a new PostgreSQL on the cluster: Yes\n? Provide Storage Class to be defined for PostgreSQL: standard\n? Provide PVC size for PostgreSQL (Gi): 1\n? Do you want to install a new RabbitMQ on the cluster: Yes\n? Replica count to be defined for RabbitMQ: 1\n? Storage Class to be defined for RabbitMQ: standard\n? Provide PVC size for RabbitMQ (Gi): 1\n\n...\n\n? Do you want to proceed to the deployment with these values? Yes\nFor current process files will be generated in the: digitalai/dai-deploy/digitalai/20221020-001911/kubernetes\nGenerated answers file successfully: digitalai/generated_answers_dai-deploy_digitalai_install-20221020-001911.yaml\nStarting install processing.\n...\n")),(0,a.kt)("p",null,"After the install command completes successfully, you will see operator and other resources pods coming up and running."),(0,a.kt)("h2",{id:"upgrade-steps"},"Upgrade steps"),(0,a.kt)("p",null,"Use ",(0,a.kt)("inlineCode",{parentName:"p"},"xl kube upgrade")," to upgrade. It is similar to installation steps. Here the already installed cluster resources are overwritten/upgraded with the newly supplied values."),(0,a.kt)("h3",{id:"example-of-running-upgrade-using-custom-docker-image-registry-option"},"Example of running upgrade using custom docker image registry option"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},"\u276f xl kube upgrade -l ./xl-op-blueprints\n...\n? Select type of image registry: public [Custom Public Registry (Uses a specific custom registry)]\n? Enter the custom docker image registry name: localhost:5000\n? Enter the repository name (eg: <repositoryName> from <repositoryName>/<imageName>:<tagName>): myrepo\n...\n? Enter the operator image to use (eg: <imageRegistryName>/<repositoryName>/<imageName>:<tagName>): localhost:5000/myrepo/deploy-operator:23.3.x\n...\n? Edit list of custom resource keys that will migrate to the new Deploy CR: \n...\n? Do you want to proceed to the deployment with these values? Yes\nFor current process files will be generated in the: digitalai/dai-deploy/digitalai/20221020-011911/kubernetes\nGenerated answers file successfully: digitalai/generated_answers_dai-deploy_digitalai_upgrade-20221020-011911.yaml\nStarting upgrade processing.\n...\n")),(0,a.kt)("p",null,"During upgrade for the question ",(0,a.kt)("inlineCode",{parentName:"p"},"Edit list of custom resource keys that will migrate to the new Deploy CR:")," append to the list following keys:"),(0,a.kt)("h3",{id:"for-default-image-registry"},"For Default image registry"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},".spec.TinyToolsImageRepository\n.spec.nginx-ingress-controller.defaultBackend.image.registry\n.spec.nginx-ingress-controller.defaultBackend.image.repository\n.spec.nginx-ingress-controller.image.registry\n.spec.nginx-ingress-controller.image.repository\n.spec.haproxy-ingress.controller.image.repository\n.spec.keycloak.image.repository\n.spec.keycloak.postgresql.image.registry\n.spec.keycloak.postgresql.image.repository\n.spec.postgresql.image.registry\n.spec.postgresql.image.repository\n.spec.rabbitmq.image.registry\n.spec.rabbitmq.image.repository\n.spec.rabbitmq.volumePermissions.image.registry\n.spec.rabbitmq.volumePermissions.image.repository\n")),(0,a.kt)("h3",{id:"for-custom-docker-registry-public"},"For custom docker registry (public)"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},".spec.TinyToolsImageRepository\n.spec.nginx-ingress-controller.defaultBackend.image.repository\n.spec.nginx-ingress-controller.image.repository\n.spec.nginx-ingress-controller.global.imageRegistry\n.spec.haproxy-ingress.controller.image.repository\n.spec.keycloak.image.repository\n.spec.keycloak.postgresql.image.registry\n.spec.keycloak.postgresql.image.repository\n.spec.postgresql.image.repository\n.spec.postgresql.global.imageRegistry\n.spec.rabbitmq.image.repository\n.spec.rabbitmq.global.imageRegistry\n.spec.rabbitmq.volumePermissions.image.repository\n")),(0,a.kt)("h3",{id:"for-custom-docker-registry-private"},"For custom docker registry (private)"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre"},".spec.TinyToolsImageRepository\n.spec.nginx-ingress-controller.defaultBackend.image.repository\n.spec.nginx-ingress-controller.image.repository\n.spec.nginx-ingress-controller.global.imageRegistry\n.spec.haproxy-ingress.controller.image.repository\n.spec.keycloak.image.repository\n.spec.keycloak.postgresql.image.registry\n.spec.keycloak.postgresql.image.repository\n.spec.postgresql.image.repository\n.spec.postgresql.global.imageRegistry\n.spec.rabbitmq.image.repository\n.spec.rabbitmq.global.imageRegistry\n.spec.rabbitmq.volumePermissions.image.repository\n.spec.nginx-ingress-controller.global.imagePullSecrets\n.spec.keycloak.imagePullSecrets\n.spec.keycloak.postgresql.imagePullSecrets\n.spec.postgresql.global.imagePullSecrets\n.spec.rabbitmq.global.imagePullSecrets\n")),(0,a.kt)("h2",{id:"image-repository-related-fields-that-are-getting-updated-in-installation-and-upgrade-process-by-xl-cli-when-using-custom-image-registry"},"Image repository related fields that are getting updated in Installation and Upgrade process by xl cli when using custom image registry"),(0,a.kt)("h4",{id:"kubernetesdai-deploy_cryaml"},"kubernetes/dai-deploy_cr.yaml"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},'spec.centralConfiguration.image.repository: "myrepo_host/myrepo/central-configuration"'),(0,a.kt)("li",{parentName:"ul"},'spec.ServerImageRepository: "myrepo_host/myrepo/xl-deploy"'),(0,a.kt)("li",{parentName:"ul"},'spec.WorkerImageRepository: "myrepo_host/myrepo/deploy-task-engine"'),(0,a.kt)("li",{parentName:"ul"},'spec.TinyToolsImageRepository: "myrepo_host/myrepo/tiny-tools"'),(0,a.kt)("li",{parentName:"ul"},"spec.ImagePullSecret: regcred (only for custom private image registry requiring authentication)")),(0,a.kt)("h4",{id:"if-you-are-using-nginx"},"If you are using nginx"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"spec.nginx-ingress-controller.defaultBackend.image.registry: myrepo_host"),(0,a.kt)("li",{parentName:"ul"},"spec.nginx-ingress-controller.defaultBackend.image.repository: myrepo/nginx"),(0,a.kt)("li",{parentName:"ul"},"spec.nginx-ingress-controller.image.registry: myrepo_host"),(0,a.kt)("li",{parentName:"ul"},"spec.nginx-ingress-controller.image.repository: myrepo/nginx-ingress-controller"),(0,a.kt)("li",{parentName:"ul"},"spec.nginx-ingress-controller.imagePullSecrets.","[0]",": regcred (only for custom private image registry requiring authentication)")),(0,a.kt)("h4",{id:"if-you-are-using-haproxy"},"If you are using haproxy"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"spec.haproxy-ingress.controller.image.repository: myrepo_host/myrepo/haproxy-ingress"),(0,a.kt)("li",{parentName:"ul"},"spec.haproxy-ingress.imagePullSecrets","[0]",".name: regcred (only for custom private image registry requiring authentication)")),(0,a.kt)("h4",{id:"if-you-are-using-embedded-keycloak"},"If you are using embedded keycloak"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"spec.keycloak.image.repository: myrepo_host/myrepo/keycloak"),(0,a.kt)("li",{parentName:"ul"},"spec.keycloak.postgresql.image.registry: myrepo_host"),(0,a.kt)("li",{parentName:"ul"},"spec.keycloak.postgresql.image.repository: myrepo/postgresql"),(0,a.kt)("li",{parentName:"ul"},"spec.keycloak.imagePullSecrets","[0]",".name: regcred (only for custom private image registry requiring authentication)"),(0,a.kt)("li",{parentName:"ul"},"spec.keycloak.postgres.imagePullSecrets","[0]",".name: regcred (only for custom private image registry requiring authentication)")),(0,a.kt)("h4",{id:"if-you-are-using-embedded-postgresql"},"If you are using embedded postgresql"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"spec.postgresql.image.registry: myrepo_host"),(0,a.kt)("li",{parentName:"ul"},"spec.postgresql.image.repository: myrepo/postgresql"),(0,a.kt)("li",{parentName:"ul"},"spec.postgres.global.imagePullSecrets.","[0]",": regcred (only for custom private image registry requiring authentication)")),(0,a.kt)("h4",{id:"if-you-are-using-embedded-rabbitmq"},"If you are using embedded rabbitmq"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"spec.rabbitmq.image.registry: myrepo_host"),(0,a.kt)("li",{parentName:"ul"},"spec.rabbitmq.image.repository: myrepo/rabbitmq"),(0,a.kt)("li",{parentName:"ul"},"spec.rabbitmq.volumePermissions.image.registry: myrepo_host "),(0,a.kt)("li",{parentName:"ul"},"spec.rabbitmq.volumePermissions.image.repository: myrepo/bitnami-shell"),(0,a.kt)("li",{parentName:"ul"},"spec.rabbitmq.global.imagePullSecrets.","[0]",": regcred (only for custom private image registry requiring authentication)")),(0,a.kt)("h4",{id:"kubernetestemplatedeploymentyaml"},"kubernetes/template/deployment.yaml"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"spec.template.spec.containers","[0]",".image: myrepo_host/myrepo/kube-rbac-proxy:v0.8.0"),(0,a.kt)("li",{parentName:"ul"},"spec.template.spec.containers","[1]",".image: myrepo_host/myrepo/deploy-operator:{operator-imageTag-given-in-xl-cmd-question}"),(0,a.kt)("li",{parentName:"ul"},"spec.template.spec.imagePullSecrets","[0]",".name: regcred (only for custom private image registry requiring authentication)")),(0,a.kt)("h4",{id:"kubernetestemplatepostgresql-init-keycloak-dbyaml"},"kubernetes/template/postgresql-init-keycloak-db.yaml"),(0,a.kt)("ul",null,(0,a.kt)("li",{parentName:"ul"},"spec.template.spec.initContainers","[0]",".image: myrepo_host/myrepo/tiny-tools:22.2.0"),(0,a.kt)("li",{parentName:"ul"},"spec.template.spec.containers","[0]",".image: myrepo_host/myrepo/tiny-tools:22.2.0"),(0,a.kt)("li",{parentName:"ul"},"spec.template.spec.imagePullSecrets","[0]",".name: regcred (only for custom private image registry requiring authentication)")))}m.isMDXComponent=!0}}]);