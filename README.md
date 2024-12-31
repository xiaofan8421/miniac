# miniac
Namely Min IaC or Mini IaC. Fast deploy your SasS on different clouds or containers.


## Quick Start

### Prerequisites
- Install [Terraform](https://www.terraform.io/downloads.html)
- Configure the authentication information for the corresponding cloud platform

### Deployment Steps

1. Clone the project to your local machine:
    ```sh
    git clone <project_url>
    cd miniac
    ```

2. Choose the cloud platform directory as needed (e.g., aws, azure, gcp, or ali), and enter the corresponding directory:
    ```sh
    cd aws
    ```

3. Initialize Terraform:
    ```sh
    terraform init
    ```

4. Check the Terraform configuration:
    ```sh
    terraform plan
    ```

5. Apply the Terraform configuration:
    ```sh
    terraform apply
    ```

6. After deployment, you can access your instance through the output IP address.

### Cleaning Up Resources
If you no longer need these resources, you can destroy them using the following command:
```sh
terraform destroy
```

## File Descriptions
* main.tf: Main Terraform configuration file, defining resources and providers.
* variables.tf: Defines the variables used in the Terraform configuration.
* outputs.tf: Defines the outputs of the Terraform configuration.
* versions.tf: Defines the version requirements for Terraform and providers.
* deploy_env.sh: A script to be executed on the instance, showing basic information.

## License
This project is licensed under the Apache License 2.0.

## Contributing
Contributions are welcome! Please submit a Pull Request or report an Issue.

## Contact
If you have any questions, please contact the project maintainers.

