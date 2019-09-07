const exec = require('@actions/exec');
const core = require('@actions/core');
const tc = require('@actions/tool-cache');
const io = require('@actions/io');

const os = require('os');

const LNMP_BRANCH = core.getInput('lnmp_branch');
const LNMP_SERVICES = core.getInput('lnmp_services');
const LREW_INCLUDE = core.getInput('lrew_include');
const DOCKER_COMPOSE_VERSION = core.getInput('docker_compose_version');

async function run() {
  const platform = os.platform();

  if (platform !== 'linux') {
    core.debug('check platform');
    await exec.exec('echo',
      [`Only Support linux platform, this platform is ${os.platform()}`]);
    return
  }

  core.debug('clone lnmp');
  await exec.exec('git', [
    'clone',
    '--depth=1',
    '-b',
    LNMP_BRANCH,
    'https://github.com/khs1994-docker/lnmp',
    '/home/runner/lnmp'
  ]);

  core.debug('set env');
  core.exportVariable('LNMP_SERVICES', LNMP_SERVICES);
  core.exportVariable('LREW_INCLUDE', LREW_INCLUDE);
  core.exportVariable('LNMP_PATH', '/home/runner/lnmp');
  core.addPath('/home/runner/lnmp');
  core.addPath('/home/runner/lnmp/bin');
  core.addPath('/home/runner/lnmp/wsl');

  core.debug('download docker compose');
  const composePath = await tc.downloadTool(`https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64`);
  await io.cp(composePath, '/home/runner/lnmp/bin/docker-compose');
  await exec.exec('chmod', ['+x', '/home/runner/lnmp/bin/docker-compose']);

  core.debug('stop mysql')
  await exec.exec('sudo', ['systemctl', 'stop', 'mysql']);
}

run().then(() => {
  console.log('Run success');
}).catch((e) => {
  core.setFailed(e.toString());
});
