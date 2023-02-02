pipeline {
    agent {
        ecs {
            inheritFrom 'default-build'
        }
    }
    environment {
        COMPOSITION       = "composition/${env.JOB_BASE_NAME.replace("_","/")}"
        ARM_CLIENT_ID     = credentials('PROD_ARM_CLIENT_ID')
        ARM_CLIENT_SECRET = credentials('PROD_ARM_CLIENT_SECRET')
        ARM_TENANT_ID     = credentials('PROD_ARM_TENANT_ID')

    }

    options {
        buildDiscarder(logRotator(numToKeepStr:'30'))
        timeout(time: 1, unit: 'HOURS')
        ansiColor('xterm')
        disableConcurrentBuilds()
    }

    parameters {
        choice(
            name: 'tf_destroy',
            choices: ['false', 'true'],
            description: 'Select action for destroy resources.'
        )
    }

    stages {
        stage('Init') {
        steps {
                checkout scm
                sshagent(credentials: ['jenkins-cicd-key']) {
                    dir("${COMPOSITION}") {
                        sh("ls -la")
                        sh("rm -rf .terraform/modules/")
                        sh("terraform -version")
                        sh("terraform init -backend-config=backend.config")
                    }
                }
            }
        }
        stage("Terraform Plan") {
            when {
                // Only when we use manual build with parameter to run the pipeline
                expression { params.tf_destroy == 'false'  }
            }
            steps {
                dir("${COMPOSITION}") {
                    terraform("plan")
                }
            }
        }
        stage("Terraform Apply") {
            when {
                // Only when we use manual build with parameter to run the pipeline
                expression { params.tf_destroy == 'false'  }
            }
            steps {
                dir("${COMPOSITION}") {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        terraform("apply")
                    }
                }
            }
        }
        stage('Terraform Destroy') {
            when {
                // Only when we use manual build with parameter to run the pipeline
                expression { params.tf_destroy == 'true'  }
            }
            steps {
                dir("${COMPOSITION}") {
                    terraform("destroy")
                }
            }
        }
    }
}


def compliance(){
    if (fileExists('tfplan')) {
        sh("cp tfplan state.secure")
        def r_compliance = sh(returnStatus: true, script: "terraform-compliance --planfile state.secure --features ../../tests/ --silent")
        echo "[Compliance] ${r_compliance}"
        if ("${r_compliance}" != "0") {
            error('Compliance Error')
        }
    } else {
        echo("no plan")
    }
}


def terraform(command) {
    if (command == "plan") {
        def status = sh(returnStatus: true, script: "terraform plan -out=tfplan -detailed-exitcode -input=false")
        echo "[plan:response] ${status}"
        if ("${status}" == "0") {
            echo 'nothing to apply'
            sh("rm -rf tfplan")
        } else if ("${status}" == "1") {
            error('Terraform error')
        }
    } else if (command == "apply") {
        if ("${env.GIT_BRANCH}" == "origin/master" || "${env.GIT_BRANCH}" == "origin/develop") {
            if (fileExists('tfplan')) {
                input "Do you want to apply Terraform?"
                sh("terraform apply tfplan")
            } else {
                echo 'no tfplan to do'
            }
        } else {
            echo "No Master or develop - cicd running on ${env.GIT_BRANCH}"
        }
    } else if (command == "destroy") {
        echo "Destroy details:"
        def status = sh(returnStatus: true, script: "terraform plan -destroy")
        echo "[destroy plan:response] ${status}"
        if ("${status}" == "0") {
            input "Do you really want to destroy all the resources?"
            sh("terraform destroy -auto-approve")
        } else {
            echo 'nothing to destroy'
        }
    }
}
