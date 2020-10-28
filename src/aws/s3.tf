
resource "aws_s3_bucket" "default" {
    bucket = local.bucket_name
    acl = "public-read"

    website {
        index_document = "index.html"
        error_document = "error.html"
    }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.default.id

    policy = <<POLICY
{
  "Id": "Policy1602721239564",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1602721238781",
      "Action": [
        "s3:GetObject",
        "s3:GetBucketAcl",
        "s3:PutBucketAcl"
      ],
      "Effect": "Allow",
      "Resource": ["arn:aws:s3:::${local.bucket_name}","arn:aws:s3:::${local.bucket_name}/*"],
      "Principal": {
          "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
      }
    }
  ]
}
POLICY
}