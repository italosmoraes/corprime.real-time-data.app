
resource "aws_ecr_repository" "realtime_data_webapp_repo" {
  name = "realtime_data_webapp_repo"
  force_delete = true
}

resource "aws_ecr_repository" "real_time_server_repo" {
  name = "real_time_server_repo"
  force_delete = true
}