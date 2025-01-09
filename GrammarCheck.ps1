param(
                                [string[]] $URLS,
                                [string] $PLAIN_TEXT,
                                [string] $URLENCODED_TEXT,
                                [string] $HTMLENCODED_TEXT
                )



# Azure OpenAI credentials
$apiKey = "YOUR AZURE OPENAI KEY"
$endpoint = "YOUR AZURE OPENAI ENDPOINT"
$deploymentId = "YOUR AZURE OPENAI MODEL DEPLOYMENT NAME"

# Prepare request body
$body = @{
    "messages" = @(
        @{
            "role" = "system"
            "content" = "Check whether my sentence has grammatical and expression problems, and directly return the corrected and optimized sentence without changing the original meaning. If there is no problem with the sentence, please return the sentence directly."
        },
        @{
            "role" = "user"
            "content" = $PLAIN_TEXT
        }
    )
    "max_tokens" = 100
    "temperature" = 0.7
} | ConvertTo-Json

# Define request headers
$headers = @{
    "Content-Type" = "application/json"
    "api-key" = $apiKey
}

# Make HTTP POST request
try {
    $response = Invoke-RestMethod -Method Post -Uri "$endpoint/openai/deployments/$deploymentId/chat/completions?api-version=2023-05-15" -Headers $headers -Body $body
    $correctedText = $response.choices[0].message.content.Trim()

    # Output corrected text
    Write-Output $correctedText
}
catch {
    Write-Error "Error calling OpenAI API: $_"
}