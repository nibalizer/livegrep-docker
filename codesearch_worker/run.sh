#!/bin/bash

docker run -it --rm -v `pwd`/../indexes:/indexes --name codesearch_worker -v `pwd`/../git_repos:/git_repos -P livegrep:codesearch_worker
