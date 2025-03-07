data "external" "node_names_generated" {
  program = ["python3", "${path.module}/external/node_names_generator.py", tostring(var.node_count)]
}

data "local_file" "node_names_file" {
  count    = var.node_names_file != "" ? 1 : 0
  filename = var.node_names_file
}
