pipeline {
  agent any
  environment {
    PLATFORM = "linux/amd64,linux/arm64,linux/arm/v7"
    DOCKER_PASSWORD = "${env.DOCKER_PASSWORD}"
    TENCENT_DOCKER_USERNAME = "${env.TENCENT_DOCKER_USERNAM}"
    DOCKER_CLI_EXPERIMENTAL = "enabled"
    BUILDX_IMAGE= "dockerpracticesig/buildkit:master-tencent"

    SOURCE_DOCKER_USERNAME = "${env.DOCKER_USERNAME}"
    SOURCE_DOCKER_PASSWORD = "${env.DOCKER_PASSWORD}"
    SOURCE_DOCKER_REGISTRY = "registry.hub.docker.com"

    // SOURCE_DOCKER_REGISTRY = "mirror.ccs.tencentyun.com"

    DEST_DOCKER_USERNAME = "${env.TENCENT_DOCKER_USERNAM}"
    DEST_DOCKER_PASSWORD = "${env.DOCKER_PASSWORD}"
    DEST_DOCKER_REGISTRY = "ccr.ccs.tencentyun.com"

    REGISTRY_NAMESPACE = "khs1994"
  }
  stages {
    stage("os-manifest"){
      steps {
        sh "cat /etc/os-release"
      }
    }
    // stage('update docker to latest'){
    //   steps {
    //     sh "docker version"
    //     sh "docker info"

    //     sh "curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -"
    //     sh "sudo add-apt-repository \"deb [arch=amd64] https://mirrors.cloud.tencent.com/docker-ce/linux/ubuntu \$(lsb_release -cs) stable\""
    //     sh "sudo apt update"
    //     sh "sudo apt install docker-ce docker-ce-cli containerd.io -y"

    //     sh "docker version"
    //     sh "docker info"
    //   }
    // }
    // stage('setting docker'){
    //   steps {
    //     sh "cat /etc/docker/daemon.json | true"
    //     // sh "sudo mkdir -p /etc/docker"
    //     // sh "echo {\"registry-mirrors\": [\"https://mirror.ccs.tencentyun.com\"]} | sudo tee /etc/docker/daemon.json"
    //     // sh "cat /etc/docker/daemon.json | true"
    //     // sh "sudo systemctl restart docker"
    //     sh "sudo systemctl cat docker"
    //     sh "docker info"
    //   }
    // }
    // stage('setup-buildx'){
    //   steps {
    //     sh "docker buildx version"
    //     sh "docker buildx ls"
    //     sh "sudo ls /proc/sys/fs | true"
    //     sh "sudo ls /proc/sys/fs/binfmt_misc | true"
    //     sh "cat /proc/sys/fs/binfmt_misc/qemu-aarch64 | true"

    //     sh "sudo apt install qemu-user -y"
    //     sh "ls /proc/sys/fs/binfmt_misc | true"
    //     sh "cat /proc/sys/fs/binfmt_misc/qemu-aarch64 | true"

    //     // sh "sudo mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc | true"

    //     sh "docker run --rm --privileged tonistiigi/binfmt:latest --install all | true"
    //     sh "docker buildx create --use --name mybuilder --driver-opt image=${BUILDX_IMAGE}"
    //     sh "docker buildx ls"

    //     sh "docker buildx inspect --bootstrap"
    //   }
    // }

    stage('同步镜像') {
      steps {
        sh "curl -L -O https://gitee.com/khs1994-docker/lnmp/raw/20.10/dockerfile/sync/docker-image-sync.json"

        sh '''
        docker run -i --rm \
            -e DEST_DOCKER_USERNAME=\${TENCENT_DOCKER_USERNAME} \
            -e DEST_DOCKER_PASSWORD=\${DOCKER_PASSWORD} \
            -e SOURCE_DOCKER_USERNAME \
            -e SOURCE_DOCKER_PASSWORD \
            -e SOURCE_DOCKER_REGISTRY \
            -e DEST_DOCKER_REGISTRY=\${DEST_DOCKER_REGISTRY} \
            -e DEST_NAMESPACE=\${REGISTRY_NAMESPACE} \
            -e CI=true \
            -e CONFIG_URL=https://gitee.com/khs1994-docker/lnmp/raw/20.10/dockerfile/sync/docker-image-sync.json \
            -v \$PWD/docker-image-sync.json:/docker-entrypoint.d/docker-image-sync.json \
            khs1994/docker-image-sync
        '''
      }
    }


  }
}
