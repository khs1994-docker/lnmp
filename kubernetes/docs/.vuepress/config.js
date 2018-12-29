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
        link: '/worker/',
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
        link: 'http://dwz.cn/I2vYahwq'
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
        'helm',
        'minikube',
        'windows',
      ],
      '/addons/': [
        'coredns',
        'dashboard',
        'efk',
        'heapster',
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
      "/worker/": [
        "kubelet",
      ],
    },
    sidebarDepth: 1,
  }
}
