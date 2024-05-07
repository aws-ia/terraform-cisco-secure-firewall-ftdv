package gwlb_test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestExistingServiceNewSpoke(t *testing.T) {
	fmt.Println("Starting tests...")
	t.Parallel()

	terraDir1 := "./new_spoke/."
	terraformOptions1 := &terraform.Options{
		TerraformDir: terraDir1,
		VarFiles:     []string{"../../t7.tfvars"},
	}

	terraDir2 := "../examples/centralized_architecture_with_fmc"
	terraformOptions2 := &terraform.Options{
		TerraformDir: terraDir2,
		VarFiles:     []string{"../../t8.tfvars"},
	}

	test_structure.RunTestStage(t, "build_fmc", func() {
		fmt.Println("Setup")

		// Save options for later test stages
		test_structure.SaveTerraformOptions(t, terraDir1, terraformOptions1)

		// Triggers the terraform init and terraform apply commandåç
		// Initialize and apply Terraform configuration
		output, err := terraform.InitAndApplyE(t, terraformOptions1)
		if err != nil {
			fmt.Println("Error during Terraform apply:", err)

			// Attempt to destroy resources if there was an error
			destroyOutput, destroyErr := terraform.DestroyE(t, terraformOptions1)
			if destroyErr != nil {
				fmt.Println("Error during Terraform destroy:", destroyErr)
			} else {
				fmt.Println("Terraform destroy completed successfully. Output:", destroyOutput)
			}

			// Fail the test if there was an error during apply
			t.FailNow()
		} else {
			fmt.Println("Terraform apply completed successfully. Output:", output)
		}

	})

	// Specify the Terraform options
	test_structure.RunTestStage(t, "setup", func() {
		time.Sleep(25 * time.Minute)

		fmt.Println("Setup")

		FMC_EIP := terraform.OutputList(t, terraformOptions1, "fmcv_eip")
		FMC_IP := terraform.OutputList(t, terraformOptions1, "fmcv_ip")

		if terraformOptions2.Vars == nil {
			terraformOptions2.Vars = make(map[string]interface{})
		}

		// Set the FMC output as a variable for the second Terraform configuration
		terraformOptions2.Vars["fmc_ip"] = FMC_IP[0]
		terraformOptions2.Vars["fmc_host"] = FMC_EIP[0]

		// Save options for later test stages
		test_structure.SaveTerraformOptions(t, terraDir2, terraformOptions2)

		// Triggers the terraform init and terraform apply command
		// Initialize and apply Terraform configuration
		output, err := terraform.InitAndApplyE(t, terraformOptions2)
		if err != nil {
			fmt.Println("Error during Terraform apply:", err)

			// Attempt to destroy resources if there was an error
			destroyOutput, destroyErr := terraform.DestroyE(t, terraformOptions2)
			if destroyErr != nil {
				fmt.Println("Error during Terraform destroy:", destroyErr)
			} else {
				fmt.Println("Terraform destroy completed successfully. Output:", destroyOutput)
			}
			destroyOutput2, destroyErr2 := terraform.DestroyE(t, terraformOptions1)
			if destroyErr != nil {
				fmt.Println("Error during Terraform destroy of fmc:", destroyErr2)
			} else {
				fmt.Println("Terraform destroy of fmc completed successfully. Output:", destroyOutput2)
			}

			// Fail the test if there was an error during apply
			t.FailNow()
		} else {
			fmt.Println("centralized_architecture_with_fmc_new_spoke completed successfully. Output:", output)
		}
	})

	// go test -v test/main_test.go -timeout 60m
	// Defer the destruction of resources until the test function is complete
	defer test_structure.RunTestStage(t, "teardown", func() {
		fmt.Println("Waiting for 3 minutes...")
		time.Sleep(3 * time.Minute) // To let the deployment finish before we start destroying.
		terraform.Destroy(t, terraformOptions2)
		defer test_structure.RunTestStage(t, "teardown_fmc", func() {
			fmt.Println("Destroying FMC....")
			terraform.Destroy(t, terraformOptions1)
		})
	})

}
