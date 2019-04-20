# EF Demo Project

- Recommended 16GB memory, 8 cores or more, Ubuntu 16.04 or later
- Additional 3GB memory, 2 cores required when adding 1 more EFserver
- Available EF tags : 9.0.1 , latest

## Initialize

```console
  $ sudo su
  $ wget -O init.sh  https://github.com/kin3303/efdemo/blob/master/init.sh?raw=true && \
  chmod 777 init.sh && \
  ./init.sh && \
  source ~/.bashrc && \
  cd master
```

## Install Environment

```console
  $ efinstall
```

## Install EF Packages

```console
  $ efstart
```

## Auto Configuration

* Requrement 1 : This is available after server activation (<http://YOUR_IP_ADDRESS:1936/haproxy?stats>)
* Requrement 2 : License file must be in **/tmp/license.xml**
* Configurations
   - Import license
   - Add resouces - localagent, apacheAgent, repositoryAgent
   - Add repository - default
   - Config devopsinsight server connection
   - Install plugins - Release Demo, Job Dashbard, Workflow Dashbard, DSL IDE, EC-Rest

```console
 $ efconfig
```

## Backup

* DB Backup 
* DevOpsInsight(Elasticsearch) Backup 
* Data Backup       
    - Configuration Files
       + <DATADIR>/conf  :  Configuration files for the Server and  Artifact Repository
       + <DATADIR>/mysql/mysql.cnf  : Configuration file for MYSQL
  +  <del> <DATADIR>/apache/conf  : Configuration files for the Web Server </del> 
    -  Workspace Directories
       + <DATADIR>/workspace
 
    - Plugins
       + <DATADIR>/plugins
    - Artifact
       + <DATADIR>/repository-data
* Packaging
    - backup.tar.gz
  
```console
 $ efbackup
```

## Restore

* Unpackaging
    - backup.tar.gz
* Data Restore
* DB Restore

```console
 $ efrestore
```

## Test 

* Demo release
   - Promote Release Demo
   - Project: Release Demo-3.0 /  Procedure: Create Release Model / Step: Create Procedures
     + Change string localhost to localagent
   - Project: Release Demo-3.0 /  Procedure: Create Release Model / Step: Set up environments
     + Change string localhost to localagent

## Scaling EF Server

```console
 $ efscale <size>
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

