# Spring Web App Demo

1. CO_WEB_DEMO => Initialize
	1.  Create SonarQube Configuration -> host 찾아서 IP 주소 넣기
	2.  CO_WEB_DEMO 의 Initialize 프로시저 실행
	3. Job 중  jira job 찾아서 수동으로 돌리기
2. Plugin  Install & Promote
	1. Slack
	2. EC-AuditReports
	3. unplug 
3. Plugin Project 열어서 workspace, resource 설정
	1. Slack
	2. EC-AuditReports
	3. SonarQube
4. SonarQube Plugin Configuration 수정
	1. admin / admin
	2. Test connection? 체크 
5. SonarQube 서버 SonarQube Project 생성
	1. http://HOSTIP:9000
	2. 프로젝트 명 : SpringCodeTest
	3. 프로젝트 키 : SpringCodeTest  
6. Slack 에 WebHook 만들기
	1. 자신의 workspace 로 로그인  ->  https://plateerworkspace.slack.com/
	2. Channels -> alert 만들기
	    1. Apps -> webhook 으로 검색 -> Incoming WebHooks Add -> Post to Channel : alert 
	4. Configuration 생성  
		1. Name : slackcfg
		2. Endpoint URL : https://hooks.slack.com/services/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
7. Insight 서버에서 System Administrator 를 열어 TimeZone - Asia/Seoul 로 설정   
8. Electric Cloud => Code Commit Report 생성 


# Kubernetes Demo

1. Kubernetes 클러스터 생성 및 설정
	1. GKE 생성
	2. SA 계정 생성
		```
		cat > root-sa-admin-access.yaml <<EOF
		apiVersion: v1
		kind: ServiceAccount
		metadata:
		  name:  root-sa
		  namespace: kube-system
		---
		kind: ClusterRoleBinding
		apiVersion: rbac.authorization.k8s.io/v1beta1
		metadata:
		  name: root-sa-kube-system-cluster-admin
		subjects:
		- kind: ServiceAccount
		  name: root-sa
		  namespace: kube-system
		roleRef:
		  apiGroup: rbac.authorization.k8s.io
		  kind: ClusterRole
		  name: cluster-admin
		EOF
		```
	3. SA 계정 배포
		```
		kubectl apply -f root-sa-admin-access.yaml
		```
	4. 계정 Token 얻기
		```
		// kubernetes API-Server 접근 정보
		APISERVER=$(kubectl config view | grep server | cut -f 2- -d ":" | tr -d " ")

		// 계정 Token 얻기
		ROOTTOKEN="$(kubectl get secret -nkube-system \
		$(kubectl get secrets -nkube-system | grep root-sa | cut -f1 -d ' ') \
		-o jsonpath='{$.data.token}' | base64 --decode)"

		//토큰으로 통신확인
		curl -D - --insecure --header "Authorization: Bearer $ROOTTOKEN" $APISERVER/api/v1/namespaces/default/services

		// 얻은 정보 확인
		echo $APISERVER
		    https://34.67.84.236
		echo $ROOTTOKEN
		    eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3Nlcn...
		
		// 마스터 노드 버전 확인
		kubernetes get no 
		    v1.14.10-gke.36
		```
2. EC-Kubernetes Configuration 생성
	1. Kubernetes API Endpoint : https://34.67.84.236/
	2. User Name : root-sa
	3. Kubernetes Bearer token : eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3Nlcn...
	4. Kubernetes Version: 1.14
	5. URI Path for Checking Cluster: api

3. Environment 생성
	1. Cluster 타입으로 생성 -> EC-Kubernetes Configuration 이름 입력

4. Service Catalog 를 통한 Microservice 구성
	1. Import Kubernetes YAML file
		1. Kubernetes YAML File Content: https://github.com/dockersamples/example-voting-app/blob/master/kube-deployment.yml
		2. Project Name: Environment 와 동일한 Project
		3. Create Microservices within an Application: Uncheck / Check
		4. Application Name: 3번이 Check 인 경우만 사용
		5. Environment Project: Environment 와 동일한 Project
		6. Environment Name: Environment 이름
		7. Cluster Name: Environment 내부에 정의한 Cluster 의 Tier 이름
		
		




