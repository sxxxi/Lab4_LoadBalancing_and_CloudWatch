locals {
  ##############################################################################
  # HERE!!! ####################################################################
  ##############################################################################
  tf_state_bucket_name = "tf-bucket-991617069"
  tf_state_key = "tf.state"
  media_bucket_name = "media_bucket_991617069"
  ssh_key = "vockey"
  ##############################################################################
  ##############################################################################
  ##############################################################################



  vpc_cidr = "10.5.0.0/16"
  public_subnets = [
    {
      cidr = "10.5.1.0/24"
      az = "us-east-1b"
      visibility = "Public"
    },
    {
      cidr = "10.5.3.0/24"
      az = "us-east-1c"
      visibility = "Public"
    },
    {
      cidr = "10.5.4.0/24"
      az = "us-east-1d"
      visibility = "Public"
    }
  ]
  private_subnets = [
    {
      cidr = "10.5.5.0/24"
      az = "us-east-1b"
      visibility = "Private"
    },
    {
      cidr = "10.5.6.0/24"
      az = "us-east-1c"
      visibility = "Private"
    },
    {
      cidr = "10.5.7.0/24"
      az = "us-east-1d"
      visibility = "Private"
    }
  ]
  nat_subnet_index = 1

  default_tags = {
    Owner = "Seiji Akakabe"
    OwnerID = "991617069"
  }


}