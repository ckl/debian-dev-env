#!/usr/bin/python3
import os, sys, configparser

home = os.path.expanduser("~")
ini = '/home/user/.ssh_hosts.ini'
filepath = os.path.join(home, ini)

hosts = configparser.ConfigParser()
hosts.read(filepath)

keys = list(hosts.sections())
keys.sort()

def print_hosts():
    for h in keys:
        print("\t%-12s %s@%s" % ('['+h+']:', hosts[h]['username'], hosts[h]['hostname']))
    print("\t%-12s %s" % ('[all]:', "execute command on all hosts"))
    print()

def execute_on_all(hs, cmd):
    for h in hs:
        user = hosts[h]['username']
        host = hosts[h]['hostname']
        port = hosts[h]['port']
        print('-' * 20, flush=True)
        print(h, flush=True)
        print('-'*20, flush=True)
        os.system("ssh %s@%s -p %s %s" % (user, host, str(port), cmd))
        print()

def check_for_host(hs):
    for h in hs:
        if h not in hosts:
            print("\n\tError - no entry for host '%s'\n" % h)
            print("\tAvailable hosts:")
            print_hosts()
            sys.exit()

def main():

    if len(sys.argv) < 2:
        print("\n\tUsage: %s <host[,host,...]> [command](add hosts to %s)\n" % 
                (os.path.basename(sys.argv[0]), filepath))
        print_hosts()
        sys.exit()

    h = sys.argv[1]
    
    if len(sys.argv) == 3:
        cmd = sys.argv[2]

    
    hs = []
    if h == 'all':
        hs = keys
    else:
        hs = h.split(',')
    check_for_host(hs)
    
    if len(sys.argv) == 3:
        execute_on_all(hs, cmd)
    elif len(hs) == 1 and len(sys.argv) == 2:
        user = hosts[h]['username']
        host = hosts[h]['hostname']
        port = hosts[h]['port']
        os.system("ssh %s@%s -p %s" % (user, host, port))

main()
