# terraform-ca
## Lab 2 CA on Terraform and Sentinel for ATU PgDip DevOps
Jacob Anderson
L00205577

### Reference Material and AI Usage
* **references:** https://developer.hashicorp.com/terraform/docs https://developer.hashicorp.com/sentinel/docs https://docs.localstack.cloud/aws/ https://developer.hashicorp.com/terraform/cloud-docs https://developer.hashicorp.com/sentinel/docs/terraform
* **extensions:** Docker, LocalStack Toolkit, HashiCorp Terraform, Container Tools, HashiCorp Sentinel
* **AI Usage:** I used inline GitHub Copilot suggestions in VSCode. Suggested completions were reviewed before acceptance and the resulting code was validated and tested. 
    I also used M365 Copilot for one prompt: "generate an initial terraform file for creating a few basic resources using localstack to test sentinel policies against. I'm looking to include a couple EC2 instances with specific regions, Encrypted EBS storage, Network security groups, etc"
    I also used GitHub Copilot chat for one prompt: "walk me through generating mocks for sentinel using HCP Terraform"

### Policy Controls
#### Digital Sovereignty
* Restricts deployments to eu-west-1 region (Ireland).
* Checks availability zone placement of infrastructure and storage resources.

#### Infrastructure Security
* EC2 instance types.
* Encrypted EBS storage.
* IMDSv2.
* Prevent public inbound SSH.
* Basic network security check.

#### Supply Chain Security
* Restricts Terraform providers to approved sources.
* Requires approved provider version constraints.

### Design Justifications
I defined a small AWS environment containing two EC2 instances, one stand-alone EBS volume, networking, and a security group. I used LocalStack to allow for quicker testing and to avoid AWS cost and risk. Three Sentinel policies were used that alligned with the categories of the assignment instructions. 

#### Digital Sovereignty
The most obvious approach to me for sovereignty was to restrict deployment to the approved Ireland AWS region eu-west-1. This theoretically would provide data-residency control through physical location. It isn't a perfect solution because regional restrictions alone don't stop backups, replication, or access from outside the region. 

#### Supply Chain Security
The supply chain policy restricts providers to approved sources and requires version constraints. The idea here is to force specific known providers and known versions to avoid untrusted sources or outdated security. This is only one layer of protection however because approved sources would still have to be properly vetted and it isn't impossible for a source to make it onto an approved list when it shouldn't. There are also further upstream dependencies, modules, and other inputs that could influence security as well. So this is a pretty rudimentary implementation.

### Limitations
Inherently using Sentinel to evaluate Terraform at plan-time has the limitation that any configuration drift that might happen outside of terraform on a deployed system would never be restricted or evaluated by Sentinel. It also adds another layer of configuration that needs to be maintained and updated regulary in the policies themselves. Approved regions, versions, sources, security, etc will all change over time so the corresponding Sentinel policies need to be reviewed and updated to stay relevant. Policy as Code feels like a good risk reduction tool and can be effective across large organizations, but it could never be a complete answer or full mitigation.