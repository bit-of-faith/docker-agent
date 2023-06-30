# docker-agent

## Development
Build: `docker build -t  ghcr.io/bit-of-faith/docker-agent:latest .`
Push: `docker push ghcr.io/bit-of-faith/docker-agent:latest`

## Init Usage

Demo run: `.\init.ps1 -downloadUrl "https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/5.13.0.66756/sonar-scanner-msbuild-5.13.0.66756-net46.zip" -sonarToken "sqp_3356fb7d74b8852328a827ce0d612f559a4bdd39" -target "sonar-scanner-msbuild-net46"`