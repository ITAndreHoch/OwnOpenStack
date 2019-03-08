provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}


data "vsphere_datacenter" dc {
  name = "DC1"
}

data "vsphere_compute_cluster" cluster {
  name          = "TM-Cluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" datastore {
  name          = "dc1_iscsi_ds01"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" network {
  name          = "_NET"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
    name = "centos_gold_image"
    datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

### Resources ###

resource "vsphere_virtual_machine" "vm" {
    name = "_HOST"
    datastore_id = "${data.vsphere_datastore.datastore.id}"
    resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
    folder = "management"

    num_cpus = "_CPU"
    memory = "_MEM"
    guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

    network_interface {
    network_id = "${data.vsphere_network.network.id}"
    }

    disk {
      label = "disk0"
      size  = 20
      #thin_provisioned = "false"
    }

    clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"

    customize {
      linux_options {
        host_name = "_HOST"
        domain    = "localhost"
      }

      network_interface {
        ipv4_address = "_IP"
        ipv4_netmask = _MASK
      }
      ipv4_gateway = "_GATEWAY"
    }
  }
wait_for_guest_net_timeout = 0
}
