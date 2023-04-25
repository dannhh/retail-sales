terraform {
  required_version = ">= 1.0"
  backend "local" {}  # Can change from "local" to "gcs" (for google) or "s3" (for aws), if you would like to preserve your tf-state online
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
  // credentials = file(var.credentials)  # Use this if you do not want to set env-var GOOGLE_APPLICATION_CREDENTIALS
}


# Overall, these 2 codes create a Compute Engine instance with a Kafka broker running on it, 
# and a firewall rule that allows external traffic to connect to the broker on port 9092. 
# The instance is tagged to ensure that the firewall rule applies only to this instance 
# and not to other instances in the same network.
resource "google_compute_firewall" "port_rules" {
  project     = var.project
  name        = "kafka-broker-port"
  network     = var.network
  description = "Opens port 9092 in the Kafka VM for Spark cluster to connect"

  allow {
    protocol = "tcp"
    ports    = ["9092"]
  }

  source_ranges = ["0.0.0.0/0"] # The firewall rule applies to all IP addresses
  target_tags   = ["kafka"]     # The rule is applied only to instances that have the "kafka" tag

}

resource "google_compute_instance" "kafka_vm_instance" {
  name                      = "kafka-instance"
  machine_type              = "e2-standard-2"
  tags                      = ["kafka"]
  zone                      = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.vm_image
      size  = 30
    }
  }

  network_interface {
    network = var.network
    access_config {
    }
  }
}

resource "google_compute_instance" "airflow_vm_instance" {
  name                      = "airflow-instance"
  machine_type              = "e2-standard-2"
  zone                      = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = var.vm_image
      size  = 30
    }
  }

  network_interface {
    network = var.network
    access_config {
    }
  }
}

# Creates a Google Cloud Storage bucket resource with the name "data-lake-bucket". 
# The resource is defined using the "google_storage_bucket" resource type
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "data-lake-bucket" {
  name          = var.bucket
  location      = var.region

  # Optional, but recommended settings:
  storage_class               = var.storage_class
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type  = "Delete"
    }
    condition {
      age   = 30  // days
    }
  }

  force_destroy = true
}

resource "google_dataproc_cluster" "multinode_spark_cluster" {
  name   = "multinode-spark-cluster"
  region = var.region

  cluster_config {

    staging_bucket = var.bucket

    gce_cluster_config {
      network = var.network
      zone    = var.zone

      shielded_instance_config {
        enable_secure_boot = true
      }
    }

    master_config {
      num_instances = 1
      machine_type  = "e2-standard-2"
      disk_config {
        boot_disk_type    = "pd-ssd"
        boot_disk_size_gb = 30
      }
    }

    worker_config {
      num_instances = 2
      machine_type  = "e2-medium"
      disk_config {
        boot_disk_size_gb = 30
      }
    }

    software_config {
      image_version = "2.0-debian10"
      override_properties = {
        "dataproc:dataproc.allow.zero.workers" = "true"
      }
      optional_components = ["JUPYTER"]
    }
  }

}

# DWH
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset
resource "google_bigquery_dataset" "stg_dataset" {
  dataset_id                 = var.stg_bq_dataset
  project                    = var.project
  location                   = var.region
  delete_contents_on_destroy = true
}

resource "google_bigquery_dataset" "core_dataset" {
  dataset_id                 = var.core_bq_dataset
  project                    = var.project
  location                   = var.region
  delete_contents_on_destroy = true
}