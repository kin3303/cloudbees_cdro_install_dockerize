1. Workflow Dashboard 에 CO_WEB_DEMO 를 넣기
2. CO_WEB_DEMO => Initialize => Create SonarQube Configuration
	1. 변수 host 찾아서 IP 주소 넣기
3. CO_WEB_DEMO 의 Initialize 프로시저 실행
4. Job 중  jira job 찾아서 수동으로 돌리기
5. SonarQube Plugin Configuration id/password 다시 넣기 
	1. admin
	2. admin
	3. Test connection? 체크
6. Check Style 플러그인 수정
	1. Report 가 나오도록 plugin - run command 스텝 뒤에 새로운 스텝을 만들고 다음 내용 추가
		1. ec-perl
	2. 플러그인 프로퍼티중 template 프로퍼티를 변경
7. SonarQube 서버 SonarQube Project 생성
	1. http://cloudbees.devops.mousoft.co.kr:9000/admin/projects_management
	2. 프로젝트 명 : SpringCodeTest
	3. 프로젝트 키 : SpringCodeTest 
8. CI 기능 ON
	1. ECSCM-SentryMonitor 스캐쥴 ON
	2. TimeZone - Asia/Seoul 로 설정
	3. CO_WEB_DEMO 스캐쥴 ON
	4. HOME->CI 에서 Project 로 CO_WEB_DEMO 프로젝트를 Add project
9. Insight
	1. Insight 서버에서 System Administrator 를 열어 TimeZone - Asia/Seoul 로 설정 
10. Workflow 를 5번 정도 CI 로 돌려 데이터를 쌓기  
11. Release
	1. Release 를 1회 정도 수행
	2. Insight 의 JIRA Configuration 을 수행
12. Electric Cloud Code Commit Report 생성 및 프로시저 한번 돌리기
13. CO_SIMPLE_ROLLBACK_APP 
	1. Artifact 생성
	2. Rollback App 생성
14. SonarQube 서버 SpringCodeTest 프로젝트 지우고 다시 SonarQube Project 생성
	2. 프로젝트 명 : SpringCodeTest
	3. 프로젝트 키 : SpringCodeTest 
15. Credential 수정
	1. https://cloudbees.devops.mousoft.co.kr/commander/link/editCredential/projects/CO_WEB_DEMO/credentials/efLogin 
