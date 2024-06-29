//  Created by Alexander Skorulis on 29/6/2024.

import Foundation
import SotoS3

struct JournalR2Service {
    
    let secrets: Secrets
    let awsClient: AWSClient
    let s3: S3

    init(secrets: Secrets) {
        self.secrets = secrets
        self.awsClient = .init(
            credentialProvider: .static(
                accessKeyId: secrets.aws.accessKeyId,
                secretAccessKey: secrets.aws.secretAccessKey
            ),
            httpClientProvider: .createNew
        )
        let endpoint = "https://\(secrets.aws.accountID).r2.cloudflarestorage.com"
        self.s3 = S3(
            client: awsClient,
            endpoint: endpoint
        )
    }
    
    func uploadFile(text: String, path: String) async throws {
        let putRequest = S3.PutObjectRequest(
            body: .string(text),
            bucket: "journal-skorulis-com",
            key: path
        )
        
        _ = try await s3.putObject(putRequest)
    }
    
}
