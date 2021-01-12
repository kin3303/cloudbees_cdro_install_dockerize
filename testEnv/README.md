## Openshift 설치

```console
# 레포지토리 업데이트
$ sudo yum -y update
$ sudo yum install -y wget
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2
$ sudo  yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 

# Docker 설치 및 실행
$ sudo  yum install -y  docker-ce docker-ce-cli containerd.io
$ sudo systemctl start docker

# 사용자 계정을 docker 그룹에 추가
$ sudo usermod -aG docker $USER
$ newgrp docker

# 도커 데몬 설정
$ sudo mkdir /etc/containers
$ sudo tee /etc/containers/registries.conf<<EOF
[registries.insecure]
registries = ['172.30.0.0/16']
EOF
$ sudo tee /etc/docker/daemon.json<<EOF
{
   "insecure-registries": [
     "172.30.0.0/16"
   ]
}
EOF

# 구성 편집후 systemd 다시 로드하고 Docker 데몬 재시작 및 부팅시 Docker 시작되도록 설정
$ sudo systemctl daemon-reload  && \
 sudo systemctl restart docker  && \
 sudo systemctl enable docker

# IP forwarding 활성화
$ echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf
$ sudo sysctl -p

# 방화벽 설정 - Option 1 > 특정 포트만 허용
$ DOCKER_BRIDGE=`docker network inspect -f "{{range .IPAM.Config }}{{ .Subnet }}{{end}}" bridge`
$ echo $DOCKER_BRIDGE
$ sudo firewall-cmd --permanent --new-zone dockerc && \
sudo firewall-cmd --permanent --zone dockerc --add-source $DOCKER_BRIDGE && \
sudo firewall-cmd --permanent --zone dockerc --add-port={80,443,8443}/tcp && \
sudo firewall-cmd --permanent --zone dockerc --add-port={53,8053}/udp && \
sudo firewall-cmd --reload

# 방화벽 설정 - Option 2 > 방화벽을 그냥 끄기
$  systemctl stop firewalld
$ systemctl disable firewalld

# OpenShift 클라이언트 설치
$ wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz  
$ tar xvf openshift-origin-client-tools*.tar.gz
$ cd openshift-origin-client*/ 
$ sudo mv  oc kubectl  /usr/local/bin/ 


# OpenShift 클라이언트 유틸리티가 설치되어 있는지 확인
$ oc version

# Cluster Up - Option 1 > OKD 로컬 클러스터 시작
$ oc cluster up --routing-suffix=<ServerPublicIP>.xip.io --public-hostname=<ServerPublicIP>.xip.io
# Cluster Up - Option 2 > 도메인이 있으면 아래 명령 사용
$ oc cluster up --routing-suffix=<ServerPublicIP>.xip.io  --public-hostname=<ServerPulicDNSName>
 
...
Creating initial project "myproject" ...
Server Information ...
OpenShift server started.

The server is accessible via web console at:
    https://34.69.214.143.xip.io:8443

You are logged in as:
    User:     developer
    Password: <any value>

To login as administrator:
    oc login -u system:admin
```

## Docker 설치

- Tested with 24GB memory, 8 cores,  Ubuntu 16.04 LTS  

```console
  $ sudo su 
  $ sysctl -w vm.max_map_count=262144
  $ sysctl -w fs.file-max=65536
  $ ulimit -n 65536
  $ ulimit -u 4096
  $ git clone https://github.com/kin3303/CBF_DEMO.git
  $ cd testEnv
  $ chmod +x install.sh && ./install.sh
  $ docker swarm init
```


## Test 도구 설치 

### Step 0. Jenkins 이미지 업로드 (Option) 

- Docker on Docker 되도록 Jenkins 이미지 빌드 후 저장
- 수행후 Docker Compose 파일의 Jenkins 이미지 이름수정 필요
- SCM 에 있는 Dockerfile 기준 1회만 수행
- Dockierfile 에 추가로 작업이 필요 없는 경우 구어놓은 kin3303/jenkins-docker:latest 사용해도 됨

```console
  $ cd ./build
  $ docker login
  $ docker build -t kin3303/jenkins-docker:latest .
  $ docker push kin3303/jenkins-docker:latest 
```
 
###  Step 1. 도메인, SSL 설정

1. 테스트할 도메인 준비( nexus, docker registry, jenkins, sonarqube )
2. `traefik.yaml` 을 열어 `Challenge HTTP` 섹션의  `email:`  을 수정 
3. `docker-compose.yaml` 파일을 열어 `- nexus.letsgohomenow.com` 에 nexus 도메인을 입력
4. `docker-compose.yaml` 파일을 열어 `- registry.letsgohomenow.com` 에 docker registry 용 도메인을 입력 
5. `docker-compose.yaml` 파일을 열어 `- jenkins.letsgohomenow.com` 에 jenkins 도메인을 입력 
6. `docker-compose.yaml` 파일을 열어 `- sonar.letsgohomenow.com` 에 sonarqube 도메인을 입력 

###  Step 2. 테스트 환경 배포 배포

```console
  $ docker stack rm testEnv
  $ docker stack deploy -c docker-compose.yaml testEnv 
```

### Step 3. Potainer 활성화

- Portainer 는 5분 내에 admin 계정을 생성해야 사용 가능하다. 

```
  Portainer - http://your-ip-address:9000
```

### Step 4. Traefik 확인

- 모든서비스가 잘 구동되고 있는지 Traefik 을 통해 확인

```
  Portainer - http://your-ip-address:8080
```

## Test 도구 환경구성 (Nexus)

### Step 1. Nexus 에 docker(host) 레포지토리 설정

1. Nexus 서버 도메인 (https://nexus.letsgohomenow.com) 로 들어가서 admin 으로 로그인 시도한다.
2. admin 초기 패스워드는 Portainer(http://hostIPAddress:9000) 에서 Nexus 컨테이너로 bash 로 접속해 얻어내며 admin 패스워드를 바꾼다.
3. 톱니바퀴 -> Repositories -> Create Repository -> docker(hosted)    
     - Name : docker-registry
     - HTTP : 체크, 5000 입력
     - 내부망에 의해 SSL 인증이 되지 않아 Insecure registry 로 사용해야 되는 경우 아래 설정 
        - Enable Docker V1 API 체크
        - Allow anonymous docker pull 체크
        - 톱니바퀴 > Realms > Docker Bearer Token Realm Active로 이동 > Save
        - /etc/docker/daemon.json 파일을 열어 아래 속성을 추가 및 도커 재시작
        ```console
        $ vi /etc/docker/daemon.json
        {
          "insecure-registries" : ["registry.letsgohomenow.com"]
        }
        $ service docker restart
        ``` 
       - Insecure registry 을 사용하고자 하는 모든 docker client 에도 daemon.json 수정 및 docker 재시작 필요
4. Roles->Create role->Nexus role
     - Role ID: docker-role
     - Role Name: docker-role
     - Filter : docker 로 나오는 것들 모두 Given 으로 이동
     - Create role 버튼 클릭
5. Users->Create local user
     - ID : docker
     - FIrst name : your_first_name
     - Last name : your_last_name
     - Email: your_email
     - Password : docker123
     - Confirm password : docker123
     - Status : active
     - Roles : docker-role 을 Given 으로 이동
     - Create local user 버튼 클릭
6. Sign out -> Sign in -> docker 로 로그인 -> 박스 버튼 클릭 -> Browse
     - docker-registry 에 아무 컨텐츠가 없음을 확인
7. Nexus 서버에 ssh 로 접속하여 아래 명령을 수행한다.
```console  
    $ docker login registry.letsgohomenow.com -u docker -p docker123 
    $ docker pull centos
    $ docker tag centos registry.letsgohomenow.com/centos:latest
    $ docker push registry.letsgohomenow.com/centos:latest
```
8. 박스 버튼 클릭 -> Browse
     - centos 이미지가 업로드 되었음을 확인
     

### Step 2. Docker Registry 와 Openshift 연결 설정 

1. Openshift 에 External Registry 접근을 위한 Secret 생성

```console

$ oc login https://web.letsgohomenow.com:8443 --token=WsOQcb8_aOnFO8UJjpb5KNMJtI3YF5TU2qXscxbtKlM
$ oc project <projectname>
$ oc create secret docker-registry nexus \
--docker-server=https://registry.letsgohomenow.com/ \
--docker-username=docker \
--docker-password=docker123 \
--docker-email=kin3303@gmail.com
```

2. pull/push 서비스 어카운트 에 Secret 마운트

- default 
   - 프로젝트 별로 존재, 이미지 pull 용 SA
- builder
   - 프로젝트 별로 존재, 이미지 push 용 SA

```console
$ oc secrets link default nexus --for=pull
$ oc secrets link builder nexus
$ oc describe sa default
Name:                default
Namespace:           my-dev
Labels:              <none>
Annotations:         <none>
Image pull secrets:  default-dockercfg-s26q7
                     nexus
Mountable secrets:   default-token-jgcq5
                     default-dockercfg-s26q7
Tokens:              default-token-jgcq5
                     default-token-mxfg2
Events:              <none>
$ oc describe sa builder
Name:                builder
Namespace:           my-dev
Labels:              <none>
Annotations:         <none>
Image pull secrets:  builder-dockercfg-k4bhw
Mountable secrets:   builder-token-s2hzz
                     builder-dockercfg-k4bhw
                     nexus
Tokens:              builder-token-8wvs7
                     builder-token-s2hzz
Events:              <none>

```

3. 빌드 결과가 External Repository 에 push/pull 하도록 BildConfig, Deployment 수정 

- BuildConfig

```
...
spec:
  output:
    to:
      kind: DockerImage
      name: registry.letsgohomenow.com/cakephp-ex:latest
    pushSecret:
      name: nexus
...
```

- Deployment, DeploymentConfig

```
...
      containers:
      - name: my-world
        image: registry.letsgohomenow.com/centos:latest
        ports:
        - containerPort: 80
        imagePullSecrets:
        - name: nexus
...
```



## Test 도구 환경 구성 (Jenkins)
 
### Step 1. Docker Plugin 설치 및 Repository 연결

```
  1. Docker Pipeline 플러그인 설치
  2. dockerHub 에 로그인하기 위한 Credential 을 Jenkins 에 추가 
      Manage Jenkins -> Manage Credentials -> Provider : Jenkins -> Global credentials  -> Add Credentials (최신버전)
        Kind : Username with password
        Scope : Global
        Username : dockerHub 계정명
        Password : dockerHub 패스워드
        ID : docker-hub
        Description : docker-hub
```
 

### Step 2 : Jenkins 에 Openshift Client Plugin 설치
 
- Manage Jenkins => Manage Plugins => Available Tab => Filter 로 "Openshift" 입력후 아래 설정을 진행

```
  1. 플러그인 선택
     - Openshift Client
     - Openshift Login
     - Openshift Sync
  2. Download now and install after restart 선택
  3. Jenkins 재시작
  4. 재시작후 설치된 플러그인에 위 플러그인들이 제대로 들어갔는지 확인
```

### Step 3 : Global Tool Configuration 설정

- Manage Jenkins => Global Tool Configuration 으로 이동해 아래 설정을 진행

```
  1. Openshift Client Tools 
    - Add OpenShift Client Tools 클릭
      - Name : oc
      - Install automatically : 체크
      - Add Openshift Client Tools 클릭
      - "Extract *.zip/*.tar.gz" 선택
      - Openshift About 페이지에서 Openshift 버전 확인 후 https://mirror.openshift.com/pub 에서 알맞은 Client 의 URL 을 복사
      - Download URL for binary archive : https://mirror.openshift.com/pub/openshift-v3/clients/3.11.0-0.32.0/linux/oc.tar.gz
    - Apply 버튼 클릭  
```

### Step 4 : Openshift Cluster 추가 설정

- Manage Jenkins => Configure System 으로 이동해 아래 설정을 진행

```
  1. Cluster Configuration
    - Add OpenShift Cluster 클릭
      - Cluster Name : openshift-cluster
      - API Server URL : oc login --server=<이 값을 복사> --token=<TOKEN>
      - Disable TLS Verify : 체크
      - Credentials : Add 하여 추가 후 해당 Credential 선택
        - Kind : Openshift Token for Openshift Client Plugin
        - Token : 로그인 토큰 ( oc whoami -t )
        - ID : my-user-token
    - Apply 버튼 클릭 
```






