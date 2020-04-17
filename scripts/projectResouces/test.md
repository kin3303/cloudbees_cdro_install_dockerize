Workflow Dashboard 에 CO_WEB_DEMO 를 넣기
CO_WEB_DEMO => Initialize => Create SonarQube Configuration
변수 host 찾아서 IP 주소 넣기
CO_WEB_DEMO 의 Initialize 프로시저 실행
Job 중  jira job 찾아서 수동으로 돌리기
SonarQube Plugin Configuration id/password 다시 넣기 
admin
admin
Test connection? 체크
Check Style 플러그인 수정
Report 가 나오도록 plugin - run command 스텝 뒤에 새로운 스텝을 만들고 다음 내용 추가
ec-perl
플러그인 프로퍼티중 template 프로퍼티를 변경
SonarQube 서버 SonarQube Project 생성
http://cloudbees.devops.mousoft.co.kr:9000/admin/projects_management
프로젝트 명 : SpringCodeTest
프로젝트 키 : SpringCodeTest 
CI 기능 ON
ECSCM-SentryMonitor 스캐쥴 ON
TimeZone - Asia/Seoul 로 설정
CO_WEB_DEMO 스캐쥴 ON
HOME->CI 에서 Project 로 CO_WEB_DEMO 프로젝트를 Add project
Insight
Insight 서버에서 System Administrator 를 열어 TimeZone - Asia/Seoul 로 설정 
Artifacts
Workflow 를 5번 정도 CI 로 돌려 데이터를 쌓기 
코드의 Title 을 변경해서 구분이 쉽게 하기  
Release
Release 를 1회 정도 수행
Insight 의 JIRA Configuration 을 수행
Electric Cloud Code Commit Report 생성 및 프로시저 한번 돌리기
Git Setup for DevOps Insight - efSample
gitcfg
https://github.com/kin3303/efwebsample.git
master
Release Command Center Schedules - efsample
Collect Reporting Data - commits - efwebsample
    2. Git Setup for DevOps Insight - CBFDemo
gitcfg
https://github.com/kin3303/CBF_DEMO.git
master
Release Command Center Schedules - cb
Collect Reporting Data - commits - cb
     3. local, default 
CO_SIMPLE_ROLLBACK_APP 
Artifact 생성
Rollback App 생성
SonarQube 서버 SpringCodeTest 프로젝트 지우고 다시 SonarQube Project 생성
http://cloudbees.devops.mousoft.co.kr:9000/admin/projects_management
프로젝트 명 : SpringCodeTest
프로젝트 키 : SpringCodeTest 
Credential 수정
https://cloudbees.devops.mousoft.co.kr/commander/link/editCredential/projects/CO_WEB_DEMO/credentials/efLogin 
