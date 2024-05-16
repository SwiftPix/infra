pipeline {
    agent any
    stages {
        stage('Checkout Infra') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/SwiftPix/Infra'
                }
            }
        }
        stage('Determine Service and Pipeline') {
            steps {
                script {
                    def repoUrlParts = env.RJPP_SCM_URL.tokenize('/')
                    def service = repoUrlParts[repoUrlParts.size() - 1].replace('.git', '')
                    env.SERVICE = service
                    echo "Service deduced: ${service}"

                    // Read the environment configuration
                    def envConfig = readYaml file: "${service}/dev.yaml"
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
