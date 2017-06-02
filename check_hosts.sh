#!/bin/bash
/home/user/bin/s host1,host2,host3 ./bin/system_summary | mail -s 'systems summary' user@hostname

# to free pagecache
# sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
