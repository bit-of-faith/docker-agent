FROM mcr.microsoft.com/windows/servercore:ltsc2022-amd64

WORKDIR /azp

COPY start.ps1 .
COPY init.ps1 .
COPY SonarQube.Analysis.xml .

CMD powershell .\start.ps1