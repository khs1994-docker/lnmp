import os


def print_help_info(script, soft, example_version):
    print('''

Usage:

$ {script} [{soft}_VERSION] [SUDO_PASSWORD]

Example:

$ {script} {example_version} sudopasswd

  '''.format(script=script, soft=soft, example_version=example_version))


def download_src(url, tar_gz_file, file):
    os.chdir('/tmp')

    if os.path.exists(file):
        return 0
    elif os.path.exists(tar_gz_file):
        os.system('tar -zxvf ' + tar_gz_file)
        return 0

    cmd = 'wget ' + url
    os.system(cmd)
    download_src(url, tar_gz_file, file)


def install_dep(cmd):
    os.system(cmd)
    pass


def install_build_dep(cmd):
    os.system(cmd)
    pass


def builder_pre(cmd):
    os.system(cmd)


def builder(file, configure_cmd, sudo_cmd):
    os.chdir('/tmp/' + file)
    os.system(configure_cmd)
    os.system('make -j $( nproc )')
    os.system(sudo_cmd + 'make install')
    pass


def builder_post(cmd):
    os.system(cmd)


def test(cmd):
    os.system(cmd)
    pass
