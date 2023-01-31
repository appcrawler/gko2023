resource "confluent_connector" "source" {
  environment {
    id = confluent_environment.sdh-gko.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.basic.id
  }

  config_sensitive = {}

  config_nonsensitive = {
    "connector.class"          = "DatagenSource"
    "name"                     = "sdh-gko-datagen"
    "kafka.auth.mode"          = "SERVICE_ACCOUNT"
    "kafka.service.account.id" = confluent_service_account.app-manager.id
    "kafka.topic"              = confluent_kafka_topic.orders.topic_name
    "output.data.format"       = "JSON"
    "quickstart"               = "ORDERS"
    "tasks.max"                = "1"
  }
}
