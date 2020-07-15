1. Workflow Dashboard 에 CO_WEB_DEMO 를 넣기
2. CO_WEB_DEMO => Initialize => Create SonarQube Configuration
	1. 변수 host 찾아서 IP 주소 넣기
3. CO_WEB_DEMO 의 Initialize 프로시저 실행
4. Job 중  jira job 찾아서 수동으로 돌리기
5. SonarQube Plugin Configuration id/password 다시 넣기 
	1. HOSTIP
	2. admin
	3. admin
	4. Test connection? 체크 
6. SonarQube 서버 SonarQube Project 생성
	1. http://HOSTIP:9000
	2. 프로젝트 명 : SpringCodeTest
	3. 프로젝트 키 : SpringCodeTest  
7. Insight
	1. Insight 서버에서 System Administrator 를 열어 TimeZone - Asia/Seoul 로 설정   
	2. Release 를 1회 정도 수행
	3. Insight 의 JIRA Configuration 을 수행
8. Electric Cloud Code Commit Report 생성   \
9. Slack Configuration
	1. 자신의 workspace 로 로그인 
		1. https://fcdevops.slack.com/
	2. Channels -> alert 만들기
	3. Apps -> webhook 으로 검색 -> Incoming WebHooks Add 
		1. Post to Channel : alert 
	4. Endpoint URL 로 slackcfg 생성
	5. Message 
          ```
          {
             "text": "Hello, world."
          }
          ```
