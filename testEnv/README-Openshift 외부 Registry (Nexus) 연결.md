
https://docs.openshift.com/container-platform/4.1/openshift_images/managing_images/using-image-pull-secrets.html

## Step 1. External Registry 로그인용 Secret 생성

```console

$ oc login https://web.letsgohomenow.com:8443 --token=WsOQcb8_aOnFO8UJjpb5KNMJtI3YF5TU2qXscxbtKlM
$ oc project <projectname>
$ oc create secret docker-registry nexus \
--docker-server=https://registry.letsgohomenow.com/ \
--docker-username=docker \
--docker-password=docker123 \
--docker-email=kin3303@gmail.com
```

## Step 2. pull/push 서비스 어카운트 에 Secret 마운트

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

## Step 3. 빌드 결과가 External Repository 에 push/pull 하도록 BildConfig, Deployment 수정 

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
