#!/usr/bin/python3
import os, sys, configparser

home = os.path.expanduser("~")
ini = '.ssh_hosts.ini'
filepath = os.path.join(home, ini)

hosts = configparser.ConfigParser()
hosts.read(filepath)

keys = list(hosts.sections())
keys.sort()

def print_hosts():
    for h in keys:
        print("\t[%s]:\t%s@%s" % (h, hosts[h]['username'], hosts[h]['hostname']))
    print()

def main():

    if len(sys.argv) != 2:
        print("\n\tUsage: %s <hostname> (add hosts to %s)\n" % 
                (os.path.basename(sys.argv[0]), filepath))
        print_hosts()
        sys.exit()

    cmd = sys.argv[1]

    h = cmd

    if h not in hosts:
        print("\n\tError - no entry for host '%s'\n" % h)
        print("\tAvailable hosts:")
        print_hosts()
        sys.exit()

    user = hosts[h]['username']
    host = hosts[h]['hostname']
    port = hosts[h]['port']

    os.system("ssh %s@%s -p %s" % (user, host, port))

main()
