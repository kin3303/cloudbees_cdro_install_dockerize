# CloudBees Flow Demo Project

- Recommended 24GB memory, 8 cores or more, Tested with Ubuntu 16.04 / 18.04 LTS 
- Available EF tags : latest, 9.2.0, 9.1.0, 9.0.1

## Step 1. Initialize

- To get master branch source , execute follow commands
- To get another branch source, change master to branchName then execute commands

```console
  $ sudo su
  $ sysctl -w vm.max_map_count=262144 
  $ wget -O init.sh  https://github.com/kin3303/CBF_DEMO/blob/master/init.sh?raw=true && chmod 777 init.sh && ./init.sh master && source ~/.bashrc && cd master && chmod 777 *
```

## Step 2. Install some packages 

```console
  $ cbfInstallPackage
```

## Step 3. Install CloudBees Flow

```console
  $ cbfInstallCBF
```
After using this command, 
check the output log in ur PC and if the Cloudbees Flow server is running, exit by Ctrl +C and then 
open Webbrowser with the displayed URL for set the Database Configuration.
You can use mysql server that I already installed. To achieve this, the following settings should be set.
```
Database Type : Mysql
Database Name : ecdb
Host name : db
Port : 3306
Username : root
Password : ecdb 
```

If you want to use your own DB, please refer to the following to set up your DB.

```
CREATE DATABASE IF NOT EXISTS ecdb CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE DATABASE IF NOT EXISTS ecdb_upgrade CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'ecdb'@'%' IDENTIFIED BY 'flow_pass';
GRANT ALL PRIVILEGES ON ecdb.* TO ecdb@'%';
GRANT ALL PRIVILEGES ON ecdb_upgrade.* TO 'ecdb'@'%';
FLUSH PRIVILEGES;
```

## Step 4. Auto Configuration

* Requrement 1 : This is available after server activation
* Requrement 2 : License file must be in **/tmp/license.xml**
* What to do
   - Import license
   - Add resouces - localagent, apacheAgent, repositoryAgent
   - Add repository - default
   - Config devopsinsight server connection
   - Install plugins - Release Demo, Job Dashbard, Workflow Dashbard, DSL IDE, EC-Rest

```console
 $ cbfConfigEnv
```

## Step 5 (OP). Demo Configuration

If you want to see demo, please use follow command.

```console
 $ cbfSetDemo
```

## Upload EF Docker Images

- Requrement : Save Flow, Devops Installer in **/tmp** folder

```console
 $ cd <SourceRoot>
 $ export EFLOW_DEV_INSTALLER=CloudBeesFlowDevOpsInsightServer-x64-9.2.0.139827
 $ export EFLOW_INSTALLER=CloudBeesFlow-x64-9.2.0.139827
 $ export TAG=latest
 $ docker login
 $ make
``` 

