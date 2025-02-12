data "external" "node_names" {
  program = ["python3", "${path.module}/external/node_name_generator.py", tostring(var.node_count)]
}
