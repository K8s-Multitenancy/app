# Using Terraform and Kubectl to Provision the Infrastructure

Steps to login:
1. Run `gcloud auth login`
2. Run `gcloud config set project <PROJECT_ID>`
3. Run `gcloud auth application-default login`

Steps to apply the IaC:
1. Run `terraform init`.
2. Run `terraform plan` to simulate the result.
3. Run `terraform apply` to apply the results.

To see the databases created along its IP addresses, run `gcloud sql instances list`.

## Before running the app, don't forget to migrate the database first!

Steps to setup kubectl:
1. Run `gcloud container clusters get-credentials $(terraform output -raw kubernetes_cluster_name) --region $(terraform output -raw region)`
2. Check the available contexts by running `kubectl config get-contexts`
3. See the currently set context by inserting `kubectl config current-context`
4. If you see any errors, add the command `source "$(brew --prefix)/share/google-cloud-sdk/path.bash.inc"` to your `.bash_profile` for bash users. For other command line users, check the command to use by running `brew info google-cloud-sdk`.

To delete, simply run `terraform plan -destroy` and then continued by `terraform destroy`.

Steps to remove the context:
1. Run `kubectl config get-contexts` to retrieve the list of contexts.
2. Run `kubectl config use-context <CONTEXT_NAME>` to set the current context.
3. Run `kubectl config current-context` to verify the current context.
4. Lastly, run `kubectl config delete-context <CONTEXT_NAME_TO_DELETE>` to delete the unused context.