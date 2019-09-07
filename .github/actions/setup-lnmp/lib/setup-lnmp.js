const exec = require('@actions/exec');
const core = require('@actions/core');
const os = require('os');

const LNMP_BRANCH = core.getInput('lnmp_branch');
const LNMP_SERVICES = core.getInput('lnmp_services');
const LREW_INCLUDE = core.getInput('lrew_include');

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

  core.debug('init lnmp')
  core.exportVariable('quite','true');
  await exec.exec('lnmp-docker');
  await exec.exec('lnmp-docker', ['compose', '--official']);
  core.exportVariable('quite','');
  await exec.exec('sudo', ['systemctl', 'stop', 'mysql']);
}

run().then(() => {
  console.log('Run success');
}).catch((e) => {
  core.setFailed(e.toString());
});
