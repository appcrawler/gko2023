resource "confluent_kafka_cluster" "dedicated-target" {
  display_name = "dedicated-target"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-1"
  dedicated {
    cku = 1
  }

  environment {
    id = confluent_environment.sdh-gko.id
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_service_account" "app-manager-target" {
  display_name = "orders-app-sa-target"
  description  = "Service Account for orders app"
}

resource "confluent_api_key" "app-manager-kafka-target-api-key" {
  display_name = "app-manager-kafka-target-api-key"
  description  = "Kafka API Key that is owned by 'app-manager-target' service account"
  owner {
    id          = confluent_service_account.app-manager-target.id
    api_version = confluent_service_account.app-manager-target.api_version
    kind        = confluent_service_account.app-manager-target.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.dedicated-target.id
    api_version = confluent_kafka_cluster.dedicated-target.api_version
    kind        = confluent_kafka_cluster.dedicated-target.kind

    environment {
      id = confluent_environment.sdh-gko.id
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_role_binding" "cluster-example-target-rb" {
  principal   = "User:${confluent_service_account.app-manager-target.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.dedicated-target.rbac_crn
}
