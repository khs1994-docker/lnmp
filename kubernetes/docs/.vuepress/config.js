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
        text: '插件',
        link: '/addons/',
      },
      {
        text: '日志',
        link: '/log/',
      },
      {
        text: '数据卷',
        link: '/volume/'
      },
      {
        text: '工作节点',
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
        'install',
        'coreos',
        'systemd',
        'docker-desktop',
        'endpoints',
        'network',
        'port',
        'ingress-nginx',
        'nginx',
        'php',
        'rollout',
        'secret',
        'ha',
        'helm',
        'minikube',
        'windows',
        'arm64',
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
      "/volume/": [
        "data",
      ],
      "/node/": [
        "kubelet",
        "worker",
        "runtime",
        "oci_runtime",
        "cni",
        "crictl",
      ],
    },
    sidebarDepth: 1,
  }
}
