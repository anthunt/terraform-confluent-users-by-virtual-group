/* Organization Level Role Binding */
resource "confluent_role_binding" "user-organization-roles" {
    for_each    = local.organization_roles
    principal   = "User:${local.users[each.value.user_email].id}"
    role_name   = each.value.role
    crn_pattern = data.confluent_organization.organization.resource_name
}

/* Environment Level Role Binding */
resource "confluent_role_binding" "user-environment-roles" {
    for_each    = local.environment_roles
    principal   = "User:${local.users[each.value.user_email].id}"
    role_name   = each.value.role
    crn_pattern = local.environments[each.value.environment].resource_name
}

/* Kafka Cluster Level Role Binding */
resource "confluent_role_binding" "user-kafka-cluster-binding" {
    for_each    = local.kafka_cluster_roles
    principal   = "User:${local.users[each.value.user_email].id}"
    role_name   = each.value.role
    crn_pattern = data.confluent_kafka_cluster.clusters[each.value.cluster_name].rbac_crn 
}

/* Topic Level Role Binding */
resource "confluent_role_binding" "user-topic-binding" {
    for_each    = local.topic_roles
    principal   = "User:${local.users[each.value.user_email].id}"
    role_name   = each.value.role
    crn_pattern = format("%s/kafka=%s/topic=%s", data.confluent_kafka_cluster.clusters[each.value.cluster_name].rbac_crn, data.confluent_kafka_cluster.clusters[each.value.cluster_name].id, each.value.prefix)
}

/* KsqlDB Level Role Binding */
resource "confluent_role_binding" "user-ksqldb-binding" {
    for_each    = local.ksqldb_roles
    principal   = "User:${local.users[each.value.user_email].id}"
    role_name   = each.value.role
    crn_pattern = data.confluent_ksql_cluster.clusters[each.value.cluster_name].resource_name
}

/* Schema Registry Subject Level Role Binding */
resource "confluent_role_binding" "user-schema-subject-binding" {
    for_each    = local.subject_roles
    principal   = "User:${local.users[each.value.user_email].id}"
    role_name   = each.value.role
    crn_pattern = format("%s/subject=%s", local.schema_registry_clusters[each.value.cluster_name].resource_name, each.value.prefix)
}
