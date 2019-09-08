module.exports = {
  title: 'Docker LNMP Docs',
  base: '/',
  themeConfig: {
    docsRepo: 'khs1994-docker/lnmp',
    docsDir: 'docs',
    editLinks: true,
    nav: [{
        text: '使用指引',
        link: '/'
      },
      {
        text: '商业版',
        link: '/ee/'
      },
      {
        text: 'GitHub',
        link: 'https://github.com/khs1994-docker/lnmp'
      },
      {
        text: '捐赠',
        link: 'https://github.com/khs1994/donate'
      },
      {
        text: '腾讯云容器服务',
        link: 'https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61'
      },
      {
        text: 'Docker LNMP',
        items: [{
          text: '腾讯云自媒体',
          link: 'https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh'
        }]
      }
    ],
    sidebar: {
      '/ee/': [

      ],
      '/': [{
          title: 'Introduction',
          collapsable: false,
          children: [
            '/',
            '/why',
            '/docker',

          ]
        },
        {
          title: '安装',
          collapsable: false,
          children: [
            '/install/linux',
            '/install/windows',
            '/mysql',
            '/update',
            '/cli.md',
            '/init',
            '/path',
          ]
        },
        {
          title: '开发环境',
          collapsable: false,
          children: [
            '/development',
            '/custom',
            '/lrew',
            '/backup',
            '/cleanup',
            '/config',
            '/port',
            '/command',
            '/windows/lwpm',
            '/compose',
          ]
        }, {
          title: "nginx",
          collapsable: false,
          children: [
            '/nginx/',
            '/nginx/config',
            '/nginx/issue-ssl',
            '/nginx/https',
            '/nginx/unit',
          ]
        }, {
          title: "PHP",
          collapsable: false,
          children: [
            '/php',
            '/xdebug',
            '/laravel',
            '/composer',
            '/phpunit',
            '/xhprof',
            '/swoole',
            '/composer/',
            '/composer/satis'
          ]
        }, {
          title: '生产环境',
          collapsable: false,
          children: [
            '/production',
            '/swarm/',
            '/kubernetes/',
            '/kubernetes/docker-desktop',
            '/registry',
          ]
        }, {
          title: '计划任务',
          collapsable: false,
          children: [
            '/crontab',
            '/supervisord',
          ]
        }, {
          title: '镜像构建',
          collapsable: false,
          children: [
            '/build',
            '/manifest',
          ]
        }, {
          title: "数据卷 Volumes",
          collapsable: false,
          children: [
            '/volumes/nfs'
          ]
        }, {
          title: '参考',
          collapsable: false,
          children: [
            '/dockerd',
            '/systemd',
            '/git',
            '/gpg',
            '/network',
            '/mirror',
            '/windows/container',
            '/arm',
            '/ab',
            '/minio',
            '/buildx',
            '/cncf/kong',
            '/windows/wsl2',
          ]
        }
      ]
    }
  }
}
