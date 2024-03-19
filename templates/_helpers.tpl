{{/* vim: set filetype=mustache: */}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
{{ include "deploy.names.customname" ( dict "overrideName" .Values.path.to.the.overrideName "suffix" "suffixValue" ) }}
*/}}
{{- define "deploy.names.customname" -}}
{{- if .overrideName -}}
{{- .overrideName | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if .context.Values.fullnameOverride -}}
{{- printf "%s%s" .Values.fullnameOverride .suffix | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .context.Chart.Name .context.Values.nameOverride -}}
{{- if contains $name .context.Release.Name -}}
{{- printf "%s%s" .context.Release.Name .suffix | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s%s" .context.Release.Name $name .suffix | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "deploy.names.centralConfiguration" -}}
{{- if eq .Values.k8sSetup.platform "Openshift" -}}
{{ include "deploy.names.customname" (dict "overrideName" .Values.centralConfiguration.overrideName "suffix" "-ocp-cc-server" "context" .) }}
{{- else -}}
{{ include "deploy.names.customname" (dict "overrideName" .Values.centralConfiguration.overrideName "suffix" "-cc-server" "context" .) }}
{{- end -}}
{{- end -}}

{{- define "deploy.names.master" -}}
{{- if eq .Values.k8sSetup.platform "Openshift" -}}
{{ include "deploy.names.customname" (dict "overrideName" .Values.master.overrideName "suffix" "-ocp-master" "context" .) }}
{{- else -}}
{{ include "deploy.names.customname" (dict "overrideName" .Values.master.overrideName "suffix" "-master" "context" .) }}
{{- end -}}
{{- end -}}

{{- define "deploy.names.worker" -}}
{{- if eq .Values.k8sSetup.platform "Openshift" -}}
{{ include "deploy.names.customname" (dict "overrideName" .Values.worker.overrideName "suffix" "-ocp-worker" "context" .) }}
{{- else -}}
{{ include "deploy.names.customname" (dict "overrideName" .Values.worker.overrideName "suffix" "-worker" "context" .) }}
{{- end -}}
{{- end -}}

{{- define "postgresql.subchart" -}}
{{ include "postgresql.v1.primary.fullname" (merge .Subcharts.postgresql (dict "nameOverride" "postgresql")) }}
{{- end -}}

{{- define "deploy.postgresql.service.port" -}}
{{ include "postgresql.v1.service.port" (dict "Values" (dict "global" .Values.global "primary" .Values.postgresql.primary)) }}
{{- end -}}

{{- define "rabbitmq.subchart" -}}
{{ include "common.names.fullname" (merge .Subcharts.rabbitmq (dict "nameOverride" "rabbitmq")) }}
{{- end -}}

{{/*
Return the proper image name
{{ include "deploy.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" .Values.global "context" .) }}
*/}}
{{- define "deploy.images.image" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $tag := (tpl .imageRoot.tag .context) | toString -}}
{{- if .global }}
    {{- if .global.imageRegistry }}
     {{- $registryName = .global.imageRegistry -}}
    {{- end -}}
{{- end -}}
{{- if $registryName }}
{{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- else -}}
{{- printf "%s:%s" $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "deploy.imagePullSecrets" -}}
{{- if or .Values.global.imagePullSecrets .Values.master.image.pullSecrets .Values.worker.image.pullSecrets .Values.centralConfiguration.image.pullSecrets .Values.busyBox.image.pullSecrets }}
{{ include "common.images.renderPullSecrets" (dict "images" (list .Values.master.image .Values.worker.image .Values.centralConfiguration.image .Values.busyBox.image) "context" $) }}
{{- end -}}
{{- end -}}

{{/*
BusyBox image
*/}}
{{- define "deploy.busyBox.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.busyBox.image "global" .Values.global) }}
{{- end }}

{{/*
shared central config encrypt key will be generated if not defined in values.yaml.
*/}}
{{- define "deploy.encryptKey" -}}
{{- default "n8FfQW0m@L,(74b" .Values.centralConfiguration.encryptKey -}}
{{- end -}}

{{/*
 Create the name of the service account to use
 */}}
{{- define "deploy.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "deploy.secretPassword" -}}
    {{- if .Values.auth.adminPassword -}}
        {{ .Values.auth.adminPassword }}
    {{- else -}}
        {{- $secretObj := (lookup "v1" "Secret" (include "common.names.namespace" .) (include "common.names.fullname" .)) | default dict }}
        {{- $secretData := (get $secretObj "data") | default dict }}
        {{- (get $secretData "deployPassword") | b64dec | default (randAlphaNum 10) }}
    {{- end -}}
{{- end -}}

{{/*
Remove Nginx regex from path.
*/}}
{{- define "deploy.path.fullname" -}}
    {{- if and .Values.ingress.enabled }}
        {{- $ingressclass := index .Values "ingress" "annotations" "kubernetes.io/ingress.class" }}
        {{- if contains $ingressclass "nginx" }}
            {{- $name := ( split "(" .Values.ingress.path)._0 }}
            {{- if $name }}
                {{- printf "%s/" $name }}
            {{- else }}
                {{- print "" }}
            {{- end }}
        {{- else -}}
            {{- printf "%s/" .Values.ingress.path }}
        {{- end -}}
    {{- else -}}
        {{- if .Values.route.enabled }}
            {{- printf "%s/" .Values.route.path }}
        {{- else -}}
            {{- print "" }}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Get the server URL
*/}}
{{- define "deploy.serverUrl" -}}
    {{- $protocol := "http" }}
    {{- if .Values.ingress.enabled }}
        {{- if .Values.ingress.tls }}
            {{- $protocol = "https" }}
        {{- end }}
        {{- $ingressclass := index .Values "ingress" "annotations" "kubernetes.io/ingress.class" }}
        {{- $hostname := .Values.ingress.hostname }}
        {{- if and (contains $ingressclass "nginx") (ne .Values.ingress.path "/") }}
            {{- $path := include "deploy.path.fullname" $ }}
            {{- if $path }}
                {{- printf "%s://%s%s" $protocol $hostname $path }}
            {{- else }}
                {{- printf "%s://%s" $protocol $hostname }}
            {{- end }}
        {{- else }}
            {{- printf "%s://%s" $protocol $hostname }}
        {{- end }}
    {{- else -}}
        {{- if .Values.route.enabled }}
            {{- if .Values.route.tls.enabled }}
                {{- $protocol = "https" }}
            {{- end }}
            {{- $hostname := .Values.route.hostname }}
            {{- $path := include "deploy.path.fullname" $ }}
            {{- if $path }}
                {{- printf "%s://%s%s" $protocol $hostname $path }}
            {{- else }}
                {{- printf "%s://%s" $protocol $hostname }}
            {{- end }}
        {{- else -}}
            {{- $path := include "deploy.path.fullname" $ }}
            {{- if $path }}
                {{- printf "%s://%s%s" ( include "deploy.masterLbUrlWithoutPort" . ) $path }}
            {{- else }}
                {{- printf "%s://%s" ( include "deploy.masterLbUrlWithoutPort" . ) }}
            {{- end }}
        {{- end }}
    {{- end }}
{{- end -}}

{{/*
Get the main db URL
*/}}
{{- define "deploy.mainDbUrl" -}}
    {{- if .Values.external.db.enabled -}}
        {{- .Values.external.db.main.url -}}
    {{- else -}}
        {{- if .Values.postgresql.install -}}
            jdbc:postgresql://{{ include "postgresql.subchart" . }}:{{ include "deploy.postgresql.service.port" . }}/xld-db
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Use the service name with namespace. In case of ssl enabled the SNI check will fail without ".".
*/}}
{{- define "deploy.hostname" -}}
    {{- if .Values.ingress.enabled }}
        {{- .Values.ingress.hostname }}
    {{- else -}}
        {{- if .Values.route.enabled }}
            {{- .Values.route.hostname }}
        {{- else -}}        
            {{- include "deploy.masterLbName" . }}
        {{- end }}
    {{- end }}
{{- end -}}

{{/*
Get the Deploy LB service name
*/}}
{{- define "deploy.masterLbName" -}}
{{ include "common.names.fullname" . }}-lb.{{ include "common.names.namespace" . }}
{{- end -}}

{{- define "deploy.masterLbService" -}}
{{ include "common.names.fullname" . }}-lb
{{- end -}}

{{/*
Get the Deploy LB service URL
*/}}
{{- define "deploy.masterLbUrl" -}}
{{- if .Values.ssl.enabled }}
{{ include "deploy.masterLbUrlWithoutPort" . }}:{{ .Values.master.services.lb.ports.deployHttps }}
{{- else -}}
{{ include "deploy.masterLbUrlWithoutPort" . }}:{{ .Values.master.services.lb.ports.deployHttp }}
{{- end -}}
{{- end -}}

{{- define "deploy.masterLbUrlWithoutPort" -}}
{{- if .Values.ssl.enabled }}
https://{{ include "deploy.masterLbName" . }}
{{- else -}}
http://{{ include "deploy.masterLbName" . }}
{{- end -}}
{{- end -}}

{{/*
Get the Deploy Master hostname suffix
*/}}
{{- define "deploy.masterHostnameSuffix" -}}
{{- if .Values.master.podServiceTemplate.enabled -}}
{{- include "common.tplvalues.render" (dict "value" .Values.master.podServiceTemplate.overrideHostnameSuffix "context" $) }}
{{- else -}}
.{{ include "deploy.names.master" . }}.{{ include "common.names.namespace" . }}.svc.cluster.local
{{- end -}}
{{- end -}}

{{- define "deploy.clusterMasterHostnameSuffix" -}}
{{- if .Values.master.podServiceTemplate.enabled -}}
{{- if .Values.deploy.master.clusterNodeHostnameSuffix -}}
{{- include "common.tplvalues.render" (dict "value" .Values.deploy.master.clusterNodeHostnameSuffix "context" $) }}
{{- else -}}
{{- include "common.tplvalues.render" (dict "value" .Values.master.podServiceTemplate.overrideHostnameSuffix "context" $) }}
{{- end -}}
{{- else -}}
.{{ include "deploy.names.master" . }}.{{ include "common.names.namespace" . }}.svc.cluster.local
{{- end -}}
{{- end -}}

{{- define "deploy.masterHostname" -}}
{{- if .Values.master.podServiceTemplate.enabled -}}
{{- if .Values.master.podServiceTemplate.overrideHostnames }}
{{- $overrideHostname := index .Values.master.podServiceTemplate.overrideHostnames .podNumber }}
{{- include "common.tplvalues.render" (dict "value" $overrideHostname "context" .) }}
{{- else }}
{{- include "common.tplvalues.render" (dict "value" .Values.master.podServiceTemplate.overrideHostname "context" .) }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Get the Deploy Worker hostname suffix
*/}}
{{- define "deploy.workerHostnameSuffix" -}}
{{- if .Values.worker.podServiceTemplate.enabled -}}
{{- include "common.tplvalues.render" (dict "value" .Values.worker.podServiceTemplate.overrideHostnameSuffix "context" $) }}
{{- else -}}
.{{ include "deploy.names.worker" . }}.{{ include "common.names.namespace" . }}.svc.cluster.local
{{- end -}}
{{- end -}}

{{- define "deploy.workerHostname" -}}
{{- if .Values.worker.podServiceTemplate.enabled -}}
{{- if .Values.worker.podServiceTemplate.overrideHostnames }}
{{- $overrideHostname := index .Values.worker.podServiceTemplate.overrideHostnames .podNumber }}
{{- include "common.tplvalues.render" (dict "value" $overrideHostname "context" .) }}
{{- else }}
{{- include "common.tplvalues.render" (dict "value" .Values.worker.podServiceTemplate.overrideHostname "context" .) }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
Get the Deploy Worker hostname suffix
*/}}
{{- define "deploy.workerMasters" -}}
{{- $serviceTemplate := .Values.master.podServiceTemplate }}
{{- if $serviceTemplate.enabled }}
{{- $maxServices := 1 }}
{{- if or (ne $serviceTemplate.serviceMode "SingleService") (and (eq $serviceTemplate.type "ClusterIP") (has "None" $serviceTemplate.clusterIPs)) }}
{{- $maxServices = int .Values.master.replicaCount }}
{{- end }}
{{- range $podNumber := untilStep 0 $maxServices 1 }}
{{- $newValues := merge (dict "podNumber" $podNumber) $ }}
{{- $masterHostname := include "deploy.masterHostname" $newValues }}
{{- $masterPort := $serviceTemplate.nodePorts.deployPekko }}
{{- if contains $serviceTemplate.serviceMode "SingleHostname;MultiService" }}
{{- $masterPort = add $masterPort $podNumber }}
{{- end }}
  -master "{{ $masterHostname }}{{ include "deploy.masterHostnameSuffix" $newValues }}:{{ $masterPort }}" \
{{- end }}
{{- else }}
{{- $replicaCount := int .Values.master.replicaCount }}
{{- $namespace := include "common.names.namespace" . }}
{{- $serviceName := include "deploy.names.master" .}}
{{- $deployPekkoPort := .Values.master.services.pekko.ports.deployPekko}}
{{- range $podNumber := untilStep 0 $replicaCount 1 -}}
  -master "{{ $serviceName }}-{{ $podNumber }}.{{ $serviceName }}.{{ $namespace }}.svc.cluster.local:{{ $deployPekkoPort }}" \
{{- end }}
{{- end }}
{{- end -}}

{{/*
Get the main db username
*/}}
{{- define "deploy.mainUsername" -}}
    {{- if .Values.external.db.enabled -}}
        {{ .Values.external.db.main.username }}
    {{- else -}}
        {{- if .Values.postgresql.install -}}
            xld
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Get the main db password
*/}}
{{- define "deploy.mainPassword" -}}
    {{- if .Values.external.db.enabled -}}
        {{ .Values.external.db.main.password }}
    {{- else -}}
        {{- if .Values.postgresql.install -}}
            xld
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Get the report db URL
*/}}
{{- define "deploy.reportDbUrl" -}}
    {{- if .Values.external.db.enabled -}}
        {{ .Values.external.db.report.url }}
    {{- else -}}
        {{- if .Values.postgresql.install -}}
            {{- if .Values.postgresql.hasReport -}}
            jdbc:postgresql://{{ include "postgresql.subchart" . }}:{{ include "deploy.postgresql.service.port" . }}/xld-report-db
            {{- else -}}
            jdbc:postgresql://{{ include "postgresql.subchart" . }}:{{ include "deploy.postgresql.service.port" . }}/xld-db
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Get the report db username
*/}}
{{- define "deploy.reportUsername" -}}
    {{- if .Values.external.db.enabled -}}
        {{ .Values.external.db.report.username }}
    {{- else -}}
        {{- if .Values.postgresql.install -}}
            {{- if .Values.postgresql.hasReport -}}
            xld-report
            {{- else -}}
            xld
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Get the report db password
*/}}
{{- define "deploy.reportPassword" -}}
    {{- if .Values.external.db.enabled -}}
        {{ .Values.external.db.report.password }}
    {{- else -}}
        {{- if .Values.postgresql.install -}}
            {{- if .Values.postgresql.hasReport -}}
            xld-report
            {{- else -}}
            xld
            {{- end -}}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Get the mq URL
*/}}
{{- define "deploy.mqUrl" -}}
    {{- if .Values.external.mq.enabled -}}
        {{ .Values.external.mq.url }}
    {{- else -}}
        {{- if .Values.rabbitmq.install -}}
            amqp://{{ include "rabbitmq.subchart" . }}:{{ .Values.rabbitmq.service.ports.amqp }}/%2F
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Get the mq queue name
*/}}
{{- define "deploy.mqQueueName" -}}
    {{- if .Values.external.mq.enabled -}}
        {{ .Values.external.mq.queueName }}
    {{- else -}}
        {{- if .Values.rabbitmq.install -}}
            xld-tasks-queue
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Get the mq username
*/}}
{{- define "deploy.mqUsername" -}}
    {{- if .Values.external.mq.enabled -}}
        {{ .Values.external.mq.username }}
    {{- else -}}
        {{- if .Values.rabbitmq.install -}}
            {{ .Values.rabbitmq.auth.username }}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Get the mq password
*/}}
{{- define "deploy.mqPassword" -}}
    {{- if .Values.external.mq.enabled -}}
        {{ .Values.external.mq.password }}
    {{- else -}}
        {{- if .Values.rabbitmq.install -}}
            {{ .Values.rabbitmq.auth.password }}
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Get the mq class name
*/}}
{{- define "deploy.mqDriverClassName" -}}
    {{- if .Values.external.mq.driverClassName -}}
        {{ .Values.external.mq.driverClassName }}
    {{- else -}}
        {{- if .Values.rabbitmq.install -}}
             "com.rabbitmq.jms.admin.RMQConnectionFactory"
        {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "deploy.validateValues" -}}
{{- $messages := list -}}
{{- $messages = append $messages (include "deploy.validateValues.ingress.tls" .) -}}
{{- $messages = append $messages (include "deploy.validateValues.keystore.passphrase" .) -}}
{{- $messages = append $messages (include "deploy.validateValues.license" .) -}}
{{- if .Values.auth.adminPassword -}}
{{- $messages = append $messages (include "validate.existing.secret" (dict "value" .Values.auth.adminPassword "context" $) ) -}}
{{- end -}}
{{- $messages = without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if and $message .Values.k8sSetup.validateValues -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}

{{- end -}}

{{/*
Validate values of Deploy - TLS configuration for Ingress
*/}}
{{- define "deploy.validateValues.ingress.tls" -}}
{{- if and .Values.ingress.enabled .Values.ingress.tls (not (include "common.ingress.certManagerRequest" ( dict "annotations" .Values.ingress.annotations ))) (not .Values.ingress.selfSigned) (empty .Values.ingress.extraTls) }}
deploy: ingress.tls
    You enabled the TLS configuration for the default ingress hostname but
    you did not enable any of the available mechanisms to create the TLS secret
    to be used by the Ingress Controller.
    Please use any of these alternatives:
      - Use the `ingress.extraTls` and `ingress.secrets` parameters to provide your custom TLS certificates.
      - Relay on cert-manager to create it by setting the corresponding annotations
      - Relay on Helm to create self-signed certificates by setting `ingress.selfSigned=true`
{{- end -}}
{{- end -}}

{{/*
Validate values of Deploy - keystore.passphrase
*/}}
{{- define "deploy.validateValues.keystore.passphrase" -}}
{{- if not .Values.keystore.passphrase }}
deploy: keystore.passphrase
    The `keystore.passphrase` is empty. It is mandatory to set.
{{- end -}}
{{- end -}}

{{/*
Validate values of Deploy - license and licenseAcceptEula
*/}}
{{- define "deploy.validateValues.license" -}}
{{- if not .Values.licenseAcceptEula }}
{{- if not .Values.license }}
deploy: license or licenseAcceptEula
    The `license` is empty. It is mandatory to set if `licenseAcceptEula` is disabled.
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "render.secret-name" -}}
  {{- if .value -}}
    {{- if kindIs "map" .value -}}
{{- tpl .value.valueFrom.secretKeyRef.name .context }}
    {{- else if kindIs "string" .value -}}
{{ .defaultName }}
    {{- else -}}
{{- fail "Invalid argument value to function render.secret-name" -}}
    {{- end -}}
  {{- else -}}
    {{- if .default -}}
{{ .defaultName }}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
Returns the name of the secret key if exists, in other case it gives the default value

Usage:
{{ include "secrets.key" (dict "secretRef" .Values.secretObjectRef "default" "defaultValue" "context" $) }}

Params:
  - secretRef - dict - Required - Name of the 'Secret' resource where the password is stored.
  - default - String - Required - Default value if, there is no secret reference under secretRef
*/}}
{{- define "secrets.key" -}}
{{- if and .secretRef (kindIs "map" .secretRef) -}}
{{- tpl .secretRef.valueFrom.secretKeyRef.key .context }}
{{- else if kindIs "string" .secretRef -}}
{{ .default }}
{{- else -}}
{{- fail "Invalid argument value to function secrets.key" -}}
{{- end -}}
{{- end -}}

{{- define "render.value-secret" -}}
{{- if and .sourceEnabled .source (kindIs "map" .source) -}}
  {{- tpl (.source | toYaml) .context }}
{{- else -}}
  {{- if .value -}}
    {{- if kindIs "string" .value -}}
valueFrom:
  secretKeyRef:
    name: {{ .defaultName }}
    key: {{ .defaultKey }}
    {{- else -}}
        {{- tpl (.value | toYaml) .context }}
    {{- end -}}
  {{- else -}}
    {{- if .default -}}
valueFrom:
  secretKeyRef:
    name: {{ .defaultName }}
    key: {{ .defaultKey }}
    {{- end -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{- define "render.value-if-not-secret" -}}
{{- if or (not .source) (not (kindIs "map" .source)) -}}
    {{- if .value -}}
        {{- if kindIs "string" .value -}}
            {{ .key }}: {{ .value | b64enc | quote }}
        {{- end -}}
    {{- else -}}
      {{- if .default -}}
        {{ .key }}: {{ .default | b64enc | quote }}
      {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{- define "render.value-if-not-secret-decode" -}}
    {{- if .value -}}
        {{- if kindIs "string" .value -}}
            {{ .key }}: {{ .value | b64dec | b64enc | quote }}
        {{- end -}}
    {{- else -}}
      {{- if .default -}}
        {{ .key }}: {{ .default | b64dec | b64enc | quote }}
      {{- end -}}
    {{- end -}}
{{- end -}}

{{/*
Returns whether a previous generated secret already exists.
On --dry-run this is always returning true (done by checking if release namespace exists)

Usage:
{{ include "secrets.exists" (dict "secret" "secret-name" "context" $) }}

Params:
  - secret - String - Required - Name of the 'Secret' resource where the password is stored.
  - context - Context - Required - Parent context.
*/}}
{{- define "secrets.exists" -}}
{{- $namespaceName := include "common.names.namespace" .context -}}
{{- $namespace := (lookup "v1" "ServicAaccount" $namespaceName "") -}}
{{- if $namespace -}}
{{- $secret := (lookup "v1" "Secret" $namespaceName .secret) -}}
{{- if $secret -}}
true
{{- else -}}
false
{{- end -}}
{{- else -}}
true
{{- end -}}
{{- end -}}

{{- define "validate.existing.secret" -}}
  {{- if .value -}}
    {{- if kindIs "map" .value -}}
      {{- if .value.valueFrom.secretKeyRef.name -}}
        {{- $exists := include "secrets.exists" (dict "secret" .value.valueFrom.secretKeyRef.name "context" .context) -}}
        {{- if eq $exists "false" -}}
            secret: {{ .value.valueFrom.secretKeyRef.name }}:
                The secret `{{ .value.valueFrom.secretKeyRef.name }}` does not exist in namespace `{{ include "common.names.namespace" .context }}`.
        {{- end -}}
      {{- else -}}
          secret: unknown
              The `{{ .value }}` is not reference to secret.
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end }}
