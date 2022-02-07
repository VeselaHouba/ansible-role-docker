import os

import yaml

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_docker_version(host):
    stream = host.file('/tmp/ansible-vars.yml').content
    ansible_vars = yaml.load(stream, Loader=yaml.FullLoader)
    def_version = ansible_vars['_version']
    c = host.run('docker version --format "{{.Server.Version}}"')
    assert c.rc == 0
    assert def_version in c.stdout


def test_docker_is_running(host):
    cmd = host.service('docker')
    assert cmd.is_running
    assert cmd.is_enabled


def test_docker_daemon_connection(host):
    c = host.run('docker ps')
    assert c.rc == 0


def test_docker_container_start(host):
    with host.sudo():
        c = host.run('docker run --rm alpine:3.12.0 cat /etc/alpine-release')
        assert c.rc == 0
        assert '3.12.0' in c.stdout


def test_docker_version_lock(host):
    stream = host.file('/tmp/ansible-vars.yml').content
    ansible_vars = yaml.load(stream, Loader=yaml.FullLoader)
    def_version = ansible_vars['_version']
    package_before = host.package("docker-ce").version
    assert def_version in package_before
    with host.sudo():
        c = host.run('apt update && apt upgrade -y')
        assert c.rc == 0
    package_after = host.package("docker-ce").version
    assert def_version in package_after
    assert package_after == package_before


def test_cleanup_cron(host):
    cronfile = host.file('/etc/cron.d/docker')
    assert cronfile.contains('docker system prune')
    assert cronfile.contains('docker volume rm')
