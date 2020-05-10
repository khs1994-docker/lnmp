pipeline {
  agent any
  environment {
    PLATFORM = "linux/amd64,linux/arm64,linux/arm/v7"
    DOCKER_PASSWORD = "${env.DOCKER_PASSWORD}"
    TENCENT_DOCKER_USERNAME = "${env.TENCENT_DOCKER_USERNAM}"
    DOCKER_CLI_EXPERIMENTAL = "enabled"
    BUILDX_IMAGE= "dockerpracticesig/buildkit:master-tencent"

    LWPM_DIST_ONLY = 'true'
    LWPM_DOCKER_USERNAME = "${env.TENCENT_DOCKER_USERNAM}"
    LWPM_DOCKER_PASSWORD = "${env.DOCKER_PASSWORD}"
    LWPM_DOCKER_REGISTRY_MIRROR = "ccr.ccs.tencentyun.com"
    // 请修改此环境变量的值为 K8S 版本号
    LWPM_K8S_VERSION = "${env.LWPM_K8S_VERSION}"
  }
  stages {
    stage("os-manifest"){
      steps {
        sh "cat /etc/os-release"
      }
    }

    // stage('setup-pwsh') {
    //   steps {
    //     sh "pwsh || true"
    //     sh "wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb"
    //     sh "sudo dpkg -i packages-microsoft-prod.deb"
    //     sh "sudo apt-get update"
    //     sh "sudo apt-get install -y powershell"
    //   }
    // }

    // stage('lwpm') {
    //   steps {
    //     // sh "pwsh -c 'echo $env:LWPM_DIST_ONLY' "
    //     // sh "pwsh -c 'echo $env:LWPM_DOCKER_USERNAME' "
    //     // sh "pwsh -c 'echo $env:LWPM_DOCKER_PASSWORD' "
    //     // sh "git clone --depth=1 -b 19.03 https://github.com/khs1994-docker/lnmp"
    //     // sh "pwsh ./lnmp/kubernetes/bin/lwpm.ps1"
    //     sh "docker run -i --rm -e LWPM_DOCKER_USERNAME \
    //         -e LWPM_DOCKER_PASSWORD \
    //         -e LWPM_DOCKER_REGISTRY=mirror.ccs.tencentyun.com \
    //         -e CI=true \
    //         -v \$PWD/vendor:/root/lnmp/vendor \
    //         lwpm/lwpm \
    //         add kubernetes-node@\${LWPM_K8S_VERSION} \
    //             kubernetes-server@\${LWPM_K8S_VERSION} \
    //             --all-platform"

    //     sh "ls -R vendor"

    //     sh "docker run -i --rm  \
    //         -v \$PWD/vendor:/root/lnmp/vendor \
    //         -e CI=true \
    //         lwpm/lwpm \
    //         dist kubernetes-node@\${LWPM_K8S_VERSION} \
    //              kubernetes-server@\${LWPM_K8S_VERSION}"

    //     sh "ls -R vendor"

    //     sh "docker run -i --rm -e LWPM_DOCKER_USERNAME \
    //         -e LWPM_DOCKER_PASSWORD \
    //         -e LWPM_DOCKER_REGISTRY=\${LWPM_DOCKER_REGISTRY_MIRROR} \
    //         -e CI=true \
    //         -v \$PWD/vendor:/root/lnmp/vendor \
    //         lwpm/lwpm \
    //         push kubernetes-node@\${LWPM_K8S_VERSION} \
    //              kubernetes-server@\${LWPM_K8S_VERSION}"

    //     sh "ls -R vendor"
    //   }
    // }

    stage('同步镜像') {
      steps {
        sh "curl -L -O https://gitee.com/khs1994-docker/lnmp/raw/19.03/kubernetes/kubernetes-release/docker-image-sync.json"

        sh "sed -i \"s#K8S_VERSION#\${LWPM_K8S_VERSION}#g\" docker-image-sync.json"

        sh "cat docker-image-sync.json"

        sh "docker run -i --rm -e DEST_DOCKER_USERNAME=\${TENCENT_DOCKER_USERNAME} \
            -e DEST_DOCKER_PASSWORD=\${DOCKER_PASSWORD} \
            -e SOURCE_DOCKER_REGISTRY=mirror.ccs.tencentyun.com \
            -e SYNC_WINDOWS=true \
            -e CI=true \
            -v \$PWD/docker-image-sync.json:/root/lnmp/windows/docker-image-sync.json \
            khs1994/docker-image-sync"
      }
    }


  }
}
