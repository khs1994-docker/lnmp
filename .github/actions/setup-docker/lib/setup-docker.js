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

let message;

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

async function buildx() {
  core.debug('set DOCKER_CLI_EXPERIMENTAL');
  if (DOCKER_CLI_EXPERIMENTAL === 'enabled') {
    core.exportVariable('DOCKER_CLI_EXPERIMENTAL', 'enabled');
  }

  if (DOCKER_BUILDX !== 'true') {
    core.info('buildx disabled');

    return;
  }

  core.exportVariable('DOCKER_CLI_EXPERIMENTAL', 'enabled');

  await exec.exec('docker', [
    'buildx',
    'version',
  ]).then(async () => {
    // install buildx
    core.startGroup('setup qemu');
    await exec.exec('docker', [
      'run',
      '--rm',
      '--privileged',
      'ghcr.io/dpsigs/tonistiigi-binfmt:latest',
      "--install",
      "all"
    ]);
    core.endGroup();

    core.startGroup('list /proc/sys/fs/binfmt_misc');
    await exec.exec('ls -la', [
      '/proc/sys/fs/binfmt_misc',
    ]).catch(() => { });
    core.endGroup();

    core.startGroup('create buildx instance');
    await exec.exec('docker', [
      'buildx',
      'create',
      '--use',
      '--name',
      'mybuilder',
      '--driver',
      'docker-container',
      '--driver-opt',
      // 'image=moby/buildkit:master'
      // moby/buildkit:buildx-stable-1
      'image=ghcr.io/dpsigs/moby-buildkit:master'
      // $ docker pull moby/buildkit:master
      // $ docker tag moby/buildkit:master ghcr.io/dpsigs/moby-buildkit:master
      // $ docker push ghcr.io/dpsigs/moby-buildkit:master
    ]);
    core.endGroup();

    core.startGroup('inspect buildx instance');
    await exec.exec('docker', [
      'buildx',
      'inspect',
      '--bootstrap'
    ]);
    core.endGroup();
  }, () => {
    core.info('this docker version NOT Support Buildx');
  });
}

async function run() {
  const platform = os.platform();

  if (platform === 'win32') {
    core.debug('check platform');
    await exec.exec('echo',
      [`Only Support Linux and macOS platform, this platform is ${os.platform()}`]);

    return
  }

  if (platform === 'darwin') {
    // macos
    if (os.arch() !== 'x64') {
      core.warning('only support macOS x86_64, os arch is ' + os.arch());

      return;
    }

    core.exportVariable('DOCKER_CONFIG', '/Users/runner/.docker');

    await exec.exec('docker', [
      '--version']).catch(() => { });

    await exec.exec('docker-compose', [
      '--version']).catch(() => { });

    core.startGroup('install docker')
    await exec.exec('brew', ['update'])
    await exec.exec('brew', [
      'install',
      '--cask',
      DOCKER_CHANNEL !== 'stable' ? 'docker' : 'docker'
    ]);
    core.endGroup();

    await exec.exec('mkdir', [
      '-p',
      '/Users/runner/.docker'
    ]);

    await shell(`echo '${DOCKER_DAEMON_JSON}' | sudo tee /Users/runner/.docker/daemon.json`);

    core.startGroup('show daemon json content');
    await exec.exec('cat', [
      '/Users/runner/.docker/daemon.json',
    ]);
    core.endGroup();

    // allow the app to run without confirmation
    await exec.exec('xattr', [
      '-d',
      '-r',
      'com.apple.quarantine',
      '/Applications/Docker.app'
    ]);

    // preemptively do docker.app's setup to avoid any gui prompts
    core.startGroup('start docker');
    await exec.exec('sudo', [
      'bash',
      '-c',
      `
set -x


cat <<EOF | tee /tmp/com.docker.vmnetd.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.docker.vmnetd</string>
	<key>Program</key>
	<string>/Library/PrivilegedHelperTools/com.docker.vmnetd</string>
	<key>ProgramArguments</key>
	<array>
		<string>/Library/PrivilegedHelperTools/com.docker.vmnetd</string>
	</array>
	<key>RunAtLoad</key>
	<true/>
	<key>Sockets</key>
	<dict>
		<key>Listener</key>
		<dict>
			<key>SockPathMode</key>
			<integer>438</integer>
			<key>SockPathName</key>
			<string>/var/run/com.docker.vmnetd.sock</string>
		</dict>
	</dict>
	<key>Version</key>
	<string>59</string>
</dict>
</plist>
EOF

sudo /bin/cp /Applications/Docker.app/Contents/Library/LaunchServices/com.docker.vmnetd /Library/PrivilegedHelperTools
# sudo /bin/cp /Applications/Docker.app/Contents/Resources/com.docker.vmnetd.plist /Library/LaunchDaemons/
sudo /bin/cp /tmp/com.docker.vmnetd.plist /Library/LaunchDaemons/
sudo /bin/chmod 544 /Library/PrivilegedHelperTools/com.docker.vmnetd
sudo /bin/chmod 644 /Library/LaunchDaemons/com.docker.vmnetd.plist
sudo /bin/launchctl load /Library/LaunchDaemons/com.docker.vmnetd.plist
open -g /Applications/Docker.app || exit

sleep 60

docker info > /dev/null || true

sleep 30

docker info > /dev/null || true
# Wait for the server to start up, if applicable.
i=0
while ! docker system info &>/dev/null; do
(( i++ == 0 )) && printf %s '-- Waiting for Docker to finish starting up...' || printf '.'
sleep 1
done
(( i )) && printf '\n'

echo "-- Docker is ready."
`]);
    core.endGroup();

    core.startGroup('docker version');
    await exec.exec('docker', ['version']);
    core.endGroup();

    core.startGroup('docker info');
    await exec.exec('docker', ['info']);
    core.endGroup();

    await core.group('set up buildx', buildx);

    return
  }

  message = 'check docker systemd status';
  core.startGroup(message)
  await exec.exec('sudo', [
    'systemctl',
    'status',
    'docker',
  ]).then(() => { }).catch(() => { });
  core.endGroup();

  message = 'check docker version'
  core.debug(message);
  core.startGroup(message);
  await exec.exec('docker', [
    'version',
  ]).catch(() => { });
  core.endGroup();

  if (DOCKER_CHANNEL === 'nightly') {
    if (os.arch() !== 'x64') {
      core.warning('nightly version only support x86_64, os arch is ' + os.arch());

      return;
    }

    core.exportVariable('DOCKER_CONFIG', '/home/runner/.docker');

    core.startGroup('download deb');
    await exec.exec('curl', [
      '-fsSL',
      '-o',
      '/tmp/moby-snapshot-ubuntu-focal-x86_64-deb.tbz',
      `https://github.com/AkihiroSuda/moby-snapshot/releases/download/${DOCKER_NIGHTLY_VERSION}/moby-snapshot-ubuntu-focal-x86_64-deb.tbz`
    ]);
    core.endGroup();

    await exec.exec('sudo', [
      'rm',
      '-rf',
      '/tmp/*.deb'
    ]);

    core.startGroup('unpack tbz file');
    await exec.exec('tar', [
      'xjvf',
      '/tmp/moby-snapshot-ubuntu-focal-x86_64-deb.tbz',
      '-C',
      '/tmp'
    ]);
    core.endGroup();

    core.startGroup('remove default moby');
    await exec.exec('sudo', [
      'sh',
      '-c',
      "apt remove -y moby-buildx moby-cli moby-containerd moby-engine moby-runc"
    ]).catch(() => { });
    core.endGroup();

    core.startGroup('update apt cache');
    await exec.exec('sudo', [
      'apt-get',
      'update',
    ]).catch(() => { });
    core.endGroup();

    core.startGroup('install docker');
    await exec.exec('sudo', [
      'sh',
      '-c',
      'apt-get install -y /tmp/*.deb'
    ]).catch(async () => {
      core.endGroup();

      core.startGroup('install docker');
      await exec.exec('sudo', [
        'sh',
        '-c',
        'dpkg -i /tmp/*.deb'
      ]);
      core.endGroup();
    });
    core.endGroup();

  } else {
    core.exportVariable('DOCKER_CONFIG', '/home/runner/.docker');

    core.debug('add apt-key');
    await shell(`
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    `);

    message = 'add apt source';
    core.debug(message);
    const UBUNTU_CODENAME = await shell('lsb_release -cs');
    core.startGroup(message);
    await shell(`
    echo \
      "deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      ${UBUNTU_CODENAME} ${DOCKER_CHANNEL}" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    `)
    core.endGroup();

    message = 'update apt cache'
    core.debug(message);
    core.startGroup(message);
    await exec.exec('sudo', [
      'apt-get',
      'update',
    ]).catch(() => { });
    core.endGroup();

    message = 'show available docker version';
    core.debug(message);
    core.startGroup(message);
    await exec.exec('apt-cache', [
      'madison',
      'docker-ce',
      '|',
      'grep',
      '20.10'
    ]);
    core.endGroup()

    const DOCKER_VERSION_STRING = await shell(
      `apt-cache madison docker-ce | grep ${DOCKER_VERSION} | head -n 1 | awk '{print $3}' | sed s/[[:space:]]//g`)

    if (!DOCKER_VERSION_STRING) {
      const OS = await shell(
        `cat /etc/os-release | grep VERSION_ID | cut -d '=' -f 2`
      );

      core.warning(`Docker ${DOCKER_VERSION} not available on ubuntu ${OS}, install latest docker version`);
    }

    message = 'install docker'
    core.debug(message);
    core.startGroup(message);
    await exec.exec('sudo', [
      'apt-get',
      '-y',
      'install',
      DOCKER_VERSION_STRING ? `docker-ce=${DOCKER_VERSION_STRING}` : 'docker-ce',
      DOCKER_VERSION_STRING ? `docker-ce-cli=${DOCKER_VERSION_STRING}` : 'docker-ce-cli'
    ]);
    core.endGroup();
  }

  message = 'check docker version';
  core.debug(message);
  core.startGroup(message);
  await exec.exec('docker', [
    'version',
  ]);
  core.endGroup();

  message = 'check docker systemd status';
  core.debug(message);
  core.startGroup(message);
  await exec.exec('sudo', [
    'systemctl',
    'status',
    'docker',
  ]);
  core.endGroup();

  // /etc/docker/daemon.json
  core.debug('set /etc/docker/daemon.json');
  core.startGroup('show default daemon json content');
  await exec.exec('sudo', [
    'cat',
    '/etc/docker/daemon.json',
  ]);
  core.endGroup();

  await shell(`echo '${DOCKER_DAEMON_JSON}' | sudo tee /etc/docker/daemon.json`);

  core.startGroup('show daemon json content');
  await exec.exec('sudo', [
    'cat',
    '/etc/docker/daemon.json',
  ]);
  core.endGroup();

  await exec.exec('sudo', [
    'systemctl',
    'restart',
    'docker',
  ]);

  await core.group('set up buildx', buildx);

  core.startGroup('docker info');
  await exec.exec('docker', ['info']);
  core.endGroup();
}

run().then(() => {
  console.log('Run success');
}).catch((e) => {
  core.setFailed(e.toString());
});
