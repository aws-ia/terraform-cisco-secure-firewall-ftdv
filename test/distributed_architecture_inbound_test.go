package gwlb_test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestDistributedArchitectureInbound(t *testing.T) {
	fmt.Println("Running test for Distributed Architecture Inbound...")

	directory_path := "./distributed_inbound/."
	tfvars_path := "../../t1.tfvars"

	terraformOptions := &terraform.Options{
		TerraformDir: directory_path,
		VarFiles:     []string{tfvars_path},
	}

	test_structure.RunTestStage(t, "init_and_apply_dai", func() {
		fmt.Println("[DAI]: Init and Apply")

		test_structure.SaveTerraformOptions(t, directory_path, terraformOptions)

		//terraform.InitAndApply(t, terraformOptions)
		// Initialize and apply Terraform configuration
		output, err := terraform.InitAndApplyE(t, terraformOptions)
		if err != nil {
			fmt.Println("Error during Terraform apply:", err)

			// Attempt to destroy resources if there was an error
			destroyOutput, destroyErr := terraform.DestroyE(t, terraformOptions)
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

	fmc_config_dir_path := "../examples/distributed_architecture_inbound_with_fmc/."
	tfvars_path2 := "../../t2.tfvars"

	fmcConfigTerraformOptions := &terraform.Options{
		TerraformDir: fmc_config_dir_path,
		VarFiles:     []string{tfvars_path2},
	}

	FMC_EIP := terraform.OutputList(t, terraformOptions, "fmcv_eip")
	FMC_IP := terraform.OutputList(t, terraformOptions, "fmcv_ip")

	if fmcConfigTerraformOptions.Vars == nil {
		fmcConfigTerraformOptions.Vars = make(map[string]interface{})
	}

	fmcConfigTerraformOptions.Vars["fmc_ip"] = FMC_IP[0]
	fmcConfigTerraformOptions.Vars["fmc_host"] = FMC_EIP[0]

	test_structure.RunTestStage(t, "fmc_config_dai", func() {
		fmt.Println("[DAI]: FMC Configuration(after waiting 25 mins for FMC to initialise)")

		time.Sleep(25 * time.Minute)
		test_structure.SaveTerraformOptions(t, fmc_config_dir_path, fmcConfigTerraformOptions)

		//terraform.InitAndApply(t, fmcConfigTerraformOptions)
		// Initialize and apply Terraform configuration
		output, err := terraform.InitAndApplyE(t, fmcConfigTerraformOptions)
		if err != nil {
			fmt.Println("Error during Terraform apply:", err)

			// Attempt to destroy resources if there was an error
			destroyOutput, destroyErr := terraform.DestroyE(t, fmcConfigTerraformOptions)
			if destroyErr != nil {
				fmt.Println("Error during Terraform destroy:", destroyErr)
			} else {
				fmt.Println("Terraform destroy completed successfully. Output:", destroyOutput)
			}
			destroyOutput2, destroyErr2 := terraform.DestroyE(t, terraformOptions)
			if destroyErr != nil {
				fmt.Println("Error during Terraform destroy of fmc:", destroyErr2)
			} else {
				fmt.Println("Terraform destroy of fmc completed successfully. Output:", destroyOutput2)
			}

			// Fail the test if there was an error during apply
			t.FailNow()
		} else {
			fmt.Println("distributed_architecture_inbound_with_fmc completed successfully. Output:", output)
		}
	})

	defer test_structure.RunTestStage(t, "destroy_dai", func() {
		fmt.Println("[DAI]: Destroy")

		time.Sleep(5 * time.Minute) // Wait before destroying

		terraform.Destroy(t, fmcConfigTerraformOptions)
		terraform.Destroy(t, terraformOptions)
	})
}
