
provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key   
  cloud_api_secret = var.confluent_cloud_api_secret 
}


resource "confluent_environment" "syslog_demo" {
  display_name = "syslog_demo_${random_id.id.id}"
}

resource "confluent_kafka_cluster" "syslog" {
  display_name = "syslog"
  availability = "SINGLE_ZONE"
  cloud = "GCP"
  region = var.region
  basic { }
  environment {
    id = confluent_environment.syslog_demo.id
  }
}

resource "confluent_kafka_topic" "test_syslog" {
  kafka_cluster {
    id = confluent_kafka_cluster.syslog.id
  }
  topic_name         = "test_syslog"
  rest_endpoint      = confluent_kafka_cluster.syslog.rest_endpoint
  credentials {
    key    = confluent_api_key.app-manager-kafka-api-key.id
    secret = confluent_api_key.app-manager-kafka-api-key.secret
  }

  depends_on = [
    confluent_role_binding.app-manager-env-admin
  ]

}

resource "confluent_service_account" "app-manager" {
  display_name = "app-manager"
  description  = "Service account to manage 'inventory' Kafka cluster"

  depends_on = [
    confluent_kafka_cluster.syslog
  ]

}

resource "confluent_role_binding" "app-manager-env-admin" {
  principal   = "User:${confluent_service_account.app-manager.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.syslog_demo.resource_name
}

resource "confluent_api_key" "app-manager-kafka-api-key" {
  display_name = "app-manager-kafka-api-key"
  description  = "Kafka API Key that is owned by 'app-manager' service account"
  disable_wait_for_ready = true
  owner {
    id          = confluent_service_account.app-manager.id
    api_version = confluent_service_account.app-manager.api_version
    kind        = confluent_service_account.app-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.syslog.id
    api_version = confluent_kafka_cluster.syslog.api_version
    kind        = confluent_kafka_cluster.syslog.kind

    environment {
      id = confluent_environment.syslog_demo.id
    }
  }
}

