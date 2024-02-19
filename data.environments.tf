data "confluent_environments" "environments" {}
data "confluent_environment" "environments" {
    count   = length(data.confluent_environments.environments.ids)
    id      = data.confluent_environments.environments.ids[count.index]
}
