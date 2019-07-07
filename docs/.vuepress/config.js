module.exports = {
  title: 'LNMP Docs',
  base: '/',
  themeConfig: {
    docsRepo: 'khs1994-docker/lnmp',
    docsDir: 'docs',
    editLinks: true,
    nav: [
      {text: '使用指引',link: '/'},
      {text: '商业版',link: '/ee/'},
      {text: 'GitHub',link: 'https://github.com/khs1994-docker/lnmp'},
      {
        text: 'LNMP Docker',
        items: [
          {text: '腾讯云容器服务',link: 'https://cloud.tencent.com/redirect.php?redirect=10058&cps_key=3a5255852d5db99dcd5da4c72f05df61'},
          {text: '腾讯云自媒体',link: 'https://cloud.tencent.com/developer/support-plan?invite_code=13vokmlse8afh'}
        ]
      }
    ],
    sidebar: {
      '/ee/': [

      ],
      '/': [
        {
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
            '/backup',
            '/cleanup',
            '/config',
            '/port',
            '/command',
            '/windows/lwpm'
          ]
        },{
          title: "nginx",
          collapsable: false,
          children: [
            '/nginx/',
            '/nginx/config',
            '/nginx/issue-ssl',
            '/nginx/https',
            '/nginx/unit',
          ]
        },{
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
        },{
          title: '生产环境',
          collapsable: false,
          children: [
             '/production',
             '/swarm/',
             '/kubernetes/',
             '/kubernetes/docker-desktop',
             '/registry',
          ]
        },{
          title: '计划任务',
          collapsable: false,
          children: [
            '/crontab',
            '/supervisord',
          ]
        },{
          title: '镜像构建',
          collapsable: false,
          children: [
            '/build',
            '/manifest',
          ]
        },{
          title: "数据卷 Volumes",
          collapsable: false,
          children: [
            '/volumes/nfs'
          ]
        },{
          title:  '参考',
          collapsable: false,
          children: [
            '/systemd',
            '/git',
            '/gpg',
            '/network',
            '/mirror',
            '/windows/container',
            '/arm',
            '/ab',
            '/minio',
          ]
        }
      ]
    }
  }
}
