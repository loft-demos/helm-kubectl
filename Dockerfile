FROM alpine:3.20

ARG KUBE_VERSION
ARG HELM_VERSION
ARG TARGETOS
ARG TARGETARCH
ARG YQ_VERSION
ARG VCLUSTER_VERSION
ARG AKUITY_CLI_VERSION

RUN apk -U upgrade \
    && apk add --no-cache ca-certificates bash git openssh curl gettext jq \
    && wget -q https://github.com/loft-sh/vcluster/releases/download/v${VCLUSTER_VERSION}/vcluster-${TARGETOS}-${TARGETARCH} -O /usr/local/bin/vcluster \
    && wget -q https://dl.k8s.io/release/v${KUBE_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -O /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar -xzO ${TARGETOS}-${TARGETARCH}/helm > /usr/local/bin/helm \
    && wget -q https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${TARGETOS}_${TARGETARCH} -O /usr/local/bin/yq \
    && wget -q "https://dl.akuity.io/akuity-cli/v${AKUITY_CLI_VERSION}/${TARGETOS}/${TARGETARCH}/akuity" -O /usr/local/bin/akuity  \
    && chmod +x /usr/local/bin/vcluster /usr/local/bin/helm /usr/local/bin/kubectl /usr/local/bin/yq /usr/local/bin/akuity \
    && mkdir /config \
    && chmod g+rwx /config /root \
    && kubectl version --client \
    && helm version \
    && akuity version  --short \
    && vcluster version \
    && uname -a

WORKDIR /config

CMD bash
