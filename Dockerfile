FROM winamd64/openjdk:11-jre

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN \
    setx /M SONARQUBE_VERSION '7.9.1'; \
    setx /M SONARQUBE_JDBC_URL "'jdbc:postgresql://192.168.54.35:5432/sonar'" ; \
    setx /M SONARQUBE_JDBC_USERNAME 'postgres'; \
    setx /M SONARQUBE_JDBC_PASSWORD 'postgres'; \
    setx /M SONARQUBE_HOME C:\\sonarqube

RUN powershell -command \
    Write-Debug [Net.ServicePointManager]::SecurityProtocol ;\
    [Net.ServicePointManager]::SecurityProtocol ;\
    [Net.ServicePointManager]::SecurityProtocol = 'Ssl3', 'Tls', 'Tls11', 'Tls12'; \
    Invoke-WebRequest "https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$env:SONARQUBE_VERSION.zip" -OutFile "sonarqube.zip"; \
    Expand-Archive -Path c:\sonarqube.zip -DestinationPath C:\ ; \
    Remove-Item sonarqube.zip ; \
    Rename-Item sonarqube-$env:SONARQUBE_VERSION sonarqube ; \
    Rename-Item c:\sonarqube\extensions c:\sonarqube\original_extensions

VOLUME c:\\sonarqube\\extentions

EXPOSE 9000


WORKDIR C:\\sonarqube

COPY sonarqube.cmd C:/sonarqube/bin/

ENTRYPOINT ["C:\\sonarqube\\bin\\sonarqube.cmd"]