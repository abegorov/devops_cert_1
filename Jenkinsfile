pipeline {
  agent {
    dockerfile {
      label 'docker-agent'
      dir 'docker/terraform-ansible-env'
      args '-v /etc/passwd:/etc/passwd:ro'
    }
  }

  parameters {
    string(
      name: 'app_version',
      defaultValue: '1.0.8',
      description: 'Application Version Tag'
    )
    string(
      name: 'cloud_id',
      defaultValue: 'b1gbdu15aenb95grbtbm',
      description: 'Yandex Cloud Id'
    )
    string(
      name: 'folder_id',
      defaultValue: 'b1g80d1kn71udkvnjn7b',
      description: 'Yandex Cloud Folder Id'
    )
    string(
      name: 'zone',
      defaultValue: 'ru-central1-b',
      description: 'Yandex Cloud Zone'
    )
    string(
      name: 'subnet',
      defaultValue: 'default-ru-central1-b',
      description: 'Yandex Cloud Subnet'
    )
    string(
      name: 'repository_id',
      defaultValue: 'crp75qdfm0mmh40msum4',
      description: 'Yandex Cloud Docker Repository Id'
    )
  }

  stages {
    stage('Build') {
      environment {
        TF_VAR_ssh_key_file = credentials('ssh_puzzle15_builder_key_file')
        TF_VAR_yc_key_file = credentials('yandex_cloud_key_file')
        TF_VAR_cloud_id = "${params.cloud_id}"
        TF_VAR_folder_id = "${params.folder_id}"
        TF_VAR_zone = "${params.zone}"
        TF_VAR_subnet = "${params.subnet}"

        yc_key_file = credentials('yandex_cloud_key_file')
        app_version = "${params.app_version}"
        repository_id = "${params.repository_id}"
      }

      steps {
        dir('terraform/puzzle15-builder') {
          sh '''
            set -eux
            ssh-keygen -f "${TF_VAR_ssh_key_file}" -y \
              | tee "${TF_VAR_ssh_key_file}.pub"
            terraform init -no-color -input=false
            terraform plan -no-color -input=false
            terraform apply -no-color -input=false -auto-approve
          '''
        }
        dir('ansible') {
          ansiblePlaybook inventory: 'puzzle15-builder', playbook: 'setup.yml'
          ansiblePlaybook inventory: 'puzzle15-builder', playbook: 'build.yml'
        }
      }

      post {
        always {
          dir("terraform/puzzle15-builder") {
            sh '''
              terraform destroy  -no-color -input=false -auto-approve
            '''
          }
        }
      }
    }
  }
}
