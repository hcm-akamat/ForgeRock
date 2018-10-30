provider "google" {
  project = "keller-williams-215619"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-idm"
  machine_type = "n1-standard-2"

  boot_disk {
    initialize_params {
      image = "packer-1539282536"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = "default"
    access_config = {
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "root"
      timeout     = "10s"
      private_key = "${file("~/.ssh/google_compute_engine")}"
    }

    inline = [
      "echo starting running commands",
      "sudo su -",
      "cd /home/hcm-akamat/openidm",
      "echo $PWD",
      "nohup ./startup.sh &",
      "echo startup script started"
    ]
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = "true"
}
