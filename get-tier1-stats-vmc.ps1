# PowervRNI Example - Get ingress/egress bandwidth usage for a VMConAWS Tier-1 Gateway
#
# Romain Decker (@woueb)
# rdecker@vmware.com
# Version 1.0
# 
# Based on this sample script from Martijn Smit (@smitmartijn): https://raw.githubusercontent.com/PowervRNI/powervrni/master/examples/get-bandwidth-usage-per-ip.ps1

param (
    [Parameter (Mandatory=$false)]
        # The epoch timestamp of when to start looking up records
        [int]$StartTime = ([Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s")) - 86400), # default to a day window
    [Parameter (Mandatory=$false)]
        # The epoch timestamp of when to stop looking up records
        [int]$EndTime = [Math]::Floor([decimal](Get-Date(Get-Date).ToUniversalTime()-uformat "%s"))
)

# If we want to select flows in a time slot, make sure the end time is later then the start time
if($StartTime -gt $EndTime) {
    throw "Param StartTime cannot be greater than EndTime"
}

if(!$defaultvRNIConnection) {
    throw "Use Connect-vRNIServer or Connect-NIServer to connect to Network Insight first!"
}

# Loop through these Tier-1 Gateways and get their download/upload bytes
$Tier1Gateways_to_lookup = @("rainpole-edge01", "CSEEdge")
foreach ($tier1_gateway in $Tier1Gateways_to_lookup)
{
    # Get download bytes first
    $requestBody = @{
        entity_type = 'Flow'
        filter = "l2 network in (l2 network of vm where Default Gateway Router = '$tier1_gateway') and (flow type = 'Source is Internet')"
        aggregations = @( @{
            field = "flow.totalBytes.delta.summation.bytes"
            aggregation_type = "SUM"
        } )
        start_time = $StartTime
        end_time = $EndTime
    }

    $listParams = @{
        Connection = $defaultvRNIConnection
        Method = 'POST'
        Uri = "/api/ni/search/aggregation"
        Body = ($requestBody | ConvertTo-Json)
    }

    $result = Invoke-vRNIRestMethod @listParams
    $download_bytes = $result.aggregations.value

    # Now get upload bytes
    $requestBody = @{
        entity_type = 'Flow'
        filter = "l2 network in (l2 network of vm where Default Gateway Router = '$tier1_gateway') and (flow type = 'Destination is Internet')"
        aggregations = @( @{
            field = "flow.totalBytes.delta.summation.bytes"
            aggregation_type = "SUM"
        } )
        start_time = $StartTime
        end_time = $EndTime
    }

    $listParams = @{
        Connection = $defaultvRNIConnection
        Method = 'POST'
        Uri = "/api/ni/search/aggregation"
        Body = ($requestBody | ConvertTo-Json)
    }

    $result = Invoke-vRNIRestMethod @listParams
    $upload_bytes = $result.aggregations.value

    Write-Host "Tier-1 Gateway: $tier1_gateway - Download bytes: $download_bytes - Upload bytes: $upload_bytes"
}