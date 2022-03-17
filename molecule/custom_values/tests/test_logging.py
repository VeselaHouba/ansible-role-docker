import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_daemon_config(host):
    config = host.file('/etc/docker/daemon.json')
    assert config.contains('"log-driver": "syslog"')


def test_syslog_forwarding(host):
    with host.sudo():
        c = host.run('docker run --name nice_name --rm alpine echo Hello_Mark')
        assert c.rc == 0
    logfile = host.file('/var/log/syslog')
    assert logfile.contains('docker-nice_name')
    assert logfile.contains('Hello_Mark')
