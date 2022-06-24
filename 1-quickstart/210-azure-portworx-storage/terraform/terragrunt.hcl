locals {
    px_spec = get_env("TF_VAR_portworx_spec")
}

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
    azure-portworx_portworx_spec = local.px_spec
    azure-portworx_cluster_type = "IPI"
    cluster_login_token=""
}