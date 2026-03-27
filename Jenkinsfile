pipeline {
    agent { label 'gcp && scsci && nobuild && stable' }

    parameters {
        string(name: 'USERNAME', defaultValue: '', description: 'New hire username')
        string(name: 'NAME', defaultValue: '', description: 'New hire full name')
    }

    stages {
        stage('Verify Authorization') {
            steps {
                script {
                    def currentUserId = env.BUILD_USER_ID ?: 'unknown/automated trigger'
                    def allowedUsers = ['zn685', 'gm304', 'nh236']
                    
                    if (!allowedUsers.contains(currentUserId)) {
                        echo "This job can only be started by allowed users: ${allowedUsers.join(', ')}."
                        echo "Current user: ${currentUserId}"
                        error("Authorization failed: User not allowed.")
                    }
                    
                    echo "Authorized: build started by ${currentUserId}"
                }
            }
        }

        stage('Send Onboarding Email') {
            steps {
                script {
                    def today = new Date().format('dd MMM yyyy')
                    def emailTemplate = readFile('email-template.html')

                    def personalizedEmail = emailTemplate
                        .replace('{{USERNAME}}', params.USERNAME)
                        .replace('{{NAME}}', params.NAME)
                        .replace('{{DATE}}', today)

                    mail bcc: 'zn685@deutsche-boerse.com',
                        mimeType: 'text/html',
                        body: personalizedEmail,
                        cc: 'nh236@deutsche-boerse.com',
                        from: 'zn685@deutsche-boerse.com',
                        replyTo: 'zn685@deutsche-boerse.com',
                        subject: "New GCP Machine - ${params.NAME} | ${params.USERNAME}",
                        to: "${params.USERNAME}@deutsche-boerse.com"
                }
            }
        }
    }
}
