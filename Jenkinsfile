pipeline {
    agent any

    stages {

        stage('CI'){
            steps {

                withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')])            {


                sh """
                    docker login -u ${USERNAME} -p ${PASSWORD}
                    docker build . -f dockerfile -t khaledashraf30/nodejs:v$BUILD_NUMBER
                    docker push khaledashraf30/nodejs:v$BUILD_NUMBER
                """
                }
              }
        }

        stage('CD'){
            steps {

                withCredentials([file(credentialsId: 'khaled-service', variable: 'config')]){
                    sh """
                        gcloud auth activate-service-account --key-file=${config}
                        gcloud container clusters get-credentials cluster-terraform --zone europe-west1-b --project khaled-ashraf
                        sed -i 's/tag/${BUILD_NUMBER}/g' deployment/deploymentservice.yml
                        kubectl apply -Rf deployment
                    """
                }
            }

        }

