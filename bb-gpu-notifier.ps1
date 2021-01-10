########################
# #bb-gpu-notifier.ps1 #
########################
########## pseudo code ###############
# check for gpus continuously
# if one $VAR.onlineAvailability = true
    # then 
        # invoke $VAR.url,$VAR.addToCartUrl
        # send notification(s)
        # pause?
# else check for gpus continuously
########## pseudo code ###############
$apiKey = "YourApiKeyHere"
$discordWebhook = 'https://discord.com/api/webhooks/{webhook.id}/{webhook.token}'
$params = "sku,name,salePrice,onlineAvailability,url,addToCartUrl,"
$skuList = @(
    #"5748618", #Switch Pro Controller for testing
    #FE cards
    "6439402", #RTX 3060Ti
    "6429442", #RTX 3070
    "6429440", #RTX 3080
    "6429434", #RTX 3090
    #EVGA cards
    "6444445", #EVGA RTX 3060Ti xc gaming
    #"6444449", #EVGA RTX 3060Ti ftw3 gaming
    "6444444", #EVGA RTX 3060Ti ftw3 gaming
    "6439299", #EVGA RTX 3070 xc3 ultra
    "6432400", #EVGA RTX 3080 xc3 ultra
    "6434198" #EVGA RTX 3090 xc3 ultra
)
$dog = "dog"
while ($dog -eq "dog") {
    foreach ($sku in $skuList) {
        $gpu = invoke-restmethod "https://api.bestbuy.com/v1/products/$sku.json?show=$params&apiKey=$apiKey"
        #$gpu = invoke-restmethod https://api.bestbuy.com/v1/products(sku in($skuList))?show=$params&apiKey=YourAPIKey
        #better method, but figure out how to add gpu to cart that where onlineAvailability==$true
        $gpuName = $gpu.name
        $gpuOnlineAvailability = $gpu.onlineAvailability
        $gpuUrl = $gpu.url
        $gpuAddToCartUrl = $gpu.addToCartUrl
        if ($gpu.onlineAvailability -eq $true) {
            Write-Host "$gpuName online availability = $gpuOnlineAvailability" -ForegroundColor Green -BackgroundColor black
            Start-Process "$gpuAddToCartUrl"
            #Start-Process "$gpuUrl"
            #discord webhook

$content = @"
\@user to get userid to paste e.g. "<@012345678901234567>"
$gpuName stock $gpuOnlineAvailability
$gpuAddToCartUrl
"@

            $payload = [PSCustomObject]@{content = $content}
            Invoke-RestMethod -Uri $discordWebhook -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json'

            pause
        }
        Write-Host "$gpuName online availability = $gpuOnlineAvailability" -ForegroundColor Red -BackgroundColor black
        Start-Sleep -m 2000
    }
}
