#!/bin/bash

docker run -it --rm -v `pwd`/../indexes:/indexes -p 131.252.216.15:8910:8910 --link codesearch_worker:codesearch_worker --name livegrep_web -v `pwd`/../git_repos:/git_repos -P livegrep:livegrep_web
