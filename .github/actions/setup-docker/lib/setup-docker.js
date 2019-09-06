const exec = require('@actions/exec');
const core = require('@actions/core');
const os = require('os');

const DOCKER_VERSION = core.getInput('docker_version');
const DOCKER_CHANNEL = core.getInput('docker_channel');
const DOCKER_CLI_EXPERIMENTAL = core.getInput('docker_cli_experimental');
const DOCKER_DAEMON_JSON = core.getInput('docker_daemon_json');
const DOCKER_BUILDX = core.getInput('docker_buildx');

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
  const platform = os.platform();

  if (platform !== 'linux') {
    core.debug('check platform');
    await exec.exec('echo',
      [`Only Support linux platform, this platform is ${os.platform()}`]);
    return
  }

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
  const UBUNTU_CODENAME = await shell('lsb_release -cs');
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

  core.debug('set DOCKER_CLI_EXPERIMENTAL');
  if (DOCKER_CLI_EXPERIMENTAL === 'enabled') {
    core.exportVariable('DOCKER_CLI_EXPERIMENTAL', 'enabled');
  }

  // /etc/docker/daemon.json
  core.debug('set /etc/docker/daemon.json');
  await exec.exec('sudo', [
    'cat',
    '/etc/docker/daemon.json',
  ]);

  await shell(`echo '${DOCKER_DAEMON_JSON}' | sudo tee /etc/docker/daemon.json`);

  await exec.exec('sudo', [
    'cat',
    '/etc/docker/daemon.json',
  ]);

  await exec.exec('sudo', [
    'systemctl',
    'restart',
    'docker',
  ]);

  // buildx
  await exec.exec('docker', [
    'buildx',
    'version',
  ]).then(async () => {
    if (DOCKER_BUILDX !== 'true') {
      core.debug('buildx disabled');
      return;
    }

    // install buildx
    await exec.exec('docker', [
      'run',
      '--rm',
      '--privileged',
      'docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3',
    ]);

    await exec.exec('cat', [
      '/proc/sys/fs/binfmt_misc/qemu-aarch64',
    ]);

    await exec.exec('docker', [
      'buildx',
      'create',
      '--use',
      '--name',
      'mybuilder',
    ]);

    await exec.exec('docker', [
      'buildx',
      'inspect',
      '--bootstrap'
    ]);
  }, () => {
    core.debug('NOT Support Buildx');
  });
}

run().then(() => {
  console.log('Run success');
}).catch((e) => {
  core.setFailed(e.toString());
});
