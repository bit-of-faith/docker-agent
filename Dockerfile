FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64

LABEL org.opencontainers.image.source=https://github.com/bit-of-faith/docker-agent
LABEL org.opencontainers.image.description="Azure Docker Agent"

WORKDIR /azp

COPY start.ps1 .
COPY init.ps1 .
COPY SonarQube.Analysis.xml .

CMD powershell .\start.ps1