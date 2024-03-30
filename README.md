# devops-challenge-pqda
This repository contain a litecoin application.

### Tools
1. Kubernetes: 1.28
2. Terraform: 1.5.0
3. Github Action
4. Github Private Registry
5. Trivy
6. Go: 1.21

## Pipeline phase
I implement GitHub Actions for a streamlined CI/CD approach, organized into three essential pipelines. The pull request pipeline provides swift feedback for developers, ensuring quick insights into the impact of their changes. The main branch pipeline focuses on deploying a resilient application to production, while a dedicated rollback pipeline efficiently addresses unforeseen issues. The use of filters optimizes the process by triggering changes only when modifications occur in specific directories or services, enhancing precision and resource efficiency throughout the CI/CD lifecycle. Also we need to protect the main branch to only get new changes from Pull Request, and will reject a direct commit.

1. Main branch pipeline.
    * Purpose: End-to-end deployment of the application to production.
    * Steps:
        * Dockerize the application.
        * Deploy the application.
2. Pull request pipeline
    * Purpose: Validate changes before merging into the main branch.
    * Checks:
        * Test build for Docker image.
        * Security check for Docker image vulnerabilities.

## Containerization
### Dockerfile
The Dockerfile for Litecoin containerizes the Litecoin application, encapsulating it within a Docker image for easy deployment and management. It utilizes a multi-stage build process, optimizing the final image size by separating the build environment from the runtime environment. During the build stage, it downloads the Litecoin release, verifies its integrity using a cryptographic checksum, and sets up the runtime environment. In the runtime stage, it uses a distroless base image for security and efficiency, copying the Litecoin binaries from the build stage, and also I use the CC distroless image because Litecoin need multilib shared library to run. Finally, it configures the container to execute the Litecoin daemon upon startup, logging output to the console for monitoring purposes.

### Kubernetes manifest
The Kubernetes manifest for deploying the Litecoin application encompasses a Deployment resource with enhanced security measures, including resource allocation and limits to optimize performance and mitigate resource abuse. Additionally, the manifest incorporates PersistentVolumeClaims (PVCs) to ensure data persistence by attaching storage volumes to the deployment. To enable external access, the manifest defines an Ingress resource, facilitating communication with the Litecoin application from outside the Kubernetes cluster. Together, these components orchestrate the deployment of the Litecoin application within the Kubernetes environment, ensuring resilience, scalability, and accessibility.

## Analyze Logs from WebServer
### Logs Format
Web server logs typically follow a specific format that records details about each incoming request to the server. The most common format is the Combined Log Format, which includes the following fields:
* IP Address: The IP address of the client making the request.
* User Identifier: (Optional) The identity of the user making the request, usually not available and represented by a hyphen.
* User Authentication: (Optional) The username provided by the client during authentication.
* Timestamp: The date and time of the request.
* Request Method: The HTTP method used in the request, such as GET, POST, etc.
* Request Path: The path to the requested resource on the server.
* HTTP Protocol Version: The version of the HTTP protocol used in the request.
* Response Status Code: The HTTP status code returned by the server.
* Response Size: The size of the response sent to the client in bytes.
An example log entry in the Combined Log Format might look like this:
```bash
192.168.1.1 - - [01/Jan/2023:12:34:56 +0000] "GET /index.html HTTP/1.1" 200 1234
```
### Scripting
The Go script analyzes web server logs by reading a log file to extract information. It parses each log entry, splitting lines into fields and aggregating data to generate statistics like the frequency of IP addresses accessing the server and the most visited URLs. The script then presents the analysis results in a human-readable format, such as sorted IP addresses by frequency or a summary of the most requested URLs. Error handling mechanisms are included to handle invalid log entries or file reading errors, ensuring reliable operation even with imperfect input data.
* Read Log File: The script reads a web server log file to extract information about incoming requests.
* Parse Log Entries: It parses each log entry, splitting lines into fields to extract relevant information.
* Aggregate Data: The script aggregates parsed data to generate statistics like IP address frequency and most visited URLs.
* Display Results: Analysis results are presented in a human-readable format, such as sorted IP addresses by frequency or a summary of most requested URLs.
* Error Handling: Error handling mechanisms are included to handle invalid log entries or file reading errors, ensuring reliable operation.
Here some example how the script works.
```bash
# Run without assigned parameter
$ go run log-checker.go
[!] No parameters assigned.
Usage of /tmp/go-build1176272993/b001/exe/log-checker:
  -f string
        Set the log filename with absolute or relative path.
  -h    Show this help message.
exit status 1

# Run with wrong paramater.
$ go run log-checker.go -s
flag provided but not defined: -s
Usage of /tmp/go-build1288519873/b001/exe/log-checker:
  -f string
        Set the log filename with absolute or relative path.
  -h    Show this help message.
exit status 2

# Run with non-exists log file
$ go run log-checker.go -f non-exist.log    
[!] File doesn\'t exist \'non-exist.log\'.
exit status 1

# Run with the right parameter and exist file
$ go run log-checker.go -f nginx_access_log 
[+] File exist \'nginx_access_log\'.
IP Address      | Frequency
----------------------------
0.9.7.9         | 191
80.91.33.133    | 121
5.83.131.103    | 23
50.57.209.92    | 23
202.143.95.26   | 16
54.86.157.236   | 15
93.180.71.3     | 15
173.203.139.108 | 13
91.234.194.89   | 12
188.138.60.101  | 12
91.239.186.133  | 11
217.168.17.5    | 11
62.75.198.179   | 11
87.233.156.242  | 10
93.190.71.150   | 10
91.121.161.213  | 10
31.22.86.126    | 9
195.154.77.170  | 9
0.8.10.3        | 9
83.161.14.106   | 9
144.76.151.58   | 8
62.75.167.106   | 8
200.6.73.40     | 8
144.76.117.56   | 7
80.70.214.71    | 7
46.4.83.163     | 6
94.23.21.169    | 6
93.64.134.186   | 6
62.210.138.59   | 6
37.187.238.39   | 6
62.75.198.180   | 6
144.92.16.161   | 6
144.76.160.62   | 6
178.32.54.253   | 5
195.154.233.202 | 5
54.64.16.235    | 5
85.214.47.178   | 5
46.4.88.134     | 5
84.53.65.28     | 5
46.4.66.76      | 5
144.76.137.134  | 4
37.26.93.214    | 4
91.194.188.90   | 4
193.192.58.163  | 3
210.245.80.75   | 3
152.90.220.17   | 2
92.50.100.22    | 2
91.120.61.154   | 2
54.187.216.43   | 2
195.210.47.239  | 2
198.61.216.151  | 2
134.119.20.172  | 2
152.90.220.18   | 1
54.72.39.202    | 1
54.191.136.177  | 1
23.23.226.37    | 1
54.172.198.124  | 1
54.193.30.212   | 1
193.192.59.41   | 1
----------------------------
```

The shell script digs into the web server logs, scanning through each line to extract important details like IP addresses, timestamps, and requested URLs. It then crunches this data, tallying up things like the most common IP addresses or the most requested pages. Once it's done, it presents these findings in an easy-to-read format, giving you insights into your web server traffic. Plus, it's designed to handle any quirks in the log files, ensuring it keeps running smoothly even with imperfect data. It will have the same behavior with the go program, but in shell script it's more handy because there are some built-in command to help.
Here are some examples.
```bash
$ ./log-checker.sh -f nginx_access_log 
[+] File exists \'nginx_access_log\'...............
IP Address      | Frequency
-----------------------------
0.9.7.9         | 191 
80.91.33.133    | 121 
5.83.131.103    | 23 
50.57.209.92    | 23 
202.143.95.26   | 16 
93.180.71.3     | 15 
54.86.157.236   | 15 
173.203.139.108 | 13 
91.234.194.89   | 12 
188.138.60.101  | 12 
91.239.186.133  | 11 
62.75.198.179   | 11 
217.168.17.5    | 11 
93.190.71.150   | 10 
91.121.161.213  | 10 
87.233.156.242  | 10 
83.161.14.106   | 9 
31.22.86.126    | 9 
195.154.77.170  | 9 
0.8.10.3        | 9 
62.75.167.106   | 8 
200.6.73.40     | 8 
144.76.151.58   | 8 
80.70.214.71    | 7 
144.76.117.56   | 7 
94.23.21.169    | 6 
93.64.134.186   | 6 
62.75.198.180   | 6 
62.210.138.59   | 6 
46.4.83.163     | 6 
37.187.238.39   | 6 
144.92.16.161   | 6 
144.76.160.62   | 6 
85.214.47.178   | 5 
84.53.65.28     | 5 
54.64.16.235    | 5 
46.4.88.134     | 5 
46.4.66.76      | 5 
195.154.233.202 | 5 
178.32.54.253   | 5 
91.194.188.90   | 4 
37.26.93.214    | 4 
144.76.137.134  | 4 
210.245.80.75   | 3 
193.192.58.163  | 3 
92.50.100.22    | 2 
91.120.61.154   | 2 
54.187.216.43   | 2 
198.61.216.151  | 2 
195.210.47.239  | 2 
152.90.220.17   | 2 
134.119.20.172  | 2 
54.72.39.202    | 1 
54.193.30.212   | 1 
54.191.136.177  | 1 
54.172.198.124  | 1 
23.23.226.37    | 1 
193.192.59.41   | 1 
152.90.220.18   | 1 
-----------------------------

$ ./log-checker.sh -h                 
Usage: ./log-checker.sh [-f <log_filename>]
Options:
  -f  LOG_FILENAME     Set the log filename.
  -h                   Show this help message

$ ./log-checker.sh -l
[!] Invalid option: l.........
Usage: ./log-checker.sh [-f <log_filename>]
Options:
  -f  LOG_FILENAME     Set the log filename.
  -h                   Show this help message
```

## Terraform module
The Terraform module orchestrates the setup of an S3 bucket with automatic file cleanup, ensuring old files are regularly purged to keep storage tidy. It also configures a policy granting specific group access to manage objects within the bucket, promoting collaboration and security. Additionally, it establishes a dedicated user within the group, streamlining access control and promoting accountability. With consistent, customizable naming conventions, it simplifies management and maintenance, ensuring clarity and cohesion across resources. We can just add inputs with the desired values.
```bash
$ tree terraform/s3-modules
terraform/s3-modules
├── main.tf
├── outputs.tf
└── variables.tf
```
An example of using the module.
```terraform
locals {
  create_buckets = {
    "bucket1" = {
      "bucket_name"    = "projectA-s3-bucket1"
      "lifecycle_days" = 7
      "group_name"     = "projectA-group1"
      "user_name"      = "projectA-user1"
      "policy_name"    = "projectA-bucket-policy1"
      "suffix_name"    = "dev"
    }
    "bucket2" = {
      "bucket_name"    = "projectA-s3-bucket2"
      "lifecycle_days" = 14
      "group_name"     = "projectA-group2"
      "user_name"      = "projectA-user2"
      "policy_name"    = "projectA-bucket-policy2"
      "suffix_name"    = "stag"
    }
  }
}

module "s3_buckets" {
  source = "./s3-modules"
  
  for_each = local.create_buckets
  
  create_bucket = true
  bucket_name   = each.value.bucket_name
  lifecycle_days = each.value.lifecycle_days
  group_name    = each.value.group_name
  user_name     = each.value.user_name
  policy_name   = each.value.policy_name
  suffix_name = each.value.suffix_name

  tags = {
    "Environment" = "dev"
    "DevOps" = "Ivan"
  }
}
```
