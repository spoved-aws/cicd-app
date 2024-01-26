module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "4.0.1"

  bucket = "vprofile-artifact-bucket-9hf98h23f934ke342d3d3"
#   acl    = "private"

#   control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}

resource "aws_s3_object" "builddir" {
  bucket = module.s3_bucket.s3_bucket_id
  key    = "vprofile-buildArtifacts"
  source = "/dev/null"
}