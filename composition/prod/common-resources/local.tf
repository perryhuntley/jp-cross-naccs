locals {
  tags = {
    topic         = var.topic
    application   = var.application
    heritage      = var.heritage
    contact       = var.contact
    costcenter    = var.costcenter
    executionitem = var.executionitem
    stage         = var.stage
    operatedby    = var.operatedby
  }
}