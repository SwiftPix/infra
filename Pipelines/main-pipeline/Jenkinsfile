pipeline {
    agent any
    parameters {
        string(name: 'SERVICE', defaultValue: '', description: 'The service that triggered the build')
        string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branch name')
    }
    stages {
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
                    // Read the environment configuration
                    def envConfig = readYaml file: "${params.SERVICE}/dev.yaml"
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
                        string(name: 'SERVICE', value: params.SERVICE),
                        string(name: 'BRANCH_NAME', value: params.BRANCH_NAME)
                    ]
                }
            }
        }
    }
}