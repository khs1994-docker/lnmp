const exec = require('@actions/exec');
const core = require('@actions/core');
const os = require('os');

const DOCKER_VERSION = core.getInput('docker_version');
const DOCKER_CHANNEL = core.getInput('docker_channel');
const DOCKER_CLI_EXPERIMENTAL = core.getInput('docker_cli_experimental');
const DOCKER_DAEMON_JSON = core.getInput('docker_daemon_json');
const DOCKER_BUILDX = core.getInput('docker_buildx');
const DOCKER_NIGHTLY_VERSION = core.getInput('docker_nightly_version');

const systemExec = require('child_process').exec;

async function shell(cmd) {
  return await new Promise((resolve, reject) => {
    systemExec(cmd, function (error, stdout, stderr) {
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

  await exec.exec('sudo', [
    'systemctl',
    'status',
    'docker',
  ]).then(() => { }).catch(() => { });

  core.debug('check docker version');
  await exec.exec('docker', [
    'version',
  ]).catch(() => { });

  if (DOCKER_CHANNEL === 'nightly') {
    await exec.exec('curl', [
      '-fsSL',
      '-o',
      '/tmp/moby-snapshot-ubuntu-focal-x86_64-deb.tbz',
      `https://github.com/AkihiroSuda/moby-snapshot/releases/download/${DOCKER_NIGHTLY_VERSION}/moby-snapshot-ubuntu-focal-x86_64-deb.tbz`
    ]);

    await exec.exec('sudo', [
      'rm',
      '-rf',
      '/tmp/*.deb'
    ]);

    await exec.exec('tar', [
      'xjvf',
      '/tmp/moby-snapshot-ubuntu-focal-x86_64-deb.tbz',
      '-C',
      '/tmp'
    ]);

    await exec.exec('sudo', [
      'apt-get',
      'update',
    ]);

    await exec.exec('sudo', [
      'sh',
      '-c',
      "apt remove -y moby-buildx moby-cli moby-containerd moby-engine moby-runc"
    ]).catch(() => { });

    await exec.exec('sudo', [
      'sh',
      '-c',
      'apt-get install -y /tmp/*.deb'
    ]).catch(async () => {
      await exec.exec('curl', [
        '-fsSL',
        '-o',
        '/tmp/libseccomp2_2.4.3-1+b1_amd64.deb',
        'http://ftp.us.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.4.3-1+b1_amd64.deb'
      ]);

      await exec.exec('sudo', [
        'sh',
        '-c',
        'dpkg -i /tmp/*.deb'
      ]);
    });

  } else {
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

    if (!DOCKER_VERSION_STRING) {
      const OS = await shell(
        `cat /etc/os-release | grep VERSION_ID | cut -d '=' -f 2`
      );

      core.warning(`Docker ${DOCKER_VERSION} not available on ubuntu ${OS}, install latest docker version`);
    }

    core.debug('install docker');
    await exec.exec('sudo', [
      'apt-get',
      '-y',
      'install',
      DOCKER_VERSION_STRING ? `docker-ce=${DOCKER_VERSION_STRING}` : 'docker-ce',
      DOCKER_VERSION_STRING ? `docker-ce-cli=${DOCKER_VERSION_STRING}` : 'docker-ce-cli'
    ]);
  }

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
      'tonistiigi/binfmt:latest',
      "--install",
      "all"
    ]);

    await exec.exec('ls -la', [
      '/proc/sys/fs/binfmt_misc',
    ]);

    await exec.exec('docker', [
      'buildx',
      'create',
      '--use',
      '--name',
      'mybuilder',
      '--driver',
      'docker-container',
      '--driver-opt',
      'image=moby/buildkit:master'
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
