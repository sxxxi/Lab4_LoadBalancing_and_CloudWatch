resource "aws_s3_bucket" "media_bucket" {
  bucket = var.name
  force_destroy = true
  tags = merge(var.default_tags)
}

resource "aws_s3_object" "dog_object" {
  bucket = aws_s3_bucket.media_bucket.id
  key    = "dog.png"
  source = "${path.root}/res/dog.png"
}
