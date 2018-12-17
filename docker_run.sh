#!/usr/bin/env bash

sudo docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it --rm -v $(pwd):/project c_flex_bison
