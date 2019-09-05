const exec = require('@actions/exec');
const core = require('@actions/core');

const DOCKER_VERSION = core.getInput('docker_version');
const DOCKER_CHANNEL = core.getInput('docker_channel');

const systemExec = require('child_process').exec;

async function shell(cmd) {
  return await new Promise((resolve, reject) => {
    systemExec(cmd, function(error, stdout, stderr) {
      if (error) {
        reject(error);
      }

      if (stderr) {
        reject(stderr);
      }

      resolve(stdout.trim());
    });
  });
}

async function run() {
  core.debug('check docker version');
  await exec.exec('docker', [
    'version',
  ]);

  core.debug('add apt-key');
  await exec.exec('curl', [
    '-fsSL',
    '-o',
    '/tmp/docker.gpg',
    'https://download.docker.com/linux/ubuntu/gpg',
  ]);
  await exec.exec('sudo', [
    'apt-key',
    'add',
    '/tmp/docker.gpg',
  ]);

  core.debug('add apt source');
  const UBUNTU_CODENAME=await shell('lsb_release -cs');
  await exec.exec('sudo', [
    'add-apt-repository',
    `deb [arch=amd64] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME} ${DOCKER_CHANNEL}`,
  ]);

  core.debug('update apt cache');
  await exec.exec('sudo', [
    'apt-get',
    'update',
  ]);

  core.debug('show available docker version');
  await exec.exec('apt-cache', [
    'madison',
    'docker-ce',
    '|',
    'grep',
    '19.03'
  ]);

  const DOCKER_VERSION_STRING = await shell(
    `apt-cache madison docker-ce | grep ${DOCKER_VERSION} | head -n 1 | awk '{print $3}' | sed s/[[:space:]]//g`)

  core.debug('install docker');
  await exec.exec('sudo', [
    'apt-get',
    '-y',
    'install',
    DOCKER_VERSION_STRING ? `docker-ce=${DOCKER_VERSION_STRING}` : 'docker-ce',
    DOCKER_VERSION_STRING ? `docker-ce-cli=${DOCKER_VERSION_STRING}` : 'docker-ce-cli'
  ]);

  core.debug('check docker version');
  await exec.exec('docker', [
    'version',
  ]);

  core.debug('check docker systemd status');
  await exec.exec('sudo', [
    'systemctl',
    'status',
    'docker',
  ]);
}

run().then(() => {
  console.log('Run success');
}).catch((e) => {
  core.setFailed(e.toString());
});
