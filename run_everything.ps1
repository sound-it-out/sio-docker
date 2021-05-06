docker network create sio.network;
docker-compose up -d
docker-compose `
    -f "docker-compose.yml" `
    -f "docker-compose.override.yml" `
    -f "docker-compose.store.yml" `
    -f "docker-compose.store.override.yml" `
    -f "docker-compose.cache.yml" `
    -f "docker-compose.cache.override.yml" `
    up -d