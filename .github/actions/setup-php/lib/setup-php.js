const exec = require('@actions/exec');
const core = require('@actions/core');

const PHP_VERSION = core.getInput('php_version');
const ARGS = core.getInput('args');
const PHP_TYPE = core.getInput('php_type');

// const RUNNER_WORKSPACE='/home/runner/work/php-demo'

const RUNNER_WORKSPACE = process.env.RUNNER_WORKSPACE;
const WORKSPACE = RUNNER_WORKSPACE.split('/').pop();

async function run() {
  core.debug('get docker network');
  await exec.exec('docker', [
    'network',
    'ls',
  ]);

  core.debug('get docker network create by service actions');
  const NETWORK = await new Promise((resolve, reject) => {
    const systemExec = require('child_process').exec;
    const cmd = 'docker network ls --filter name=github -q';

    systemExec(cmd, function(error, stdout, stderr) {
      if (error) {
        reject(error);
      }

      if (stderr) {
        reject(stderr);
      }

      resolve(stdout.trim() || 'bridge');
    });
  });
  core.debug(`docker network create by actions is : "${NETWORK}"`)

  const IMAGE = `khs1994/php:${PHP_VERSION}-${PHP_TYPE}-alpine`;

  core.debug('pull docker image : ' + IMAGE);
  await exec.exec('docker', [
    'pull',
    '-q',
    IMAGE,
  ]);

  core.debug('run docker container');
  await exec.exec('docker', [
    'container',
    'run',
    '--workdir', '/github/workspace',
    '--rm',
    '--network', NETWORK,
    '-v', '/home/runner/work/_temp/_github_home:/github/home',
    '-v', '/home/runner/work/_temp/_github_workflow:/github/workflow',
    '-v', `${RUNNER_WORKSPACE}/${WORKSPACE}:/github/workspace`,
    IMAGE,
    'sh', '-cex', ARGS,
  ]);
}

run().then(() => {
  console.log('Run success');
}).catch((e) => {
  core.setFailed(e.toString());
});
