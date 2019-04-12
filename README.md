# ElectricFlow 데모 프로젝트

- 권장사양 16GB 메모리 , 8 코어 이상
- 사용 가능 Tag 는 https://cloud.docker.com/u/kin3303/repository/docker/kin3303/commanderserver 에서 확인

## 테스트 환경 설치 (단일서버용)

```console
 $ sudo ./setup/install.sh
 ```

## EFServer 인스톨 

```console
 $ export TAG=latest
 $ 인스톨러 다운로드
 $ export EFLOW_INSTALLER=<EFInstaller위치>
 $ license.xml 파일을 ./data/conf 폴더에 저장
 $ docker-compose up -d
 $ docker-compose logs -f
```

## EFServer HAProxy Scaling 

```console
 $ EFServer 인스톨 종료후 아래 명령어 가능
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

## Docker Stack Test

```console
 $ make clean
 $ TAG=latest docker stack deploy -c docker-stack-test2.yml EF
 $ docker service ls
 $ docker stack rm EF
 $ docker service logs -f EF_commanderserver
```

