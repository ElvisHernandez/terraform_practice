
resource "aws_iam_user" "jamstack_admin" {
    name = "jamstack_admin"
    force_destroy = true
}

data "aws_iam_policy_document" "iam_jamstack_policy" {
    statement {
        actions = ["s3:PutObject"]
        resources = ["arn:aws:s3:::${local.bucket_name}","arn:aws:s3:::${local.bucket_name}/*"]
    }
}

resource "aws_iam_policy" "jamstack_policy" {
    name = "jamstack_policy"
    policy = data.aws_iam_policy_document.iam_jamstack_policy.json
}

resource "aws_iam_user_policy_attachment" "attach" {
    user = aws_iam_user.jamstack_admin.name
    policy_arn = aws_iam_policy.jamstack_policy.arn
}