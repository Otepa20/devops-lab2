docker rm -f gracaotepa-03-web gracaotepa-03-db
docker build --build-arg VERSION=2.0 -t gracaotepa-03/probe:2.0 .
docker volume create gracaotepa-03-data
docker run -d --name gracaotepa-03-db \
  -e POSTGRES_PASSWORD=lab \
  -e POSTGRES_DB=lab \
  -v gracaotepa-03-data:/var/lib/postgresql/data \
  -p 8011:5432 \
  postgres:16-alpine
docker run -d --name gracaotepa-03-web \
  --add-host host.docker.internal:host-gateway \
  -e DATABASE_URL="postgresql://postgres:lab@host.docker.internal:8011/lab" \
  -p 8009:5003 \
  gracaotepa-03/probe:2.0
SECONDS=0
until curl -sf -m 3 localhost:8009/notes > /dev/null || [ $SECONDS -ge 60 ]; do sleep 2; done
curl -s localhost:8009/notes
