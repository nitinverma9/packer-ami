build {
  source "amazon-ebs.image" {}

  provisioner "shell" {
    remote_folder   = "/home/${var.ssh_username}"
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "mount -o remount,exec /tmp",
      "echo 'proc   /proc   proc    defaults' | sudo tee -a  /etc/fstab",
      "yum install -y python3 python3-pip"
    ]
  }

  provisioner "ansible" {
    #galaxy_file          = "requirements.yml"
    galaxy_force_install = true
    playbook_file        = "playbook.yml"
    user                 = var.ssh_username

    extra_arguments = [
      "--extra-vars",
      "ansible_python_interpreter=/usr/bin/python3"
    ]
  }
}

