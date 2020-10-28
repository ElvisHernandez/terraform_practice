
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
    comment = "An OAI for s3 bucket + CF distribution"
}

resource "aws_cloudfront_distribution" "s3_distribution" {

    origin {
        domain_name = aws_s3_bucket.default.bucket_regional_domain_name
        origin_id = local.s3_origin_id
        origin_path = "/master"


        s3_origin_config {
            origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
        }
    }

    enabled             = true
    is_ipv6_enabled     = true
    default_root_object = "index.html"

    # logging_config {
    #     include_cookies = false
    #     bucket          = "mylogs.s3.amazonaws.com"
    #     prefix          = "myprefix"
    # }

    aliases = [var.domain]

    default_cache_behavior {
        allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = local.s3_origin_id

        forwarded_values {
            query_string = true

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "allow-all"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }

    restrictions {
        geo_restriction {
            restriction_type = "whitelist"
            locations        = ["US", "CA", "GB", "DE"]
        }
    }

    tags = {
        Environment = "production"
    }

    viewer_certificate {
        # cloudfront_default_certificate = true
        acm_certificate_arn = aws_acm_certificate.domain.arn
        ssl_support_method = "sni-only"
    }
}
