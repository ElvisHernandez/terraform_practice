

data aws_route53_zone "domain" {
    name = var.domain
}

resource "aws_route53_record" "cloudfront" {
    depends_on = [
        aws_cloudfront_distribution.s3_distribution
    ]

    zone_id = data.aws_route53_zone.domain.zone_id
    name    = var.domain
    type    = "A"

    alias {
        name = aws_cloudfront_distribution.s3_distribution.domain_name
        zone_id = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
        evaluate_target_health = false
    }
}

resource "aws_route53_record" "bastion" {
    zone_id = data.aws_route53_zone.domain.zone_id
    name = "bastion.${var.domain}"
    type = "A"
    ttl = "60"
    records = [aws_instance.bastion.public_ip]
}

resource "aws_route53_record" "phpmyadmin" {
    zone_id = data.aws_route53_zone.domain.zone_id
    name = "phpmyadmin.${var.domain}"
    type = "A"
    ttl = "60"
    records = [aws_instance.bastion.public_ip]
}

resource "aws_route53_record" "directus" {
    zone_id = data.aws_route53_zone.domain.zone_id
    name = "directus.${var.domain}"
    type = "A"
    ttl = "60"
    records = [aws_instance.bastion.public_ip]
}

resource "aws_route53_record" "api" {
    zone_id = data.aws_route53_zone.domain.zone_id
    name = "api.${var.domain}"
    type = "A"
    ttl = "60"
    records = [aws_instance.bastion.public_ip]
}

resource "aws_route53_record" "gatsby" {
    zone_id = data.aws_route53_zone.domain.zone_id
    name = "gatsby.${var.domain}"
    type = "A"
    ttl = "60"
    records = [aws_instance.bastion.public_ip]
}

# SSL Certificate
resource "aws_acm_certificate" "domain" {
    domain_name = var.domain
    subject_alternative_names = [
        "*.${var.domain}"
    ]
    validation_method = "DNS"

    tags = {
        Name = var.domain
    }
}

# SES Resource
resource "aws_ses_domain_identity" "domain" {
    domain = var.domain
}

resource "aws_ses_domain_dkim" "domain_dkim" {
    domain = aws_ses_domain_identity.domain.domain
}


# SES DKIM Entries
resource "aws_route53_record" "ses_dkim_verification_record" {
    count   = 3
    zone_id = data.aws_route53_zone.domain.zone_id
    name    = "${element(aws_ses_domain_dkim.domain_dkim.dkim_tokens, count.index)}._domainkey"
    type    = "CNAME"
    ttl     = "60"
    records = [
        "${element(aws_ses_domain_dkim.domain_dkim.dkim_tokens, count.index)}.dkim.amazonses.com"
    ]
}

# SES TXT Entry
resource "aws_route53_record" "ses_txt_verification_record" {
    zone_id = data.aws_route53_zone.domain.zone_id
    name    = "_amazonses.${var.domain}"
    type    = "TXT"
    ttl     = "60"
    records = [
        aws_ses_domain_identity.domain.verification_token
    ]
}

# SSL Cerificate Validation
resource "aws_route53_record" "cert_validation" {

    for_each = {
        for dvo in aws_acm_certificate.domain.domain_validation_options : dvo.domain_name => {
            name = dvo.resource_record_name
            record = dvo.resource_record_value
            type = dvo.resource_record_type
        }
    }

    allow_overwrite = true
    name = each.value.name
    records = [each.value.record]
    ttl = 60
    type = each.value.type
    zone_id = data.aws_route53_zone.domain.id
}

output "certificate_arn" {
    value = aws_acm_certificate.domain.arn
}

output "zone_id" {
    value = data.aws_route53_zone.domain.zone_id
}

output "directus_url" {
    value = aws_route53_record.directus.name
}

