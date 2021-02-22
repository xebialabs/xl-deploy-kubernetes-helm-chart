pipeline{
    agent {
        label 'helm-chart'
    }
    parameters {
        choice(name: 'PRODUCT', choices: ['XL Release', 'XL Deploy'], description: 'Select the product to package')
        choice(name: 'PLATFORM', choices: ['Onprem','EKS','Openshift_AWS','Openshift_Onprem'], description: 'Pick the platform to deploy the helm chart')
        choice(name: 'BRANCH', choices: ['master','1.0','Openshift-Master','Openshift-1.0'], description: 'Select the branch to build')
        choice(name: 'PUSH_TO_NEXUS', choices: ['YES', 'NO'], description: 'Do you want to push the zip file to nexus?')
        choice(name: 'PUSH_TO_XEBIALABS_DIST', choices: ['YES', 'NO'], description: 'Do you want to push the zip file to xebialabs distribution?')
        choice(name: 'INSTALL_CHART', choices: ['YES', 'NO'], description: 'Do you want to install the helm chart?')
    }
    options {
        timeout(time: 1, unit: 'HOURS')
    }
    environment {
        GIT_HUB_XLR_URL = "https://github.com/xebialabs/xl-release-kubernetes-helm-chart.git"
        GIT_HUB_XLD_URL = "https://github.com/xebialabs/xl-deploy-kubernetes-helm-chart.git"
        BRANCH_NAME = "${params.BRANCH}"
        NEXUS_PASSWORD = credentials('nexus-ci')
        NEXUS_URL = "https://nexus.xebialabs.com/nexus/content/repositories/helm/"
        OPENSHIFT_AWS_CRED = credentials('openshift-aws')
        OPENSHIFT_AWS_SERVER_URL = "https://api.ocp-qa.xldevinfra.com:6443"
        OPENSHIFT_ONPREM_CRED = credentials('openshift-onprem')
        OPENSHIFT_ONPREM_SERVER_URL = "https://api.ocp4.xebialabs.com:6443"
        OPENSHIFT_TOKEN_ONPREM = credentials('openshift-token-onprem')
        OPENSHIFT_TOKEN_AWS = credentials('openshift-token-aws')
        HOST_NAME_ONPREM_OPENSHIFT_RELEASE = "xlpipelinerelease.apps.ocp4.xebialabs.com"
        HOST_NAME_ONPREM_OPENSHIFT_DEPLOY = "xlpipelinedeploy.apps.ocp4.xebialabs.com"
        HOST_NAME_AWS_OPENSHIFT_RELEASE = "xlpipelinerelease.apps.ocp-qa.xldevinfra.com"
        HOST_NAME_AWS_OPENSHIFT_DEPLOY = "xlpipelinedeploy.apps.ocp-qa.xldevinfra.com"
        HOST_NAME_AWS_EKS = "xlpipeline.digitalai-testing.com"
        HOST_NAME_ONPREM_K8S = "kublove-kn1.xebialabs.com"
        XLD_LICENSE = credentials('xld-lic')
        XLR_LICENSE = credentials('xlr-lic')
        REPOSITORY_KEYSTORE = credentials('repository-keystore')
        KEYSTORE_PASSPHRASE = credentials('keystore-passphrase')
    }
    stages {
        stage('Git checkout') {
            steps {
                // Clean old workspace
                step([$class: 'WsCleanup'])
                script {
                    if ( params.PRODUCT == 'XL Release') {
                        try {
                            echo "Checking out the code for ${params.PRODUCT} from ${params.BRANCH} branch"
                            sh '''
                                git clone -b $BRANCH_NAME $GIT_HUB_XLR_URL
                                echo "Git check out successful !!!"
                            '''
                        }catch(error){
                            throw error
                        }
                    }else {
                        try {
                            echo "Checking out the code for ${params.PRODUCT} from ${params.BRANCH} branch"
                            sh '''
                                git clone -b $BRANCH_NAME $GIT_HUB_XLD_URL
                                echo "Git check out successful !!!"
                            '''
                        }catch(error) {
                            throw error
                        }
                    }
                }
            }
        }
        stage('Helm package') {
            steps {
                script {
                    if ( params.PRODUCT == 'XL Release' ) {
                        try{
                            echo "Updating the helm dependencies for ${params.PRODUCT}"
                            sh '''
                                helm dependency update xl-release-kubernetes-helm-chart
                                helm package xl-release-kubernetes-helm-chart
                                echo "Build Finished"
                            '''
                        }catch(error) {
                            throw error
                        }
                    }else {
                        try{
                            echo "Updating the helm dependencies for ${params.PRODUCT}"
                            sh '''
                                helm dependency update xl-deploy-kubernetes-helm-chart
                                helm package xl-deploy-kubernetes-helm-chart
                                echo "Build Finished"
                            '''
                        }catch(error){
                            throw error
                        }
                    }
                }
            }
        }
        stage('Push to nexus') {
            when {
                anyOf {
                    expression { params.PUSH_TO_NEXUS == 'YES' && params.PRODUCT == 'XL Release' }
                    expression { params.PUSH_TO_NEXUS == 'YES' && params.PRODUCT == 'XL Deploy' }
                }
            }
            steps {
                script {
                    if ( params.PRODUCT == 'XL Release' ) {
                        try {
                            echo "Pushing ${params.PRODUCT} build to nexus"
                            sh '''
                                curl -k -u ${NEXUS_PASSWORD} ${NEXUS_URL} --upload-file *release*.tgz -v
                                echo "Push successful"
                            '''
                        }catch(error){
                            throw error
                        }
                    }else {
                        try {
                            echo "Pushing ${params.PRODUCT} build to nexus"
                            sh '''
                                curl -k -u ${NEXUS_PASSWORD} ${NEXUS_URL} --upload-file *deploy*.tgz -v
                                echo "Push successful"
                            '''
                        }catch(error){
                            throw error
                        }
                    }
                }
            }
        }
        stage('Push to Xebialabs dist') {
            when {
                anyOf {
                    expression { params.PUSH_TO_XEBIALABS_DIST == 'YES' && params.PRODUCT == 'XL Release' }
                    expression { params.PUSH_TO_XEBIALABS_DIST == 'YES' && params.PRODUCT == 'XL Deploy' }
                }
            }
            steps {
                script {
                    if ( params.PRODUCT == 'XL Release' ) {
                        try {
                            echo "Pushing ${params.PRODUCT} build to xebialabs distribution"
                        }catch(error) {
                            throw error
                        }
                    }else {
                        try {
                            echo "Pushing ${params.PRODUCT} build to xebialabs distribution"
                        }catch(error) {
                            throw error
                        }
                    }
                }
            }
        }
        stage('Platforms') {
            parallel {
                stage('Deploy to Openshift AWS') {
                    when {
                        anyOf {
                            expression { params.INSTALL_CHART == 'YES' && params.PRODUCT == 'XL Release' && params.PLATFORM == 'Openshift_AWS' }
                            expression { params.INSTALL_CHART == 'YES' && params.PRODUCT == 'XL Deploy' && params.PLATFORM == 'Openshift_AWS' }
                        }
                    }
                    steps {
                        script {
                            if ( params.PRODUCT == 'XL Release' ) {
                                try {
                                    withCredentials([file(credentialsId: 'xl-release-license', variable: 'xl-release-license')]) {
                                        withCredentials([string(credentialsId: 'repository-keystore', variable: 'repository-keystore')]) {
                                            withCredentials([string(credentialsId: 'keystore-passphrase', variable: 'keystore-passphrase')]) {
                                                echo "Installing ${params.PRODUCT} on ${params.PLATFORM} platform"
                                                sh '''
                                                    oc login --token=$OPENSHIFT_TOKEN_AWS --server=$OPENSHIFT_AWS_SERVER_URL --insecure-skip-tls-verify
                                                    oc project xlpipeline
                                                    echo "Deleting previous deployment if any on xlpipeline namespace"
                                                    helm uninstall xlrelease-oc > /dev/null
                                                    sleep 8
                                                    oc delete pvc --all > /dev/null
                                                    sleep 8
                                                    helm install xlrelease-oc *.tgz --set route.hosts[0]=$HOST_NAME_AWS_OPENSHIFT_RELEASE --set xlrLicense=${XLR_LICENSE} --set RepositoryKeystore=${REPOSITORY_KEYSTORE} --set KeystorePassphrase=${KEYSTORE_PASSPHRASE} --set postgresql.persistence.storageClass=aws-efs --set rabbitmq.persistence.storageClass=gp2 --set Persistence.StorageClass=aws-efs
                                                '''
                                            }
                                        }
                                    }
                                }catch(error) {
                                    throw error
                                }
                            }else {
                                try {
                                    withCredentials([file(credentialsId: 'xl-deploy-license', variable: 'xl-deploy-license')]) {
                                        withCredentials([string(credentialsId: 'repository-keystore', variable: 'repository-keystore')]) {
                                            withCredentials([string(credentialsId: 'keystore-passphrase', variable: 'keystore-passphrase')]) {
                                                echo "Installing ${params.PRODUCT} on ${params.PLATFORM} platform"
                                                sh '''
                                                   oc login --token=$OPENSHIFT_TOKEN_AWS --server=$OPENSHIFT_AWS_SERVER_URL --insecure-skip-tls-verify
                                                   oc project xlpipeline
                                                   echo "Deleting previous deployment if any on xlpipeline namespace"
                                                   helm uninstall xldeploy-oc > /dev/null
                                                   sleep 8
                                                   oc delete pvc --all > /dev/null
                                                   sleep 8
                                                   helm install xldeploy-oc *.tgz --set route.hosts[0]=$HOST_NAME_AWS_OPENSHIFT_DEPLOY --set xldLicense=${XLD_LICENSE} --set RepositoryKeystore=${REPOSITORY_KEYSTORE} --set KeystorePassphrase=${KEYSTORE_PASSPHRASE} --set postgresql.persistence.storageClass=aws-efs --set rabbitmq.persistence.storageClass=gp2 --set Persistence.StorageClass=aws-efs
                                                '''
                                            }
                                        }
                                    }
                                }catch(error) {
                                    throw error
                                }
                            }
                        }
                    }
                }
                stage('Deploy to Openshift Onprem') {
                    when {
                        anyOf {
                            expression { params.INSTALL_CHART == 'YES' && params.PRODUCT == 'XL Release' && params.PLATFORM == 'Openshift_Onprem' }
                            expression { params.INSTALL_CHART == 'YES' && params.PRODUCT == 'XL Deploy' && params.PLATFORM == 'Openshift_Onprem' }
                        }
                    }
                    steps {
                        script {
                            if ( params.PRODUCT == 'XL Release' ) {
                                try {
                                    withCredentials([file(credentialsId: 'xl-release-license', variable: 'xl-release-license')]) {
                                        withCredentials([string(credentialsId: 'repository-keystore', variable: 'repository-keystore')]) {
                                            withCredentials([string(credentialsId: 'keystore-passphrase', variable: 'keystore-passphrase')]) {
                                                echo "Installing ${params.PRODUCT} on ${params.PLATFORM} platform"
                                                sh '''
                                                    oc login --token=$OPENSHIFT_TOKEN_ONPREM --server=$OPENSHIFT_ONPREM_SERVER_URL --insecure-skip-tls-verify
                                                    oc project xlpipeline
                                                    helm install --generate-name *.tgz --set route.hosts[0]=$HOST_NAME_ONPREM_OPENSHIFT_RELEASE --set xlrLicense=${XLR_LICENSE} --set RepositoryKeystore=${REPOSITORY_KEYSTORE} --set KeystorePassphrase=${KEYSTORE_PASSPHRASE} --set postgresql.persistence.storageClass=nfs-client --set rabbitmq.persistence.storageClass=nfs-client --set Persistence.StorageClass=nfs-client
                                                '''
                                            }
                                        }
                                    }
                                }catch(error){
                                    throw error
                                }
                            }else {
                                try {
                                    withCredentials([file(credentialsId: 'xl-deploy-license', variable: 'xl-deploy-license')]) {
                                        withCredentials([string(credentialsId: 'repository-keystore', variable: 'repository-keystore')]) {
                                            withCredentials([string(credentialsId: 'keystore-passphrase', variable: 'keystore-passphrase')]) {
                                                echo "Installing ${params.PRODUCT} on ${params.PLATFORM} platform"
                                                sh '''
                                                    oc login --token=$OPENSHIFT_TOKEN_ONPREM --server=$OPENSHIFT_ONPREM_SERVER_URL --insecure-skip-tls-verify
                                                    oc project xlpipeline
                                                    helm install --generate-name *.tgz --set route.hosts[0]=$HOST_NAME_ONPREM_OPENSHIFT_DEPLOY --set xldLicense=${XLD_LICENSE} --set RepositoryKeystore=${REPOSITORY_KEYSTORE} --set KeystorePassphrase=${KEYSTORE_PASSPHRASE} --set postgresql.persistence.storageClass=nfs-client --set rabbitmq.persistence.storageClass=nfs-client --set Persistence.StorageClass=nfs-client
                                                '''
                                            }
                                        }
                                    }
                                }catch(error){
                                    throw error
                                }
                            }
                        }
                    }
                }
                stage('Deploy to EKS') {
                    when {
                        anyOf {
                            expression { params.INSTALL_CHART == 'YES' && params.PRODUCT == 'XL Release' && params.PLATFORM == 'EKS' }
                            expression { params.INSTALL_CHART == 'YES' && params.PRODUCT == 'XL Deploy' && params.PLATFORM == 'EKS' }
                        }
                    }
                    steps {
                        script {
                            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'AWS_CREDENTIALS', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {
                                withKubeConfig(caCertificate: '', clusterName: 'xlpipeline-cluster', contextName: 'iTest@xlpipeline-cluster.eu-west-1.eksctl.io', credentialsId: 'AWS_EKS_CONFIG', namespace: 'xlpipeline', serverUrl: 'https://36233C5EEAE9B53A8DFF31C554DBD35F.gr7.eu-west-1.eks.amazonaws.com') {
                                    if ( params.PRODUCT == 'XL Release' ) {
                                        try {
                                            echo "Installing ${params.PRODUCT} on ${params.PLATFORM} platform"
                                            withCredentials([file(credentialsId: 'xl-release-license', variable: 'xl-release-license')]) {
                                                withCredentials([string(credentialsId: 'repository-keystore', variable: 'repository-keystore')]) {
                                                    withCredentials([string(credentialsId: 'keystore-passphrase', variable: 'keystore-passphrase')]) {
                                                            sh '''
                                                                kubectl config set-context --current --namespace xlpipeline
                                                                helm install --generate-name *.tgz --set ingress.hosts[0]=$HOST_NAME_AWS_EKS --set haproxy-ingress.controller.service.type=LoadBalancer --set xlrLicense=${XLR_LICENSE} --set RepositoryKeystore=${REPOSITORY_KEYSTORE} --set KeystorePassphrase=${KEYSTORE_PASSPHRASE} --set Persistence.StorageClass=aws-efs
                                                                kubectl get svc
                                                            '''
                                                    }
                                                }
                                            }
                                        }catch(error) {
                                            throw error
                                        }
                                    }else {
                                        try {
                                            withCredentials([file(credentialsId: 'xl-deploy-license', variable: 'xl-deploy-license')]) {
                                                withCredentials([string(credentialsId: 'repository-keystore', variable: 'repository-keystore')]) {
                                                    withCredentials([string(credentialsId: 'keystore-passphrase', variable: 'keystore-passphrase')]) {
                                                        echo "Installing ${params.PRODUCT} on ${params.PLATFORM} platform"
                                                        sh '''
                                                            kubectl config set-context --current --namespace xlpipeline
                                                            helm install --generate-name *.tgz --set ingress.hosts[0]=$HOST_NAME_AWS_EKS --set haproxy-ingress.controller.service.type=LoadBalancer --set xldLicense=${XLD_LICENSE} --set RepositoryKeystore=${REPOSITORY_KEYSTORE} --set KeystorePassphrase=${KEYSTORE_PASSPHRASE} --set Persistence.StorageClass=aws-efs
                                                            kubectl get svc
                                                        '''
                                                    }
                                                }
                                            }
                                        }catch(error) {
                                            throw error
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                stage('Deploy to Onprem kubernetes') {
                    when {
                        anyOf {
                            expression { params.INSTALL_CHART == 'YES' && params.PRODUCT == 'XL Release' && params.PLATFORM == 'Onprem' }
                            expression { params.INSTALL_CHART == 'YES' && params.PRODUCT == 'XL Deploy' && params.PLATFORM == 'Onprem' }
                        }
                    }
                    steps {
                        script {
                            withCredentials([usernamePassword(credentialsId: 'kube-love', passwordVariable: 'password', usernameVariable: 'username')]) {
                                withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: 'kubernetes-admin@kubernetes', credentialsId: 'kube-love-config', namespace: 'xlpipeline', serverUrl: 'https://172.16.16.21:6443') {
                                    if ( params.PRODUCT == 'XL Release' ) {
                                        try {
                                            withCredentials([file(credentialsId: 'xl-release-license', variable: 'xl-release-license')]) {
                                                withCredentials([string(credentialsId: 'repository-keystore', variable: 'repository-keystore')]) {
                                                     withCredentials([string(credentialsId: 'keystore-passphrase', variable: 'keystore-passphrase')]) {
                                                             echo "Installing ${params.PRODUCT} on ${params.PLATFORM} platform"
                                                             sh '''
                                                                kubectl config set-context --current --namespace xlpipeline
                                                                helm install --generate-name *.tgz --set ingress.hosts[0]=${HOST_NAME_ONPREM_K8S} --set xlrLicense=${XLR_LICENSE} --set RepositoryKeystore=${REPOSITORY_KEYSTORE} --set KeystorePassphrase=${KEYSTORE_PASSPHRASE} --set postgresql.persistence.storageClass=nfs-client --set rabbitmq.persistence.storageClass=nfs-client --set Persistence.StorageClass=nfs-client
                                                                kubectl get svc
                                                             '''
                                                    }
                                                }
                                            }
                                        }catch(error) {
                                            throw error
                                        }
                                    }else {
                                        try {
                                            withCredentials([file(credentialsId: 'xl-deploy-license', variable: 'xl-deploy-license')]) {
                                                withCredentials([string(credentialsId: 'repository-keystore', variable: 'repository-keystore')]) {
                                                    withCredentials([string(credentialsId: 'keystore-passphrase', variable: 'keystore-passphrase')]) {
                                                        echo "Installing ${params.PRODUCT} on ${params.PLATFORM} platform"
                                                        sh '''
                                                            kubectl config set-context --current --namespace xlpipeline
                                                            helm install --generate-name *.tgz --set ingress.hosts[0]=${HOST_NAME_ONPREM_K8S} --set xldLicense=${XLD_LICENSE} --set RepositoryKeystore=${REPOSITORY_KEYSTORE} --set KeystorePassphrase=${KEYSTORE_PASSPHRASE} --set postgresql.persistence.storageClass=nfs-client --set rabbitmq.persistence.storageClass=nfs-client --set Persistence.StorageClass=nfs-client
                                                            kubectl get svc
                                                        '''
                                                    }
                                                }
                                            }
                                        }catch(error) {
                                            throw error
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
