# CloudBees Flow Demo Project

- Tested with 24GB memory, 8 cores,  Ubuntu 16.04 LTS 
- Available EF tags : latest, 9.2.0, 9.1.0, 9.0.1

## Step 1. Initialization

- To get master branch source , execute follow commands
- To get another branch source, change master to branchName then execute commands

```console
  $ sudo su
  $ sysctl -w vm.max_map_count=262144 
  $ wget -O init.sh  https://github.com/kin3303/CBF_DEMO/blob/master/init.sh?raw=true && chmod 777 init.sh && ./init.sh master && source ~/.bashrc && cd master && chmod 777 *
```

## Step 2. Installing required packages 

```console
  $ cbfInstallPackage
```

## Step 3. Installing CloudBees Flow

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

If you want to use your own DB, you need to execute query that I mention below and use it for Database Configuration.

```
CREATE DATABASE IF NOT EXISTS ecdb CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE DATABASE IF NOT EXISTS ecdb_upgrade CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'ecdb'@'%' IDENTIFIED BY 'flow_pass';
GRANT ALL PRIVILEGES ON ecdb.* TO ecdb@'%';
GRANT ALL PRIVILEGES ON ecdb_upgrade.* TO 'ecdb'@'%';
FLUSH PRIVILEGES;
```

Additionally you need to require modification of mysql.cnf file as follow:

```
[client]
default-character-set=utf8

[mysql]
default-character-set=utf8

[mysqld]
init_connect='SET collation_connection = utf8_unicode_ci' 
init_connect='SET NAMES utf8' 
character-set-server=utf8 
collation-server=utf8_unicode_ci 
skip-character-set-client-handshake
port=3306
transaction-isolation=READ-COMMITTED
table_open_cache=512
sort_buffer_size=6M
tmp_table_size=256M
max_heap_table_size=64M
read_rnd_buffer_size=256K
innodb_buffer_pool_size=1024M
max_allowed_packet=1024M
max_connections=200
table_open_cache=512
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

If you want to use demo projects, please use follow command.

```console
 $ cbfSetDemo
```

## Upload CloudBees Flow Docker Images

- Requrement : Save Flow, Devops Installer in **/tmp** folder

```console
 $ cd <SourceRoot>
 $ export INSIGHT_INSTALLER=CloudBeesFlowDevOpsInsightServer-x64-9.2.0.139827
 $ export FLOW_INSTALLER=CloudBeesFlow-x64-9.2.0.139827
 $ export TAG=latest
 $ docker login
 $ make
``` 

