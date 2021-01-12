
## Docker 설치

- Tested with 24GB memory, 8 cores,  Ubuntu 16.04 LTS  

```console
  $ sudo su 
  $ sysctl -w vm.max_map_count=262144
  $ sysctl -w fs.file-max=65536
  $ ulimit -n 65536
  $ ulimit -u 4096
  $ git clone https://github.com/kin3303/DDI_OPENSHIFT.git
  $ cd DDI_OPENSHIFT
  $ git checkout testEnv
  $ cd nexus
  $ chmod +x install.sh && ./install.sh
  $ docker swarm init
```

## Nexus 설치 
 
###  Step 1. 도메인, SSL 설정

1. 테스트할 도메인을 두 개 준비( 하나는 nexus 하나는 docker registry )
2. `traefik.yaml` 을 열어 `Challenge HTTP` 섹션의  `email:`  을 수정 
3. `docker-compose.yaml` 파일을 열어 `- nexus.letsgohomenow.com` 에 nexus 도메인을 입력
4. `docker-compose.yaml` 파일을 열어 `- registry.letsgohomenow.com` 에 docker registry 용 도메인을 입력 

###  Step 2. Nexus 배포

```console
  $ docker stack rm traefik
  $ docker stack deploy -c docker-compose.yaml traefik 
```

### Step 3. Potainer 활성화

- Portainer 는 5분 내에 admin 계정을 생성해야 사용 가능하다. 

```
  Portainer - http://your-ip-address:9000
```

### Step 4. Nexus 에 docker(host) 레포지토리 설정

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
