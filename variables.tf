variable "user_groups" {
    type = map(object({
        policy = object({
            organization_roles  = optional(list(string),      [])
            environment_roles   = optional(map(object({
                roles               = optional(list(string), [])
                kafka_cluster_roles = optional(map(object({
                    roles                  = optional(list(string), [])
                    topic_roles            = optional(map(string),  {})
                    consumer_group_roles   = optional(map(string),  {})
                })), {})
                ksqldb_roles           = optional(map(string), {})
                schema_registry_roles  = optional(map(object({
                    subject_roles          = optional(map(string),  {})
                })), {})
            })), {})            
        })
        users = list(string)
    }))
}
