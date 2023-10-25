FROM summerwind/actions-runner:latest

ENV RUNNER_ALLOW_RUNASROOT="1"

USER root

ENV TERRAFORM_VERSION=1.5.2
RUN apt-get update && apt-get install -y \
  bash \
  ca-certificates \
  curl \
  unzip \
  wget \
  zip \
  gettext-base \
  git \
  python3 \
  gpg

RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && mv terraform /usr/bin \
  && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/* \
  && rm -rf /var/tmp/*

RUN curl -LO https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

RUN apt-get -y install apt-transport-https ca-certificates gnupg \
  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
  && apt-get -y update && apt-get -y install google-cloud-cli

RUN apt-get -y install google-cloud-sdk-gke-gcloud-auth-plugin