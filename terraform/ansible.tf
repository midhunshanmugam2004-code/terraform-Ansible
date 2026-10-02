resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = <<-EOF
[midhun]
${aws_instance.midhun.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${var.private_key_path} ansible_python_interpreter=/usr/bin/python3
EOF

  depends_on = [
    aws_instance.midhun
  ]
}

resource "null_resource" "wait_for_ssh" {
  depends_on = [
    aws_instance.midhun
  ]

  provisioner "local-exec" {
    #interpreter = ["/bin/bash", "-c"]

    command = <<-EOT
      echo "Waiting for SSH on ${aws_instance.midhun.public_ip}:22..."
      for i in {1..60}; do
        if timeout 3 bash -c "</dev/tcp/${aws_instance.midhun.public_ip}/22" 2>/dev/null; then
          echo "SSH port is reachable."
          exit 0
        fi
        sleep 5
      done
      echo "SSH did not become reachable within the timeout."
      exit 1
    EOT
  }
}

resource "null_resource" "ansible_configuration" {
  depends_on = [
    local_file.ansible_inventory,
    null_resource.wait_for_ssh
  ]

  triggers = {
    instance_id = aws_instance.midhun.id
    public_ip   = aws_instance.midhun.public_ip
    playbook    = filemd5("${path.module}/../ansible/main.yml")
    template    = filemd5("${path.module}/../ansible/template/index.html")
  }

  provisioner "local-exec" {
    #interpreter = ["/bin/bash", "-c"]

    command = "ansible-playbook -i ../ansible/inventory.ini ../ansible/main.yml"
  }
}
