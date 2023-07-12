{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "xl-deploy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "xl-deploy.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "xl-deploy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Remove Nginx regex from NOTES.txt.
*/}}
{{- define "path.fullname" -}}
{{- $ingressclass := index .Values "ingress" "annotations" "kubernetes.io/ingress.class" }}
{{- if and .Values.ingress.Enabled }}
{{- if contains $ingressclass "nginx" }}
{{- $name := ( split "(" .Values.ingress.path)._0 -}}
{{- printf "%s" $name -}}/
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
shared central config encrypt key will be generated if not defined in values.yaml.
*/}}
{{- define "central-config.encrypt-key" -}}
{{- default "n8FfQW0m@L,(74b" .Values.CentralConfigEncryptKey -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "common.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Get the Deploy Master hostname suffix
*/}}
{{- define "deploy.masterHostnameSuffix" -}}
{{- if .Values.deploy.master.podServiceTemplate.enabled -}}
{{- include "common.tplvalues.render" (dict "value" .Values.deploy.master.podServiceTemplate.overrideHostnameSuffix "context" $) }}
{{- else -}}
.{{ template "xl-deploy.fullname" . }}-master.{{.Release.Namespace}}.svc.cluster.local
{{- end -}}
{{- end -}}

{{- define "deploy.masterHostname" -}}
{{- if .Values.deploy.master.podServiceTemplate.overrideHostnames }}
{{- $overrideHostname := index .Values.deploy.master.podServiceTemplate.overrideHostnames .podNumber }}
{{- include "common.tplvalues.render" (dict "value" $overrideHostname "context" .) }}
{{- else }}
{{- include "common.tplvalues.render" (dict "value" .Values.deploy.master.podServiceTemplate.overrideHostname "context" .) }}
{{- end }}
{{- end -}}

{{/*
Get the Deploy Worker hostname suffix
*/}}
{{- define "deploy.workerHostnameSuffix" -}}
{{- if .Values.deploy.worker.podServiceTemplate.enabled -}}
{{- include "common.tplvalues.render" (dict "value" .Values.deploy.worker.podServiceTemplate.overrideHostnameSuffix "context" $) }}
{{- else -}}
.{{ template "xl-deploy.fullname" . }}-worker.{{.Release.Namespace}}.svc.cluster.local
{{- end -}}
{{- end -}}

{{- define "deploy.workerHostname" -}}
{{- if .Values.deploy.worker.podServiceTemplate.overrideHostnames }}
{{- $overrideHostname := index .Values.deploy.worker.podServiceTemplate.overrideHostnames .podNumber }}
{{- include "common.tplvalues.render" (dict "value" $overrideHostname "context" .) }}
{{- else }}
{{- include "common.tplvalues.render" (dict "value" .Values.deploy.worker.podServiceTemplate.overrideHostname "context" .) }}
{{- end }}
{{- end -}}

{{/*
Get the Deploy Worker hostname suffix
*/}}
{{- define "deploy.workerMasters" -}}
{{- $serviceTemplate := .Values.deploy.master.podServiceTemplate }}
{{- if $serviceTemplate.enabled }}
{{- $maxServices := 1 }}
{{- if or (ne $serviceTemplate.serviceMode "SingleService") (and (eq $serviceTemplate.type "ClusterIP") (has "None" $serviceTemplate.clusterIPs)) }}
{{- $maxServices = int .Values.XldMasterCount }}
{{- end }}
{{- range $podNumber := untilStep 0 $maxServices 1 }}
{{- $newValues := merge (dict "podNumber" $podNumber) $ }}
{{- $masterHostname := include "deploy.masterHostname" $newValues }}
{{- $masterPort := $serviceTemplate.nodePorts.deployAkka }}
{{- if contains $serviceTemplate.serviceMode "SingleHostname;MultiService" }}
{{- $masterPort = add $masterPort $podNumber }}
{{- end }}
      -master "{{ $masterHostname }}{{ include "deploy.masterHostnameSuffix" $newValues }}:{{ $masterPort }}" \
{{- end }}
{{- else }}
      -master "{{ template "xl-deploy.fullname" . }}-master.{{.Release.Namespace}}.svc.cluster.local:8180" \
{{- end }}
{{- end -}}
