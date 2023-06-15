output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_location" {
  value       = google_container_cluster.primary.location
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

data "template_file" "cpymltpl"{
  template = "${file("cp.tpl.yml")}"
  vars = {
    bootstrapEndpoint = replace(confluent_kafka_cluster.syslog.bootstrap_endpoint, "SASL_SSL://", "")
  }
}

resource "local_file" "cpyml"{
  filename = "cp.yml"
  file_permission = "0600"
  content = "${data.template_file.cpymltpl.rendered}"
}

resource "local_file" "api_key" {
  filename = "api_key.txt"
  file_permission = "0600"
  content = "username=${confluent_api_key.app-manager-kafka-api-key.id}\npassword=${confluent_api_key.app-manager-kafka-api-key.secret}"
}

data "template_file" "kafka_config" {
  template = "${file("kafka.tpl.properties")}"
  vars = {
    bootstrapEndpoint = replace(confluent_kafka_cluster.syslog.bootstrap_endpoint, "SASL_SSL://", "")
    username = confluent_api_key.app-manager-kafka-api-key.id
    password = confluent_api_key.app-manager-kafka-api-key.secret
  }
}

resource "local_file" "kafka_props" {
  filename = "kafka.properties"
  file_permission = "0600"
  content = "${data.template_file.kafka_config.rendered}"
}
