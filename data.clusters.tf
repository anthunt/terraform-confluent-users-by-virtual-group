data "confluent_kafka_cluster" "clusters" {
    for_each        = local.kafka_clusters
    display_name    = each.key
    environment {
        id = local.environments[each.value.environment].id
    }
}

data "confluent_ksql_cluster" "clusters" {
    for_each        = local.ksqldb_clusters
    display_name    = each.key
    environment {
        id = local.environments[each.value.environment].id
    }
}

data "confluent_schema_registry_clusters" "clusters" {}
