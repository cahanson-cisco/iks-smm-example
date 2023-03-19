provider "intersight" {
  apikey    = var.apikey
  secretkey = var.secretkey
  endpoint  = var.endpoint
}

module "iks_cluster" {
  source = "terraform-cisco-modules/iks/intersight//"
  version = "2.3.0"

  cluster = {
    name                = "iks-hx-demo"
    action              = "Unassign"
    # action can be Unassign or Deploy. If Deploy set wait_for_completion to false
    wait_for_completion = false
    worker_nodes        = 3
    load_balancers      = 5
    worker_max          = 6
    control_nodes       = 1
    ssh_user            = var.ssh_user
    ssh_public_key      = var.ssh_key
  }

  ip_pool = {
    use_existing        = false
    name                = "iks-ip-pool"
    ip_starting_address = "10.0.44.11"
    ip_pool_size        = "150"
    ip_netmask          = "255.255.255.0"
    ip_gateway          = "10.0.44.1"
    dns_servers         = ["10.0.10.22","10.0.10.23"]
  }

  sysconfig = {
    use_existing = false
    name         = "iks-hx-demo-ntp"
    domain_name  = "brattice.dovetail-lab.ca"
    timezone     = "America/Toronto"
    ntp_servers  = ["10.0.0.252","10.0.0.253"]
    dns_servers  = ["10.0.10.22","10.0.10.23"]
  }

  k8s_network = {
    use_existing = false
    name         = "pod-service-cidr"
    pod_cidr     = "100.63.0.0/16"
    service_cidr = "100.62.0.0/24"
    cni          = "Calico"
  }
  # Version policy
  versionPolicy = {
    useExisting   = false
    policyName     = "iks-latest"
    iksVersionName = "1.21.14-iks.0"
  }

  # Trusted registry policy
  tr_policy = {
     use_existing = false
     create_new   = false
  }

  runtime_policy = {
    use_existing = false
    create_new   = false
  }

  # Infra Config Policy Information
  infraConfigPolicy = {
    use_existing    = false
    platformType = "esxi"
    policyName      = "iks-hx-demo"
    vcTargetName   = "vcenter.brattice.dovetail-lab.ca"
    interfaces    = ["apps-844"]
    vcDatastoreName     = "neptune-shared"
    vcClusterName       = "neptune"
    vcResourcePoolName = ""
    vcPassword      = var.vc_password
  }

  addons = [
    {  
    createNew = true    
    addonPolicyName = "smm"
    addonName = "smm"
    description = "Service Mesh Manager Addon Policy"
    upgradeStrategy = "AlwaysReinstall"
    installStrategy = "InstallOnly"
    releaseVersion = "1.8.2-cisco6-helm3"
    overrides = yamlencode({"demoApplication":{"enabled":true}})
    }
  ]

  # Worker node instance type
  instance_type = {
    use_existing = false
    name         = "hx-vm-16GB"
    cpu          = 8
    memory       = 16384
    disk_size    = 40
  }

  # Organization and Tag
  organization = var.organization
  tags         = var.tags
}

