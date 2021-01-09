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
$params = "sku,name,salePrice,onlineAvailability,url,addToCartUrl,"
$skuList = @(
    "6439402", #RTX 3060Ti
    "6429442", #RTX 3070
    "6429440", #RTX 3080
    "6429434"  #RTX 3090
)
$dog = "dog"
while ($dog -eq "dog") {
    foreach ($sku in $skuList) {
        $gpu = invoke-restmethod "https://api.bestbuy.com/v1/products/$sku.json?show=$params&apiKey=$apiKey"
        $gpuName = $gpu.name
        $gpuOnlineAvailability = $gpu.onlineAvailability
        $gpuUrl = $gpu.url
        $gpuAddToCartUrl = $gpu.addToCartUrl
        if ($gpu.onlineAvailability -eq $true) {
            Write-Host "$gpuName online availability = $gpuOnlineAvailability" -ForegroundColor Green -BackgroundColor black
            Start-Process "$gpuAddToCartUrl"
            #Start-Process "$gpuUrl"
            #SEND NOTIFICATION, make system sound? send email with url link? discord message with url link? 
            pause
        }
        Write-Host "$gpuName online availability = $gpuOnlineAvailability" -ForegroundColor Red -BackgroundColor black
        Start-Sleep -m 2000
    }
}
