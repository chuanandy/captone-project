{{- define "api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "api.fullname" -}}
{{- printf "%s-%s" (include "api.name" .) .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "api.serviceAccountName" -}}
{{- default (include "api.fullname" .) .Values.serviceAccountName -}}
{{- end -}}
