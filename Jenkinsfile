pipeline {
    agent any
    environment {
        WORKSPACE = "${env.WORKSPACE}"
    }
    stages {
        stage('Determine Service') {
            steps {
                script {
                    // Assumindo que o caminho do workspace segue o padrão '.../jobs/{org}/jobs/{repo}/branches/{branch}/workspace'
                    def workspaceParts = env.WORKSPACE.tokenize('/')
                    def service = workspaceParts[workspaceParts.size() - 4]
                    env.SERVICE = service
                    echo "Service deduced: ${service}"
                }
            }
        }
        stage('Checkout Service Repository') {
            steps {
                script {
                    git branch: "${env.RJPP_BRANCH}", url: "${env.RJPP_SCM_URL}"
                }
            }
        }
        stage('Checkout Infra') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/SwiftPix/Infra'
                }
            }
        }
        stage('Determine Pipeline') {
            steps {
                script {
                    // Lê a configuração do ambiente no repositório do serviço
                    def envConfig = readYaml file: "${env.WORKSPACE}/${env.SERVICE}/dev.yaml"
                    def runtime = envConfig.runtime

                    // Define o caminho para o Jenkinsfile apropriado baseado no runtime
                    if (runtime == 'python') {
                        env.PIPELINE_PATH = "${env.WORKSPACE}Pipelines/python-pipeline/Jenkinsfile"
                    } else if (runtime == 'node') {
                        env.PIPELINE_PATH = "${env.WORKSPACE}Pipelines/react-pipeline/Jenkinsfile"
                    } else {
                        error "Unsupported runtime: ${runtime}"
                    }
                }
            }
        }
        stage('Run Service Pipeline') {
            steps {
                script {
                    // Executa o Jenkinsfile apropriado
                    build job: env.PIPELINE_PATH, parameters: [
                        string(name: 'SERVICE', value: env.SERVICE),
                        string(name: 'BRANCH_NAME', value: env.RJPP_BRANCH)
                    ]
                }
            }
        }
    }
}
