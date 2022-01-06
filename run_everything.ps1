docker network create sio.network;
$eventpublisherArgs = "-f ""../sio-eventpublisher/docker-compose.yml"" -f ""../sio-eventpublisher/docker-compose.override.yml""";
$identityArgs = "-f ""../sio-identity/docker-compose.yml"" -f ""../sio-identity/docker-compose.override.yml""";
$apiArgs = "-f ""../sio-api/docker-compose.yml"" -f ""../sio-api/docker-compose.override.yml""";
$translationOptionImporter = "-f ""../sio-translation-option-importer/docker-compose.yml"" -f ""../sio-translation-option-importer/docker-compose.override.yml""";
$eventNotifierArgs = "-f ""../sio-eventnotifier/docker-compose.yml"" -f ""../sio-eventnotifier/docker-compose.override.yml""";
$frontArgs = "-f ""../sio-front/docker-compose.yml"" -f ""../sio-front/docker-compose.override.yml""";
$mailerArgs = "-f ""../sio-mailer/docker-compose.yml"" -f ""../sio-mailer/docker-compose.override.yml""";

# Invoke-Expression "docker-compose $eventpublisherArgs $identityArgs $apiArgs $translationOptionImporter build --parallel"

Invoke-Expression "docker-compose -f ""docker-compose.yml"" -f ""docker-compose.override.yml"" -p ""sio-shared"" up --no-deps -d --remove-orphans";
Invoke-Expression "docker-compose $eventpublisherArgs -p ""sio-eventpublisher"" up --no-deps -d --remove-orphans";
Invoke-Expression "docker-compose $eventNotifierArgs -p ""sio-eventnotifier"" up --no-deps -d --remove-orphans";
Invoke-Expression "docker-compose $mailerArgs -p ""sio-mailer"" up --no-deps -d --remove-orphans";
Invoke-Expression "docker-compose $identityArgs -p ""sio-identity"" up --no-deps -d --remove-orphans";
Invoke-Expression "docker-compose $apiArgs -p ""sio-api"" up --no-deps -d --remove-orphans";
Invoke-Expression "docker-compose $translationOptionImporter -p ""sio-translation-option-importer"" up --no-deps -d --remove-orphans";
Invoke-Expression "docker-compose $frontArgs -p ""sio-front"" up --no-deps -d --remove-orphans";