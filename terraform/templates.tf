/* Jenkins Task Container Definition */
data "template_file" "jenkins_task" {
  template = "${file("task-definitions/jenkins.json")}"

  vars {
    jenkins_docker_image = "${var.jenkins_docker_image}"
  }
}
