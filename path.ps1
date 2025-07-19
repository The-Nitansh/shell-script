$basePath = "C:\Apps\kafka"

$zookeeper = @{
    "start" = ".\bin\windows\zookeeper-server-start.bat"
    "stop" = ".\bin\windows\zookeeper-server-stop.bat"
    "config" = ".\config\zookeeper.properties"
    "service" = "zookeeper"
}

$kafka = @{
    "start" = ".\bin\windows\kafka-server-start.bat"
    "stop" = ".\bin\windows\kafka-server-stop.bat"
    "config" = ".\config\server.properties"
    "service" = "kafka.Kafka"
}
