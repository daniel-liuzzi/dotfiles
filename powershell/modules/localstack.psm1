# Inspiration: https://hackf5.medium.com/localstack-in-docker-on-windows-6e691585279f

function Invoke-LocalStackAws {
    aws --endpoint-url=http://localhost:4566 $args
}

Set-Alias -Name laws -Value Invoke-LocalStackAws
