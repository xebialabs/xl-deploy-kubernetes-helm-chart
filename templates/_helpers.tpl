{{/* vim: set filetype=mustache: */}}

{{- define "postgresql.subchart" -}}
{{ include "postgresql.primary.fullname" (merge .Subcharts.postgresql (dict "nameOverride" "postgresql")) }}
{{- end -}}

{{- define "rabbitmq.subchart" -}}
{{ include "common.names.fullname" (merge .Subcharts.rabbitmq (dict "nameOverride" "rabbitmq")) }}
{{- end -}}

{{/*
Return the proper image name
{{ include "common.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" .Values.global "context" .) }}
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
        {{ randAlphaNum 10 }}
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
            {{- printf "%s://%s" $protocol $hostname }}
        {{- else -}}
            {{- print "" }}
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
            jdbc:postgresql://{{ include "postgresql.subchart" . }}:{{ .Values.postgresql.service.port }}/xld-db
        {{- end -}}
    {{- end -}}
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
            jdbc:postgresql://{{ include "postgresql.subchart" . }}:{{ .Values.postgresql.service.port }}/xld-report-db
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
            xld-report
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
            xld-report
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
{{- if .Values.AdminPassword -}}
{{- $messages = append $messages (include "validate.existing.secret" (dict "value" .Values.AdminPassword "context" $) ) -}}
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
deploy: keystore.license
    The `license` is empty. It is mandatory to set if `licenseAcceptEula` is disabled.
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "render.secret-name" -}}
  {{- if .value -}}
    {{- if kindIs "map" .value -}}
{{ .value.valueFrom.secretKeyRef.name }}
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
{{ include "secrets.key" (dict "secretRef" .Values.secretObjectRef "default" "defaultValue") }}

Params:
  - secretRef - dict - Required - Name of the 'Secret' resource where the password is stored.
  - default - String - Required - Default value if, there is no secret reference under secretRef
*/}}
{{- define "secrets.key" -}}
{{- if and .secretRef (not (kindIs "string" .secretRef)) -}}
{{ .secretRef.valueFrom.secretKeyRef.key }}
{{- else if kindIs "string" .secretRef -}}
{{ .default }}
{{- else -}}
{{- fail "Invalid argument value to function secrets.key" -}}
{{- end -}}
{{- end -}}

{{- define "render.value-secret" -}}
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

{{- define "render.value-if-not-secret" -}}
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
Returns whether a previous generated secret already exists

Usage:
{{ include "secrets.exists" (dict "secret" "secret-name" "context" $) }}

Params:
  - secret - String - Required - Name of the 'Secret' resource where the password is stored.
  - context - Context - Required - Parent context.
*/}}
{{- define "secrets.exists" -}}
{{- $secret := (lookup "v1" "Secret" .context.Release.Namespace .secret) -}}
{{- if $secret -}}
  {{- true -}}
{{- end -}}
{{- end -}}

{{- define "validate.existing.secret" -}}
  {{- if .value -}}
    {{- if not (kindIs "string" .value) -}}
      {{- if .value.valueFrom.secretKeyRef.name }}
        {{- $exists := include "secrets.exists" (dict "secret" .value.valueFrom.secretKeyRef.name "context" .context) -}}
        {{- if not $exists -}}
            secret: {{ .value.valueFrom.secretKeyRef.name }}
                The `{{ .value.valueFrom.secretKeyRef.name }}` does not exist.
        {{- end -}}
      {{- else -}}
          secret: unknown
              The `{{ .value }}` is not reference to secret.
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end }}
