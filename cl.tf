resource "confluent_cluster_link" "target-outbound-sdh" {
  link_name = "target-initiated-cluster-link"
  source_kafka_cluster {
    id                 = confluent_kafka_cluster.basic.id
    bootstrap_endpoint = confluent_kafka_cluster.basic.bootstrap_endpoint

    credentials {
      key    = confluent_api_key.app-manager-kafka-api-key.id
      secret = confluent_api_key.app-manager-kafka-api-key.secret
    }
  }

  destination_kafka_cluster {
    id            = confluent_kafka_cluster.dedicated-target.id
    rest_endpoint = confluent_kafka_cluster.dedicated-target.rest_endpoint
    credentials {
      key    = confluent_api_key.app-manager-kafka-target-api-key.id
      secret = confluent_api_key.app-manager-kafka-target-api-key.secret
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}
