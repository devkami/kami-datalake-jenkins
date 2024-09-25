FROM jenkins/jenkins:lts

USER root

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Instalar Docker CLI (para interagir com o Docker da máquina host)
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get install -y docker-ce-cli

# Instalar plugins do Jenkins
RUN jenkins-plugin-cli --plugins \
    workflow-aggregator \
    git \
    amazon-ecr \
    aws-credentials \
    docker-workflow \
    blueocean

USER jenkins

# Copiar scripts de inicialização personalizados, se necessário
# COPY init.groovy.d/ /var/jenkins_home/init.groovy.d/

# Expor a porta do Jenkins
EXPOSE 8080
