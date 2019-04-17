# EF 데모 프로젝트

- 권장사양 16GB 메모리 , 8 코어 이상 , Ubuntu 16.04 이상
- EFServer Scaling 1개 올릴시 Memory 3GB 메모리 , 2 코어 추가 필요함 
- 사용 가능 Tag 는 https://cloud.docker.com/u/kin3303/repository/docker/kin3303/commanderserver 에서 확인

## 실행환경 설치

```console
 $ wget -O install.sh  https://github.com/kin3303/efdemo/blob/master/setup.sh?raw=true
 $ sudo ./setup.sh
```

## 구동

```console
 $ sudo ./setup/start.sh <TAG>
```

## Licnese 임포트 + 리소스 자동설정

- 서버 활성화 후 사용가능 (http://YOUR_IP_ADDRESS:1936/haproxy?stats)
- License 파일이 있어야 사용가능
- conf 폴더에 license.xml 파일을 넣어놓은 후 아래 명령 실행
```console
  $ sudo ./setup/autoConfig.sh
```

## 서버 스캐일링 

```console
 $ sudo ./setup/scale.sh <size>
```

## 이미지 추가

- 준비사항 : Flow , Devops Installer 를 /tmp 폴더에 저장

```console
 $ export EFLOW_DEV_INSTALLER=ElectricFlowDevOpsInsightServer-x64-9.0.1.136311
 $ export EFLOW_INSTALLER=ElectricFlow-x64-9.0.1.136311
 $ export TAG=9.0.1
 $ docker login
 $ make
``` 

