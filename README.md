# EF Demo Project

- Recommended 16GB memory, 8 cores or more, Ubuntu 14.04 / 16.04 / 18.04 LTS 
- Additional 3GB memory, 2 cores required when adding 1 more EFserver
- Available EF tags : latest, 9.1.0, 9.0.1
- Elasticsearch also uses a mix of NioFS and MMapFS for the various files. 
Ensure that you configure the maximum map count so that there is ample virtual memory available for mmapped files.

## Initialize

- To get master branch source , execute follow commands
- To get another branch source, change master to branchName then execute commands

```console
  $ sudo su
  $ sysctl -w vm.max_map_count=262144 
  $ wget -O init.sh  https://github.com/kin3303/efdemo/blob/master/init.sh?raw=true && chmod 777 init.sh && ./init.sh master && source ~/.bashrc && cd master && chmod 777 *
```

## Install Environment

```console
  $ efinstall
```

## Install EF Packages

```console
  $ efstart <op:TAG_VALUE> <op:DOCKER_COMPOSE_FILE_NAME>  (i.e efstart latest docker-compose-complex.yaml)
```

## Auto Configuration

* Requrement 1 : This is available after server activation
* Requrement 2 : License file must be in **/tmp/license.xml**
* What to do
   - Import license
   - Add resouces - localagent, apacheAgent, repositoryAgent
   - Add repository - default
   - Config devopsinsight server connection
   - Install plugins - Release Demo, Job Dashbard, Workflow Dashbard, DSL IDE, EC-Rest

```console
 $ efconfig
```

## Demo Configuration

```console
 $ efsetdemo
```

## Scaling EF Server

* Requrement : Starting with docker-compose-with-haproxy.yaml

```console
 $ efscale <size>
```

## Backup
* Please do not modify the project while backup
* What to do
  - DB dump 
  - DevOpsInsight(Elasticsearch) snapshot 
  - Data Backup       
    + Configuration Files
       1. <DATADIR>/conf  :  Configuration files
       2. <DATADIR>/mysql/mysql.cnf  : Configuration file for MYSQL
    + Workspace Directories
       1. <DATADIR>/workspace
    + Plugins
       1. <DATADIR>/plugins
    + Artifact
       1. <DATADIR>/repository-data
  - Packaging
    + backup.tar.gz
  
```console
 $ efbackup
```

## Restore
* Please do not modify the project while restore
* What to do
  - Unpackaging backup.tar.gz
  - Data Restore       
    + Configuration Files
       1. <DATADIR>/conf  :  Configuration files
       2. <DATADIR>/mysql/mysql.cnf  : Configuration file for MYSQL
    + Workspace Directories
       1. <DATADIR>/workspace
    + Plugins
       1. <DATADIR>/plugins
    + Artifact
       1. <DATADIR>/repository-data
  - Restore DB
  - Restore DevOpsInsight snapshot
```console
 $ efrestore
```

## Upload EF Docker Images

- Requrement : Save Flow, Devops Installer in **/tmp** folder

```console
 $ cd <SourceRoot>
 $ export EFLOW_DEV_INSTALLER=ElectricFlowDevOpsInsightServer-x64-9.0.1.136311
 $ export EFLOW_INSTALLER=ElectricFlow-x64-9.0.1.136311
 $ export TAG=latest
 $ docker login
 $ make
``` 

