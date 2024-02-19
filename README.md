# confluent-users-terraform
Terraform module for confluent user management

*example for value.auto.tfvars*

```
user_groups = {

    "user group name" = {
        policy = {
            organization_roles  = ["MetricsViewer", "AccountAdmin"]
            environment_roles = {
                "environment name" = {
                    roles = ["MetricsViewer", "EnvironmentAdmin"]
                    kafka_cluster_roles = {
                        "kafka cluster name" = {
                            roles = ["MetricsViewer"]
                            topic_roles = {
                                "topic prefix1" = "DeveloperRead"
                                "topic prefix2" = "DeveloperWrite"
                            }
                            consumer_group_roles = {
                                "group prefix1" = "DeveloperRead"
                                "group prefix2" = "DeveloperWrite"
                            }
                        }
                    }
                    ksqldb_roles = {
                        "ksqldb cluster name" = "KsqlAdmin"
                    }
                    schema_registry_roles  = {
                        "schema registry cluster name" = {
                            subject_roles = {
                                "subject prefix1" = "DeveloperRead"
                                "subject prefix2" = "DeveloperWrite"
                            }
                        }
                    }
                }
            }
        }

        users = [
            "A User Email Address",
            "B User Email Address",
        ]

    }
}
```
