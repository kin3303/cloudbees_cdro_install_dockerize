# EF 데모 프로젝트

- 권장사양 16GB 메모리 , 8 코어 이상
- EFServer Scaling 1개 올릴시 Memory 3GB 메모리 , 2 코어 추가 필요함 
- 사용 가능 Tag 는 https://cloud.docker.com/u/kin3303/repository/docker/kin3303/commanderserver 에서 확인

## 실행환경 설치

```console
 $ sudo ./setup/install.sh 
```

## 구동

```console
 $ sudo ./setup/start.sh <TAG>
```

## 서버 스캐일링 

```console
 $ sudo ./setup/scale.sh <size>
```

## 세부설정

1. HaProxy 작동확인
```
   http://****IP****:1936/haproxy?stats
```   

2. License 임포트
```console
  $ docker exec $(docker ps |grep commanderserver_1|awk '{print $1}')   /tmp/scripts/import_license_and_create_resource.sh
```

3. 모든 데이터 
```console
 $  make clean
```

4. 이미지 추가
```console
 $ Installer 를 ./ 폴더에 저장
 $ export EFLOW_INSTALLER=ElectricFlow-xxxx
 $ export TAG=xxxx
 $ make
``` 

