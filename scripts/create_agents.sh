#!/bin/bash
export PATH=$PATH:/opt/electriccloud/electriccommander/bin
ectool deleteResource  local1
ectool createResource local1 --hostName 3e0df2dc6e66 --pools default
ectool pingResource local1
