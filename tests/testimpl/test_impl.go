package testimpl

import (
	"context"
	"math/rand"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	secretsManagerClient := GetAWSSecretsManagerClient(t)

	secretId := terraform.Output(t, ctx.TerratestTerraformOptions(), "secret_id")
	secretArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "secret_arn")

	t.Run("TestSecretsManagerSecretExists", func(t *testing.T) {
		secret, err := secretsManagerClient.DescribeSecret(context.TODO(), &secretsmanager.DescribeSecretInput{
			SecretId: &secretId,
		})
		if err != nil {
			t.Errorf("Failure during DescribeSecret: %v", err)
		}
		assert.Equal(t, *secret.ARN, secretArn, "Expected ARN did not match actual ARN!")
	})

	t.Run("TestNewlyCreatedSecretContainsNoValue", func(t *testing.T) {
		_, err := secretsManagerClient.GetSecretValue(context.TODO(), &secretsmanager.GetSecretValueInput{
			SecretId: &secretId,
		})
		assert.NotNil(t, err, "Secret shouldn't contain an initial value!")
	})

	t.Run("TestSecretsManagerSecretCanBeSet", func(t *testing.T) {
		password := GeneratePassword(16)

		_, err := secretsManagerClient.PutSecretValue(context.TODO(), &secretsmanager.PutSecretValueInput{
			SecretId:     &secretId,
			SecretString: &password,
		})
		if err != nil {
			t.Errorf("Failure during PutSecretValue: %v", err)
		}

		retrieved, err := secretsManagerClient.GetSecretValue(context.TODO(), &secretsmanager.GetSecretValueInput{
			SecretId: &secretId,
		})
		if err != nil {
			t.Errorf("Failure during GetSecretValue: %v", err)
		}

		assert.Equal(t, *retrieved.SecretString, password, "Expected SecretString did not match actual SecretString!")

	})
}

func GetAWSSecretsManagerClient(t *testing.T) *secretsmanager.Client {
	awsSecretsManagerClient := secretsmanager.NewFromConfig(GetAWSConfig(t))
	return awsSecretsManagerClient
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}

func GeneratePassword(n int) string {
	var chars = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

	built := make([]rune, n)
	for i := range built {
		built[i] = chars[rand.Intn(len(chars))]
	}
	return string(built)
}
