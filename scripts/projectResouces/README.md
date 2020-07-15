1. Workflow Dashboard 에 CO_WEB_DEMO 를 넣기
2. CO_WEB_DEMO => Initialize => Create SonarQube Configuration
	1.  host 찾아서 IP 주소 넣기
	2.  CO_WEB_DEMO 의 Initialize 프로시저 실행
	3. Job 중  jira job 찾아서 수동으로 돌리기
3. Slack Plugin Install & Promote
4. JIRA, Slack Plugin Project 열어서 workspace, resource 설정
5. Configuration 수정 - SonarQube Plugin 
	1. admin / admin
	2. Test connection? 체크 
6. SonarQube 서버 SonarQube Project 생성
	1. http://HOSTIP:9000
	2. 프로젝트 명 : SpringCodeTest
	3. 프로젝트 키 : SpringCodeTest  
7. Slack 에 WebHook 만들기
	1. 자신의 workspace 로 로그인  ->  https://fcdevops.slack.com/
	2. Channels -> alert 만들기
	3. Apps -> webhook 으로 검색 -> Incoming WebHooks Add -> Post to Channel : alert 
8. Configuration 생성 - Slack Plugin 
	1. Endpoint URL 로 slackcfg 생성
	2. 플러그인에 메시지는 아래 형식으로 넣음
          ```
          {
             "text": "Hello, world."
          }
          ```
9. Insight 서버에서 System Administrator 를 열어 TimeZone - Asia/Seoul 로 설정   
10. Electric Cloud Code Commit Report 생성

