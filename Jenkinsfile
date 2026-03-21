pipeline {
    agent { label 'gcp && scsci && nobuild && stable' }

    parameters {
        string(name: 'USERNAME', defaultValue: '', description: 'New hire username')
        string(name: 'NAME', defaultValue: '', description: 'New hire full name')
    }

    stages {
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
