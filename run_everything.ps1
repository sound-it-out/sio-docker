param(
    [switch] $cleanAll,
    [switch] $clean,
    [switch] $reBuild,
    [switch] $buildShared,
    [switch] $buildMailer,
    [switch] $buildFront,
    [switch] $buildEventPublisher,
    [switch] $buildEventNotifier,
    [switch] $buildIdentity,
    [switch] $buildApi,
    [switch] $buildTranslationOptionImporter
)

function Clean-Conatiners {
    param (
        [string]$containerRoot
    )

    $containerIds = $(docker ps -aq -f label=com.docker.compose.project=$containerRoot);
    Invoke-Expression "docker kill $containerIds";
    Invoke-Expression "docker rm $containerIds";
    Invoke-Expression "docker volume prune -f";
    docker image prune
    
};

$reBuild = $reBuild -or $cleanAll;

$buildShared = $buildShared -or $reBuild;
$buildMailer = $buildMailer -or $reBuild;
$buildFront = $buildFront -or $reBuild;
$buildEventPublisher = $buildEventPublisher -or $reBuild;
$buildEventNotifier = $buildEventNotifier -or $reBuild;
$buildIdentity = $buildIdentity -or $reBuild;
$buildApi = $buildApi -or $reBuild;
$buildTranslationOptionImporter = $buildTranslationOptionImporter -or $reBuild;

if($cleanAll) {
    $containerIds = $(docker ps -a -q);
    if($containerIds) {
        Invoke-Expression "docker kill $containerIds";
        Invoke-Expression "docker rm $containerIds";        
    }

    docker image prune -a -f
    docker volume prune -f
    docker builder prune -a -f
}

$networkName = "sio.network"

if (!(docker network ls | select-string $networkName -Quiet))
{
    docker network create $networkName
}

$sharedArgs = "-f ""$PSScriptRoot/docker-compose.yml"" -f ""$PSScriptRoot/docker-compose.override.yml""";
$eventPublisherArgs = "-f ""$PSScriptRoot/../sio-eventpublisher/docker-compose.yml"" -f ""$PSScriptRoot/../sio-eventpublisher/docker-compose.override.yml""";
$identityArgs = "-f ""$PSScriptRoot/../sio-identity/docker-compose.yml"" -f ""$PSScriptRoot/../sio-identity/docker-compose.override.yml""";
$apiArgs = "-f ""$PSScriptRoot/../sio-api/docker-compose.yml"" -f ""$PSScriptRoot/../sio-api/docker-compose.override.yml""";
$translationOptionImporterArgs = "-f ""$PSScriptRoot/../sio-translation-option-importer/docker-compose.yml"" -f ""$PSScriptRoot/../sio-translation-option-importer/docker-compose.override.yml""";
$eventNotifierArgs = "-f ""$PSScriptRoot/../sio-eventnotifier/docker-compose.yml"" -f ""$PSScriptRoot/../sio-eventnotifier/docker-compose.override.yml""";
$frontArgs = "-f ""$PSScriptRoot/../sio-front/docker-compose.yml"" -f ""$PSScriptRoot/../sio-front/docker-compose.override.yml""";
$mailerArgs = "-f ""$PSScriptRoot/../sio-mailer/docker-compose.yml"" -f ""$PSScriptRoot/../sio-mailer/docker-compose.override.yml""";

$sharedConatinerRoot = "sio-shared";
$mailerConatinerRoot = "sio-mailer";
$frontConatinerRoot = "sio-front";
$eventpublisherConatinerRoot = "sio-event-publisher";
$eventNotifierConatinerRoot = "sio-event-notifier";
$identityConatinerRoot = "sio-identity";
$apiConatinerRoot = "sio-api";
$translationOptionImporterConatinerRoot = "sio-translation-option-importer";


if ($buildShared) {
    if($clean) {
        Clean-Conatiners -containerRoot $sharedConatinerRoot;
    }

    Invoke-Expression "docker compose $sharedArgs build --parallel";
}

if ($buildMailer) {
    if($clean) {
        Clean-Conatiners -containerRoot $mailerConatinerRoot;
    }

    Invoke-Expression "docker compose $mailerArgs build --parallel";
}

if ($buildFront) {    
    if($clean) {
        Clean-Conatiners -containerRoot $frontConatinerRoot;
    }

    Invoke-Expression "docker compose $frontArgs build --parallel";
}

if ($buildEventPublisher) {
    if($clean) {
        Clean-Conatiners -containerRoot $eventPublisherConatinerRoot;
    }

    Invoke-Expression "docker compose $eventPublisherArgs build --parallel";
}

if ($buildEventNotifier) {
    if($clean) {
        Clean-Conatiners -containerRoot $eventNotifierConatinerRoot;
    }

    Invoke-Expression "docker compose $eventNotifierArgs build --parallel";
}

if ($buildIdentity) {
    if($clean) {
        Clean-Conatiners -containerRoot $identityConatinerRoot;
    }

    Invoke-Expression "docker compose $identityArgs build --parallel";
}

if ($buildApi) {
    if($clean) {
        Clean-Conatiners -containerRoot $apiConatinerRoot;
    }

    Invoke-Expression "docker compose $apiArgs build --parallel";
}

if ($buildTranslationOptionImporter) {
    if($clean) {
        Clean-Conatiners -containerRoot $translationOptionImporterConatinerRoot;
    }

    Invoke-Expression "docker compose $translationOptionImporterArgs build --parallel"
}


Invoke-Expression "docker compose $sharedArgs -p $sharedConatinerRoot up --no-deps -d --remove-orphans";
Invoke-Expression "docker compose $eventPublisherArgs -p $eventPublisherConatinerRoot up --no-deps -d --remove-orphans";
Invoke-Expression "docker compose $eventNotifierArgs -p $eventNotifierConatinerRoot up --no-deps -d --remove-orphans";
Invoke-Expression "docker compose $mailerArgs -p $mailerConatinerRoot up --no-deps -d --remove-orphans";
Invoke-Expression "docker compose $identityArgs -p $identityConatinerRoot up --no-deps -d --remove-orphans";
Invoke-Expression "docker compose $apiArgs -p $apiConatinerRoot up --no-deps -d --remove-orphans";
Invoke-Expression "docker compose $translationOptionImporterArgs -p $translationOptionImporterConatinerRoot up --no-deps -d --remove-orphans";
Invoke-Expression "docker compose $frontArgs -p $frontConatinerRoot up --no-deps -d --remove-orphans";