locals {
    user_groups = var.user_groups

    organization_roles = { for roles in distinct(flatten([
        for group_name, group_policy in local.user_groups : [
            for role in group_policy.policy.organization_roles : [
                for user_email in group_policy.users : {
                    user_email = user_email
                    role       = role
                }
            ]
        ]
    ])) : format("%s-%s", roles.user_email, roles.role) => roles }

    environment_roles = { for roles in distinct(flatten([
        for group_name, group_policy in local.user_groups : [
            for environment, policy in group_policy.policy.environment_roles : [
                for role in policy.roles : [
                    for user_email in group_policy.users : {
                        environment = environment
                        user_email  = user_email
                        role        = role
                    }
                ]
            ]
        ]
    ])) : format("%s-%s-%s", roles.user_email, roles.environment, roles.role) => roles }

    kafka_cluster_roles = { for roles in distinct(flatten([
        for group_name, group_policy in local.user_groups : [
            for environment, policy in group_policy.policy.environment_roles : [
                for cluster_name, role in policy.kafka_cluster_roles : [
                    for role_name in role.roles : [
                        for user_email in group_policy.users : {
                            environment  = environment
                            user_email   = user_email
                            cluster_name = cluster_name
                            role         = role_name
                        }
                    ]
                ]
            ]
        ]
    ])) : format("%s-%s-%s-%s", roles.user_email, roles.environment, roles.cluster_name, roles.role) => roles }

    topic_roles = { for roles in distinct(flatten([
        for group_name, group_policy in local.user_groups : [
            for environment, policy in group_policy.policy.environment_roles : [
                for cluster_name, role in policy.kafka_cluster_roles : [
                    for prefix, role_name in role.topic_roles : [
                        for user_email in group_policy.users : {
                            environment  = environment
                            user_email   = user_email
                            cluster_name = cluster_name
                            prefix       = prefix
                            role         = role_name
                        }
                    ]
                ]
            ]
        ]
    ])) : format("%s-%s-%s-%s-%s", roles.user_email, roles.environment, roles.cluster_name, roles.prefix, roles.role) => roles }

    consumer_group_roles = { for roles in distinct(flatten([
        for group_name, group_policy in local.user_groups : [
            for environment, policy in group_policy.policy.environment_roles : [
                for cluster_name, role in policy.kafka_cluster_roles : [
                    for prefix, role_name in role.consumer_group_roles : [
                        for user_email in group_policy.users : {
                            environment  = environment
                            user_email   = user_email
                            cluster_name = cluster_name
                            prefix       = prefix
                            role         = role_name
                        }
                    ]
                ]
            ]
        ]
    ])) : format("%s-%s-%s-%s-%s", roles.user_email, roles.environment, roles.cluster_name, roles.prefix, roles.role) => roles }

    ksqldb_roles = { for roles in distinct(flatten([
        for group_name, group_policy in local.user_groups : [
            for environment, policy in group_policy.policy.environment_roles : [
                for cluster_name, role in policy.ksqldb_roles : [
                    for user_email in group_policy.users : {
                        environment  = environment
                        user_email   = user_email
                        cluster_name = cluster_name
                        role         = role
                    }
                ]
            ]
        ]
    ])) : format("%s-%s-%s-%s", roles.user_email, roles.environment, roles.cluster_name, roles.role) => roles }

    subject_roles = { for roles in distinct(flatten([
        for group_name, group_policy in local.user_groups : [
            for environment, policy in group_policy.policy.environment_roles : [
                for cluster_name, role in policy.schema_registry_roles : [
                    for prefix, role_name in role.subject_roles : [
                        for user_email in group_policy.users : {
                            environment  = environment
                            user_email   = user_email
                            cluster_name = cluster_name
                            prefix       = prefix
                            role         = role_name
                        }
                    ]
                ]
            ]
        ]
    ])) : format("%s-%s-%s-%s-%s", roles.user_email, roles.environment, roles.cluster_name, roles.prefix, roles.role) => roles }

    users = { for index, user in data.confluent_user.users : user.email => user }

    environments = {
        for idx, environment in data.confluent_environment.environments
        : environment.display_name => environment
    }

    kafka_clusters = { for cluster in distinct(flatten([
        for key, value in local.kafka_cluster_roles : [{
            environment     = value.environment
            cluster_name    = value.cluster_name 
        }]
    ])) : cluster.cluster_name => cluster }

    ksqldb_clusters = { for cluster in distinct(flatten([
        for key, value in local.ksqldb_roles : [{
            environment     = value.environment
            cluster_name    = value.cluster_name 
        }]
    ])) : cluster.cluster_name => cluster }

    schema_registry_clusters = {
        for index, cluster in data.confluent_schema_registry_clusters.clusters.clusters
        : cluster.display_name => cluster
    }
}
