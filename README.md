# EF Demo Project

- Recommended 16GB memory, 8 cores or more, Ubuntu 16.04 or later
- Additional 3GB memory, 2 cores required when adding 1 more EFserver
- Available tags is in https://cloud.docker.com/u/kin3303/repository/docker/kin3303/commanderserver

## Install the execution environment

```console
  $ wget -O install.sh  https://github.com/kin3303/efdemo/blob/master/setup.sh?raw=true
  $ sudo ./setup.sh
```

## Install EF Packages

```console
  $ cd <SourceRoot>
  $ sudo ./setup/start.sh
```

## Auto Configuration

- Requrement 1 : This is available after server activation (http://YOUR_IP_ADDRESS:1936/haproxy?stats)
- Requrement 2 : License file must be in */tmp/license.xml*
```console
  $ cd <SourceRoot>
  $ sudo ./setup/config.sh
```

## Scaling EF Server

```console
 $ sudo ./setup/scale.sh <size>
```

## Upload EF Docker Images

- Requrement : Save Flow, Devops Installer in / tmp folder

```console
 $ cd <SourceRoot>
 $ export EFLOW_DEV_INSTALLER=ElectricFlowDevOpsInsightServer-x64-9.0.1.136311
 $ export EFLOW_INSTALLER=ElectricFlow-x64-9.0.1.136311
 $ export TAG=9.0.1
 $ docker login
 $ make
``` 

