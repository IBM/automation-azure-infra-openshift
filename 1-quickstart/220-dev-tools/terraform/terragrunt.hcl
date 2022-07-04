dependencies {
  paths = ["../200-openshift-gitops"]

}

terraform {
  # Ensures paralellism never exceed three modules at any time
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=3"]
  }
}