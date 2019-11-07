module.exports = {
  title: 'K8s LNMP',
  description: 'Run LNMP On K8s',
  head: [
    []
  ],
  themeConfig: {
    nav: [
      {
        text: '教程',
        link: '/guide/',
      },
      {
        text: '示例',
        link: '/example/',
      },
      {
        text: '插件',
        link: '/addons/',
      },
      {
        text: '日志',
        link: '/log/',
      },
      {
        text: '存储',
        link: '/storage/'
      },
      {
        text: '节点',
        link: '/node/',
      },
      {
        text: 'GitHub',
        link: 'https://github.com/khs1994-docker/lnmp-k8s',
      },
      {
        text: 'khs1994.com',
        link: 'https://khs1994.com',
      },
      {
        text: 'Kubernetes 免费实验室',
        link: 'https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61'
      }
    ],
    sidebar: {
      '/guide/': [
        'coreos',
        'etcd',
        'systemd',
        'docker-desktop',
        'endpoints',
        'network',
        'port',
        'ingress-nginx',
        'rollout',
        'secret',
        'ha',
        'helm',
        'kustomize',
        'minikube',
        'windows',
        'arm64',
        'virtualbox',
        'podman',
        'rpi',
        'kubectl',
        '/resources/deployment',
        '/resources/configMap',
      ],
      '/example/': [
        'nginx',
        'php',
      ],
      '/addons/': [
        'coredns',
        'dashboard',
        'efk',
        'metrics-server',
        'prometheus-operator',
        'registry',
      ],
      "/log/": [
        "mysql",
        "nginx",
        "php",
        "redis",
      ],
      "/storage/": [
        "data",
        "nfs",
        "pv",
        "flexVolume",
        "csi",
        "storage-classes",
      ],
      "/node/": [
        'flanneld',
        "kubelet",
        "worker",
        "runtime",
        "oci_runtime",
        "cni",
        "crictl",
        {
          title: "master 节点",
          collapsable: false,
          children: [
            "/server/kube-apiserver",
            "/server/kube-controller-manager",
            "/server/kube-scheduler",
          ],
        },
      ],
    },
    sidebarDepth: 1,
  }
}
