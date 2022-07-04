dependencies {
    paths = ["../105-azure-ocp-ipi","../110-azure-acme-certificate"]
}

dependency "acme-certs" {
    config_path = "../110-azure-acme-certificate"

    mock_outputs_allowed_terraform_commands = ["init","validate","plan"]
    mock_outputs = {
        ca_cert = "fake-ca-cert"
    }
}

dependency "ocp-ipi" {
    config_path = "../105-azure-ocp-ipi"

    mock_outputs_allowed_terraform_commands = ["init","validate","plan"]
    mock_outputs = {
        server_url = "https://fake.url.org:6443"
        username = "fakeuser"
        password = "fakepassword"
    }    
}

inputs = {
    cluster_ca_cert = base64encode("${dependency.acme-certs.outputs.ca_cert}")
    server_url = dependency.ocp-ipi.outputs.server_url
    cluster_login_user = dependency.ocp-ipi.outputs.username
    cluster_login_password = dependency.ocp-ipi.outputs.password
    cluster_login_token=""
}

terraform {
  # Ensures paralellism never exceed three modules at any time
  extra_arguments "reduced_parallelism" {
    commands  = get_terraform_commands_that_need_parallelism()
    arguments = ["-parallelism=3"]
  }
}