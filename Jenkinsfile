pipeline {
  agent {
    node {
      label 'docker-agent'
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
    stage('Setup') {
      agent {
        dockerfile {
          dir 'docker/terraform-yc'
          label 'terraform-yc'
          args '-v /etc/passwd:/etc/passwd:ro'
          reuseNode true
        }
      }

      environment {
        builder_key_file = credentials('ssh_puzzle15_builder_key_file')
        stage_key_file = credentials('ssh_puzzle15_stage_key_file')
        TF_VAR_service_account_key_file = credentials('yandex_cloud_key_file')
        TF_VAR_cloud_id = "${params.cloud_id}"
        TF_VAR_folder_id = "${params.folder_id}"
        TF_VAR_zone = "${params.zone}"
        TF_VAR_subnet = "${params.subnet}"
      }

      steps {
        dir("terraform/puzzle15-builder") {
          sh '''
            set -eux
            export TF_VAR_ssh_key_file="$builder_key_file"
            ssh-keygen -f "${builder_key_file}" -y | tee "${builder_key_file}.pub"
            terraform init -input=false
            terraform plan -input=false
            terraform apply -input=false -auto-approve
          '''
        }
      }

      post {
        always {
          dir("terraform/puzzle15-builder") {
            sh '''
              export TF_VAR_ssh_key_file="$builder_key_file"
              terraform destroy -input=false -auto-approve
              rm "${builder_key_file}.pub" -f
              rm "${stage_key_file}.pub" -f
            '''
          }
        }
      }
    }
  }
}
