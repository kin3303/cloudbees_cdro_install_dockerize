# ElectricFlow 데모 프로젝트

- 권장사양 16GB 메모리 , 8 코어 이상
- 사용 가능 Tag 는 https://cloud.docker.com/u/kin3303/repository/docker/kin3303/commanderserver 에서 확인

## ElectricFlow 데모 프로젝트 설치

```console
 $ sudo ./setup/install.sh
 $ export TAG=<latest, 9.0.1 가능>
 $ license.xml 파일을 ./data/conf 폴더에 저장
 $ make clean
 $ docker-compose up -d
 $ docker-compose logs -f
```

## EFServer HAProxy Scaling 

```console
 $ docker-compose scale commanderserver=n
 $ docker-compose logs -f
```

## 서버 구동 확인 및 정지

1. 권장 사양으로 테스트시 서버 업로드 까지 10분 정도 소요
2. 서버 구성에 필요한 컨테이너 구동은 아래 세이트에서 확인 가능
   http://****IP****:1936/haproxy?stats
3. 해당 사이트에서 모든 컨테이너가 구동중이 되면 (녹색불) 라이선스를 아래 명령으로 Import
```console
  $ docker exec $(docker ps |grep commanderserver_1|awk '{print $1}')   /tmp/scripts/import_license_and_create_resource.sh
```
4. 서버 구동 확인 
  https://****IP****
 
5. 사용후 서버 구동 중단
```console
  $ docker exec $(docker ps |grep commanderserver_1|awk '{print $1}')   /tmp/scripts/import_license_and_create_resource.sh
``` 

6. 데이터 정리시는 아래 명령사용
```console
 $  make clean
```

## 새 도커 이미지 저장

```console
 $ Installer 를 ./ 폴더에 저장
 $ export EFLOW_INSTALLER=ElectricFlow-xxxx
 $ export TAG=xxxx
 $ make
``` 

