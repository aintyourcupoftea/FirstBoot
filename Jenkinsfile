pipeline {
    agent { label 'gcp && scsci && nobuild && stable' }

    parameters {
        string(name: 'USERNAME', defaultValue: '', description: 'New hire username')
        string(name: 'NAME', defaultValue: '', description: 'New hire full name')
        text(name: 'CC', defaultValue: '', description: 'Enter usernames to CC (one per line, without domain)')
    }

    stages {
        stage('Verify Authorization') {
            steps {
                script {
                    def currentUserId = 'unknown/automated trigger'
                    def causes = currentBuild.getBuildCauses()
                    for (cause in causes) {
                        if (cause._class && cause._class.contains('UserIdCause') && cause.userId) {
                            currentUserId = cause.userId
                            break
                        }
                    }
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

                    def currentUserId = 'unknown'
                    def causes = currentBuild.getBuildCauses()
                    for (cause in causes) {
                        if (cause._class && cause._class.contains('UserIdCause') && cause.userId) {
                            currentUserId = cause.userId
                            break
                        }
                    }
                    def triggerUserEmail = "${currentUserId}@deutsche-boerse.com"

                    def finalBcc = "zn685@deutsche-boerse.com"
                    if (currentUserId != 'zn685') {
                        finalBcc += ",${triggerUserEmail}"
                    }

                    def ccList = []
                    if (params.CC) {
                        def extraUsers = params.CC.split(/[\s,]+/)
                        for (user in extraUsers) {
                            if (user.trim()) {
                                ccList.add("${user.trim()}@deutsche-boerse.com")
                            }
                        }
                    }
                    def finalCc = ccList.join(',')

                    if (finalCc) {
                        mail bcc: finalBcc,
                            mimeType: 'text/html',
                            body: personalizedEmail,
                            cc: finalCc,
                            from: triggerUserEmail,
                            replyTo: triggerUserEmail,
                            subject: "New GCP Machine - ${params.NAME} | ${params.USERNAME}",
                            to: "${params.USERNAME}@deutsche-boerse.com"
                    } else {
                        mail bcc: finalBcc,
                            mimeType: 'text/html',
                            body: personalizedEmail,
                            from: triggerUserEmail,
                            replyTo: triggerUserEmail,
                            subject: "New GCP Machine - ${params.NAME} | ${params.USERNAME}",
                            to: "${params.USERNAME}@deutsche-boerse.com"
                    }
                }
            }
        }
    }
}
