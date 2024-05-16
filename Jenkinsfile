pipeline {
    agent any
    environment {
        RJPP_SCM_URL = "${env.RJPP_SCM_URL}"
        RJPP_JENKINSFILE = "${env.RJPP_JENKINSFILE}"
        RJPP_BRANCH = "${env.RJPP_BRANCH}"
        RJPP_LOCAL_MARKER = "${env.RJPP_LOCAL_MARKER}"
    }
    stages {
        stage('Determine Service') {
            steps {
                script {
                    // Assumindo que a URL do repositório segue o padrão 'https://github.com/SwiftPix/{repo-name}.git'
                    def repoUrlParts = env.RJPP_SCM_URL.tokenize('/')
                    def service = repoUrlParts[repoUrlParts.size() - 5].replace('.git', '')
                    env.SERVICE = service
                    echo "Service deduced: ${service}"
                    echo "${env.RJPP_SCM_URL}"
                    echo "${env.RJPP_JENKINSFILE}"
                    echo "${env.RJPP_BRANCH}"
                    echo "${env.RJPP_LOCAL_MARKER}"
                }
            }
        }
        stage('Checkout Infra') {
            steps {
                script {
                    git branch: "${env.RJPP_BRANCH}", url: 'https://github.com/SwiftPix/Infra'
                }
            }
        }
        stage('Determine Pipeline') {
            steps {
                script {
                    // Read the environment configuration
                    def envConfig = readYaml file: "${env.SERVICE}/dev.yaml"
                    def runtime = envConfig.runtime

                    // Set the path to the appropriate Jenkinsfile based on the runtime
                    if (runtime == 'python') {
                        env.PIPELINE_PATH = 'Pipelines/python-pipeline/Jenkinsfile'
                    } else if (runtime == 'node') {
                        env.PIPELINE_PATH = 'Pipelines/react-pipeline/Jenkinsfile'
                    } else {
                        error "Unsupported runtime: ${runtime}"
                    }
                }
            }
        }
        stage('Run Service Pipeline') {
            steps {
                script {
                    // Run the appropriate Jenkinsfile
                    build job: env.PIPELINE_PATH, parameters: [
                        string(name: 'SERVICE', value: env.SERVICE),
                        string(name: 'BRANCH_NAME', value: env.RJPP_BRANCH)
                    ]
                }
            }
        }
    }
}
