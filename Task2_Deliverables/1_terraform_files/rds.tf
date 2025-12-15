# ============================================
# DB Subnet Group (Using PUBLIC subnets to avoid NAT Gateway cost)
# ============================================

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.public[*].id  # Changed from private to public (no NAT needed)

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# ============================================
# RDS PostgreSQL Instance
# ============================================

resource "aws_db_instance" "postgres" {
  identifier     = "${var.project_name}-postgres"
  engine         = "postgres"
  engine_version = "15.5"
  
  instance_class    = "db.t3.micro"  # Free tier eligible: 750 hours/month
  allocated_storage = 20             # Free tier eligible: up to 20GB
  storage_type      = "gp2"          # Changed from gp3 to gp2 for free tier
  storage_encrypted = true

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  publicly_accessible = false
  skip_final_snapshot = true  # For dev/testing - set to false in production

  backup_retention_period = 0  # Changed from 7 to 0 for free tier (disables automated backups)
  # backup_window           = "03:00-04:00"  # Commented out - not needed without backups
  maintenance_window      = "mon:04:00-mon:05:00"

  # enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]  # Commented out for free tier

  tags = {
    Name = "${var.project_name}-postgres"
  }
}
